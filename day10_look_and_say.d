/+ dub.sdl:
name "aoc10"
+/

pure @safe nothrow ubyte[] next(ubyte[] digits) {
  ubyte counted = 0;
  ubyte count = 0;

  ubyte[] result;

  foreach (digit; digits ~ [cast(ubyte)(0)]) {
    if (digit == counted) {
      ++count;
    } else {
      if (count > 0) {
        result ~= [count, counted];
      }
      counted = digit;
      count = 1;
    }
  }

  return result;
}

void main(string[] args) {
  import std.algorithm : map;
  import std.array : array;
  import std.stdio : writeln;

  immutable string input = args.length <= 1 ? "12" : args[1];

  ubyte[] digits = array(input.map!(e => cast(ubyte)(e - '0')));

  foreach (n; [40, 10]) {
    for (int j = 0; j < n; ++j) {
      digits = next(digits);
    }
    writeln(digits.length);
  }
}
