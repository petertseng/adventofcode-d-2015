/+ dub.sdl:
name "aoc09"
+/

void main(string[] args) {
  import std.algorithm : fold, map, max, min, permutations, sum;
  import std.file : slurp;
  import std.range : iota;
  import std.stdio : writeln;

  const distLines = slurp!(string, string, uint)(args.length <= 1 ? "/dev/stdin" : args[1], "%s to %s = %d");
  int[string][string] dists;

  foreach (line; distLines) {
    dists[line[0]][line[1]] = line[2];
    dists[line[1]][line[0]] = line[2];
  }

  auto distances = dists.keys.permutations.map!(p =>
      iota(0, p.length - 1).map!(i => dists[p[i]][p[i + 1]]).sum
  );

  auto minMax = distances.fold!(min, max);

  writeln(minMax[0]);
  writeln(minMax[1]);
}
