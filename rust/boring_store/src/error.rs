use failure::Fail;
use std::result;

#[derive(Debug, Fail)]
pub enum Error {
  #[fail(display = "Request error: {}", _0)]
  RequestError(viaduct::Error),

  #[fail(display = "Deserialization error: {}", _0)]
  DeserializationError(serde_json::Error),

  #[fail(display = "Persistence error: {}", _0)]
  PersistenceError(rusqlite::Error),

  #[fail(display = "URL error: {}", _0)]
  URLError(url::ParseError),
}

pub type Result<T> = result::Result<T, Error>;

impl From<viaduct::Error> for Error {
  fn from(error: viaduct::Error) -> Self {
    Error::RequestError(error)
  }
}

impl From<serde_json::Error> for Error {
  fn from(error: serde_json::Error) -> Self {
    Error::DeserializationError(error)
  }
}

impl From<rusqlite::Error> for Error {
  fn from(error: rusqlite::Error) -> Self {
    Error::PersistenceError(error)
  }
}

impl From<url::ParseError> for Error {
  fn from(error: url::ParseError) -> Self {
    Error::URLError(error)
  }
}

impl From<Error> for ffi_support::ExternError {
  fn from(error: Error) -> Self {
    ffi_support::ExternError::new_error(ffi_support::ErrorCode::new(1), &format!("{}", error))
  }
}
