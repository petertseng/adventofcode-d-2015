/+ dub.sdl:
name "aoc22"
+/

enum Spell {
  MagicMissile = 53,
  Drain = 73,
  Shield = 113,
  Poison = 173,
  Recharge = 229,
}

enum Winner {
  Nobody,
  Player,
  Boss,
}

struct Game {
  this(uint myHp, uint myMp, uint bossHp, uint bossDamage, bool hard) pure {
    this.myHp = myHp;
    this.myMp = myMp;
    this.bossHp = bossHp;
    this.bossDamage = bossDamage;
    this.hard = hard;
    if (hard) {
      --this.myHp;
    }
  }

  pure @safe Game castSpell(Spell s) const {
    import std.exception : enforce;
    enforce(winner == Winner.Nobody, "Can't cast spell on finished game");
    enforce(myMp >= s, "Not enough mana to cast spell");

    Game g = this;

    g.applySpellEffect(s);
    g.myMp -= s;
    if (g.winner != Winner.Nobody) {
      return g;
    }

    g.tickTimers();
    if (g.winner != Winner.Nobody) {
      return g;
    }

    g.bossAttack();
    if (g.winner != Winner.Nobody) {
      return g;
    }

    if (g.hard) {
      --g.myHp;
    }
    if (g.winner != Winner.Nobody) {
      return g;
    }

    g.tickTimers();
    return g;
  }

  pure @safe nothrow @property Spell[] legalSpells() const {
    import std.algorithm : filter;
    import std.array : array;
    import std.traits : EnumMembers;

    return array([EnumMembers!Spell].filter!(s => canCast(s)));
  }

  private:

  int myHp;
  uint myMp;
  int bossHp;
  uint bossDamage;
  bool hard;

  uint shieldTime = 0;
  uint poisonTime = 0;
  uint rechargeTime = 0;

  pure @safe nothrow bool canCast(Spell s) const {
    if (s == Spell.Shield && shieldTime > 0) {
      return false;
    }
    if (s == Spell.Poison && poisonTime > 0) {
      return false;
    }
    if (s == Spell.Recharge && rechargeTime > 0) {
      return false;
    }
    return myMp >= s;
  }

  pure @safe nothrow void applySpellEffect(Spell s) {
    final switch (s) {
    case Spell.MagicMissile:
      bossHp -= 4;
      break;
    case Spell.Drain:
      myHp += 2;
      bossHp -= 2;
      break;
    case Spell.Shield:
      shieldTime = 6;
      break;
    case Spell.Poison:
      poisonTime = 6;
      break;
    case Spell.Recharge:
      rechargeTime = 5;
      break;
    }
  }

  pure @safe nothrow void tickTimers() {
    if (shieldTime > 0) {
      --shieldTime;
    }
    if (rechargeTime > 0) {
      myMp += 101;
      --rechargeTime;
    }
    if (poisonTime > 0) {
      bossHp -= 3;
      --poisonTime;
    }
  }

  pure @safe nothrow void bossAttack() {
    uint armour = shieldTime > 0 ? 7 : 0;
    uint damage = bossDamage > armour ? bossDamage - armour : 1;
    myHp -= damage;
  }

  pure @safe nothrow @property Winner winner() const {
    if (bossHp <= 0) {
      return Winner.Player;
    }
    if (myHp <= 0) {
      return Winner.Boss;
    }
    return Winner.Nobody;
  }
}

class Search {
  import std.typecons : Tuple;

  this(Game g) pure {
    game = g;
  }

  pure @safe nothrow @property Spell[] bestSpells() const {
    return bestList.dup;
  }

  pure @safe Tuple!(uint, Spell[]) best() {
    import std.typecons : tuple;
    uint mana = bestFrom(game, (Spell[]).init, 0, 1);
    return tuple(mana, bestList);
  }

  private:

  const Game game;
  uint bestCost = uint.max;
  Spell[] bestList;
  uint[Game] seen;

  pure @safe uint bestFrom(const Game game, const Spell[] spellsSoFar, uint costSoFar, uint turn) {
    import std.algorithm : fold, map, min;

    if (game in seen && seen[game] <= costSoFar) {
      return uint.max;
    }
    seen[game] = costSoFar;

    Spell[] legal = game.legalSpells;
    if (legal.length == 0) {
      return uint.max;
    }

    // Sorry, stateful map.
    return legal.map!(delegate uint(Spell spell) {
      const Game gameAfter = game.castSpell(spell);
      uint costAfter = costSoFar + spell;

      final switch (gameAfter.winner) {
      case Winner.Boss:
        return uint.max;
      case Winner.Player:
        if (costAfter < bestCost) {
          bestCost = costAfter;
          bestList = spellsSoFar ~ [spell];
        }
        return costAfter;
      case Winner.Nobody:
        Spell[] spellsAfter = spellsSoFar ~ [spell];
        return bestFrom(gameAfter, spellsAfter, costAfter, turn + 1);
      }
    }).fold!(min);
  }
}

unittest {
  Game g = Game(10, 250, 13, 8, false);
  g = g.castSpell(Spell.Poison);
  g = g.castSpell(Spell.MagicMissile);
  assert(g.winner == Winner.Player);

  g = Game(10, 250, 14, 8, false);
  g = g.castSpell(Spell.Poison);
  g = g.castSpell(Spell.MagicMissile);
  assert(g.winner == Winner.Boss);

  g = Game(10, 250, 14, 8, false);
  g = g.castSpell(Spell.Recharge);
  g = g.castSpell(Spell.Shield);
  g = g.castSpell(Spell.Drain);
  g = g.castSpell(Spell.Poison);
  g = g.castSpell(Spell.MagicMissile);
  assert(g.winner == Winner.Player);
}

void main(string[] args) {
  import std.conv : to;
  import std.stdio : writeln;

  int myHp = 50;
  int myMp = 500;
  int bossHp = args.length <= 1 ? 0 : to!uint(args[1]);
  int bossDamage = args.length <= 2 ? 0 : to!uint(args[2]);

  foreach (hard; [false, true]) {
    Search s = new Search(Game(myHp, myMp, bossHp, bossDamage, hard));
    const best = s.best;
    writeln(best[0]);
    //writeln(best[1]);
  }
}
