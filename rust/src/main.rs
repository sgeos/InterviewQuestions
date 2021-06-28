use lib::run;
use lib::rlib_run;

use std::env;
use std::error::Error;
use std::ffi::CString;
use std::os::raw::{c_char, c_int};
use std::ptr;

fn main() {
  ffi_main();
}

// For systems where the FFI is used.
fn ffi_main() {
  let args: Vec<CString> = env::args()
    .map(|s| CString::new(s).expect("CString::new failed"))
    .collect();
  let c_args: Vec<*const c_char> = args
    .iter()
    .map(|a| a.as_ptr())
    .collect();
  let argc: c_int = args.len() as c_int;
  let argv: *const *const c_char = c_args.as_ptr();

  run(argc, argv);
}

// For systems where everything is written in Rust.
fn rlib_main() -> Result<(), Box<dyn Error>> {
  let mut env_args: Vec<String> = env::args().collect();
  let args: Vec<&str> = env_args
    .iter_mut()
    .map(|s| s.as_str())
    .collect();
  rlib_run(args)
}

// For systems where command line arguments do not make sense.
fn no_arg_ffi_main() {
  run(0, ptr::null());
}

#[cfg(test)]
mod tests {
  use super::*;

  #[test]
  fn main_ok() {
    main();
  }

  #[test]
  fn ffi_main_ok() {
    ffi_main();
  }

  #[test]
  fn rlib_main_ok() {
    let is_ok = match rlib_main() {
      Err(_) => false,
      _ => true,
    };
    assert!(is_ok);
  }

  #[test]
  fn no_arg_ffi_main_ok() {
    no_arg_ffi_main();
  }
}

