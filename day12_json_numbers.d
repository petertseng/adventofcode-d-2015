/+ dub.sdl:
name "aoc12"
+/

import std.json : JSONType, JSONValue;

pure long total(const JSONValue j, bool function(const JSONValue j) pure accept) {
  import std.algorithm : map, sum;

  if (!accept(j)) {
    return 0;
  }

  switch (j.type) {
  case JSONType.object:
    return j.object.values.map!((v) => v.total(accept)).sum;
  case JSONType.array:
    return j.array.map!((v) => v.total(accept)).sum;
  case JSONType.integer:
    return j.integer;
  case JSONType.uinteger:
    return j.uinteger;
  default:
    return 0;
  }
}

void main(string[] args) {
  import std.algorithm : any;
  import std.file : readText;
  import std.json : parseJSON;
  import std.stdio : writeln;

  immutable JSONValue j = parseJSON(readText(args.length <= 1 ? "/dev/stdin" : args[1]));

  writeln(j.total((_) => true));
  writeln(j.total((v) => v.type != JSONType.object || !v.object.values.any!(
          (vv) => vv.type == JSONType.string && vv.str == "red"
  )));
}
