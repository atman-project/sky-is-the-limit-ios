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

typedef struct SyncListInsertCommand {
  const uint8_t *doc_space;
  uintptr_t doc_space_len;
  const uint8_t *doc_id;
  uintptr_t doc_id_len;
  const uint8_t *property;
  uintptr_t property_len;
  const uint8_t *data;
  uintptr_t data_len;
  uintptr_t index;
} SyncListInsertCommand;

/**
 * Initialize and run Atman with the given syncman directory.
 *
 * # Safety
 * `syncman_dir` must be a valid null-terminated C string.
 */
unsigned short run_atman(const char *syncman_dir);

/**
 * Send a [`SyncUpdateCommand`] to Atman.
 *
 * # Safety
 * all fields in [`SyncUpdateCommand`] must be valid pointers to byte arrays of
 * the corresponding length.
 */
void send_atman_sync_update_command(struct SyncUpdateCommand cmd);

/**
 * Send a [`SyncListInsertCommand`] to Atman.
 *
 * # Safety
 * all fields in [`SyncListInsertCommand`] must be valid pointers to byte
 * arrays of the corresponding length.
 */
void send_atman_sync_list_insert_command(struct SyncListInsertCommand cmd);
