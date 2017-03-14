/+ dub.sdl:
name "aoc03"
+/

import std.typecons : Tuple;

alias Coord = Tuple!(int, "y", int, "x");
alias Trip = Tuple!(Coord[], "santas", bool[Coord], "visited");

void main(string[] args) {
  import std.file : readText;
  import std.stdio : writeln;

  immutable string arrows = readText(args.length <= 1 ? "/dev/stdin" : args[1]);

  Trip t1 = Trip([Coord()], [Coord(0, 0): true]);
  Trip t2 = Trip([Coord(), Coord()], [Coord(0, 0): true]);

  foreach (size_t i, char c; arrows) {
    Coord* santa1 = &t1.santas[0];
    Coord* santa2 = &t2.santas[i % 2];

    switch (c) {
    case '>':
      santa1.x += 1;
      santa2.x += 1;
      break;
    case '<':
      santa1.x -= 1;
      santa2.x -= 1;
      break;
    case '^':
      santa1.y += 1;
      santa2.y += 1;
      break;
    case 'v':
      santa1.y -= 1;
      santa2.y -= 1;
      break;
    case '\n':
      break;
    default:
      writeln("Unknown character " ~ c);
      break;
    }
    t1.visited[*santa1] = true;
    t2.visited[*santa2] = true;
  }

  writeln(t1.visited.length);
  writeln(t2.visited.length);
}
