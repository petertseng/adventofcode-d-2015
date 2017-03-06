# adventofcode-d-2015

These are my solutions to http://adventofcode.com

All solutions are written in D.

[![Build Status](https://travis-ci.org/petertseng/adventofcode-d-2015.svg?branch=master)](https://travis-ci.org/petertseng/adventofcode-d-2015)

# Input

All inputs are hard-coded, with no file input capabilities.

Advantages:

  * No need to deal with reading input from a file, etc.
  * Can take advantage of `dub test`.

Diadvantages:

  * Might make timing comparisons against other languages unfair, since the compiler may be able to pre-compute some values from knowing the inputs at compile-time.
  * Knowing how to do file I/O is an important part of a language.
