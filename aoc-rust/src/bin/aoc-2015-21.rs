use itertools::*;

#[derive(Debug, Clone, Copy)]
struct Fighter {
    hp: i32,
    damage: i32,
    armor: i32,
}

impl Fighter {
    fn new(hp: i32, damage: i32, armor: i32) -> Fighter {
        Fighter { hp, damage, armor }
    }
    fn attack(&self, opp: &Fighter) -> i32 {
        let a = self.damage - opp.armor;
        if a < 1 {
            return 1;
        }
        a
    }
    fn time_until_death(&self, opp: &Fighter) -> usize {
        (self.hp as f64 / opp.attack(self) as f64).ceil() as usize
    }
    fn beats(&self, opp: &Fighter) -> bool {
        opp.time_until_death(self) <= self.time_until_death(opp)
    }
}

#[test]
fn fighter_attack_works() {
    for tc in &[(5, 2, 3), (5, 10, 1), (7, 5, 2)] {
        let me = Fighter::new(0, tc.0, 0);
        let boss = Fighter::new(0, 0, tc.1);
        assert_eq!(
            me.attack(&boss),
            tc.2,
            "attack {} damage against {} armor",
            tc.0,
            tc.1
        );
    }
}

#[test]
fn fighter_time_until_death_works() {
    for tc in &[(12, 2, 5, 4), (8, 5, 7, 4)] {
        let me = Fighter::new(tc.0, 0, tc.1);
        let boss = Fighter::new(0, tc.2, 0);
        assert_eq!(
            me.time_until_death(&boss),
            tc.3 as usize,
            "time until death {}hp {}armor against {} damage",
            tc.0,
            tc.1,
            tc.2
        );
    }
}

#[test]
fn fighter_battle_works() {
    let me = Fighter::new(8, 5, 5);
    let boss = Fighter::new(12, 7, 2);
    assert_eq!(me.beats(&boss), true, "boss is beaten");
}

#[derive(Debug, Clone, Copy)]
struct Equipment {
    cost: usize,
    damage: i32,
    armor: i32,
}

struct Battle {
    weapons: Vec<Equipment>,
    armor: Vec<Equipment>,
    rings: Vec<Equipment>,
}

impl Battle {
    fn new() -> Battle {
        let weapons: Vec<Equipment> = vec![
            Equipment {
                // Dagger
                cost: 8,
                damage: 4,
                armor: 0,
            },
            Equipment {
                // Shortsword
                cost: 10,
                damage: 5,
                armor: 0,
            },
            Equipment {
                // Warhammer
                cost: 25,
                damage: 6,
                armor: 0,
            },
            Equipment {
                // Longsword
                cost: 40,
                damage: 7,
                armor: 0,
            },
            Equipment {
                // Greataxe
                cost: 74,
                damage: 8,
                armor: 0,
            },
        ];
        let armor: Vec<Equipment> = vec![
            Equipment {
                // Leather
                cost: 13,
                damage: 0,
                armor: 1,
            },
            Equipment {
                // Chainmail
                cost: 31,
                damage: 0,
                armor: 2,
            },
            Equipment {
                // Splintmail
                cost: 53,
                damage: 0,
                armor: 3,
            },
            Equipment {
                // Bandedmail
                cost: 75,
                damage: 0,
                armor: 4,
            },
            Equipment {
                // Platemail
                cost: 102,
                damage: 0,
                armor: 5,
            },
            Equipment {
                // No armor
                cost: 0,
                damage: 0,
                armor: 0,
            },
        ];
        let rings: Vec<Equipment> = vec![
            Equipment {
                // Damage +1
                cost: 25,
                damage: 1,
                armor: 0,
            },
            Equipment {
                // Damage +2
                cost: 50,
                damage: 2,
                armor: 0,
            },
            Equipment {
                // Damage +3
                cost: 100,
                damage: 3,
                armor: 0,
            },
            Equipment {
                // Defense +1
                cost: 20,
                damage: 0,
                armor: 1,
            },
            Equipment {
                // Defense +2
                cost: 40,
                damage: 0,
                armor: 2,
            },
            Equipment {
                // Defense +3
                cost: 80,
                damage: 0,
                armor: 3,
            },
            Equipment {
                // No Ring
                cost: 0,
                damage: 0,
                armor: 0,
            },
            Equipment {
                // No Ring
                cost: 0,
                damage: 0,
                armor: 0,
            },
        ];
        Battle {
            weapons,
            armor,
            rings,
        }
    }
    fn sim(&self) -> (usize, usize) {
        let boss = Fighter::new(103, 9, 2);
        let mut min = std::usize::MAX;
        let mut max = std::usize::MIN;
        for w in self.weapons.iter().combinations(1) {
            for a in self.armor.iter().combinations(1) {
                for r in self.rings.iter().combinations(2) {
                    let e = [w[0], a[0], r[0], r[1]].iter().fold(
                        Equipment {
                            cost: 0,
                            damage: 0,
                            armor: 0,
                        },
                        |a, b| Equipment {
                            cost: a.cost + b.cost,
                            damage: a.damage + b.damage,
                            armor: a.armor + b.armor,
                        },
                    );
                    let me = Fighter::new(100, e.damage, e.armor);
                    let victory = me.beats(&boss);
                    if victory && e.cost < min {
                        min = e.cost as usize
                    }
                    if !victory && e.cost > max {
                        max = e.cost as usize
                    }
                }
            }
        }
        (min, max)
    }
}

fn main() {
    aoc::benchme(|bench: bool| {
        let battle = Battle::new();
        let (p1, p2) = &battle.sim();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn sim_works() {
    let battle = Battle::new();
    let (p1, p2) = battle.sim();
    assert_eq!(p1, 121, "part 1");
    assert_eq!(p2, 201, "part 2");
}
