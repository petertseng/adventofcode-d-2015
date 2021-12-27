/+ dub.sdl:
name "aoc20"
+/

immutable uint[15] PRIMES = [47, 43, 41, 39, 31, 29, 23, 19, 17, 13, 11, 7, 5, 3, 2];

// askalski's tip
// https://www.reddit.com/r/adventofcode/comments/po1zel/comment/hd1esc2
pure @safe nothrow uint sumExceeds(uint goal, uint primeIdx, uint[uint] cache) {
  import std.algorithm : min;

  if (primeIdx >= PRIMES.length) {
    return goal;
  }

  uint cacheKey = goal * cast(uint) PRIMES.length + primeIdx;
  if (cacheKey in cache) {
    return cache[cacheKey];
  }

  uint prime = PRIMES[primeIdx];
  uint primePower = 1;
  uint primeSum = 1;

  uint best = sumExceeds(goal, primeIdx + 1, cache);

  while (primeSum < goal) {
    primePower *= prime;
    primeSum += primePower;

    // subproblem: ceil(goal/prime_sum) using only primes less than prime
    uint subgoal = (goal + primeSum - 1) / primeSum;
    best = min(best, primePower * sumExceeds(subgoal, primeIdx + 1, cache));
  }

  return best;
}

pure @safe nothrow bool good2(uint house, uint target) {
  uint elves = 0;
  for (uint div = 1; div <= 50; div++) {
    if (house % div == 0) {
      elves += house / div;
    }
  }
  return 11 * elves >= target;
}

void main(string[] args) {
  import std.conv : to;
  import std.file : readText;
  import std.stdio : writeln;
  import std.string : strip;

  uint target = to!uint(args.length <= 1 ? strip(readText("/dev/stdin")) : args[1]);

  uint[uint] cache;
  uint house1 = sumExceeds(target / 10, 0, cache);
  writeln(house1);

  for (uint i = good2(house1, target) ? 0 : house1; i < target; i += 2 * 3 * 5 * 7) {
    if (good2(i, target)) {
      writeln(i);
      return;
    }
  }
}
