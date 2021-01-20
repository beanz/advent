use std::collections::HashMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Spell {
    cost: usize,
    damage: i32,
    heal: i32,
    armor: i32,
    mana: i32,
    turns: usize,
}

const MAGIC_MISSILE: Spell = Spell {
    cost: 53,
    damage: 4,
    heal: 0,
    armor: 0,
    mana: 0,
    turns: 0,
};
const DRAIN: Spell = Spell {
    cost: 73,
    damage: 2,
    heal: 2,
    armor: 0,
    mana: 0,
    turns: 0,
};
const SHIELD: Spell = Spell {
    cost: 113,
    damage: 0,
    heal: 0,
    armor: 7,
    mana: 0,
    turns: 6,
};
const POISON: Spell = Spell {
    cost: 173,
    damage: 3,
    heal: 0,
    armor: 0,
    mana: 0,
    turns: 6,
};
const RECHARGE: Spell = Spell {
    cost: 229,
    damage: 0,
    heal: 0,
    armor: 0,
    mana: 101,
    turns: 5,
};

const ALL_SPELLS: [Spell; 5] = [MAGIC_MISSILE, DRAIN, SHIELD, POISON, RECHARGE];

#[derive(Debug, Clone, PartialEq, Eq, Default)]
struct Me {
    hp: i32,
    armor: i32,
    mana: i32,
    mana_spent: usize,
    active: HashMap<Spell, usize>,
}

