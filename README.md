# Interview Questions

This is a place to put interview questions I have been asked.
Coding on a white board or a piece of paper is completely unnatural.
The solutions in this repository are how I actually code.

Assessing a programmer with a paper or whiteboard exercise is like
assessing a person's table manners after giving them a straw to
use to eat a meal.  The exercise is not entirely without merit,
but it is insane and silly.

# Installation Instructions

Clone this repository.

```sh
git clone git@github.com:sgeos/InterviewQuestions.git
mv InterviewQuestions interview_questions
cd interview_questions
```

## Rust

The files in the **rust** directory require the [Rust][rust-home]
programming language.
Instructions for installing Rust can be found [here][rust-install].

Rust examples are located in **rust/src**.
**main.rs** is boilerplate code that has a few strategies for
communicating with the library code to build an executable binary.
**lib.rs** contains library code with FFI and native Rust entry points.
It parses command line arguments and calls the appropriate question based
on a subcommand.
Note that many of the option can also be defined with environment
variables.

**question.rs** is a module that lists and exposes all of the questions.
The **question** directory contains the code for each individual
question.
Each module has a top level **run()** function that takes parameters
appropriate for the problem.
**lib.rs** parses the parameters from the command line before passing them in.

The help subcommand can be used to get information about the subcommands
and parameters that can be used.
Individual files in the **questions** directory have usage examples.

```sh
cd rust

# list subcommands and general options
cargo run -- --help

# list options for a particular subcommand
cargo run hello --help
cargo run unique_character --help
```

Defaults are used if nothing is specified.

```sh
# default command with default arguments
cargo run

# default arguments
cargo run hello
cargo run unique_character
```

Parameters tend to have a short name, long name, and environment variable
option.

```sh
# hello examples
cargo run hello -n Rust
cargo run hello --name $(whoami)
NAME=environment cargo run hello

# unique_character examples
cargo run unique_character -s 日曜日
cargo run unique_character --string 忍者
STRING=$(whoami) cargo run unique_character
```

## Elixir

The files in the **elixir** directory require the [Elixir][elixir-home]
programming language.
Instructions for installing Elixir can be found [here][elixir-install].

If **env** is located at **/usr/bin/env**, then the **.exs** files
can be executed.

```sh
cd elixir
chmod +x *.exs
./fizz_buzz.exs -s 2 -F Big... -B Scary... -W Monsters!
```

Otherwise **elixir** can be used to run them.

```sh
elixir fizz_buzz.exs -s 2 -F Big... -B Scary... -W Monsters!
```

# Software Versions

```sh
$ date -u "+%Y-%m-%d %H:%M:%S +0000"
2021-06-25 04:51:07 +0000
$ uname -vm
Darwin Kernel Version 20.5.0: Sat May  8 05:10:33 PDT 2021; root:xnu-7195.121.3~9/RELEASE_X86_64 x86_64
$ rustc -V && rustup -V
rustc 1.53.0 (53cb7b09b 2021-06-17)
rustup 1.24.3 (ce5817a94 2021-05-31)
$ mix hex.info
Hex:    0.21.2
Elixir: 1.11.2
OTP:    23.1
```

# Links

- [Elixir, Home Page][elixir-home]
- [Elixir, Installing Elixir][elixir-install]
- [Rust, Home Page][rust-home]
- [Rust, Install Rust][rust-install]

[elixir-home]:    http://elixir-lang.org
[elixir-install]: http://elixir-lang.org/install.html
[rust-home]:      https://www.rust-lang.org
[rust-install]:   https://www.rust-lang.org/tools/install

