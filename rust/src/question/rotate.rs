// USAGE EXAMPLES:
//
//   cargo run rotate
//   cargo run rotate -d 0123
//   cargo run rotate -d '\../.\/../\./..X' -s 4 -r 1
//   cargo run rotate --data "0-1|X.2.3" --size 3 --rotate=-1
//   DATA="\..×.\S×魔.☆×→→→→" SIZE=4 ROTATE=10 cargo run rotate
//
// PROBLEM: Rotate Matrix
//   Given an image represented by an NxN matrix, where each pixel in
//   the image is [represented by a Unicode character], write [functions]
//   to rotate the image by 90 [and 180] degrees.
//   Can you do this in place?
//
// EXAMPLES:
//   "01  == CW ===> "20
//    23" == CW ===>  31"
//
//   "01  == FLIP => "32
//    23" == FLIP =>  10"
//
//   "01  == CCW ==> "13
//    23" == CCW ==>  02"
//
//   "0-1  == CW ===> "2|0
//    |X.  == CW ===>  .X-
//    2.3" == CW ===>  3.1"
//
//   "0-1  == FLIP => "3.2
//    .X.  == FLIP =>  .X|
//    2.3" == FLIP =>  1-0"
//
//   "0-1  == CCW ==> "1.3
//    .X.  == CCW ==>  -X.
//    2.3" == CCW ==>  0|2"
//
// Cracking the Coding Interview, 6th Edition, Page 91
// Interview Questions 1.7 [modifications in brackets]

// time complexity, O(N), loop over data
// space complexity, O(N), copy data into vector
pub fn run(string: String, size: i64, rotate: i64) {
  // O(N), loop over data
  let mut data = string.chars().collect::<Vec<_>>();
  // O(1)
  let window_size = if size < 0 {
    (data.len() as f64).sqrt() as usize
  } else {
    size as usize
  };
  // O(1)
  // correct negative values with double % call
  match (4 + rotate % 4) % 4 {
    // O(N), loop over data
    1 => rotate_cw(&mut data, window_size),
    2 => flip(&mut data, window_size),
    3 => rotate_ccw(&mut data, window_size),
    // O(1)
    _ => (),
  }
  // O(N), loop over data
  print_data(&data, window_size);
}

// time complexity, O(N), loop over data
// space complexity, O(1), iterator does not copy data
fn print_data(data: &Vec<char>, window_size: usize) {
  // O(N)
  if window_size < 1 {
    return;
  }
  // O(N), loop over data
  for (i, c) in data.iter().enumerate() {
    // O(1)
    if i % window_size == 0 && i != 0 {
      // O(1)
      println!();
    }
    // O(1)
    print!("{}", c);
  }
  println!();
}

// time complexity, O(1), vector operation
// space complexity, O(1), vector operation
fn read(data: &mut Vec<char>, width: usize, x: usize, y: usize) -> char {
  // O(1), vector operation
  return data[y * width + x];
}

// time complexity, O(1), vector operation
// space complexity, O(1), vector operation
fn blit(
  data: &mut Vec<char>,
  width: usize,
  x: usize,
  y: usize,
  pixel: char
) {
  // O(1), vector operation
  data[y * width + x] = pixel;
}

// time complexity, O(1), vector operation
// space complexity, O(1), vector operation
fn replace(
  data: &mut Vec<char>,
  width: usize,
  x: usize,
  y: usize,
  pixel: char
) -> char {
  // O(1), vector operations
  let result = read(data, width, x, y);
  blit(data, width, x, y, pixel);
  return result;
}

// time complexity, O(N), loop over data
// space complexity, O(1), scalar bookkeeping variables
fn rotate_cw(data: &mut Vec<char>, window_size: usize) {
  // O(1)
  let half_width = (window_size + 1) / 2;
  let half_height = window_size / 2;
  // O(sqrt(N)), loop in x direction of data
  for x in 0..half_width {
    // O(sqrt(N)), loop in y direction of data
    for y in 0..half_height {
      // O(1)
      let inv_x = window_size - x - 1;
      let inv_y = window_size - y - 1;
      // O(1), vector operations
      let mut c = read(data, window_size, x, y);
      c = replace(data, window_size, inv_y,     x, c);
      c = replace(data, window_size, inv_x, inv_y, c);
      c = replace(data, window_size,     y, inv_x, c);
      blit(data, window_size, x, y, c);
    }
  }
}

