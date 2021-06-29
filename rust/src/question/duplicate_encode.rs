// USAGE EXAMPLES:
//
//   cargo run duplicate_encode
//   cargo run duplicate_encode -s Civic
//   cargo run duplicate_encode --string 悪魔の黒魔術
//   STRING=")) @" cargo run duplicate_encode
//
// PROBLEM: Duplicate Encoder
//   The goal of this exercise is to convert a string to a new string
//   where each character in the new string is "(" if that character
//   appears only once in the original string, or ")" if that character
//   appears more than once in the original string. Ignore capitalization
//   when determining if a character is a duplicate.
//
// EXAMPLES:
//   "din"      =>  "((("
//   "recede"   =>  "()()()"
//   "Success"  =>  ")())())"
//   "(( @"     =>  "))((" 
//
// Code Wars, 6th kyu
//   https://www.codewars.com/kata/54b42f9314d9229fd6000d9c/train/rust

use std::collections::HashMap;

pub fn run(string: String) {
  println!("{}", duplicate_encode(&string));
}

// time complexity, O(N), loop over input
// space complexity, O(N), allocate input-sized memory
fn duplicate_encode(input: &str) -> String {
  // O(N), loop over input
  let lowercase_input = input.to_lowercase();
  // O(1), memory allocation
  let mut character_map = HashMap::new();
  // O(N), loop over input
  for key in lowercase_input.chars() {
    // O(1), amortized CRUD operation
    let is_duplicate: bool = character_map.contains_key(&key);
    // O(1), amortized CRUD operation
    character_map.insert(key, is_duplicate);
  }
  // O(1), memory allocation
  let mut result = String::with_capacity(lowercase_input.len());
  // O(N), loop input
  for key in lowercase_input.chars() {
    // O(1), amortized CRUD operation
    if character_map[&key] {
      // O(1), vector operation
      result.push(')');
    } else {
      // O(1), vector operation
      result.push('(');
    }
  }
  // O(1) exit function
  return result;
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
    assert_eq!(    "(((", duplicate_encode(    "din"));
    assert_eq!( "()()()", duplicate_encode( "recede"));
    assert_eq!(")())())", duplicate_encode("Success"));
    assert_eq!(   "))((", duplicate_encode(   "(( @"));
  }
}

