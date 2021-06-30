mod question;

use clap::{App, Arg};

use std::error::Error;
use std::ffi::CStr;
use std::os::raw::{c_char, c_int};
use std::str::FromStr;

const APP_NAME: &str = "Interview Questions";
const APP_VERSION: &str = "0.1";

const COUNT_DUPLICATES_DEFAULT_STRING: &str = "aabBcde";
const DIGIT_1_DEFAULT_NUMBER: &str = "13";
const DIGITAL_ROOT_DEFAULT_NUMBER: &str = "123";
const DUPLICATE_ENCODE_DEFAULT_STRING: &str = "Success";
const HELLO_DEFAULT_NAME: &str = "World";
const NAILS_DEFAULT_HAMMER: &str = "2";
const NAILS_DEFAULT_NAILS: &str = "1,1,3,3,3,4,5,5,5,5";
const PRINT_L_DEFAULT_SIZE: &str = "4";
const ROME_DEFAULT_FROM: &str = "1,2,3";
const ROME_DEFAULT_TO: &str = "0,0,0";
const ROTATE_DEFAULT_DATA: &str = "01234F.#.5E.#.6D.##7CBA98";
const ROTATE_DEFAULT_ROTATE: &str = "1";
const ROTATE_DEFAULT_SIZE: &str = "-1";
const UNIQUE_STRING_DEFAULT_STRING: &str = "test";

#[no_mangle]
pub extern fn run(argc: c_int, argv: *const *const c_char) {
  let mut args = Vec::new();
  for i in 0..(argc as isize) {
    unsafe {
      let arg: &str = CStr::from_ptr(*argv.offset(i)).to_str().unwrap_or("");
      args.push(arg);
    }
  }
  match rlib_run(args) {
    Err(e) => println!("{:?}", e),
    _ => ()
  }
}

pub fn rlib_run(args: Vec<&str>) -> Result<(), Box<dyn Error>> {
  // Command Line Arguments
  let matches = parse_args(args);
  let subcommand_name = matches.subcommand_name().unwrap_or("");
  let subcommand_matches = matches.subcommand_matches(subcommand_name).unwrap_or(&matches);

  match subcommand_name {
    "count_duplicates" => {
      let string = match_value(&subcommand_matches, "string", COUNT_DUPLICATES_DEFAULT_STRING.to_string());
      question::count_duplicates::run(string);
    },
    "digit_1" => {
      let number = match_value(&subcommand_matches, "number", DIGIT_1_DEFAULT_NUMBER.parse::<i64>().unwrap());
      question::digit_1::run(number);
    },
    "digital_root" => {
      let number = match_value(&subcommand_matches, "number", DIGITAL_ROOT_DEFAULT_NUMBER.parse::<i64>().unwrap());
      question::digital_root::run(number);
    },
    "duplicate_encode" => {
      let string = match_value(&subcommand_matches, "string", DUPLICATE_ENCODE_DEFAULT_STRING.to_string());
      question::duplicate_encode::run(string);
    },
    "hello" => {
      let name = match_value(&subcommand_matches, "name", HELLO_DEFAULT_NAME.to_string());
      question::hello::run(name);
    },
    "nails" => {
      let hammer = match_value(&subcommand_matches, "hammer", NAILS_DEFAULT_HAMMER.parse::<i64>().unwrap());
      let mut nails: Vec<i64> =
        match_value(&subcommand_matches, "nails", NAILS_DEFAULT_NAILS.to_string())
        .split(',')
        .map(|s| s.parse::<i64>().unwrap_or(0))
        .collect();
      nails.sort();
      question::nails::run(&nails, hammer);
    },
    "print_l" => {
      let size = match_value(&subcommand_matches, "size", PRINT_L_DEFAULT_SIZE.parse::<i64>().unwrap());
      question::print_l::run(size);
    },
    "rome" => {
      let from: Vec<i64> =
        match_value(&subcommand_matches, "from", ROME_DEFAULT_FROM.to_string())
        .split(',')
        .map(|s| s.parse::<i64>().unwrap_or(0))
        .collect();
      let to: Vec<i64> =
        match_value(&subcommand_matches, "to", ROME_DEFAULT_TO.to_string())
        .split(',')
        .map(|s| s.parse::<i64>().unwrap_or(0))
        .collect();
      question::rome::run(&from, &to);
    },
    "rotate" => {
      let data = match_value(&subcommand_matches, "data", ROTATE_DEFAULT_DATA.to_string());
      let rotate = match_value(&subcommand_matches, "rotate", ROTATE_DEFAULT_ROTATE.parse::<i64>().unwrap());
      let size = match_value(&subcommand_matches, "size", ROTATE_DEFAULT_SIZE.parse::<i64>().unwrap());
      question::rotate::run(data, size, rotate);
    },
    "unique_character" => {
      let string = match_value(&subcommand_matches, "string", UNIQUE_STRING_DEFAULT_STRING.to_string());
      question::unique_character::run(&string);
    },
    _ => question::hello::run(HELLO_DEFAULT_NAME.to_string()),
  }

  Ok(())
}

