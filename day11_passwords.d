/+ dub.sdl:
name "aoc11"
+/

pure @safe nothrow char nextChar(char c) {
  // Hmm, can't just use c + 2 or c + 1.
  ++c;
  if (c == 'i' || c == 'l' || c == 'o') {
    ++c;
  }
  return c;
}

pure @safe nothrow void nextAtPlace(char[] password, size_t place) {
  if (password[place] == 'z') {
    password[place] = 'a';
    password.nextAtPlace(place - 1);
  } else {
    password[place] = password[place].nextChar;
  }
}

pure @safe nothrow void nextPairAtPlace(char[] password, size_t place) {
  bool lastWasZ = password[place] == 'z';
  password.nextAtPlace(place);
  // cbz -> cca, but NOT aaa -> aab
  if (lastWasZ && password[place - 2] == password[place - 1]) {
    return;
  }

  /*
     We don't need to check more than 3 chars.
     The only way >= 3 chars change is if at least the last two chars are z.
     In that case, nextAtPlace would give a string ending in aa, and that's a pair.
     For the same reason, it's OK that we didn't return early for dczz -> ddaa.
  */

  if (password[place - 1] > password[place]) {
    // Easy case: only the last char changes.
    // For example, cba -> cbb
    password[place] = password[place - 1];
  } else if (password[place - 1] > password[place]) {
    // The last two chars have to change. Two cases:
    if (password[place - 2] == password[place - 1].nextChar) {
      // The third-to-last and second-to-last character make a pair.
      // For example, cbc -> cca (which comes before ccc)
      password[place - 1] = password[place - 2];
      password[place] = 'a';
    } else {
      // The second-to-last and last character make a pair.
      // For example, cab -> cbb (which comes before cca)
      password[place] = password[place - 1] = password[place - 1].nextChar;
      // It's impossible for second-to-last to be 'z'.
      // No letter sorts after 'z'.
      // So we won't accidentally turn a 'z' into a '{' this way.
    }
  }
}

void main(string[] args) {
  import std.regex : ctRegex, matchFirst;
  import std.stdio : writeln;

  char[] password = (args.length <= 1 ? "abcdefgh" : args[1]).dup;
  size_t length = password.length;

  foreach (i, c; password) {
    if (c == 'i' || c == 'l' || c == 'o') {
      password.nextAtPlace(i);
      for (size_t j = i + 1; j < password.length; ++j) {
        password[j] = 'a';
      }
      break;
    }
  }

  auto straight = ctRegex!("abc|bcd|cde|def|efg|fgh|pqr|qrs|rst|stu|tuv|uvw|vwx|wxy|xyz");
  auto pairs = ctRegex!("(.)\\1.*(.)\\2");
  // Safe pair is one that will not be destroyed when searching for another
  auto safePair = ctRegex!("(.)\\1.{2,}");

  for (int i = 0; i < 2; ++i) {
    while (password.matchFirst(straight).empty || password.matchFirst(pairs).empty) {
      if (!password.matchFirst(pairs).empty) {
        // Only doing nextAtPlace takes about 1 second.
        password.nextAtPlace(length - 1);
      } else if (!password.matchFirst(safePair).empty) {
        // If there are not enough pairs, make the next password with one.
        // Speeds up from 1 second -> 0.7 seconds.
        password.nextPairAtPlace(length - 1);
      } else {
        // If there are no pairs at all, make the next password with two.
        // Speeds up from 0.7 seconds -> 0.1 seconds.
        password.nextPairAtPlace(length - 3);
        password[length - 2] = password[length - 1] = 'a';
        // Obviously there's more work to be done (next password with straights
        // AND zero, one, or two pairs), but too much code, too little speedup.
        // If we were iterating through all possible passwords,
        // then maybe it would be worth it.
      }
    }
    writeln(password);

    password.nextAtPlace(length - 1);
  }
}
