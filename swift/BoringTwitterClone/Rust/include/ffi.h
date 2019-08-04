#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

typedef const char *FfiStr;
typedef uint64_t ContextHandle;

typedef struct BoringCoreError
{
  int32_t code;
  char *_Nullable message;
} BoringCoreError;

ContextHandle boring_core_create_context(FfiStr _Nonnull db_path, BoringCoreError *_Nonnull error);
void boring_core_destroy_context(ContextHandle handle, BoringCoreError *_Nonnull err);

typedef struct BoringBuffer
{
  int64_t len;
  uint8_t *_Nullable data;
} BoringBuffer;

void boring_core_destroy_boring_buffer(BoringBuffer buffer);
void boring_destroy_string(char *_Nonnull s);

BoringBuffer boring_core_get_latest_posts(ContextHandle handle,
                                          BoringCoreError *error);

BoringBuffer boring_core_get_comments(ContextHandle handle, int64_t postID,
                                      BoringCoreError *error);

BoringBuffer boring_core_get_all_posts_by_author(ContextHandle handle, int64_t authorID,
                                                 BoringCoreError *error);