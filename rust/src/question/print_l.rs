// USAGE EXAMPLES:
//
//   cargo run print_l
//   cargo run print_l -s 3
//   cargo run print_l --size 1
//   SIZE=6 cargo run print_l
//
// PROBLEM:
//   Write a function:
//
//     pub fn run(size: i64)
//
//   that prints out ASCII-art in the shape of the capital letter L,
//   made up of copies of the capital letter L. The SIZE parameter is an
//   i64 (between 1 and 100) and represents the expected size of the
//   ASCII-art (the output should comprise SIZE rows, the last of which
//   should comprise SIZE letters L).
//
//   For example, here is the output for size = 4:
//
//     L
//     L
//     L
//     LLLL
//
//   The function should not return any value.
//
//   You can print a string to the output (without or with the end-of-line
//   character) as follows:
//
//     print!("sameple string");
//     println!("whole line");
//
//   You can write to stderr for debugging purposes.  For example:
//
//     eprint!("debug string");
//     eprintln!("this is a debug message");

// time complexity, O(N)
// space complexity, O(1)
pub fn run(size: i64) {
  // O(N)
  for _ in 1..size {
    println!("L");
  }
  // O(N)
  for _ in 1..size {
    print!("L");
  }
  // O(1)
  println!("L");
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run(4);
  }
}

