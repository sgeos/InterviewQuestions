// USAGE EXAMPLES:
//
//   cargo run hello
//   cargo run hello -n Rust
//   cargo run hello --name $(whoami)
//   NAME=environment cargo run hello
//
// PROBLEM:
//
//   Write a hello world routine that accepts a name as a parameter.
//
//     pub fn run(name: String)

pub fn run(name: String) {
  println!("Hello, {}!", name);
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run("World".to_string());
  }
}

