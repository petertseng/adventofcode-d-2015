# adventofcode-d-2015

These are my solutions to http://adventofcode.com

All solutions are written in D.

[![Build Status](https://travis-ci.org/petertseng/adventofcode-d-2015.svg?branch=master)](https://travis-ci.org/petertseng/adventofcode-d-2015)

# Input

In general, all solutions can be invoked in both of the following ways:

* Without command-line arguments, takes input on standard input.
* With 1+ command-line arguments, reads input from the first, which must be the path to an input file.
  Arguments beyond the first are ignored.

Some may additionally support other ways:

* 4 (Advent Coins): Pass the secret key in ARGV.
* 10 (Look and Say): Pass the seed sequence in ARGV.
* 11 (Passwords): Pass the initial password in ARGV.
* 20 (Factors): Pass the target number of gifts in ARGV.
* 21 (RPG): Pass the Boss's HP, damage, and armor in ARGV, in that order.
* 22 (Wizard): Pass the Boss's HP and damage in ARGV, in that order. Pass `-d` flag to see example battles.

## DUB

DUB is used to build the library functions common to all days, but each day is its own [single-file package](https://code.dlang.org/getting_started#single-file-packages).
The alternative would have to been to have the entire thing be a single DUB library, taking advantage of D's native `unittest` functionality.

Advantages of doing it this way:

  * It can be useful to have example code to do file I/O (turns out it's pretty simple in D).
  * Fairer runtime timing comparisons against other languages. If inputs are known at compile-time, the compiler may pre-compute some values before runtime.
  * Failure messages of D's native `unittest`, being `assert`s, are not particularly helpful in saying what failed (no expected/observed values, etc.); `diff` makes it clear what failed.
  * Flexibility: A built binary may be run against many users' inputs, instead of only some specific hard-coded inputs.

Diadvantages:

  * Can't take advantage of `dub test`.
  * Extra boilerplate per file (`dub.sdl` comment header, `main` that reads input file).
