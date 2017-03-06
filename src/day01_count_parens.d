import std.algorithm : map, sum;

pure @safe int endFloor(string parens) {
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

unittest {
  assert(endFloor("(())") == 0);
  assert(endFloor("()()") == 0);
  assert(endFloor("(((") == 3);
  assert(endFloor("(()(()(") == 3);
  assert(endFloor("))(((((") == 3);
  assert(endFloor("())") == -1);
  assert(endFloor("))(") == -1);
  assert(endFloor(")))") == -3);
  assert(endFloor(")())())") == -3);

  assert(firstBasement(")") == 1);
  assert(firstBasement("()())") == 5);
}
