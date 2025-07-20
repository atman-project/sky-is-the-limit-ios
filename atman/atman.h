#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

void run_atman(void);

/**
 * Send a message to Atman.
 *
 * # Safety
 * `msg` must be a valid pointer to a byte array of length `len`.
 */
void send_atman_message(const uint8_t *msg, uintptr_t len);
