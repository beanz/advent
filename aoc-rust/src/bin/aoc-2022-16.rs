use ahash::RandomState;
use std::collections::HashMap;

use smallvec::SmallVec;

#[derive(Clone, Debug)]
struct Valve {
    id: u32,
    bit: u32,
    rate: u32,
    next: SmallVec<[u32; 5]>,
}

fn valve_id(a: u8, b: u8) -> u32 {
    ((a as u32) << 8) + (b as u32)
}

#[derive(Debug, Copy, Clone, Hash, PartialEq, Eq)]
struct Search {
    cave: u32,
    t: u32,
    todo: u32,
}

struct Caves<'a> {
    valves: &'a SmallVec<[Valve; 64]>,
    dist: &'a [[u32; 64]; 64],
    non_zero: usize,
    mem: HashMap<Search, u32, RandomState>,
}

impl<'a> Caves<'a> {
    fn search(&mut self, s: &Search) -> u32 {
        if let Some(res) = self.mem.get(s) {
            return *res;
        }
        let mut max = 0;
        for i in 0..self.non_zero {
            if s.todo & (1 << i) != 0 {
                if s.t < self.dist[s.cave as usize][i] + 1 {
                    continue;
                }
                let nt = s.t - self.dist[s.cave as usize][i] - 1; // -1 for open
                if nt > 0 {
                    let mut pres = self.search(&Search {
                        cave: i as u32,
                        t: nt,
                        todo: s.todo ^ (1 << i),
                    });
                    pres += self.valves[i].rate * nt;
                    if max < pres {
                        max = pres;
                    }
                }
            }
        }
        self.mem.insert(*s, max);
        max
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut i = 0;
    let mut valves = SmallVec::<[Valve; 64]>::new();
    let mut non_zero = 0;
    while i < inp.len() {
        let id = valve_id(inp[i + 6], inp[i + 7]);
        let (j, rate) = aoc::read::uint::<u32>(inp, i + 23);
        i = j + 24;
        if inp[i] == b' ' {
            i += 1;
        }
        if rate != 0 {
            non_zero += 1;
        }
        let mut next = SmallVec::<[u32; 5]>::new();
        loop {
            let nc = valve_id(inp[i], inp[i + 1]);
            next.push(nc);
            i += 2;
            if inp[i] != b',' {
                break;
            }
            i += 2;
        }
        valves.push(Valve {
            id,
            rate,
            next,
            bit: 0,
        });
        i += 1;
    }
    valves.sort_by(|a, b| b.rate.cmp(&a.rate));
    let mut bit = 1;
    let mut id_to_index: HashMap<u32, u32> = HashMap::default();
    for (i, valve) in valves.iter_mut().enumerate() {
        valve.bit = bit;
        id_to_index.insert(valve.id, i as u32);
        bit <<= 1;
    }
    let mut dist: [[u32; 64]; 64] = [[99999999; 64]; 64];
    for i in 0..valves.len() {
        for nc in &valves[i].next {
            dist[i][*id_to_index.get(nc).expect("value unknown?") as usize] = 1;
        }
    }
    for k in 0..valves.len() {
        for i in 0..valves.len() {
            for j in 0..valves.len() {
                if dist[i][k] + dist[k][j] < dist[i][j] {
                    dist[i][j] = dist[i][k] + dist[k][j]
                }
            }
        }
    }
    let start = *(id_to_index.get(&valve_id(b'A', b'A')).expect("has AA"));
    let all_todo = (1 << non_zero) - 1;
    let mut c = Caves {
        valves: &valves,
        dist: &dist,
        non_zero,
        mem: HashMap::with_capacity_and_hasher(1320000, RandomState::new()),
    };
    let p1 = c.search(&Search {
        cave: start,
        t: 30,
        todo: all_todo,
    });
    let mut p2 = 0;
    for m in 0..all_todo + 1 {
        if m.count_ones() != ((non_zero + 1) / 2) as u32 {
            continue;
        }
        let mut pres = c.search(&Search {
            cave: start,
            t: 26,
            todo: m,
        });
        pres += c.search(&Search {
            cave: start,
            t: 26,
            todo: all_todo ^ m,
        });
        if pres > p2 {
            p2 = pres
        }
    }
    (p1 as usize, p2 as usize)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/16/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (1651, 1707));
        let inp = std::fs::read("../2022/16/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1915, 2772));
    }
}
