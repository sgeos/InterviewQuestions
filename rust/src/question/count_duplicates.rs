// USAGE EXAMPLES:
//
//   cargo run count_duplicates
//   cargo run count_duplicates -s abcde
//   cargo run count_duplicates --string ああイイ上おヲ
//   STRING=$(whoami) cargo run count_duplicates
//
// PROBLEM: Counting Duplicates
//   Write a function that will return the count of distinct
//   case-insensitive alphabetic characters and numeric digits that occur
//   more than once in the input string. The input string can be assumed
//   to contain only alphabets (both uppercase and lowercase) and numeric
//   digits.
//
// EXAMPLES:
//   "abcde" -> 0 # no characters repeats more than once
//   "aabbcde" -> 2 # 'a' and 'b'
//   "aabBcde" -> 2 # 'a' occurs twice and 'b' twice (`b` and `B`)
//   "indivisibility" -> 1 # 'i' occurs six times
//   "Indivisibilities" -> 2 # 'i' occurs seven times and 's' occurs twice
//   "aA11" -> 2 # 'a' and '1'
//   "ABBA" -> 2 # 'A' and 'B' each occur twice
//
// Code Wars, 6th kyu
//   https://www.codewars.com/kata/54bf1c2cd5b56cc47f0007a1/train/rust

use std::collections::HashMap;

pub fn run(string: String) {
  println!("{}", count_duplicates(&string));
}

// time complexity, O(N), loop over input
// space complexity, O(N), create hashmap
fn count_duplicates(input: &str) -> u32 {
  // O(N), loop over input
  let lowercase_input = input.to_lowercase();
  // O(1), memory allocation
  let mut character_map = HashMap::new();
  // O(N), loop over input
  for key in lowercase_input.chars() {
    // O(1), amortized CRUD operation
    if character_map.contains_key(&key) {
      // O(1), amortized CRUD operation
      character_map.insert(key, 1);
    } else {
      // O(1), amortized CRUD operation
      character_map.insert(key, 0);
    }
  }
  // O(N), loop over input
  let result = character_map.values().sum();
  // O(1) exit function
  return result;
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run("".to_string());
    run("a".to_string());
  }

  #[test]
  fn returns_expected() {
    assert_eq!(0, count_duplicates("abcde"));
    assert_eq!(1, count_duplicates("abcdea"));
    assert_eq!(2, count_duplicates("aabbcde"));
    assert_eq!(2, count_duplicates("aabBcde"));
    assert_eq!(1, count_duplicates("indivisibility"));
    assert_eq!(2, count_duplicates("Indivisibilities"));
    assert_eq!(2, count_duplicates("aA11"));
    assert_eq!(2, count_duplicates("ABBA"));
  }
}

