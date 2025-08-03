#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct SyncUpdateCommand {
  const uint8_t *doc_space;
  uintptr_t doc_space_len;
  const uint8_t *doc_id;
  uintptr_t doc_id_len;
  const uint8_t *data;
  uintptr_t data_len;
} SyncUpdateCommand;

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

/**
 * Send a [`SyncUpdateCommand`] to Atman.
 *
 * # Safety
 * all fields in [`SyncUpdateCommand`] must be valid pointers to byte arrays of the corresponding length.
 */
void send_atman_sync_update_command(struct SyncUpdateCommand cmd);