// time complexity, O(N), loop over data
// space complexity, O(1), scalar bookkeeping variables
fn flip(data: &mut Vec<char>, window_size: usize) {
  // O(1)
  let length = window_size * window_size;
  let half_length = length / 2;
  // O(N), loop over data
  for i in 0..half_length {
    // O(1)
    let inv_i = length - i - 1;
    // O(1), vector operations
    let c = data[i];
    data[i] = data[inv_i];
    data[inv_i] = c;
  }
}

// time complexity, O(N), loop over data
// space complexity, O(1), scalar bookkeeping variables
fn rotate_ccw(data: &mut Vec<char>, window_size: usize) {
  // O(1)
  let half_width = (window_size + 1) / 2;
  let half_height = window_size / 2;
  // O(sqrt(N)), loop in x direction of data
  for x in 0..half_width {
    // O(sqrt(N)), loop in y direction of data
    for y in 0..half_height {
      // O(1)
      let inv_x = window_size - x - 1;
      let inv_y = window_size - y - 1;
      // O(1), vector operations
      let mut c = read(data, window_size, x, y);
      c = replace(data, window_size,     y, inv_x, c);
      c = replace(data, window_size, inv_x, inv_y, c);
      c = replace(data, window_size, inv_y,     x, c);
      blit(data, window_size, x, y, c);
    }
  }
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run("1".to_string(), 1, 3);
    run("1".to_string(), -1, 0);
    run("0123".to_string(), 2, 0);
    run("0123".to_string(), -1, -1);
    run("0-1|X.2.3".to_string(), 3, 90);
    run("0-1|X.2.3".to_string(), -1, -103);
  }

  #[test]
  fn returns_expected_even() {
    let mut input = "0123".to_string().chars().collect::<Vec<_>>();
    let original = "0123".to_string().chars().collect::<Vec<_>>();
    let cw = "2031".to_string().chars().collect::<Vec<_>>();
    let flipped = "3210".to_string().chars().collect::<Vec<_>>();
    let ccw = "1302".to_string().chars().collect::<Vec<_>>();
    rotate_cw(&mut input, 2);
    assert_eq!(input, cw);
    rotate_cw(&mut input, 2);
    assert_eq!(input, flipped);
    rotate_cw(&mut input, 2);
    assert_eq!(input, ccw);
    rotate_cw(&mut input, 2);
    assert_eq!(input, original);
    rotate_ccw(&mut input, 2);
    assert_eq!(input, ccw);
    rotate_ccw(&mut input, 2);
    assert_eq!(input, flipped);
    rotate_ccw(&mut input, 2);
    assert_eq!(input, cw);
    rotate_ccw(&mut input, 2);
    assert_eq!(input, original);
    flip(&mut input, 2);
    assert_eq!(input, flipped);
    flip(&mut input, 2);
    assert_eq!(input, original);
  }

  #[test]
  fn returns_expected_odd() {
    let mut input = "0-1|X.2.3".to_string().chars().collect::<Vec<_>>();
    let original = "0-1|X.2.3".to_string().chars().collect::<Vec<_>>();
    let cw = "2|0.X-3.1".to_string().chars().collect::<Vec<_>>();
    let flipped = "3.2.X|1-0".to_string().chars().collect::<Vec<_>>();
    let ccw = "1.3-X.0|2".to_string().chars().collect::<Vec<_>>();
    rotate_cw(&mut input, 3);
    assert_eq!(input, cw);
    rotate_cw(&mut input, 3);
    assert_eq!(input, flipped);
    rotate_cw(&mut input, 3);
    assert_eq!(input, ccw);
    rotate_cw(&mut input, 3);
    assert_eq!(input, original);
    rotate_ccw(&mut input, 3);
    assert_eq!(input, ccw);
    rotate_ccw(&mut input, 3);
    assert_eq!(input, flipped);
    rotate_ccw(&mut input, 3);
    assert_eq!(input, cw);
    rotate_ccw(&mut input, 3);
    assert_eq!(input, original);
    flip(&mut input, 3);
    assert_eq!(input, flipped);
    flip(&mut input, 3);
    assert_eq!(input, original);
  }
}

