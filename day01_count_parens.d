/+ dub.sdl:
name "aoc01"
+/

pure @safe int endFloor(string parens) {
  import std.algorithm : map, sum;
  return parens.map!(c => c == '(' ? 1 : c == ')' ? -1 : 0).sum;
}

pure @safe nothrow int firstBasement(string parens) {
  int floor = 0;
  foreach (i, c; parens) {
    floor += c == '(' ? 1 : -1;
    if (floor == -1) {
      return cast(int) i + 1;
    }
  }
  return -1;
}

void main(string[] args) {
  import std.file : readText;
  import std.stdio : writeln;

  immutable string parens = readText(args.length <= 1 ? "/dev/stdin" : args[1]);

  writeln(endFloor(parens));
  writeln(firstBasement(parens));
}
