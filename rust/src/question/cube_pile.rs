// USAGE EXAMPLES:
//
//   cargo run cube_pile
//   cargo run cube_pile -c 24723578342962
//   cargo run cube_pile --cubes 135440716410000
//   CUBES=40539911473216 cargo run cube_pile
//
// PROBLEM: Build a Pile of Cubes
//   Your task is to construct a building which will be a pile of n cubes.
//   The cube at the bottom will have a volume of n^3, the cube above will
//   have volume of (n-1)^3 and so on until the top which will have a
//   volume of 1^3.
//
//   You are given the total volume m of the building. Being given m can
//   you find the number n of cubes you will have to build?
//
//   The parameter of the function findNb (find_nb, find-nb, findNb, ...)
//   will be an integer m and you have to return the integer n such as n^3
//   + (n-1)^3 + ... + 1^3 = m if such a n exists or -1 if there is no
//   such n.
//
// EXAMPLES:
//   find_nb(1071225)        --> 45
//   find_nb(91716553919377) --> -1
//
// Code Wars, 6th kyu
//   https://www.codewars.com/kata/5592e3bd57b64d00f3000047/train/rust

pub fn run(number: u64) {
  println!("{}", find_nb(number));
}

// time complexity, O(1), closed form mathematical solution
// space complexity, O(1), closed form mathematical solution
//
// Solution for sum of cubes:
//   https://www.geeksforgeeks.org/sum-cubes-even-odd-natural-numbers/
// Used WolframAlpha for closed form mathematical solution for n:
//   https://www.wolframalpha.com
//   m = (n(n+1)/2)^2 solve for n
fn find_nb(m: u64) -> i32 {
  // O(1), closed form mathematical solution
  // n = (sqrt( 8 * sqrt(m) + 1 ) - 1) / 2
  let n = (((8.0 * (m as f64).sqrt() + 1.0).sqrt() - 1.0) / 2.0) as u64;
  // O(1), closed form mathematical solution
  // m = ((n * (n + 1)) / 2)^2
  //   = n^2 * (n+1)^2 / 4
  let verify = n * n * (n + 1) * (n + 1) / 4;
  // O(1)
  if verify == m {
    return n as i32;
  } else {
    return -1;
  };
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
    assert_eq!(   0, find_nb(              0));
    assert_eq!(   1, find_nb(              1));
    assert_eq!(  -1, find_nb(              2));
    assert_eq!(  45, find_nb(        1071225));
    assert_eq!(  -1, find_nb( 91716553919377));
    assert_eq!(2022, find_nb(  4183059834009));
    assert_eq!(  -1, find_nb( 24723578342962));
    assert_eq!(4824, find_nb(135440716410000));
    assert_eq!(3568, find_nb( 40539911473216));
    assert_eq!(3218, find_nb( 26825883955641));
  }
}

