//
//  Data.swift
//  SkyIsTheLimit
//
//  Created by Youngjoon Lee on 6/29/25.
//

import Foundation

func withUnsafePointer<T>(_ data: Data, _ body: (UnsafePointer<UInt8>, UInt) -> T) -> T {
    return data.withUnsafeBytes { buffer in
        let ptr = buffer.baseAddress!.assumingMemoryBound(to: UInt8.self)
        return body(ptr, UInt(data.count))
    }
}
