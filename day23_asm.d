/+ dub.sdl:
name "aoc23"
+/

pure @safe uint[char] run(const string[][] insts, uint[char] regs) {
  import std.conv : to;

  size_t pc = -1;

  while (++pc < insts.length) {
    // Ideally we would pre-parse these instructions so we're not repeatedly parsing,
    // but I don't care.
    const string[] inst = insts[pc];
    switch (inst[0]) {
    case "hlf":
      regs[inst[1][0]] /= 2;
      break;
    case "tpl":
      regs[inst[1][0]] *= 3;
      break;
    case "inc":
      ++regs[inst[1][0]];
      break;
    case "jmp":
      pc += to!int(inst[1]) - 1;
      break;
    case "jie":
      if (regs[inst[1][0]] % 2 == 0) {
        pc += to!int(inst[2]) - 1;
      }
      break;
    case "jio":
      if (regs[inst[1][0]] == 1) {
        pc += to!int(inst[2]) - 1;
      }
      break;
    default:
      throw new Exception("bad inst " ~ inst[0]);
    }
  }

  return regs;
}

void main(string[] args) {
  import std.algorithm : map;
  import std.array : array, split;
  import std.file : slurp;
  import std.stdio : writeln;

  const insts = array(slurp!(string)(args.length <= 1 ? "/dev/stdin" : args[1], "%s").map!("a.split"));

  writeln(run(insts, ['a': 0u, 'b': 0u])['b']);
  writeln(run(insts, ['a': 1u, 'b': 0u])['b']);
}
