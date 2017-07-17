/+ dub.sdl:
name "aoc16"
+/

static enum constraints = [
  "children": 3,
  "cats": 7,
  "samoyeds": 2,
  "pomeranians": 3,
  "akitas": 0,
  "vizslas": 0,
  "goldfish": 5,
  "trees": 3,
  "cars": 2,
  "perfumes": 1,
];

static enum funcs = [
  // Otherwise, "Error: can't have associative array of void"???
  "garbage": function bool(int, int) => 0,
  "cats": (a, b) => a > b,
  "trees": (a, b) => a > b,
  "pomeranians": (a, b) => a < b,
  "goldfish": (a, b) => a < b,
];

void main(string[] args) {
  import std.algorithm : all;
  import std.file : slurp;
  import std.stdio : writeln;

  const sueLines = slurp!(int, string, int, string, int, string, int)(args.length <= 1 ? "/dev/stdin" : args[1], "Sue %d: %s: %d, %s: %d, %s: %d");

  size_t[] sue1 = [], sue2 = [];

  foreach (i, sueLine; sueLines) {
    immutable sue = [sueLine[1]: sueLine[2], sueLine[3]: sueLine[4], sueLine[5]: sueLine[6]];
    if (sue.byKeyValue.all!((kv) => constraints[kv.key] == kv.value)) {
      sue1 ~= i + 1;
    }
    if (sue.byKeyValue.all!((kv) => kv.key in funcs ? funcs[kv.key](kv.value, constraints[kv.key]) : kv.value == constraints[kv.key])) {
      sue2 ~= i + 1;
    }
  }

  foreach(sue; sue1) {
    writeln(sue);
  }
  foreach(sue; sue2) {
    writeln(sue);
  }
}
