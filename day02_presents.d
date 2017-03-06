/+ dub.sdl:
name "aoc02"
+/

import std.typecons : Tuple;

pure @safe nothrow int paper(Tuple!(int, int, int) t) {
  import std.algorithm : min;
  int a = t[0];
  int b = t[1];
  int c = t[2];
  int minSide = min(a * b, a * c, b * c);
  return 2 * a * b + 2 * a * c + 2 * b * c + minSide;
}

pure @safe nothrow int ribbon(Tuple!(int, int, int) t) {
  import std.algorithm : max;
  int a = t[0];
  int b = t[1];
  int c = t[2];
  int maxDim = max(a, b, c);
  return a * b * c + 2 * (a + b + c - maxDim);
}

void main(string[] args) {
  import std.algorithm : map, sum;
  import std.file : slurp;
  import std.stdio : writeln;

  const dimensions = slurp!(int, int, int)(args.length <= 1 ? "/dev/stdin" : args[1], "%dx%dx%d");

  writeln(dimensions.map!(paper).sum);
  writeln(dimensions.map!(ribbon).sum);
}
