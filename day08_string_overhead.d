/+ dub.sdl:
name "aoc08"
+/

@safe ulong literalOverhead(string s) {
  import std.algorithm : count;
  import std.regex : ctRegex, matchAll;

  auto charRegex = ctRegex!(`\\"|\\\\|\\x..|[^\\]`);

  return s.length - s[1 .. $ - 1].matchAll(charRegex).count();
}

unittest {
  assert(literalOverhead(`""`) == 2);
  assert(literalOverhead(`"abc"`) == 2);
  assert(literalOverhead(`"aaa\"aaa"`) == 3);
  assert(literalOverhead(`"\x27"`) == 5);
}

pure @safe ulong encodedOverhead(string s) {
  import std.string : countchars;

  // The type of this is curious. Regex isn't accepted.
  // But the | works, so it's like a regex?
  // The docs just say isSomeString!(s) for it.
  return 2 + s.countchars("\"|\\");
}

void main(string[] args) {
  import std.algorithm : map, sum;
  import std.file : slurp;
  import std.stdio : writeln;

  const strs = slurp!(string)(args.length <= 1 ? "/dev/stdin" : args[1], "%s");

  writeln(strs.map!(literalOverhead).sum);
  writeln(strs.map!(encodedOverhead).sum);
}
