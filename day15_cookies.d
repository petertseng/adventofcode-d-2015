/+ dub.sdl:
name "aoc15"
+/

import std.typecons : Tuple;

alias Ingredient = Tuple!(string, int, int, int, int, int);

void main(string[] args) {
  import std.algorithm : fold, map;
  import std.file : slurp;
  import std.stdio : writeln;

  // TODO: Sort by largest negative?
  const ingredientLines = slurp!(Ingredient)(args.length <= 1 ? "/dev/stdin" : args[1], "%s: capacity %d, durability %d, flavor %d, texture %d, calories %d");

  uint best = 0;
  uint best500 = 0;

  for (int x1 = 0; x1 <= 100; ++x1) {
    // TODO: Code is repetitive, make better.
    // TODO: Can stop if the cookie is doomed.
    // That sped up Ruby from 3 seconds to 1 second,
    // but since the D code runs in < 0.05 seconds without that optimisation,
    // why bother?
    immutable v1 = [
      ingredientLines[0][1] * x1,
      ingredientLines[0][2] * x1,
      ingredientLines[0][3] * x1,
      ingredientLines[0][4] * x1,
    ];
    int cal1 = ingredientLines[0][5] * x1;
    for (int x2 = 0; x1 + x2 <= 100; ++x2) {
      immutable v12 = [
        v1[0] + ingredientLines[1][1] * x2,
        v1[1] + ingredientLines[1][2] * x2,
        v1[2] + ingredientLines[1][3] * x2,
        v1[3] + ingredientLines[1][4] * x2,
      ];
      int cal12 = cal1 + ingredientLines[1][5] * x2;
      for (int x3 = 0; x1 + x2 + x3 <= 100; ++x3) {
        int x4 = 100 - x1 - x2 - x3;
        immutable vs = [
          v12[0] + ingredientLines[2][1] * x3 + ingredientLines[3][1] * x4,
          v12[1] + ingredientLines[2][2] * x3 + ingredientLines[3][2] * x4,
          v12[2] + ingredientLines[2][3] * x3 + ingredientLines[3][3] * x4,
          v12[3] + ingredientLines[2][4] * x3 + ingredientLines[3][4] * x4,
        ];
        int cal = cal12 + ingredientLines[2][5] * x3 + ingredientLines[3][5] * x4;
        int score = vs.map!((a) => a > 0 ? a : 0).fold!((a, b) => a * b)(1);
        if (score > best) {
          best = score;
        }
        if (cal == 500 && score > best500) {
          best500 = score;
        }
      }
    }
  }

  writeln(best);
  writeln(best500);
}
