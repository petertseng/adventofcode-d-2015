/+ dub.sdl:
name "aoc24"
dependency "adventofcode" path="."
+/

pure @safe nothrow size_t minNeeded(const ulong[] weights, ulong target) {
  import std.algorithm : sort;

  ulong weightSoFar = 0;
  size_t n = 0;

  foreach (weight; weights.dup.sort!("a > b")) {
    ++n;
    weightSoFar += weight;
    if (weightSoFar >= target) {
      return n;
    }
  }

  return weights.length;
}

pure @safe immutable(ulong)[] partition(const ulong[] weights, uint numGroups) {
  import std.algorithm : sum;
  import combinations : combinations;

  ulong total = weights.sum;
  ulong eachGroup = total / numGroups;

  for (size_t i = minNeeded(weights, eachGroup); i <= weights.length / numGroups; ++i) {
    import std.algorithm : filter, minElement, reduce;
    import std.array : array;

    // Incorrect: Does not check for partitionability on the winning set.
    auto winningCombos = array(weights.combinations(i).filter!(a => a.sum == eachGroup));
    if (winningCombos.length != 0) {
      return winningCombos.minElement!(c => c.reduce!("a * b"));
    }
  }

  return weights.dup;
}

void main(string[] args) {
  import std.algorithm : reduce;
  import std.file : slurp;
  import std.stdio : writeln;

  const weights = slurp!(ulong)(args.length <= 1 ? "/dev/stdin" : args[1], "%d");

  foreach (n; [3, 4]) {
    const best = partition(weights, n);
    writeln(best.reduce!("a * b"));
  }
}
