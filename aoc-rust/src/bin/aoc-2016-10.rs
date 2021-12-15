use std::collections::HashMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
enum Target {
    B(usize),
    O(usize),
    None,
}

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
struct Bot {
    values: Vec<usize>,
    hi: Target,
    lo: Target,
}

impl Bot {
    fn new() -> Bot {
        Bot {
            values: vec![],
            hi: Target::None,
            lo: Target::None,
        }
    }
    fn is_ready(&self) -> bool {
        self.values.len() == 2
    }
    fn pop(&mut self) -> (usize, usize) {
        let (min, max) = if self.values[0] < self.values[1] {
            (self.values[0], self.values[1])
        } else {
            (self.values[1], self.values[0])
        };
        self.values.clear();
        (min, max)
    }
}

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
struct Output {
    values: Vec<usize>,
}

impl Output {
    fn new() -> Output {
        Output { values: vec![] }
    }
}

trait AddValue {
    fn add_value(&mut self, v: usize);
}

impl AddValue for Output {
    fn add_value(&mut self, v: usize) {
        self.values.push(v);
    }
}

impl AddValue for Bot {
    fn add_value(&mut self, v: usize) {
        self.values.push(v);
    }
}

struct Factory {
    bots: HashMap<usize, Bot>,
    outputs: HashMap<usize, Output>,
    targets: (usize, usize),
}

impl Factory {
    fn new(inp: &[String], targets: (usize, usize)) -> Factory {
        let bots: HashMap<usize, Bot> = HashMap::new();
        let outputs: HashMap<usize, Output> = HashMap::new();
        let mut f = Factory {
            bots,
            outputs,
            targets,
        };
        let mut out_nums: Vec<usize> = vec![];
        for l in inp {
            let nums = aoc::ints::<usize>(l).collect::<Vec<usize>>();
            if l.starts_with("value") {
                f.bot(nums[1]).add_value(nums[0])
            } else {
                let mut bot = f.bot(nums[0]);
                let rhs = l.split(" gives ").nth(1).unwrap();
                let mut sp = rhs.split(" and ");
                let lo = sp.next().unwrap();
                let hi = sp.next().unwrap();
                bot.lo = if lo.contains("bot") {
                    Target::B(nums[1])
                } else {
                    out_nums.push(nums[1]);
                    Target::O(nums[1])
                };
                bot.hi = if hi.contains("bot") {
                    Target::B(nums[2])
                } else {
                    out_nums.push(nums[2]);
                    Target::O(nums[2])
                };
            }
        }
        //dbg!(&out_nums);
        for n in out_nums {
            f.out(n);
        }
        f
    }
    fn bot(&mut self, id: usize) -> &mut Bot {
        self.bots.entry(id).or_insert_with(Bot::new)
    }
    fn out(&mut self, id: usize) -> &mut Output {
        self.outputs.entry(id).or_insert_with(Output::new)
    }
    fn add_value(&mut self, target: Target, v: usize) {
        match target {
            Target::B(n) => self.bots.get_mut(&n).unwrap().add_value(v),
            Target::O(n) => self.outputs.get_mut(&n).unwrap().add_value(v),
            _ => panic!("invalid target"),
        }
    }
    fn pop(&mut self, n: usize) -> (usize, usize) {
        self.bots.get_mut(&n).unwrap().pop()
    }
    fn hilo(&self, n: usize) -> (Target, Target) {
        let b = self.bots.get(&n).unwrap();
        (b.lo, b.hi)
    }
    fn is_ready(&self, n: usize) -> bool {
        self.bots.get(&n).unwrap().is_ready()
    }
    fn part2(&self) -> Option<usize> {
        let o0 = self.outputs.get(&0).unwrap();
        let o1 = self.outputs.get(&1).unwrap();
        let o2 = self.outputs.get(&2).unwrap();
        if !o0.values.is_empty()
            && !o1.values.is_empty()
            && !o2.values.is_empty()
        {
            Some(o0.values[0] * o1.values[0] * o2.values[0])
        } else {
            None
        }
    }
    fn calc(&mut self) -> (usize, usize) {
        let mut p1 = 0;
        loop {
            let bots = self.bots.keys().copied().collect::<Vec<usize>>();
            for num in bots {
                if !self.is_ready(num) {
                    continue;
                }
                let (min, max) = self.pop(num);
                //dbg!(num, min, max);
                if self.targets == (min, max) {
                    p1 = num;
                }
                let (lo, hi) = self.hilo(num);
                self.add_value(lo, min);
                self.add_value(hi, max);
                if let Some(p2) = self.part2() {
                    return (p1, p2);
                }
            }
        }
    }
}

#[allow(dead_code)]
const EX1: [&str; 6] = [
    "value 5 goes to bot 2",
    "bot 2 gives low to bot 1 and high to bot 0",
    "value 3 goes to bot 1",
    "bot 1 gives low to output 1 and high to bot 0",
    "bot 0 gives low to output 2 and high to output 0",
    "value 2 goes to bot 2",
];

#[test]
fn factory_works() {
    let e: Vec<String> =
        EX1.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    let mut f = Factory::new(&e, (2, 5));
    let (p1, p2) = f.calc();
    assert_eq!(p1, 2);
    assert_eq!(p2, 30);
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let mut f = Factory::new(&inp, (17, 61));
        let (p1, p2) = f.calc();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
