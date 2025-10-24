#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef struct ConnectAndSyncCommand {
  const uint8_t *node_id;
  uintptr_t node_id_len;
  const uint8_t *doc_space;
  uintptr_t doc_space_len;
  const uint8_t *doc_id;
  uintptr_t doc_id_len;
} ConnectAndSyncCommand;

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
  const uint8_t *collection_doc_id;
  uintptr_t collection_doc_id_len;
  const uint8_t *doc_id;
  uintptr_t doc_id_len;
  const uint8_t *property;
  uintptr_t property_len;
  const uint8_t *data;
  uintptr_t data_len;
  uintptr_t index;
} SyncListInsertCommand;

typedef struct SyncGetCommand {
  const uint8_t *doc_space;
  uintptr_t doc_space_len;
  const uint8_t *doc_id;
  uintptr_t doc_id_len;
} SyncGetCommand;

/**
 * Initialize and run Atman with the given syncman directory.
 *
 * # Safety
 * `syncman_dir` must be a valid null-terminated C string.
 */
unsigned short run_atman(const char *identity,
                         const char *network_key,
                         const char *syncman_dir,
                         uint64_t sync_interval_secs);

/**
 * Send a [`ConnectAndSyncCommand`] to Atman.
 *
 * # Safety
 * All fields in [`ConnectAndSyncCommand`] must be valid pointers to byte
 * arrays of the corresponding length.
 */
void send_atman_connect_and_sync_command(struct ConnectAndSyncCommand cmd);

/**
 * Send a [`SyncUpdateCommand`] to Atman.
 *
 * # Safety
 * All fields in [`SyncUpdateCommand`] must be valid pointers to byte arrays of
 * the corresponding length.
 */
void send_atman_sync_update_command(struct SyncUpdateCommand cmd);

/**
 * Send a [`SyncListInsertCommand`] to Atman.
 *
 * # Safety
 * All fields in [`SyncListInsertCommand`] must be valid pointers to byte
 * arrays of the corresponding length.
 */
void send_atman_sync_list_insert_command(struct SyncListInsertCommand cmd);

/**
 * Send a [`SyncGetCommand`] to Atman.
 *
 * Returns a JSON represented document if successful. Otherwise, return NULL.
 *
 * # Safety
 * All fields in [`SyncGetCommand`] must be valid pointers to byte arrays of
 * the corresponding length.
 */
char *send_atman_sync_get_command(struct SyncGetCommand cmd);

/**
 * Free a C string allocated by Rust if it is not null.
 *
 * # Safety
 * `str` must be a valid pointer returned by Rust.
 */
void free_string(char *str);
