mod question;

use clap::{App, Arg};

use std::error::Error;
use std::ffi::CStr;
use std::os::raw::{c_char, c_int};
use std::str::FromStr;

const APP_NAME: &str = "Interview Questions";
const APP_VERSION: &str = "0.1";

const DIGITAL_ROOT_DEFAULT_NUMBER: &str = "123";
const HELLO_DEFAULT_NAME: &str = "World";
const NAILS_DEFAULT_HAMMER: &str = "2";
const NAILS_DEFAULT_NAILS: &str = "1,1,3,3,3,4,5,5,5,5";
const PRINT_L_DEFAULT_SIZE: &str = "4";
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
    "digital_root" => {
      let number = match_value(&subcommand_matches, "number", DIGITAL_ROOT_DEFAULT_NUMBER.parse::<i64>().unwrap());
      question::digital_root::run(number);
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
 
