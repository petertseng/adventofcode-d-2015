/+ dub.sdl:
name "aoc18"
+/

pure @safe nothrow void gameOfLife(const bool[][] src, bool[][] dest, bool stuck) {
  import std.algorithm : min;

  foreach (y, row; src) {
    size_t yMin = y == 0 ? 0 : y - 1;
    size_t yMax = min(src.length, y + 2);
    bool cornerRow = y == 0 || y == src.length - 1;
    foreach (x, cell; row) {
      size_t xMin = x == 0 ? 0 : x - 1;
      size_t xMax = min(src[0].length, x + 2);
      uint n = 0;
      foreach (ny; yMin .. yMax) {
        foreach (nx; xMin .. xMax) {
          if (ny == y && nx == x) {
            continue;
          }
          if (src[ny][nx]) {
            ++n;
          }
        }
      }
      bool corner = cornerRow && (x == 0 || x == src[0].length - 1);
      dest[y][x] = n == 3 || n == 2 && cell || stuck && corner;
    }
  }
}

void main(string[] args) {
  import std.array : array;
  import std.algorithm : count, map, sum;
  import std.file : slurp;
  import std.stdio : writeln;

  bool[][] grid = array(slurp!(string)(args.length <= 1 ? "/dev/stdin" : args[1], "%s").map!(l => array(l.map!`a == '#'`)));
  bool[][] grid2 = array(grid.map!`new bool[a.length]`);
  bool[][] stuckGrid = array(grid.map!`a.dup`);
  bool[][] stuckGrid2 = array(stuckGrid.map!`new bool[a.length]`);

  stuckGrid[0][0] = true;
  stuckGrid[0][$ - 1] = true;
  stuckGrid[$ - 1][0] = true;
  stuckGrid[$ - 1][$ - 1] = true;

  for (int i = 0; i < 100; ++i) {
    gameOfLife(grid, grid2, false);
    gameOfLife(stuckGrid, stuckGrid2, true);

    bool[][] tmp = grid;
    grid = grid2;
    grid2 = tmp;
    tmp = stuckGrid;
    stuckGrid = stuckGrid2;
    stuckGrid2 = tmp;
  }

  writeln(grid.map!(l => l.count!`a`).sum);
  writeln(stuckGrid.map!(l => l.count!`a`).sum);
}
