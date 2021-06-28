// Cracking the Coding Interview, 6th Edition, Page 90
// Interview Questions 1.1
//
// PROBLEM: Is Unique
//   Implement an algorithm to determine if a string has all unique
//   characters.  What if you cannot use additional data structures?

use std::collections::HashMap;

pub fn run(string: &str) {
  let is_unique = time_optimized(string);
  let is_unique_space = space_optimized(string);

  match (is_unique, is_unique_space) {
    (true, true) =>
      println!("{} : \"{}\" has unique characters.", is_unique, string),
    (false, false) =>
      println!("{} : \"{}\" does NOT have unique characters.", is_unique, string),
    _ =>
      println!("error : implementations do not match for \"{}\".", string),
  }
}

// time complexity O(N), expected
// time complexity O(N^3), pathological worst case
// space complexity O(N), hashmap
fn time_optimized(string: &str) -> bool {
  // O(1), empty map
  let mut character_map = HashMap::new();
  // O(N)
  for character in string.chars() {
    // O(1), expected
    // O(N), worst case
    if character_map.contains_key(&character) {
      // println!("match {}", character);
      return false;
    }
    // O(1), expected
    // O(N), worst case
    character_map.insert(character, 0);
    // println!("insert {}", character);
  }
  return true;
}

// time complexity O(N^3), Unicode default
// time complexity O(N^2), if rewritten for ASCII
// space complexity O(1), no memory allocated
fn space_optimized(string: &str) -> bool {
  // no worse than O(N)
  let length = string.chars().count();
  // O(N)
  for (index, source) in string.chars().enumerate() {
    // O(N), average about N/2 times
    for n in (index + 1)..length {
      // this would be O(1) for ASCII
      // probably no worse than O(N) for Unicode
      let target = string.chars().nth(n).unwrap();
      // the rest of these are O(1)
      let is_match = source == target;
      // println!("{} = {} == {}", is_match, source, target);
      if is_match {
        return false;
      }
    }
  }
  return true;
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run("test");
  }

  #[test]
  fn time_optimized_returns_expected() {
    assert_eq!(false, time_optimized("test"));
    assert_eq!(true, time_optimized("true"));
    assert_eq!(false, time_optimized("日曜日"));
    assert_eq!(true, time_optimized("忍者"));
  }

  #[test]
  fn space_optimized_returns_expected() {
    assert_eq!(false, space_optimized("test"));
    assert_eq!(true, space_optimized("true"));
    assert_eq!(false, space_optimized("日曜日"));
    assert_eq!(true, space_optimized("忍者"));
  }
}

