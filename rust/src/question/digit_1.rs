// USAGE EXAMPLES:
//
//   cargo run digit_1
//   cargo run digit_1 -n 717
//   cargo run digit_1 --number 3000
//   NUMBER=111 cargo run digit_1
//
// PROBLEM:
//   Write a function:
//
//     fn solve(number: i64) -> i64
//
//   that, given an integer NUMBER, returns the number of times the digit
//   1 occurs in decimal representations of all positive integers not
//   exceeding NUMBER.
//
//   For example, given NUMBER = 13 the function should return 6, because:
//     - all the positive integers that do not exceed 13 are 1, 2, 3, 4,
//       5, 6, 7, 8, 9, 10, 11, 12 and 13;
//     - digit 1 occurs six times altogether: once in number 1, once in
//       number 10, twice in number 11, once in number 12 and once in
//       number 13.
//
//   Write an efficient algorithm for the following assumptions:
//     - NUMBER is an integer within the range [0..100,000,000].

use std::cmp;

pub fn run(number: i64) {
  println!("From zero to {}, the digit one occurs {} times.", number, solve(number));
}

// time complexity, O(log N), based on digits in number
// space complexity, O(1)
fn solve(number: i64) -> i64 {
  let mut result: i64 = 0;
  // start at the ones digit
  let mut digit:i64 = 1;
  // no sense calculating past the size of the input
  let max = cmp::min(100000000, number);
  // O(log N), loop over digits
  while digit <= max {
    // O(1)
    // naive number of times 1 has occurred in the present digit
    result += digit * ((number + 9 * digit) / (10 * digit));
    // if the current digit is a 1
    if 1 == number / digit % 10 {
      // subtract final naive pass
      result -= digit;
      // calculate exact value of final pass
      result += number % digit + 1;
    }
    // move to next base-10 digit
    digit *= 10;
  }
  return result;
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run(0);
  }

  #[test]
  fn returns_expected() {
    assert_eq!(   0, solve(   0));
    assert_eq!(   1, solve(   1));
    assert_eq!(   6, solve(  13));
    assert_eq!(  36, solve( 111));
    assert_eq!( 250, solve( 717));
    assert_eq!(1600, solve(2000));
    assert_eq!(1900, solve(3000));
  }
}