fn parse_args(args: Vec<&str>) -> clap::ArgMatches {
  App::new(APP_NAME)
    .version(APP_VERSION)
    .author("Brendan Sechter <sgeos@hotmail.com>")
    .about("Interview questions project.")
    .subcommand(App::new("count_duplicates")
      .about("Print number of duplicated characters in string.")
      .arg(Arg::new("string")
        .env("STRING")
        .about("Input string.")
        .long("string")
        .short('s')
        .takes_value(true)
        .default_value(COUNT_DUPLICATES_DEFAULT_STRING)
      )
    )
    .subcommand(App::new("digit_1")
      .about("Print number of 1 digits in numbers from 0 to input value.")
      .arg(Arg::new("number")
        .env("NUMBER")
        .about("Input number.")
        .long("number")
        .short('n')
        .takes_value(true)
        .default_value(DIGIT_1_DEFAULT_NUMBER)
      )
    )
    .subcommand(App::new("digital_root")
      .about("Print recursive sum of digits in a number.")
      .arg(Arg::new("number")
        .env("NUMBER")
        .about("Input number.")
        .long("number")
        .short('n')
        .takes_value(true)
        .default_value(DIGITAL_ROOT_DEFAULT_NUMBER)
      )
    )
    .subcommand(App::new("duplicate_encode")
      .about("Enode string using '(' for unique characters and ')' for duplicates.")
      .arg(Arg::new("string")
        .env("STRING")
        .about("Input string.")
        .long("string")
        .short('s')
        .takes_value(true)
        .default_value(DUPLICATE_ENCODE_DEFAULT_STRING)
      )
    )
    .subcommand(App::new("hello")
      .about("Simple hello world example.")
      .arg(Arg::new("name")
        .env("NAME")
        .about("Message username.")
        .long("name")
        .short('n')
        .takes_value(true)
        .default_value(HELLO_DEFAULT_NAME)
      )
    )
    .subcommand(App::new("nails")
      .about("Nails of same length after hammering down at most H.")
      .arg(Arg::new("hammer")
        .env("HAMMER")
        .about("Number of nails to hammer down.")
        .long("hammer")
        .short('h')
        .takes_value(true)
        .default_value(NAILS_DEFAULT_HAMMER)
      )
      .arg(Arg::new("nails")
        .env("NAILS")
        .about("Comma-separated list of nail lengths.")
        .long("nails")
        .short('n')
        .takes_value(true)
        .default_value(NAILS_DEFAULT_NAILS)
      )
    )
    .subcommand(App::new("print_l")
      .about("Print an ASCII-art L.")
      .arg(Arg::new("size")
        .env("SIZE")
        .about("Size of L.")
        .long("size")
        .short('s')
        .takes_value(true)
        .default_value(PRINT_L_DEFAULT_SIZE)
      )
    )
    .subcommand(App::new("rome")
      .about("Find Rome based on the logic that all roads lead to Rome. FROM[N] leads to TO[N].")
      .arg(Arg::new("from")
        .env("FROM")
        .about("Comma-separated list of cities where roads start from.")
        .long("from")
        .short('f')
        .takes_value(true)
        .default_value(ROME_DEFAULT_FROM)
      )
      .arg(Arg::new("to")
        .env("TO")
        .about("Comma-separated list of cities where roads lead to.")
        .long("to")
        .short('t')
        .takes_value(true)
        .default_value(ROME_DEFAULT_TO)
      )
    )
    .subcommand(App::new("rotate")
      .about("Rotate square string-image in increments of 90 degrees.")
      .arg(Arg::new("data")
        .env("DATA")
        .about("Square string-image data.")
        .long("data")
        .short('d')
        .takes_value(true)
        .default_value(ROTATE_DEFAULT_DATA)
      )
      .arg(Arg::new("rotate")
        .env("ROTATE")
        .about("Number of times to rotate clockwise.  Negative values can be used to rotate counter-clockwise.")
        .long("rotate")
        .short('r')
        .takes_value(true)
        .default_value(ROTATE_DEFAULT_ROTATE)
      )
      .arg(Arg::new("size")
        .env("SIZE")
        .about("Length of side of square.  Use negative value to autocalculate by taking the square root of the string-image data length.")
        .long("size")
        .short('s')
        .takes_value(true)
        .default_value(ROTATE_DEFAULT_SIZE)
      )
    )
    .subcommand(App::new("unique_character")
      .about("String has unique characters or not.")
      .arg(Arg::new("string")
        .env("STRING")
        .about("String to test.")
        .long("string")
        .short('s')
        .takes_value(true)
        .default_value(UNIQUE_STRING_DEFAULT_STRING)
      )
    )
    .get_matches_from(args)
}

fn match_value<T: FromStr>(matches: &clap::ArgMatches, key: &str, default: T) -> T {
  // println!("{} {:?}", key, matches.value_of(key));
  matches
    .value_of(key)
    .unwrap()
    .parse::<T>()
    .unwrap_or(default)
}

#[cfg(test)]
mod tests {
  use super::*;
  use std::ffi::CString;

  #[test]
  fn run_ok() {
    let args: Vec<CString> =
      vec![CString::new("help").expect("CString::new failed")];
    let c_args: Vec<*const c_char> = args
      .iter()
      .map(|a| a.as_ptr())
      .collect();
    let argc: c_int = args.len() as c_int;
    let argv: *const *const c_char = c_args.as_ptr();

    run(argc, argv);
  }

  #[test]
  fn rlib_run_ok() {
    let args: Vec<&str> = vec!["help"];

    let is_ok = match rlib_run(args) {
      Err(_) => false,
      _ => true,
    };
    assert!(is_ok);
  }
}
 
