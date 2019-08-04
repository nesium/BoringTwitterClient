// TODO: The opened SQLite file is currently unused.
// Imagine we'd use it to cache the loaded and parsed entities…

use boring_store::Context;
use ffi_support::{
  define_bytebuffer_destructor, define_handle_map_deleter, define_string_destructor, ByteBuffer,
  ConcurrentHandleMap, ExternError, FfiStr,
};

define_bytebuffer_destructor!(boring_core_destroy_boring_buffer);
define_string_destructor!(boring_destroy_string);
define_handle_map_deleter!(CONTEXTS, boring_core_destroy_context);

pub type ContextHandle = u64;
pub type BoringRustError = ExternError;

lazy_static::lazy_static! {
  pub static ref CONTEXTS: ConcurrentHandleMap<Context> = ConcurrentHandleMap::new();
}

#[no_mangle]
pub extern "C" fn boring_core_create_context(
  db_path: FfiStr<'_>,
  error: &mut BoringRustError,
) -> ContextHandle {
  CONTEXTS.insert_with_result(error, || -> Result<Context, ExternError> {
    log::debug!("Opening sqlite db at {}", db_path.as_str());
    Context::new(db_path.as_str()).map_err(|err| err.into())
  })
}

#[no_mangle]
pub unsafe extern "C" fn boring_core_get_latest_posts(
  handle: ContextHandle,
  error: &mut BoringRustError,
) -> ByteBuffer {
  CONTEXTS.call_with_result(error, handle, |ctx| ctx.get_latest_posts())
}

#[no_mangle]
pub unsafe extern "C" fn boring_core_get_comments(
  handle: ContextHandle,
  post_id: i64,
  error: &mut BoringRustError,
) -> ByteBuffer {
  CONTEXTS.call_with_result(error, handle, |ctx| ctx.get_comments(post_id))
}

#[no_mangle]
pub unsafe extern "C" fn boring_core_get_all_posts_by_author(
  handle: ContextHandle,
  author_id: i64,
  error: &mut BoringRustError,
) -> ByteBuffer {
  CONTEXTS.call_with_result(error, handle, |ctx| ctx.get_all_posts_by_author(author_id))
}
