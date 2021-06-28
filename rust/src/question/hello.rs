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

