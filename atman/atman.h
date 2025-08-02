#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

void run_atman(void);

/**
 * Send a [`Command`] to Atman.
 * This accepts a JSON-represented command as a byte array,
 * converts it to a [`Command`], and sends it to Atman.
 *
 * # Safety
 * `msg` must be a valid pointer to a byte array of length `len`.
 */
void send_atman_command(const uint8_t *cmd, uintptr_t len);
