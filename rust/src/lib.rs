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
 
