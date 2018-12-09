/+ dub.sdl:
name "aoc15"
+/

import std.typecons : Tuple;

alias Ingredient = Tuple!(string, int, int, int, int, int);

pure @safe nothrow int[] add(immutable int[] traits, Ingredient ingredient, uint amount) {
  return [
    traits[0] + ingredient[1] * amount,
    traits[1] + ingredient[2] * amount,
    traits[2] + ingredient[3] * amount,
    traits[3] + ingredient[4] * amount,
    traits[4] + ingredient[5] * amount,
  ];
}

pure @safe nothrow void cookie(const Ingredient[] ingredients, uint remaining, immutable int[] traitsSoFar, ref uint best, ref uint best500) {
  import std.algorithm : fold, map;

  const Ingredient ingredient = ingredients[0];

  if (ingredients.length == 1) {
    int[] traitsWith = add(traitsSoFar, ingredient, remaining);
    int calories = traitsWith[$ - 1];
    int score = traitsWith[0 .. ($ - 1)].map!((a) => a > 0 ? a : 0).fold!((a, b) => a * b)(1);
    if (score > best) {
      best = score;
    }
    if (calories == 500 && score > best500) {
      best500 = score;
    }
    return;
  }

  for (uint i = 0; i < remaining; ++i) {
    immutable traitsWith = add(traitsSoFar, ingredient, i);
    // TODO: Can stop if the cookie is doomed.
    // That sped up Ruby from 3 seconds to 1 second,
    // but since the D code runs in < 0.05 seconds without that optimisation,
    // why bother?
    cookie(ingredients[1 .. $], remaining - i, traitsWith, best, best500);
  }
}

void main(string[] args) {
  import std.algorithm : fold, map;
  import std.file : slurp;
  import std.stdio : writeln;

  // TODO: Sort by largest negative?
  const ingredientLines = slurp!(Ingredient)(args.length <= 1 ? "/dev/stdin" : args[1], "%s: capacity %d, durability %d, flavor %d, texture %d, calories %d");

  uint best = 0;
  uint best500 = 0;

  cookie(ingredientLines, 100, [0, 0, 0, 0, 0], best, best500);

  writeln(best);
  writeln(best500);
}
