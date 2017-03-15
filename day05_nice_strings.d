/+ dub.sdl:
name "aoc05"
+/

import std.regex : ctRegex, regex, matchFirst;
import std.typecons : Tuple;

alias char2 = Tuple!(char, char);

@safe bool nice1(string s) {
  // I don't think using ctRegex saved any time at all.
  // Nor did moving the regexes outside.
  // I also could not seem to use an immutable regex or const regex.
  auto badPair = ctRegex!("ab|cd|pq|xy");
  auto samePair = ctRegex!("(.)\\1");
  auto vowels = ctRegex!("(.*[aeiou]){3}");
  return s.matchFirst(badPair).empty && !s.matchFirst(samePair).empty && !s.matchFirst(vowels).empty;
}

@safe bool nice2_broken(string s) {
  // Very disappointing:
  // Could not get twoPair = regex("(..).*\\1") to work at all,
  // whether with matchFirst, matchAll, or bmatch.
  // https://issues.dlang.org/show_bug.cgi?id=15489
  // https://issues.dlang.org/show_bug.cgi?id=16251
  // (aba works fine though).
  auto aba = regex("(.).\\1");
  auto twoPair = regex("(..).*\\1");
  return !s.matchFirst(aba).empty && !s.matchFirst(twoPair).empty;
}

pure @safe nothrow bool nice2(string s) {
  char c1 = '\0';
  char c2 = '\0';

  bool aba = false;
  bool twoPair = false;
  size_t[char2] pairs;

  foreach (size_t i, char c3; s) {
    if (i == 0) {
      c1 = c3;
      continue;
    } else if (i == 1) {
      c2 = c3;
      pairs[char2(c1, c2)] = i;
      continue;
    }

    if (c1 == c3) {
      if (twoPair) {
        return true;
      }
      aba = true;
    }

    size_t* p = char2(c2, c3) in pairs;
    if (p && *p < i - 1) {
      if (aba) {
        return true;
      }
      twoPair = true;
    } else if (!p) {
      pairs[char2(c2, c3)] = i;
    }

    c1 = c2;
    c2 = c3;
  }

  return false;
}

void main(string[] args) {
  import std.algorithm : count;
  import std.file : slurp;
  import std.stdio : writeln;

  const strings = slurp!(string)(args.length <= 1 ? "/dev/stdin" : args[1], "%s");

  writeln(strings.count!(nice1)());
  writeln(strings.count!(nice2)());
}
