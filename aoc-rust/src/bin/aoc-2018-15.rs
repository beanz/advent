use heapless::FnvIndexSet;
use smallvec::SmallVec;

#[derive(Debug, PartialEq, Eq, Clone)]
enum PL {
    Elf = 0,
    Goblin = 1,
}

#[derive(Debug, PartialEq, Eq, Clone)]
struct Pos {
    x: i32,
    y: i32,
}

impl PartialOrd for Pos {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        match self.y.cmp(&other.y) {
            std::cmp::Ordering::Equal => self.x.partial_cmp(&other.x),
            x => Some(x),
        }
    }
}

impl Ord for Pos {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        match self.y.cmp(&other.y) {
            std::cmp::Ordering::Equal => self.x.cmp(&other.x),
            x => x,
        }
    }
}

#[derive(Debug, PartialEq, Eq, Clone)]
struct Player {
    pos: Pos,
    kind: PL,
    hp: i32,
    pwr: i32,
}

impl PartialOrd for Player {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        self.pos.partial_cmp(&other.pos)
    }
}

impl Ord for Player {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.pos.cmp(&other.pos)
    }
}

impl Player {
    fn is_enemy(&self, other: &Self) -> bool {
        self.kind != other.kind
    }
}

#[derive(Debug)]
struct Game<'a> {
    m: &'a [u8],
    w: usize,
    h: usize,
}

fn parts(inp: &[u8]) -> (i32, i32) {
    let w1 = aoc::read::skip_next_line(inp, 0);
    let h = inp.len() / w1;
    let w = w1 - 1;
    let g = Game { m: inp, w, h };

    let p1 = play(&g, 3);
    let mut pwr = 4;
    loop {
        let res = play(&g, pwr);
        if res != -1 {
            return (p1, res);
        }
        pwr += 1;
    }
}

#[derive(Debug)]
struct Search {
    start: Pos,
    end: Pos,
}

#[derive(Debug)]
struct Attack {
    pos: Pos,
    enemy: usize,
}

struct Sim<'a> {
    init: &'a Game<'a>,
    players: Vec<Player>,
    initial_elves: usize,
    num_elves: usize,
    num_goblins: usize,
}

impl<'a> Sim<'a> {
    fn turn_for(&mut self, pl: usize) {
        if let Some(e) = self.target(pl) {
            self.attack(pl, e);
            return;
        }
        self.mov(pl);
        if let Some(e) = self.target(pl) {
            self.attack(pl, e);
        }
    }
    fn target(&self, pl: usize) -> Option<usize> {
        self.target_at(pl, &self.players[pl].pos)
    }
    fn target_at(&self, pl: usize, pos: &Pos) -> Option<usize> {
        let mut enemy: Option<usize> = None;
        if let Some(e) = self.player_at(pos.x, pos.y - 1) {
            if self.is_enemy(pl, e) {
                enemy = Some(e);
            }
        }
        if let Some(e) = self.player_at(pos.x - 1, pos.y) {
            if self.is_enemy(pl, e) {
                if let Some(pe) = enemy {
                    if self.players[pe].hp > self.players[e].hp {
                        enemy = Some(e);
                    }
                } else {
                    enemy = Some(e);
                }
            }
        }
        if let Some(e) = self.player_at(pos.x + 1, pos.y) {
            if self.is_enemy(pl, e) {
                if let Some(pe) = enemy {
                    if self.players[pe].hp > self.players[e].hp {
                        enemy = Some(e);
                    }
                } else {
                    enemy = Some(e);
                }
            }
        }
        if let Some(e) = self.player_at(pos.x, pos.y + 1) {
            if self.is_enemy(pl, e) {
                if let Some(pe) = enemy {
                    if self.players[pe].hp > self.players[e].hp {
                        enemy = Some(e);
                    }
                } else {
                    enemy = Some(e);
                }
            }
        }
        enemy
    }
    fn player_at(&self, x: i32, y: i32) -> Option<usize> {
        for (i, p) in self.players.iter().enumerate() {
            if p.pos.x == x && p.pos.y == y && p.hp > 0 {
                return Some(i);
            }
        }
        None
    }
    fn is_enemy(&self, pl: usize, other: usize) -> bool {
        self.players[pl].is_enemy(&self.players[other])
    }
    fn attack(&mut self, pl: usize, enemy: usize) {
        self.players[enemy].hp -= self.players[pl].pwr;
        if self.players[enemy].hp <= 0 {
            match self.players[enemy].kind {
                PL::Elf => self.num_elves -= 1,
                PL::Goblin => self.num_goblins -= 1,
            }
        }
    }
    fn empty_at(&self, x: i32, y: i32) -> bool {
        if self.init.m[x as usize + (y as usize) * (self.init.w + 1)] == b'#' {
            return false;
        }
        self.player_at(x, y).is_none()
    }
    fn mov(&mut self, pl: usize) -> bool {
        let mut todo = SmallVec::<[Search; 64]>::new();
        let mut next_todo = SmallVec::<[Search; 64]>::new();
        for (x, y) in [
            (self.players[pl].pos.x, self.players[pl].pos.y - 1),
            (self.players[pl].pos.x - 1, self.players[pl].pos.y),
            (self.players[pl].pos.x + 1, self.players[pl].pos.y),
            (self.players[pl].pos.x, self.players[pl].pos.y + 1),
        ] {
            if self.empty_at(x, y) {
                todo.push(Search {
                    start: Pos { x, y },
                    end: Pos { x, y },
                })
            }
        }
        let mut visited = FnvIndexSet::<(i32, i32), 512>::new();
        let mut attack: Option<Attack> = None;
        let (mut todo, mut next_todo) = (&mut todo, &mut next_todo);
        while !todo.is_empty() {
            for j in 0..todo.len() {
                let cur = &todo[j];
                if let Some(enemy) = self.target_at(pl, &cur.end) {
                    if let Some(a) = &attack {
                        if self.players[enemy].pos.cmp(&self.players[a.enemy].pos)
                            == std::cmp::Ordering::Less
                        {
                            attack = Some(Attack {
                                pos: cur.start.clone(),
                                enemy,
                            });
                        }
                    } else {
                        attack = Some(Attack {
                            pos: cur.start.clone(),
                            enemy,
                        });
                    }
                }
                for (x, y) in [
                    (cur.end.x, cur.end.y - 1),
                    (cur.end.x - 1, cur.end.y),
                    (cur.end.x + 1, cur.end.y),
                    (cur.end.x, cur.end.y + 1),
                ] {
                    if self.empty_at(x, y) && visited.insert((x, y)).expect("visited overflow") {
                        next_todo.push(Search {
                            start: cur.start.clone(),
                            end: Pos { x, y },
                        })
                    }
                }
            }
            if let Some(a) = attack {
                self.players[pl].pos = a.pos;
                return true;
            }
            (todo, next_todo) = (next_todo, todo);
            next_todo.clear();
        }
        false
    }
}

