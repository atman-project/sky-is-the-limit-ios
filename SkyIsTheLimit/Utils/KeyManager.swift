import Foundation
import LocalAuthentication
import Security
import CryptoKit

class KeyManager {
    private static let identityIdentifier = "dev.oudwud.SkyIsTheLimit.identity"
    private static let networkKeyIdentifier = "dev.oudwud.SkyIsTheLimit.network_key"
    
    /// Gets or generates a persistent identity for Atman from Keychain
    /// Returns the private key as a hex string (64 hex characters = 32 bytes)
    static func getOrGenerateIdentity() -> String? {
        return getOrGenerateEd25519Key(identityIdentifier)
    }
    
    /// Gets or generates a persistent network key for Atman from Keychain
    /// Returns the private key as a hex string (64 hex characters = 32 bytes)
    static func getOrGenerateNetworkKey() -> String? {
        return getOrGenerateEd25519Key(networkKeyIdentifier)
    }

    /// Gets or generates a persistent Ed25519 key from Keychain
    /// Returns the private key as a hex string (64 hex characters = 32 bytes)
    static func getOrGenerateEd25519Key(_ keyIdentifier: String) -> String? {
        // Try to retrieve existing key from Keychain
        if let existingKey = retrieveFromKeychain(keyIdentifier) {
            return existingKey
        }

        // Generate a new Ed25519 signing key
        let signingKey = Curve25519.Signing.PrivateKey()
        let privateKeyData = signingKey.rawRepresentation
        let keyHex = privateKeyData.map { String(format: "%02x", $0) }.joined()

        // Store it securely in Keychain
        if storeInKeychain(keyHex, keyIdentifier) {
            return keyHex
        }

        // If storing fails, return the generated key anyway (shouldn't happen)
        print("Warning: Failed to store network key in Keychain")
        return keyHex
    }

    /// Gets the public key corresponding to the stored private key
    static func getPublicKey() -> String? {
        guard let privateKeyHex = getOrGenerateNetworkKey(),
              let privateKeyData = Data(hexString: privateKeyHex) else {
            return nil
        }

        do {
            let signingKey = try Curve25519.Signing.PrivateKey(rawRepresentation: privateKeyData)
            let publicKeyData = signingKey.publicKey.rawRepresentation
            return publicKeyData.map { String(format: "%02x", $0) }.joined()
        } catch {
            print("Error deriving public key: \(error)")
            return nil
        }
    }

    /// Stores the network key in Keychain
    private static func storeInKeychain(_ key: String, _ keyIdentifier: String) -> Bool {
        guard let keyData = key.data(using: .utf8) else { return false }

        // Create access control with biometry/passcode requirement
        guard let access = SecAccessControlCreateWithFlags(
            nil,
            kSecAttrAccessibleWhenUnlockedThisDeviceOnly,
            .userPresence, // Requires Face ID/Touch ID or passcode
            nil
        ) else {
            print("Failed to create access control")
            return false
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyIdentifier,
            kSecValueData as String: keyData,
            // NOTE: Just pass kSecAttrAccessibleWhenUnlockedThisDeviceOnly if we don't need biometry/passcode.
            kSecAttrAccessControl as String: access
        ]

        // Delete any existing item first
        SecItemDelete(query as CFDictionary)

        // Add the new item
        let status = SecItemAdd(query as CFDictionary, nil)
        print("storeInKeychain result: \(status)")
        return status == errSecSuccess
    }

    /// Retrieves the network key from Keychain
    private static func retrieveFromKeychain(_ keyIdentifier: String) -> String? {
        let context = LAContext()
        context.localizedReason = "Authenticate to access network key"
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: keyIdentifier,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
            // NOTE: Remove this field if we don't use kSecAttrAccessible in storeInKeychain
            kSecUseAuthenticationContext as String: context,
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        print("retrievedFromKeychain result: \(status)")
        guard status == errSecSuccess,
              let data = result as? Data,
              let key = String(data: data, encoding: .utf8) else {
            return nil
        }

        return key
    }

    /// Deletes the network key from Keychain (useful for testing or reset)
    static func clearNetworkKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: networkKeyIdentifier
        ]

        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess || status == errSecItemNotFound
    }
}

// Helper extension to convert hex string to Data
extension Data {
    init?(hexString: String) {
        let length = hexString.count / 2
        var data = Data(capacity: length)
        var index = hexString.startIndex
        for _ in 0..<length {
            let nextIndex = hexString.index(index, offsetBy: 2)
            if let byte = UInt8(hexString[index..<nextIndex], radix: 16) {
                data.append(byte)
            } else {
                return nil
            }
            index = nextIndex
        }
        self = data
    }
}
