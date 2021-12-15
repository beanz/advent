use itertools::*;
use std::collections::HashMap;

struct Seats {
    people: HashMap<String, u16>,
    happiness: HashMap<(u16, u16), i32>,
}

impl Seats {
    fn new() -> Seats {
        Seats {
            people: HashMap::new(),
            happiness: HashMap::new(),
        }
    }
    fn person_id(&mut self, person: &str) -> u16 {
        let next = self.people.len() as u16;
        *self.people.entry(person.to_string()).or_insert(next)
    }
    fn happiness(&self, a: u16, b: u16) -> i32 {
        *self.happiness.get(&(a, b)).unwrap()
    }
    fn add(&mut self, s: &str) {
        let mut words = s.split(' ');
        let first = self.person_id(words.next().unwrap());
        words.next();
        let gainlose = words.next().unwrap();
        let mut amount = words.next().unwrap().parse::<i32>().unwrap();
        // second needs trim to remove dot
        let second = self.person_id(words.last().unwrap().trim_matches('.'));
        if gainlose == "lose" {
            amount *= -1;
        }
        self.happiness.insert((first, second), amount);
    }
    fn max(&self) -> i32 {
        (0..self.people.len() as u16)
            .permutations(self.people.len())
            .map(|x| {
                x.windows(2)
                    .map(|pair| {
                        self.happiness(pair[0], pair[1])
                            + self.happiness(pair[1], pair[0])
                    })
                    .sum::<i32>()
                    + self.happiness(x[0], x[x.len() - 1])
                    + self.happiness(x[x.len() - 1], x[0])
            })
            .max()
            .unwrap()
    }

    fn part1(&self) -> i32 {
        self.max()
    }
    fn part2(&mut self) -> i32 {
        let me = self.person_id("Me");
        for guest in 0..self.people.len() as u16 {
            self.happiness.insert((me, guest), 0);
            self.happiness.insert((guest, me), 0);
        }
        self.max()
    }
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let mut seats = Seats::new();
        for l in &inp {
            seats.add(&l);
        }
        let p1 = seats.part1();
        let p2 = seats.part2();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn part1_works() {
    let mut seats = Seats::new();
    seats.add("Alice would gain 54 happiness units by sitting next to Bob.");
    seats.add("Alice would lose 79 happiness units by sitting next to Carol.");
    seats.add("Alice would lose 2 happiness units by sitting next to David.");
    seats.add("Bob would gain 83 happiness units by sitting next to Alice.");
    seats.add("Bob would lose 7 happiness units by sitting next to Carol.");
    seats.add("Bob would lose 63 happiness units by sitting next to David.");
    seats.add("Carol would lose 62 happiness units by sitting next to Alice.");
    seats.add("Carol would gain 60 happiness units by sitting next to Bob.");
    seats.add("Carol would gain 55 happiness units by sitting next to David.");
    seats.add("David would gain 46 happiness units by sitting next to Alice.");
    seats.add("David would lose 7 happiness units by sitting next to Bob.");
    seats.add("David would gain 41 happiness units by sitting next to Carol.");
    assert_eq!(seats.person_id("Alice"), 0);
    assert_eq!(seats.person_id("Bob"), 1);
    assert_eq!(seats.person_id("Carol"), 2);
    assert_eq!(seats.person_id("David"), 3);
    assert_eq!(seats.happiness(0, 1), 54);
    assert_eq!(seats.happiness(1, 0), 83);
    assert_eq!(seats.happiness(1, 2), -7);
    assert_eq!(seats.happiness(2, 1), 60);
    assert_eq!(seats.happiness(2, 3), 55);
    assert_eq!(seats.happiness(3, 2), 41);
    assert_eq!(seats.happiness(3, 0), 46);
    assert_eq!(seats.happiness(0, 3), -2);
    assert_eq!(seats.part1(), 330);
}