fn play(g: &Game, attack: i32) -> i32 {
    let mut sim = Sim {
        init: g,
        initial_elves: 0,
        players: vec![],
        num_elves: 0,
        num_goblins: 0,
    };
    let w1 = g.w + 1;
    for y in 0..g.h {
        for x in 0..g.w {
            match g.m[x + y * w1] {
                b'E' => {
                    sim.players.push(Player {
                        pos: Pos {
                            x: x as i32,
                            y: y as i32,
                        },
                        kind: PL::Elf,
                        hp: 200,
                        pwr: attack,
                    });
                    sim.num_elves += 1;
                }
                b'G' => {
                    sim.players.push(Player {
                        pos: Pos {
                            x: x as i32,
                            y: y as i32,
                        },
                        kind: PL::Goblin,
                        hp: 200,
                        pwr: 3,
                    });
                    sim.num_goblins += 1;
                }
                _ => {}
            }
        }
    }
    sim.initial_elves = sim.num_elves;
    let mut round = 1;
    loop {
        sim.players.sort();
        for pl in 0..sim.players.len() {
            if sim.players[pl].hp <= 0 {
                continue;
            }
            if attack != 3 {
                if sim.num_elves != sim.initial_elves {
                    return -1;
                }
            }
            if sim.num_elves * sim.num_goblins == 0 {
                let mut hp = 0;
                for p in sim.players {
                    if p.hp > 0 {
                        hp += p.hp;
                    }
                }
                return (round - 1) * hp;
            }
            sim.turn_for(pl);
        }
        //eprintln!("Round {}", round);
        //pretty(&sim);
        //eprintln!();
        round += 1;
    }
}

#[allow(dead_code)]
fn pretty(sim: &Sim) {
    let mut hp = SmallVec::<[i32; 16]>::new();
    for y in 0..sim.init.h as i32 {
        for x in 0..sim.init.w as i32 {
            if let Some(i) = sim.player_at(x, y) {
                match sim.players[i].kind {
                    PL::Elf => eprint!("E"),
                    PL::Goblin => eprint!("G"),
                }
                hp.push(sim.players[i].hp);
                continue;
            }
            eprint!("{}", if sim.empty_at(x, y) { "." } else { "#" });
        }
        eprintln!(" {:?}", hp);
        hp.clear();
    }
    eprintln!();
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/15/test0.txt").expect("read error");
        assert_eq!(parts(&inp), (9933, 920));
        let inp = std::fs::read("../2018/15/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (27730, 4988));
        let inp = std::fs::read("../2018/15/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (36334, 29064));
        let inp = std::fs::read("../2018/15/test3.txt").expect("read error");
        assert_eq!(parts(&inp), (39514, 31284));
        let inp = std::fs::read("../2018/15/test4.txt").expect("read error");
        assert_eq!(parts(&inp), (27755, 3478));
        let inp = std::fs::read("../2018/15/test5.txt").expect("read error");
        assert_eq!(parts(&inp), (28944, 6474));
        let inp = std::fs::read("../2018/15/test6.txt").expect("read error");
        assert_eq!(parts(&inp), (18740, 1140));
        let inp = std::fs::read("../2018/15/test0m.txt").expect("read error");
        assert_eq!(parts(&inp), (16533, 560));
        let inp = std::fs::read("../2018/15/test1m.txt").expect("read error");
        assert_eq!(parts(&inp), (136, 2703));
        let inp = std::fs::read("../2018/15/test2m.txt").expect("read error");
        assert_eq!(parts(&inp), (10430, 8372));
        let inp = std::fs::read("../2018/15/test3m.txt").expect("read error");
        assert_eq!(parts(&inp), (11388, 672));
        let inp = std::fs::read("../2018/15/test4m.txt").expect("read error");
        assert_eq!(parts(&inp), (10620, 235));
        let inp = std::fs::read("../2018/15/input.txt").expect("read error");
        assert_eq!(parts(&inp), (220480, 53576));
        let inp = std::fs::read("../2018/15/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (190777, 47388));
    }
}
