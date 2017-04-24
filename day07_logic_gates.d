/+ dub.sdl:
name "aoc07"
+/

import std.typecons : Tuple;
import std.variant : Algebraic;

alias Input = Algebraic!(string, ushort);
alias Wire = Algebraic!(Input, Tuple!(bool, Input), Tuple!(string, Input, Input));

pure Input parseInput(string s) {
  import std.conv : ConvException, to;
  try {
    return Input(to!ushort(s));
  } catch (ConvException e) {
    return Input(s);
  }
}

ushort value(const Wire[string] circuit, string wire, ushort[string] cache) {
  import std.variant : visit;

  if (wire in cache) {
    return cache[wire];
  }

  auto input = delegate ushort(Input i) {
    return i.visit!(
      (string s) => value(circuit, s, cache),
      (ushort v) => v,
    );
  };

  return cache[wire] = circuit[wire].visit!(
    (Input i) => input(i),
    (Tuple!(bool, Input) unop) => ~input(unop[1]),
    delegate ushort(Tuple!(string, Input, Input) binop) {
      ushort v1 = input(binop[1]);
      ushort v2 = input(binop[2]);
      switch (binop[0]) {
      case "AND":
        return v1 & v2;
      case "OR":
        return v1 | v2;
      case "LSHIFT":
        return cast(ushort)(v1 << v2);
      case "RSHIFT":
        return v1 >> v2;
      default:
        throw new Exception("Unknown command " ~ binop[0]);
      }
    },
  );
}

void main(string[] args) {
  import std.array : split;
  import std.file : slurp;
  import std.stdio : writeln;
  import std.typecons : tuple;

  const lines = slurp!(string)(args.length <= 1 ? "/dev/stdin" : args[1], "%s");

  Wire[string] wires;

  foreach (string line; lines) {
    auto splits = line.split();
    switch (splits.length) {
    case 3:
      wires[splits[2]] = parseInput(splits[0]);
      break;
    case 4:
      if (splits[0] != "NOT") {
        throw new Exception("Unknown command " ~ line);
      }
      wires[splits[3]] = tuple(true, parseInput(splits[1]));
      break;
    case 5:
      wires[splits[4]] = tuple(splits[1], parseInput(splits[0]), parseInput(splits[2]));
      break;
    default:
      throw new Exception("Unknown command " ~ line);
    }
  }

  auto run = () => value(wires, "a", ["": 0]);
  ushort a = run();
  writeln(a);
  wires["b"] = Input(a);
  writeln(run());
}
