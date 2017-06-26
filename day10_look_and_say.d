/+ dub.sdl:
name "aoc10"
+/

pure @safe nothrow ubyte[] next(ubyte[] digits) {
  import std.algorithm : group;

  ubyte[] result;
  // Wonder if there's any better way to flatten?
  foreach (elt, count; digits.group()) {
    result ~= [cast(ubyte)(count), elt];
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
