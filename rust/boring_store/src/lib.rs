mod error;
pub use error::{Error, Result};
use ffi_support::implement_into_ffi_by_protobuf;
use rusqlite::Connection;
use std::collections::HashMap;
use std::sync::Mutex;
use url::Url;
use viaduct::Request;

pub mod types {
  include!(concat!(env!("OUT_DIR"), "/boring.types.rs"));
}

implement_into_ffi_by_protobuf!(types::PostsResponse);
implement_into_ffi_by_protobuf!(types::CommentsResponse);

pub struct Context {
  pub conn: Mutex<Connection>,
}

impl Context {
  pub fn new(db_path: &str) -> Result<Context> {
    Connection::open(db_path)
      .map(|conn| Context {
        conn: Mutex::new(conn),
      })
      .map_err(|err| err.into())
  }

  pub fn get_latest_posts(&self) -> Result<types::PostsResponse> {
    let uri = Url::parse("https://jsonplaceholder.typicode.com/posts")?;

    Request::get(uri)
      .send()?
      .json()
      .map(|posts: Vec<types::Post>| {
        let posts_dict: HashMap<i64, types::Post> =
          posts.into_iter().map(|post| (post.user_id, post)).collect();
        types::PostsResponse {
          posts: posts_dict.values().cloned().collect(),
        }
      })
      .map_err(|err| err.into())
  }

  pub fn get_comments(&self, post_id: i64) -> Result<types::CommentsResponse> {
    let uri = Url::parse("https://jsonplaceholder.typicode.com/posts/1/comments")?;

    Request::get(uri)
      .send()?
      .json()
      .map(|comments: Vec<types::Comment>| types::CommentsResponse {
        comments: comments
          .into_iter()
          .filter(|comment| comment.post_id == post_id)
          .collect(),
      })
      .map_err(|err| err.into())
  }

  pub fn get_all_posts_by_author(&self, author_id: i64) -> Result<types::PostsResponse> {
    let uri = Url::parse("https://jsonplaceholder.typicode.com/posts")?;

    Request::get(uri)
      .send()?
      .json()
      .map(|posts: Vec<types::Post>| types::PostsResponse {
        posts: posts
          .into_iter()
          .filter(|post| post.user_id == author_id)
          .collect(),
      })
      .map_err(|err| err.into())
  }
}
