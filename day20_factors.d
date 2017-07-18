/+ dub.sdl:
name "aoc20"
+/

pure @safe nothrow uint gifts(uint house, uint elfLimit) {
  uint given = 0;
  for (uint i = 1; i * i <= house; ++i) {
    if (house % i != 0) {
      continue;
    }
    uint factor1 = i;
    uint factor2 = house / i;
    if (elfLimit == 0 || factor2 < elfLimit) {
      given += factor1;
    }
    if (factor1 != factor2 && (elfLimit == 0 || factor1 < elfLimit)) {
      given += factor2;
    }
  }
  return given;
}

pure @safe nothrow uint houseUpperBound(uint target, uint elfLimit) {
  // smallest greater factorial:
  uint bound = 2;
  uint n = 2;
  while (gifts(bound, elfLimit) < target) {
    n += 1;
    bound *= n;
  }

  // Decrease each factor
  for (uint from = n; from > 1; --from) {
    uint boundWithout = bound / from;
    for (uint to = 1; to < from; ++to) {
      uint boundWith = boundWithout * to;
      if (gifts(boundWith, elfLimit) >= target) {
        bound = boundWith;
        break;
      }
    }
  }

  return bound;
}

pure @safe houseLowerBound(uint target) {
  // Euler-Mascheroni constant
  static enum real gamma = 0.57721566490153286060651209008240243104215933593992;

  import std.conv : to;
  import std.math : ceil, exp, log;

  // Robin's inequality:
  // \sigma(n) < e^\gamma n \log \log n
  // n \log \log n > \frac{T}{e^\gamma}
  // lower bound, so \log \log n can be increased to \log \log T
  // n > \frac{T}{e^\gamma \log \log T}

  uint n = to!uint(ceil(target / (exp(gamma) * log(log(target)))));

  // TODO: This was approximate (since we changed an n for T) and we can do better,
  // but the improvement is unlikely to be significant (704242 -> 733346, 641725 -> 668446).

  // Robin's inequality doesn't hold for n <= 5040.
  return n > 5040 ? n : 1;
}

pure @safe uint firstHouse(uint target, uint perElf, uint elfLimit) {
  uint elfFactorNeeded = target / perElf;
  uint lowerBound = houseLowerBound(elfFactorNeeded);
  uint upperBound = houseUpperBound(elfFactorNeeded, elfLimit);
  uint[] presents = new uint[upperBound + 1 - lowerBound];

  for (uint elf = 1; elf <= upperBound; ++elf) {
    uint skipped = elf < lowerBound ? (lowerBound - 1) / elf : 0;
    for (uint mult = skipped + 1; elf * mult <= upperBound && (elfLimit == 0 || mult < elfLimit); ++mult) {
      uint house = elf * mult;
      presents[house - lowerBound] += elf;
      if (mult == 1 && presents[house - lowerBound] >= elfFactorNeeded) {
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
