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
    uint function(uint x) onOffFn;
    uint function(uint x) brightFn;

    switch (c.command.length) {
    case 1:
      onOffFn = (_) { return 1; };
      brightFn = (x) { return x + 1; };
      break;
    case 2:
      onOffFn = (_) { return 0; };
      brightFn = (x) { return x == 0 ? 0 : x - 1; };
      break;
    case 4:
      onOffFn = (x) { return 1 - x; };
      brightFn = (x) { return x + 2; };
      break;
    default:
      throw new Exception("unknown command: " ~ c[0] ~ "o" ~ c.command);
    }

    foreach (int y; c.ymin .. c.ymax + 1) {
      foreach (int x; c.xmin .. c.xmax + 1) {
        onOff[y][x] = onOffFn(onOff[y][x]);
        bright[y][x] = brightFn(bright[y][x]);
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
