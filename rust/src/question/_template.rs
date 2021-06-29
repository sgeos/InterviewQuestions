// USAGE EXAMPLES:
//
//   cargo run template
//   cargo run template -i apple
//   cargo run template --input バナナ
//   INPUT="☺️" cargo run template
//
// PROBLEM:
//   New problem template file.  (Print number of characters in string.)
//
// EXAMPLES:
//   "apple"  => 5
//   "バナナ" => 3
//   "☺️"     => 2
//
// REFERENCE:
//   URL

pub fn run(string: String) {
  println!("{}", solve(&string));
}

fn solve(string: &str) -> i64 {
  return string.chars().count() as i64;
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run("".to_string());
  }

  #[test]
  fn returns_expected() {
    assert_eq!(5, solve("apple"));
    assert_eq!(3, solve("バナナ"));
    assert_eq!(2, solve("☺️"));
  }
}

