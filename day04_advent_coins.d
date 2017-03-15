/+ dub.sdl:
name "aoc04"
+/

void main(string[] args) {
  import core.stdc.stdio : sprintf;
  import std.algorithm : all;
  import std.digest.md : md5Of;
  import std.file : readText;
  import std.stdio : writefln;

  immutable string input = args.length <= 1 ? readText("/dev/stdin") : args[1];
  char[] buf = input.dup;

  int zeroes = 1;
  int n = 0;
  size_t len = input.length + 1;
  int nextTen = 10;
  // Do I need this + 1 for the extra null byte?
  buf.length = len + 1;

  while (zeroes <= 6) {
    int fullBytes = zeroes >> 1;
    bool halfByte = (zeroes & 1) == 1;

    sprintf(buf.ptr + input.length, "%d", n);
    auto md5 = md5Of(buf[0 .. len]);

    if (all!"a == 0"(md5[0..fullBytes]) && (!halfByte || (md5[fullBytes] & ~15) == 0)) {
      if (zeroes >= 5) {
        writefln("%d", n);
      }
      ++zeroes;
    } else {
      ++n;
      if (n == nextTen) {
        nextTen *= 10;
        ++len;
        ++buf.length;
      }
    }
  }
}
