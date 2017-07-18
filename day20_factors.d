/+ dub.sdl:
name "aoc20"
+/

pure @safe nothrow uint firstHouse(uint target, uint perElf, uint elfLimit) {
  uint elfFactorNeeded = target / perElf;
  // TODO: Tighter upper bound allows smaller memory allocation.
  // TODO: Lower bound allows smaller memory allocation.
  uint upperBound = elfFactorNeeded;
  uint[] presents = new uint[upperBound + 1];

  for (uint elf = 1; elf <= upperBound; ++elf) {
    for (uint mult = 1; elf * mult <= upperBound && (elfLimit == 0 || mult < elfLimit); ++mult) {
      uint house = elf * mult;
      presents[house] += elf;
      if (mult == 1 && presents[house] >= elfFactorNeeded) {
        return house;
      }
    }
  }

  return 0;
}

void main(string[] args) {
  import std.conv : to;
  import std.file : readText;
  import std.stdio : writeln;
  import std.string : strip;

  uint target = to!uint(args.length <= 1 ? strip(readText("/dev/stdin")) : args[1]);

  writeln(firstHouse(target, 10, 0));
  writeln(firstHouse(target, 11, 50));
}
