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
* 25 (Triangular): Pass the row and column number in ARGV, in that order.

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

## Language notes

### Slurp

Slurp is quite good.
Impressed how it can return whatever type you specify, and also that it can return tuples if there's more than one per line, and scalars if there's just one.
It's not all-powerful though: See day 06 where I had to hack around its eager match.
Also note that for some reason what it returns can't become immutable.

### Style: const?

Should I make args const if they are pass-by-value? This includes strings.
This serves as assurance that I don't accidentally reassign internally.
But if I were writing an API, such an assurance is not particularly helpful to my clients.
It only helps the programmer.
I decided not to.
Select things in main (such as my input) are made const or immutable though.

### Regexes

Not impressed. See day 05.

### Tuples

Tuples with named fields are nice.

### map!

I initially kept forgetting I have to say `map!` instead of `map`, and the compiler error is very unhelpful in this case.
As of 2.074.1:

    day06_light_grid.d(58,23): Error: template std.algorithm.iteration.map cannot deduce function from argument types !()(int[1000][], void), candidates are:
    /usr/include/dlang/dmd/std/algorithm/iteration.d(456,1):        std.algorithm.iteration.map(fun...) if (fun.length >= 1)

As of 2.094.1, a little better, but still not sure it's clear I'm suppoesd to use `map!`

    day06_light_grid.d(58,23): Error: template std.algorithm.iteration.map cannot deduce function from argument types !()(uint[1000][], void), candidates are:
    /usr/include/dlang/dmd/std/algorithm/iteration.d(482,1):        map(fun...)
      with fun = ()
      must satisfy the following constraint:
           fun.length >= 1

### Static arrays

See day 06: static arrays can't be used as inputs to functions that want ranges.
http://forum.dlang.org/thread/zmcurpjtlkyrgikomrvn@forum.dlang.org

### algebraic

Very useful, see day 07.
`visit!` makes sure all variants are handled.

### UFCS

Very useful; I routinely use it.
I seem to not use it for `array` though, whereas the code I lifted off of Rosetta Code (day 24) did.

### No destructuring

Not being able to destructure the iteratee in `foreach` is a little unfortunate.
Would have been useful in day 09 and day 21.
At least you can omit the type (explicitly saying `auto` doesn't work!).

### recurrence

Pretty cool. See day 10.

### min of a range

I wish you could do `things.min` to get the minimum thing out of things, rather than `things.fold!(min)`.

### Style: template args?

Unsure about best style for template args, such as for map.
Double quotes? Backticks? Function literal? If I use either of the first two, parens or not?

### Style: imports?

Unsure whether all imports should go at top of function, or as close as possible to use.
I think I'll settle on "top of scopes only, narrowest scope possible"?
