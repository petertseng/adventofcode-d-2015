/+ dub.sdl:
name "aoc14"
+/

immutable uint raceLength = 2503;

class Reindeer {
  immutable uint speed;
  immutable uint runTime;
  immutable uint restTime;

  this(uint speed, uint runTime, uint restTime) pure {
    this.speed = speed;
    this.runTime = runTime;
    this.restTime = restTime;
  }

  pure @safe nothrow uint tick() {
    import std.stdio : writefln;

    ++timeInState;
    if (resting) {
      if (timeInState == restTime) {
        resting = false;
        timeInState = 0;
      }
    } else {
      distance += speed;
      if (timeInState == runTime) {
        resting = true;
        timeInState = 0;
      }
    }
    return distance;
  }

  pure @safe nothrow uint lead(uint leaderDistance) {
    if (leaderDistance == distance) {
      ++points;
    }
    return points;
  }

private:
  uint distance = 0;
  uint points = 0;
  uint timeInState = 0;
  bool resting = false;
}

void main(string[] args) {
  import std.algorithm : map, max, reduce;
  import std.array : array;
  import std.file : slurp;
  import std.stdio : writeln;

  const reindeerLines = slurp!(string, uint, uint, uint)(args.length <= 1 ? "/dev/stdin" : args[1], "%s can fly %d km/s for %d seconds, but then must rest for %d seconds.");
  Reindeer[] reindeer = array(reindeerLines.map!(a => new Reindeer(a[1], a[2], a[3])));

  for (int i = 0; i < raceLength; ++i) {
    uint leaderDistance = reindeer.map!(a => a.tick()).reduce!(max);
    uint mostPoints = reindeer.map!(a => a.lead(leaderDistance)).reduce!(max);
    if (i == raceLength - 1) {
      writeln(leaderDistance);
      writeln(mostPoints);
    }
  }
}
