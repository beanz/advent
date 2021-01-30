use std::collections::HashMap;
use std::collections::HashSet;

struct Pipes {
    connections: HashMap<usize, HashSet<usize>>,
    set_of: HashMap<usize, usize>,
}

impl Pipes {
    fn new() -> Pipes {
        Pipes {
            connections: HashMap::new(),
            set_of: HashMap::new(),
        }
    }
    fn add_connection(&mut self, a: usize, b: usize) {
        let sets = &mut self.set_of;
        if sets.contains_key(&a) && sets.contains_key(&b) {
            // merge sets
            let b_elements = self
                .connections
                .get_mut(sets.get(&b).unwrap())
                .unwrap()
                .iter()
                .copied()
                .collect::<Vec<usize>>();
            let ia = *sets.get(&a).unwrap();
            let ib = *sets.get(&b).unwrap();
            if ia != ib {
                for be in b_elements {
                    sets.insert(be, ia);
                    self.connections.get_mut(&ia).unwrap().insert(be);
                }
                self.connections.remove(&ib);
            }
        } else if sets.contains_key(&a) {
            // add b to set of a
            let ia = *sets.get(&a).unwrap();
            sets.insert(b, ia);
            self.connections.get_mut(&ia).unwrap().insert(b);
        } else if sets.contains_key(&b) {
            // add a to set of b
            let ib = *sets.get(&b).unwrap();
            sets.insert(a, ib);
            self.connections.get_mut(&ib).unwrap().insert(a);
        } else {
            // create new set
            let m = if a < b { a } else { b };
            self.connections.insert(m, HashSet::new());
            self.set_of.insert(a, m);
            self.set_of.insert(b, m);
            //let set = self.connections.get_mut(&m).unwrap();
            self.connections.get_mut(&m).unwrap().insert(a);
            self.connections.get_mut(&m).unwrap().insert(b);
        }
    }
    fn add(&mut self, inp: &[String]) {
        for l in inp {
            let mut progs = aoc::uints::<usize>(&l);
            let first = progs.next().unwrap();
            for conn in progs {
                self.add_connection(first, conn);
            }
        }
    }
    fn part1(&self) -> usize {
        self.connections
            .get(self.set_of.get(&0).unwrap())
            .unwrap()
            .len()
    }
    fn part2(&self) -> usize {
        self.connections.len()
    }
}

fn main() {
    let inp = aoc::input_lines();
    let mut p = Pipes::new();
    p.add(&inp);
    println!("Part 1: {}", p.part1());
    println!("Part 2: {}", p.part2());
}

#[test]
fn parts_work() {
    let e: Vec<String> = [
        "0 <-> 2",
        "1 <-> 1",
        "2 <-> 0, 3, 4",
        "3 <-> 2, 4",
        "4 <-> 2, 3, 6",
        "5 <-> 6",
        "6 <-> 4, 5",
    ]
    .iter()
    .map(|x| x.to_string())
    .collect::<Vec<String>>();
    let mut p = Pipes::new();
    p.add(&e);
    assert_eq!(p.part1(), 6);
    assert_eq!(p.part2(), 2);
}
