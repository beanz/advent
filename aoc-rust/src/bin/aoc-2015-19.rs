extern crate rand;

use crate::rand::prelude::SliceRandom;
use rand::thread_rng;
use std::collections::HashSet;

struct Mach {
    rules: Vec<(String, String)>,
    init: String,
}

impl Mach {
    fn new(inp: Vec<&str>) -> Mach {
        let mut rules: Vec<(String, String)> = vec![];
        let mut it = inp.iter();
        loop {
            let l = it.next().unwrap();
            if l.is_empty() {
                break;
            }
            let mut kv = l.split(" => ");
            rules.push((
                kv.next().unwrap().to_string(),
                kv.next().unwrap().to_string(),
            ));
        }
        let init = it.next().unwrap().to_string();
        Mach { rules, init }
    }
    fn part1(&self) -> usize {
        let mut res: HashSet<String> = HashSet::new();
        for r in &self.rules {
            let s = &self.init;
            for (i, _) in s.match_indices(&r.0) {
                let n = format!(
                    "{}{}{}",
                    s[0..i].to_string(),
                    r.1[..].to_string(),
                    s[i + r.0.len()..].to_string()
                );
                res.insert(n);
            }
        }
        res.len()
    }
    fn part2(&mut self) -> usize {
        let mut rng = thread_rng();
        let rules = &mut self.rules;
        loop {
            let mut s = self.init.clone();
            let mut c = 0;
            let mut changed = true;
            while changed {
                changed = false;
                for r in rules.iter() {
                    while let Some(i) = s.find(&r.1) {
                        changed = true;
                        c += 1;
                        s.replace_range(i..i+r.1.len(), &r.0);
                        if s == "e" {
                            return c;
                        }
                    }
                }
            }
            // shuffle rules order
            rules.shuffle(&mut rng);
        }
    }
}

fn main() {
    let input_lines = aoc::vec_input_lines();
    let lines: Vec<&str> = input_lines.iter().map(|x| &**x).collect();
    let mut m = Mach::new(lines);
    println!("Part 1: {}", m.part1());
    println!("Part 2: {}", m.part2());
}

#[test]
fn part1_works() {
    let m1 = Mach::new(vec!["H => HO", "H => OH", "O => HH", "", "HOH"]);
    assert_eq!(m1.part1(), 4, "part 1 of first test input");
    let m2 = Mach::new(vec!["H => HO", "H => OH", "O => HH", "", "HOHOHO"]);
    assert_eq!(m2.part1(), 7, "part 1 of second test input");
}

#[test]
fn part2_works() {
    let mut m1 = Mach::new(vec!["e => H", "e => O", "H => HO", "H => OH", "O => HH", "", "HOH"]);
    assert_eq!(m1.part2(), 3, "part 2 of first test input");
    let mut m2 = Mach::new(vec!["e => H", "e => O", "H => HO", "H => OH", "O => HH", "", "HOHOHO"]);
    assert_eq!(m2.part2(), 6, "part 2 of second test input");
}
