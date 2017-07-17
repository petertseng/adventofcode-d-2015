/+ dub.sdl:
name "aoc17"
+/

pure @safe nothrow uint[uint] ways(const uint[] containers, int weight, uint used) {
  if (containers.length == 0) {
    return (uint[uint]).init;
  }
  if (weight == 0) {
    return [used: 1];
  }
  if (weight < 0) {
    return (uint[uint]).init;
  }
  if (containers.length == 1) {
    return weight == containers[0] ? [used + 1u: 1u] : (uint[uint]).init;
  }
  // Ways without.
  auto ways = containers[1 .. $].ways(weight, used);
  // Ways with.
  foreach (wayWith; containers[1 .. $].ways(weight - containers[0], used + 1).byKeyValue()) {
    ways[wayWith.key] += wayWith.value;
  }
  return ways;
}

void main(string[] args) {
  import std.algorithm : fold, min, sum;
  import std.file : slurp;
  import std.stdio : writeln;

  const containers = slurp!(uint)(args.length <= 1 ? "/dev/stdin" : args[1], "%d");

  const ways = containers.ways(150, 0);
  writeln(ways.values.sum);
  writeln(ways[ways.keys.fold!(min)]);
}
