#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

void run_atman_core(void);

/**
 * Send a message to Atman Core.
 *
 * # Safety
 * `msg` must be a valid pointer to a byte array of length `len`.
 */
void send_atman_core_message(const uint8_t *msg, uintptr_t len);
