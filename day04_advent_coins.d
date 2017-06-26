/+ dub.sdl:
name "aoc04"
+/

void main(string[] args) {
  import std.algorithm : all;
  import std.conv : to;
  import std.digest.md : md5Of;
  import std.file : readText;
  import std.stdio : writefln;

  immutable string input = args.length <= 1 ? readText("/dev/stdin") : args[1];

  int zeroes = 1;
  int n = 0;

  while (zeroes <= 6) {
    int fullBytes = zeroes >> 1;
    bool halfByte = (zeroes & 1) == 1;
    auto md5 = md5Of(input ~ to!string(n));
    if (all!"a == 0"(md5[0..fullBytes]) && (!halfByte || (md5[fullBytes] & ~15) == 0)) {
      if (zeroes >= 5) {
        writefln("%d", n);
      }
      ++zeroes;
    } else {
      ++n;
    }
  }
}
