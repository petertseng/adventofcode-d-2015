/+ dub.sdl:
name "aoc21"
+/

import std.typecons : tuple;

static enum weapons = [
  tuple(8, 4),
  tuple(10, 5),
  tuple(25, 6),
  tuple(40, 7),
  tuple(74, 8),
];

static enum armours = [
  tuple(0, 0),
  tuple(13, 1),
  tuple(31, 2),
  tuple(53, 3),
  tuple(75, 4),
  tuple(102, 5),
];

static enum rings = [
  tuple(0, 0, 0),
  tuple(25, 1, 0),
  tuple(50, 2, 0),
  tuple(100, 3, 0),
  tuple(20, 0, 1),
  tuple(40, 0, 2),
  tuple(80, 0, 3),
];

pure @safe nothrow bool win(int myHp, int myDamage, int myArmour, int bossHp, int bossDamage, int bossArmour) {
  import std.algorithm : max;

  uint myEffectiveDamage = max(myDamage - bossArmour, 1);
  uint bossEffectiveDamage = max(bossDamage - myArmour, 1);
  while (myHp > 0 && bossHp > 0) {
    bossHp -= myEffectiveDamage;
    myHp -= bossEffectiveDamage;
  }
  return bossHp <= 0;
}

unittest {
  assert(win(8, 5, 5, 12, 7, 2));
}

void main(string[] args) {
  import std.algorithm : cartesianProduct;
  import std.conv : to;
  import std.stdio : writeln;
  import std.typecons : Tuple;

  alias int2 = Tuple!(int, int);
  alias int3 = Tuple!(int, int, int);
  alias Items = Tuple!(int2, int2, int3, int3);

  int myHp = 100;
  int bossHp = args.length <= 1 ? 0 : to!uint(args[1]);
  int bossDamage = args.length <= 2 ? 0 : to!uint(args[2]);
  int bossArmour = args.length <= 3 ? 0 : to!uint(args[3]);

  uint minWin = uint.max;
  uint maxLose = 0;

  foreach (items; cartesianProduct(weapons, armours, rings, rings)) {
    const weapon = items[0];
    const armour = items[1];
    const ring1 = items[2];
    const ring2 = items[3];
    if (ring1 == ring2 && ring1[0] != 0) {
      // Can't have same ring.
      continue;
    }
    int myDamage = weapon[1] + ring1[1] + ring2[1];
    int myArmour = armour[1] + ring1[2] + ring2[2];
    int cost = weapon[0] + armour[0] + ring1[0] + ring2[0];
    if (win(myHp, myDamage, myArmour, bossHp, bossDamage, bossArmour)) {
      if (cost < minWin) {
        minWin = cost;
      }
    } else {
      if (cost > maxLose) {
        maxLose = cost;
      }
    }
  }

  writeln(minWin);
  writeln(maxLose);
}
