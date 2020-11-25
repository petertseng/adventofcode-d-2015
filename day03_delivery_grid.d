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
    foreach (Trip t; [t1, t2]) {
      Coord* santa = &t.santas[i % t.santas.length];
      switch (c) {
      case '>':
        santa.x += 1;
        break;
      case '<':
        santa.x -= 1;
        break;
      case '^':
        santa.y += 1;
        break;
      case 'v':
        santa.y -= 1;
        break;
      case '\n':
        break;
      default:
        writeln("Unknown character " ~ c);
        break;
      }
      t.visited[*santa] = true;
    }
  }

  writeln(t1.visited.length);
  writeln(t2.visited.length);
}
