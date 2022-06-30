// USAGE EXAMPLES:
//
//   cargo run ascii_encoder
//   cargo run ascii_encoder -p "energy" -m "e=mc^2"
//   cargo run ascii_encoder --password password --message user@email.com
//   PASSWORD=art MESSAGE=Key cargo run ascii_encoder
//
//   cargo run ascii_decoder
//   cargo run ascii_decoder -p "energy" -m "I=oU^g"
//   cargo run ascii_decoder --password password --message Jgz5@oP4rR.8B2
//   PASSWORD=art MESSAGE=1m1 cargo run ascii_decoder
//
// PROBLEM:
//
//   A password is used to encode the alphanumeric characters in a message.
//   For the purposes of encoding messages, the alphanumeric characters
//   consist of the lowercase letters (a to z), uppercase letters (A to Z),
//   and Arabic numerals (0 to 9), in that order.  The following algorithm
//   is used for encoding.
//
//   1) Shift the first character in message forward in the alphanumeric
//     character set N spaces, where N is the sum of the numerical values
//     of the ASCII codes of all the characters in the password.  Loop back
//     to 'a' from '9' when necessary.
//   2) Shift every subsequent alphanumeric character forward by M spaces,
//     where M is the sum of N and the position in the character set of the
//     previously encoded character after it was encoded.  Note that 'a'
//     has the position of 0, not 1.
//
//   EXAMPLE.
//     The password is "Secret", and the message is "Hello, world!"
//     N is 614 = 83 + 101 + 99 + 114 + 101 + 116
//     "H" becomes "B" after being shifted forward 614 places.
//     For the second charater, M is 641 = 614 + 27.
//     "e" becomes "z" after being shifted forward 641 places.
//     For the third charater, M is 639 = 614 + 25.
//     "l" becomes "E" after being shifted forward 639 places.
//     ...
//     The encoded message is "BzEJR, 7fqvs!"
//
//   Write the decoder for this algorithm.  Include test data.

const LETTER_COUNT: u32 = 26;
const NUMBER_COUNT: u32 = 10;
const CHAR_COUNT: u32 = 2*LETTER_COUNT + NUMBER_COUNT;

pub fn run_decoder(password: String, message: String) {
  println!("{}", decode_message(&password, &message));
}

pub fn run_encoder(password: String, message: String) {
  println!("{}", encode_message(&password, &message));
}

fn decode_message(password: &str, message: &str) -> String {
  let mut result = vec![];
  let password_offset: u32 = password_to_offset(password);
  let mut index: u32 = 0;
  for c in message.chars() {
    let decoded_char = match c {
      'a'..='z' | 'A'..='Z' | '0'..='9' => {
        let offset = (password_offset + index) % CHAR_COUNT;
        index = char_to_index(c);
        // looks funny but clamps to positive numbers in range
        let new_index = (CHAR_COUNT + index - offset) % CHAR_COUNT;
        index_to_char(new_index)
      },
      // other characters do not need to be decoded
      _ => c,
    };
    result.push(decoded_char);
  }
  return result.iter().collect::<String>();
}

fn encode_message(password: &str, message: &str) -> String {
  let mut result = vec![];
  let password_offset: u32 = password_to_offset(password);
  let mut new_index: u32 = 0;
  for c in message.chars() {
    let encoded_char = match c {
      'a'..='z' | 'A'..='Z' | '0'..='9' => {
        let offset = password_offset + new_index;
        let index = char_to_index(c);
        new_index = (index + offset) % CHAR_COUNT;
        index_to_char(new_index)
      },
      // other characters do not need to be encoded
      _ => c,
    };
    result.push(encoded_char);
  }
  return result.iter().collect::<String>();
}

fn password_to_offset(password: &str) -> u32 {
  let mut result: u32 = 0;
  for c in password.chars() {
    result += c as u32;
  }
  return result;
}

fn char_to_index(c: char) -> u32 {
  match c {
    'a'..='z' => c as u32 - 'a' as u32 + 0*LETTER_COUNT,
    'A'..='Z' => c as u32 - 'A' as u32 + 1*LETTER_COUNT,
    '0'..='9' => c as u32 - '0' as u32 + 2*LETTER_COUNT,
    _ => 0,
  }
}

fn index_to_char(i: u32) -> char {
  match i {
    0..=25 =>  char::from_u32(i + 'a' as u32 - 0*LETTER_COUNT).unwrap(),
    26..=51 => char::from_u32(i + 'A' as u32 - 1*LETTER_COUNT).unwrap(),
    52..=61 => char::from_u32(i + '0' as u32 - 2*LETTER_COUNT).unwrap(),
    _ => '?',
  }
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn run_ok() {
    run_encoder("".to_string(), "".to_string());
    run_decoder("".to_string(), "".to_string());
  }

  #[test]
  fn returns_expected() {
    assert_eq!("BzEJR, 7fqvs!", encode_message("Secret", "Hello, world!"));
    assert_eq!("Hello, world!", decode_message("Secret", "BzEJR, 7fqvs!"));
    assert_eq!("I=oU^g", encode_message("energy", "e=mc^2"));
    assert_eq!("e=mc^2", decode_message("energy", "I=oU^g"));
    assert_eq!("Jgz5@oP4rR.8B2", encode_message("password", "user@email.com"));
    assert_eq!("user@email.com", decode_message("password", "Jgz5@oP4rR.8B2"));
    assert_eq!("1m1", encode_message("art", "Key"));
    assert_eq!("Key", decode_message("art", "1m1"));
    assert_eq!(614, password_to_offset("Secret"));
    assert_eq!(0, char_to_index('a'));
    assert_eq!(26, char_to_index('A'));
    assert_eq!(52, char_to_index('0'));
    assert_eq!(0, char_to_index('?'));
    assert_eq!('a', index_to_char(0));
    assert_eq!('A', index_to_char(26));
    assert_eq!('0', index_to_char(52));
    assert_eq!('?', index_to_char(66));
  }
}
