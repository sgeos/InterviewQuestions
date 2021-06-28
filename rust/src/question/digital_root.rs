// Code Wars, 6th kyu
//   https://www.codewars.com/kata/541c8630095125aba6000c00/train/rust
//
// PROBLEM: Digital Root
//   Digital root is the recursive sum of all the digits in a number.
//
//   Given n, take the sum of the digits of n. If that value has more than
//   one digit, continue reducing in this way until a single-digit number
//   is produced. The input will be a non-negative integer.
//
// EXAMPLES:
//        2  -->  2
//       16  -->  1 + 6 = 7
//      942  -->  9 + 4 + 2 = 15  -->  1 + 5 = 6
//   132189  -->  1 + 3 + 2 + 1 + 8 + 9 = 24  -->  2 + 4 = 6
//   493193  -->  4 + 9 + 3 + 1 + 9 + 3 = 29  -->  2 + 9 = 11
//                                            -->  1 + 1 = 2

pub fn run(n: i64) {
  println!("{}", digital_root(n))
}

fn digital_root(n: i64) -> i64 {
  let mut result = n;
  while 10 <= result {
    let mut digits = result;
    result = 0;
    while 0 < digits {
      result += digits % 10;
      digits /= 10;
    }
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
    assert_eq!(digital_root(2), 2);
    assert_eq!(digital_root(16), 7);
    assert_eq!(digital_root(942), 6);
    assert_eq!(digital_root(132189), 6);
    assert_eq!(digital_root(493193), 2);
  }    
}

