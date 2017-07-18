/+ dub.sdl:
name "aoc19"
+/

void main(string[] args) {
  import std.algorithm : count;
  import std.file : slurp;
  import std.stdio : writeln;

  const lines = slurp!(string)(args.length <= 1 ? "/dev/stdin" : args[1], "%s");
  const rules = lines[0 .. $ - 2];
  const string molecule = lines[$ - 1];

  bool[string] seen;

  ulong maxE = 0;

  foreach (rule; rules) {
    import std.algorithm : max;
    import std.array : split;
    import std.string : indexOf;

    const words = rule.split();
    const string from = words[0];
    const string to = words[$ - 1];

    if (from == "e") {
      maxE = max(maxE, to.count!("a >= 'A' && a <= 'Z'"));
    }

    for (ptrdiff_t start = molecule.indexOf(from); start >= 0; start = molecule.indexOf(from, start + 1)) {
      seen[molecule[0 .. start] ~ to ~ molecule[start + from.length .. $]] = true;
    }
  }

  writeln(seen.length);

  size_t elements = molecule.count!("a >= 'A' && a <= 'Z'");
  size_t rn = molecule.count("Rn");
  size_t y = molecule.count('Y');
  //size_t ar = molecule.count("Ar");
  // # Ar should == # Rn
  writeln(elements - rn * 2 - y * 2 - (maxE - 1));
}
