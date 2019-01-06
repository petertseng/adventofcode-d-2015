/+ dub.sdl:
name "aoc06"
+/

import std.typecons : Tuple;

alias Command = Tuple!(string, string, "command", uint, "xmin", uint, "ymin", uint, "xmax", uint, "ymax");

void main(string[] args) {
  import std.algorithm : map, sum;
  import std.file : slurp;
  import std.stdio : writeln;

  // Sadly, I couldn't get slurp "%s %d,%d through %d,%d" to work:
  // Unexpected 'o' when converting from type char[] to type int
  // That's because the first space in "turn on" makes %s match with "turn" and %d match with "on".
  // Thus, we have to split on the "o" which is present in all three choices.
  const commands = slurp!(Command)(args.length <= 1 ? "/dev/stdin" : args[1], "%so%s %d,%d through %d,%d");

  uint[1000][1000] onOff, bright;

  foreach (Command c; commands) {
    foreach (int y; c.ymin .. c.ymax + 1) {
      foreach (int x; c.xmin .. c.xmax + 1) {
        switch (c.command.length) {
        case 1:
          onOff[y][x] = 1;
          bright[y][x] += 1;
          break;
        case 2:
          onOff[y][x] = 0;
          if (bright[y][x] > 0) {
            bright[y][x] -= 1;
          }
          break;
        case 4:
          onOff[y][x] = 1 - onOff[y][x];
          bright[y][x] += 2;
          break;
        default:
          throw new Exception("unknown command: " ~ c[0] ~ "o" ~ c.command);
        }
      }
    }
  }

  // Need that extra [] are needed.
  // http://forum.dlang.org/thread/zmcurpjtlkyrgikomrvn@forum.dlang.org
  // I tried onOff.joiner.sum, but that gets:
  // template std.algorithm.iteration.joiner cannot deduce function from argument types !()(int[1000][1000])
  // Then I tried onOff[].joiner.sum, which gets similar:
  // template std.algorithm.iteration.joiner cannot deduce function from argument types !()(int[1000][])
  writeln(onOff[].map!(a => a[].sum).sum);
  writeln(bright[].map!(a => a[].sum).sum);
}
