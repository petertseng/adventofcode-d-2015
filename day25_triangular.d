/+ dub.sdl:
name "aoc25"
+/

static enum ulong seed = 20151125;
static enum ulong base = 252533;
static enum ulong modulus = 33554393;

pure @safe nothrow ulong iterations(ulong row, ulong col) {
  ulong diagonal = row + col - 1;
  return (diagonal * diagonal + diagonal) / 2 - row;
}

pure @safe nothrow ulong modPow(ulong base, ulong exp, ulong mod) {
  if (exp == 0) {
    return 1;
  }

  ulong odds = 1;
  ulong evens = base;

  while (exp >= 2) {
    if (exp % 2 == 1) {
      odds = odds * evens % mod;
    }
    evens = evens * evens % mod;
    exp /= 2;
  }

  return evens * odds % mod;
}

void main(string[] args) {
  import std.conv : to;
  import std.stdio : writeln;

  ulong row = args.length <= 1 ? 0u : to!ulong(args[1]);
  ulong col = args.length <= 2 ? 0u : to!ulong(args[2]);

  ulong n = iterations(row, col);
  writeln(seed * modPow(base, n, modulus) % modulus);
}