impl Me {
    fn new(hp: i32, mana: i32) -> Me {
        Me {
            hp,
            armor: 0,
            mana,
            mana_spent: 0,
            active: HashMap::new(),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Boss {
    hp: i32,
    damage: i32,
}

impl Boss {
    fn new(hp: i32, damage: i32) -> Boss {
        Boss { hp, damage }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Default)]
struct State {
    me: Me,
    boss: Boss,
    hard_mode: bool,
}

impl State {
    fn turn(&mut self, spell: &Spell) {
        // wizard turn
        for sp in ALL_SPELLS.iter() {
            if let Some(turns) = self.me.active.get_mut(sp) {
                self.me.hp += sp.heal;
                self.me.mana += sp.mana;
                self.boss.hp -= sp.damage;
                *turns -= 1;
                if *turns == 0 {
                    self.me.active.remove(sp);
                    if sp.armor != 0 {
                        self.me.armor -= sp.armor;
                    }
                }
            }
        }
        self.me.mana -= spell.cost as i32;
        self.me.mana_spent += spell.cost;

        if spell.turns > 0 {
            self.me.active.insert(*spell, spell.turns);
            if spell.armor != 0 {
                self.me.armor += spell.armor;
            }
        } else {
            self.me.hp += spell.heal;
            self.me.mana += spell.mana;
            self.boss.hp -= spell.damage;
        }

        if self.boss.hp <= 0 {
            // boss died
            return;
        }

        // boss turn
        for sp in ALL_SPELLS.iter() {
            if let Some(turns) = self.me.active.get_mut(sp) {
                self.me.hp += sp.heal;
                self.me.mana += sp.mana;
                self.boss.hp -= sp.damage;
                *turns -= 1;
                if *turns == 0 {
                    self.me.active.remove(sp);
                    if sp.armor != 0 {
                        self.me.armor -= sp.armor;
                    }
                }
            }
        }

        if self.boss.hp <= 0 {
            // boss died
            return;
        }

        let damage = std::cmp::max(1, self.boss.damage - self.me.armor);
        self.me.hp -= damage;
        if self.me.hp <= 0 {
            // player died
        }
    }
}

fn sim(hard_mode: bool) -> usize {
    let mut min_cost = std::usize::MAX;
    let mut todo = vec![State {
        me: Me::new(50, 500),
        boss: Boss::new(71, 10),
        hard_mode,
    }];
    while !todo.is_empty() {
        let mut cur = todo.pop().unwrap();
        if hard_mode {
            cur.me.hp -= 1;
            if cur.me.hp <= 0 {
                // player died from hard mode
                continue;
            }
        }
        for sp in ALL_SPELLS.iter() {
            if let Some(turns) = cur.me.active.get(sp) {
                if *turns > 1 {
                    continue; // currently active
                }
            }
            if cur.me.mana < sp.cost as i32 {
                continue; // can't afford spell
            }
            if cur.me.mana_spent + sp.cost > min_cost {
                // already spent too much mana
                continue;
            }

            let mut new = cur.clone();
            new.turn(sp);
            if new.boss.hp <= 0 {
                //dbg!("player wins", min_cost, new.me.mana_spent);
                if min_cost > new.me.mana_spent {
                    //dbg!("new minimum", min_cost);
                    min_cost = new.me.mana_spent;
                }
                continue;
            }
            if new.me.hp <= 0 {
                //dbg!("boss wins");
                continue;
            }
            todo.push(new);
        }
    }
    min_cost
}

fn main() {
    println!("Part 1: {}", sim(false));
    println!("Part 2: {}", sim(true));
}

#[test]
fn example1_works() {
    let mut s = State {
        me: Me::new(10, 250),
        boss: Boss::new(13, 8),
        hard_mode: false,
    };
    s.turn(&POISON);
    assert_eq!(s.boss.hp, 10, "T1&2 boss hp");
    assert_eq!(s.me.hp, 2, "T1&2 player hp");
    assert_eq!(s.me.armor, 0, "T1&2 player armor");
    assert_eq!(s.me.mana, 77, "T1&2 player mana");
    assert_eq!(s.me.mana_spent, 173, "T1&2 player mana spent");
    s.turn(&MAGIC_MISSILE);
    assert_eq!(s.boss.hp, 0, "T3&4 boss hp");
    assert_eq!(s.me.hp, 2, "T3&4 player hp");
    assert_eq!(s.me.armor, 0, "T3&4 player armor");
    assert_eq!(s.me.mana, 24, "T3&4 player mana");
    assert_eq!(s.me.mana_spent, 226, "T3&4 player mana spent");
}

#[test]
fn example2_works() {
    let mut s = State {
        me: Me::new(10, 250),
        boss: Boss::new(14, 8),
        hard_mode: false,
    };
    s.turn(&RECHARGE);
    assert_eq!(s.boss.hp, 14, "T1&2 boss hp");
    assert_eq!(s.me.hp, 2, "T1&2 player hp");
    assert_eq!(s.me.armor, 0, "T1&2 player armor");
    assert_eq!(s.me.mana, 122, "T1&2 player mana");
    assert_eq!(s.me.mana_spent, 229, "T1&2 player mana spent");

    s.turn(&SHIELD);
    assert_eq!(s.boss.hp, 14, "T3&4 boss hp");
    assert_eq!(s.me.hp, 1, "T3&4 player hp");
    assert_eq!(s.me.armor, 7, "T3&4 player armor");
    assert_eq!(s.me.mana, 211, "T3&4 player mana");
    assert_eq!(s.me.mana_spent, 229 + 113, "T3&4 player mana spent");

    s.turn(&DRAIN);
    assert_eq!(s.boss.hp, 12, "T5&6 boss hp");
    assert_eq!(s.me.hp, 2, "T5&6 player hp");
    assert_eq!(s.me.armor, 7, "T5&6 player armor");
    assert_eq!(s.me.mana, 340, "T5&6 player mana");
    assert_eq!(s.me.mana_spent, 229 + 113 + 73, "T5&6 player mana spent");

    s.turn(&POISON);
    assert_eq!(s.boss.hp, 9, "T7&8 boss hp");
    assert_eq!(s.me.hp, 1, "T7&8 player hp");
    assert_eq!(s.me.armor, 7, "T7&8 player armor");
    assert_eq!(s.me.mana, 167, "T7&8 player mana");
    assert_eq!(
        s.me.mana_spent,
        229 + 113 + 73 + 173,
        "T7&8 player mana spent"
    );

    s.turn(&MAGIC_MISSILE);
    assert_eq!(s.boss.hp, -1, "T9&10 boss hp");
    assert_eq!(s.me.hp, 1, "T9&10 player hp");
    assert_eq!(s.me.armor, 0, "T9&10 player armor");
    assert_eq!(s.me.mana, 114, "T9&10 player mana");
    assert_eq!(
        s.me.mana_spent,
        229 + 113 + 73 + 173 + 53,
        "T9&10 player mana spent"
    );
}

#[test]
fn part1_works() {
    let mut s = State {
        me: Me::new(50, 500),
        boss: Boss::new(71, 10),
        hard_mode: false,
    };
    for turn in &[
        (POISON, 68, 40),
        (RECHARGE, 62, 30),
        (SHIELD, 56, 27),
        (POISON, 50, 24),
        (RECHARGE, 44, 21),
        (SHIELD, 38, 18),
        (POISON, 32, 15),
        (RECHARGE, 26, 12),
        (SHIELD, 20, 9),
        (MAGIC_MISSILE, 13, 6),
        (POISON, 10, 3),
        (MAGIC_MISSILE, 0, 3),
    ] {
        s.turn(&turn.0);
        assert_eq!(s.boss.hp, turn.1, "boss hp");
        assert_eq!(s.me.hp, turn.2, "player hp");
    }
}
