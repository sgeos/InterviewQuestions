// USAGE EXAMPLES:
//
//   cargo run rome
//   cargo run rome -f 0 -t 1
//   cargo run rome --from 0,1,2,4,5 --to 2,3,3,3,2
//   FROM=2,3,3,4 TO=1,1,0,0 cargo run rome
//
// PROBLEM:
//
//   You are given a map of the Roman Empire. There are ROADS + 1 cities
//   (numbered from 0 to ROADS) and ROADS directed roads between them.
//   The road network is connected; that is, ignoring the directions of
//   roads, there is a route between each pair of cities.
//
//   The capital of the Roman Empire is Rome. We know that all roads lead
//   to Rome. This means that there is a route from each city to Rome.
//   Your task is to find Rome on the map, or decide that it is not
//   there.
//
//   The roads are described by two vectors FROM and TO of ROADS integers
//   each. For each integer I (0 ≤ I < ROADS), there exists a road from
//   city FROM[I] to city TO[I].
//
//   Write a function:
//
//     fn solve(from: &Vec<i64>, to: &Vec<i64>) -> i64
//
//   that, given two arrays FROM and TO, returns the number of the city
//   which is Rome (the city that can be reached from all other cities).
//   If no such city exists, your function should return −1.
//
// EXAMPLES:
//
//   1. Given FROM = vec!(1, 2, 3) and TO = vec!(0, 0, 0), the function
//      should return 0. Rome has the number 0 on the map.
//
//     2
//       \
//         >
//           0  <- 3
//         >
//       /
//     1
//
//   2. Given FROM = vec!(0, 1, 2, 4, 5) and TO = vec!(2, 3, 3, 3, 2),
//      the function should return 3. Rome has the number 3 on the map.
//      From cities 1, 2 and 4, there is a direct road to city 3. From
//      cities 0 and 5, the roads to city 3 go through city 2.
//
//        5                 4
//          \             /
//            >         <
//              2 ->  3
//            >         <
//          /             \
//        0                 1
//
//   3. Given FROM = vec!(2, 3, 3, 4) and TO = vec!(1, 1, 0, 0), the
//      function should return −1. There is no Rome on the map.
//
//        2 -->  1  <-- 3 -->  0  <-- 4
//
//   Write an efficient algorithm for the following assumptions:
//
//     - ROADS is an integer within the range [1..200,000];
//     - each element of vectors FROM, TO is an integer within the range
//       [0..ROADS];
//     - the road network is connected.

pub fn run(from: &Vec<i64>, to: &Vec<i64>) {
  println!("roads from: {:?}", from);
  println!("roads to: {:?}", to);
  if !input_ok(from, to) {
    return;
  }
  let rome = solve(&from, &to);
  match rome {
    -1 => println!("Rome: None"),
    _ => println!("Rome: City {}", rome),
  }
}

// Not part of the solution, but...
// time complexity, O(N), loop over the vectors
// space complexity, O(1), scalar variables not based on input size
fn input_ok(from: &Vec<i64>, to: &Vec<i64>) -> bool {
  let length = from.len();
  if to.len() != length {
    println!("ERROR: Road vectors are not the same length.");
    return false;
  }
  let max = length as i64;
  for i in 0..length {
    if from[i] < 0 || to[i] < 0 {
      println!("ERROR: Negative city value.");
      return false;
    }
    if max < from[i] || max < to[i] {
      println!("ERROR: City value greater then number of roads.");
      return false;
    }
  }
  return true;
}

// time compexity, O(N), loop over vectors one at a time
// space compexity, O(N), vector of cities
fn solve(from: &Vec<i64>, to: &Vec<i64>) -> i64 {
  let roads = from.len();
  let mut cities: Vec<bool> = vec![false; roads + 1];
  for city in to.iter() {
    cities[*city as usize] = true;
  }
  for city in from.iter() {
    cities[*city as usize] = false;
  }
  let mut result: i64 = -1;
  for (city, is_rome) in cities.iter().enumerate() {
    if *is_rome {
      if result < 0 {
        result = city as i64;
      } else {
        return -1;
      }
    }
  }
  return result;
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run(&vec!(0), &vec!(0));
  }

  #[test]
  fn returns_expected() {
    assert_eq!( 1, solve(&vec!(0), &vec!(1)));
    assert_eq!(-1, solve(&vec!(0), &vec!(0)));
    assert_eq!( 0, solve(&vec!(1,2,3), &vec!(0,0,0)));
    assert_eq!( 3, solve(&vec!(0,1,2,4,5), &vec!(2,3,3,3,2)));
    assert_eq!(-1, solve(&vec!(2,3,3,4), &vec!(1,1,0,0)));
  }
}

