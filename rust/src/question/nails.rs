// PROBLEM:
//
//   There are QUANTITY nails hammered into the same block of wood. Each
//   nail sticks out of the wood at some length. You can choose at most
//   HAMMER nails and hammer them down to any length between their
//   original lengths and 0. Nails cannot be pulled up. The goal is to
//   have as many nails of the same length as possible.
//
//   You are given an implementation of a function:
//
//     fn solve(nails: &Vec<i64>, hammer: i64) -> i64
//
//   which, given a &Vec<i64> NAILS of QUANTITY integers representing
//   lengths of the nails sorted in a non-decreasing order and an i64
//   HAMMER, returns the maximal number of nails that can be positioned at
//   the same length after hammering down at most HAMMER nails.
//
//   For example, given HAMMER = 2 and vector NAILS = vec!(1, 1, 3, 3, 3,
//   4, 5, 5, 5, 5) the function should return 5. One of the possibilities
//   is to hammer the nails represented by NAILS[8] and NAILS[9] down to
//   length 3.
//
//     5              T T T T
//     4            T | | | |
//     3      T T T | | | * *
//     2      | | | | | | | |
//     1  T T | | | | | | | |
//     0  | | | | | | | | | |
//     .  0 1 2 3 4 5 6 7 8 9
//
//   Assume that:
//   - QUANTITY is an integer within the range [1..10,000];
//   - HAMMER is an integer within the range [0..QUANTITY];
//   - each element of array NAILS is an integer within the range
//     [1..1,000,000,000];
//   - array NAILS is sorted in non-decreasing order.
//
//   In your solution, focus on correctness. The performance of your
//   solution will not be the focus of the assessment.

use std::cmp;

pub fn run(nails: &Vec<i64>, hammer: i64) {
  println!("nails lengths: {:?}", nails);
  println!("hammer count: {:?}", hammer);
  println!("max same length: {:?}", solve(nails, hammer));
}

fn solve(nails: &Vec<i64>, hammer: i64) -> i64 {
  let quantity: i64 = nails.len() as i64;
  let max: usize = cmp::max(0, quantity - hammer - 1) as usize;
  let mut best: i64 = 0;
  let mut count: i64 = 0;
  for i in 0..max {
    if nails[i] == nails[i + 1] {
      count += 1;
    } else {
      count = 0;
    }
    best = cmp::max(best, count);
  }
  return cmp::min(quantity, best + 1 + hammer);
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run(&vec!(0), 0);
  }

  #[test]
  fn returns_expected() {
    let nails: Vec<i64> = vec!(1,1,3,3,3,4,5,5,5,5);
    assert_eq!( 4, solve(&nails,  0));
    assert_eq!( 4, solve(&nails,  1));
    assert_eq!( 5, solve(&nails,  2));
    assert_eq!( 6, solve(&nails,  3));
    assert_eq!( 7, solve(&nails,  4));
    assert_eq!( 8, solve(&nails,  5));
    assert_eq!( 8, solve(&nails,  6));
    assert_eq!( 9, solve(&nails,  7));
    assert_eq!(10, solve(&nails,  8));
    assert_eq!(10, solve(&nails,  9));
    assert_eq!(10, solve(&nails, 10));
  }
}

