  use boring_store::{types, Result};
  use url::Url;
  use viaduct::Request;

  #[test]
  fn deserialize_posts() -> Result<()> {
    let uri = Url::parse("https://jsonplaceholder.typicode.com/posts")?;
    let resp: Vec<types::Post> = Request::get(uri).send()?.json()?;
    assert_eq!(resp.len(), 100);
    Ok(())
  }

  #[test]
  fn deserialize_comments() -> Result<()> {
    let uri = Url::parse("https://jsonplaceholder.typicode.com/comments")?;
    let resp: Vec<types::Comment> = Request::get(uri).send()?.json()?;
    assert_eq!(resp.len(), 500);
    Ok(())
  }