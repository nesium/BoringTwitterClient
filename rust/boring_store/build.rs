fn main() {
  let mut prost_build = prost_build::Config::new();
  prost_build.type_attribute(".", "#[derive(serde::Deserialize)]");
  prost_build.type_attribute(".", "#[serde(rename_all = \"camelCase\")]");
  prost_build.compile_protos(
      &["../../proto/types.proto"],
      &["../../proto/"]
    )
    .unwrap();
  println!("cargo:rerun-if-changed=../../proto/types.proto");
}