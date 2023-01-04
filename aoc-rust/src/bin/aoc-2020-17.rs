#[derive(Debug, PartialEq, Clone, Eq, Hash)]
struct Point {
    x: i8,
    y: i8,
    z: i8,
    q: i8,
}

use ahash::RandomState;
use std::collections::HashSet;

struct Pocket {
    init: HashSet<Point, RandomState>,
    part2: bool,
}

impl Pocket {
    fn new(inp: &[u8], part2: bool) -> Pocket {
        let mut init: HashSet<Point, RandomState> = HashSet::default();
        let mut x = 0;
        let mut y = 0;
        for ch in inp {
            match ch {
                b'#' => {
                    init.insert(Point { x, y, z: 0, q: 0 });
                    x += 1;
                }
                b'.' => {
                    x += 1;
                }
                b'\n' => {
                    x = 0;
                    y += 1;
                }
                _ => unreachable!("invalid input"),
            }
        }
        Pocket { init, part2 }
    }
    fn neighbours(&self, p: &Point) -> Vec<Point> {
        let mut nb = Vec::with_capacity(87);
        const NB: [i8; 3] = [-1, 0, 1];
        #[allow(clippy::bool_to_int_with_if)]
        let qlo = if self.part2 { 0 } else { 1 };
        let qhi = if self.part2 { 3 } else { 2 };
        for oq in &NB[qlo..qhi] {
            for oz in &NB[0..3] {
                for oy in &NB[0..3] {
                    for ox in &NB[0..3] {
                        if *ox == 0 && *oy == 0 && *oz == 0 && *oq == 0 {
                            continue;
                        }
                        nb.push(Point {
                            x: p.x + ox,
                            y: p.y + oy,
                            z: p.z + oz,
                            q: p.q + oq,
                        });
                    }
                }
            }
        }
        nb
    }
    fn run(&mut self, n: usize) -> usize {
        let mut cur = self.init.clone();
        let mut next: HashSet<Point, RandomState> = HashSet::default();
        for _ in 0..n {
            let mut nb = cur.clone();
            for cur in &cur {
                for p in self.neighbours(cur) {
                    nb.insert(p);
                }
            }
            for poss in &nb {
                let mut nc = 0;
                for p in self.neighbours(poss) {
                    if cur.contains(&p) {
                        nc += 1;
                    }
                }
                if (cur.contains(poss) && nc == 2) || nc == 3 {
                    next.insert(poss.clone());
                }
            }
            (cur, next) = (next, cur);
            next.clear();
        }
        cur.len()
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let mut pkt = Pocket::new(&inp, false);
        let p1 = pkt.run(6);
        let mut pkt = Pocket::new(&inp, true);
        let p2 = pkt.run(6);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
