#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
enum Op {
    // Operand
    Register(char),
    Immediate(isize),
}

impl Op {
    fn new(s: &str) -> Op {
        let first = s.chars().next().unwrap();
        match first {
            'a'..='d' => Op::Register(first),
            '-' | '0'..='9' => Op::Immediate(s.parse::<isize>().unwrap()),
            _ => panic!("invalid operand: {}", s),
        }
    }
    fn value(&self, reg: &[isize]) -> isize {
        match self {
            Op::Register(r) => reg[(*r as u8 - b'a') as usize],
            Op::Immediate(v) => *v,
        }
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
enum Inst {
    Cpy(Op, Op),
    Inc(Op),
    Dec(Op),
    Jnz(Op, Op),
}

impl Inst {
    fn new(l: &str) -> Inst {
        let mut words = l.split(' ');
        let inst = words.next().unwrap();
        match inst {
            "cpy" => Inst::Cpy(
                Op::new(words.next().unwrap()),
                Op::Register(words.next().unwrap().chars().next().unwrap()),
            ),
            "inc" => Inst::Inc(Op::Register(
                words.next().unwrap().chars().next().unwrap(),
            )),
            "dec" => Inst::Dec(Op::Register(
                words.next().unwrap().chars().next().unwrap(),
            )),
            "jnz" => Inst::Jnz(
                Op::new(words.next().unwrap()),
                Op::new(words.next().unwrap()),
            ),
            _ => panic!("invalid instruction: {}", l),
        }
    }
    fn run(&self, state: &mut ElfComp2016State) {
        match self {
            Inst::Cpy(x, y) => {
                let vx = x.value(&state.reg);
                match y {
                    Op::Register(r) => {
                        state.reg[(*r as u8 - b'a') as usize] = vx
                    }
                    Op::Immediate(_v) => panic!("2nd operand must be register"),
                };
                state.ip += 1;
            }
            Inst::Inc(x) => {
                match x {
                    Op::Register(r) => {
                        state.reg[(*r as u8 - b'a') as usize] += 1
                    }
                    Op::Immediate(_v) => panic!("2nd operand must be register"),
                };
                state.ip += 1;
            }
            Inst::Dec(x) => {
                match x {
                    Op::Register(r) => {
                        state.reg[(*r as u8 - b'a') as usize] -= 1
                    }
                    Op::Immediate(_v) => panic!("2nd operand must be register"),
                };
                state.ip += 1;
            }
            Inst::Jnz(x, y) => {
                let vx = x.value(&state.reg);
                let vy = y.value(&state.reg);
                state.ip += if vx != 0 { vy } else { 1 } as usize;
            }
        }
    }
}

struct ElfComp2016State {
    ip: usize,
    reg: Vec<isize>,
}

struct ElfComp2016 {
    inst: Vec<Inst>,
}

impl ElfComp2016 {
    fn new(inp: &[String]) -> ElfComp2016 {
        ElfComp2016 {
            inst: inp.iter().map(|l| Inst::new(l)).collect(),
        }
    }
    fn run(&self, s: &mut ElfComp2016State) {
        while s.ip < self.inst.len() {
            let inst = &self.inst[s.ip];
            inst.run(s);
        }
    }
    fn part1(&self) -> isize {
        let mut state = ElfComp2016State {
            ip: 0,
            reg: vec![0; 4],
        };
        self.run(&mut state);
        state.reg[0]
    }
    fn part2(&self) -> isize {
        let mut state = ElfComp2016State {
            ip: 0,
            reg: vec![0, 0, 1, 0],
        };
        self.run(&mut state);
        state.reg[0]
    }
}

#[allow(dead_code)]
const EX1: [&str; 6] =
    ["cpy 41 a", "inc a", "inc a", "dec a", "jnz a 2", "dec a"];

#[test]
fn part1_works() {
    let e: Vec<String> =
        EX1.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    let comp = ElfComp2016::new(e);
    assert_eq!(comp.part1(), 42, "part 1 example");
}

fn main() {
    let lines = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let comp = ElfComp2016::new(&lines);
        let p1 = comp.part1();
        let p2 = comp.part2();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
