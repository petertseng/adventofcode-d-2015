/+ dub.sdl:
name "aoc13"
+/

void main(string[] args) {
  import std.algorithm.iteration : permutations;
  import std.file : slurp;
  import std.stdio : writeln;

  auto distLines = slurp!(string, string, uint, string)(args.length <= 1 ? "/dev/stdin" : args[1], "%s would %s %d happiness units by sitting next to %s.");
  int[string][string] dists;

  foreach (line; distLines) {
    int gain = line[2] * (line[1] == "lose" ? -1 : 1);
    dists[line[0]][line[3]] += gain;
    dists[line[3]][line[0]] += gain;
  }

  int maxCycle = 0;
  int maxPath = 0;

  foreach (permutation; dists.keys.permutations) {
    int dist = 0;
    for (uint i = 0; i + 1 < permutation.length; ++i) {
      dist += dists[permutation[i]][permutation[i + 1]];
    }

    if (dist > maxPath) {
      maxPath = dist;
    }

    dist += dists[permutation[0]][permutation[$ - 1]];

    if (dist > maxCycle) {
      maxCycle = dist;
    }
  }

  writeln(maxCycle);
  writeln(maxPath);
}
