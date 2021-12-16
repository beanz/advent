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
    Tgl(Op),
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
            "tgl" => Inst::Tgl(Op::new(words.next().unwrap())),
            _ => panic!("invalid instruction: {}", l),
        }
    }
    fn run(&self, state: &mut ElfComp2016) {
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
            Inst::Tgl(x) => {
                let vx = x.value(&state.reg);
                if vx == 0 {
                    state.ip += 1;
                    return;
                }
                let nip = state.ip as isize + vx;
                if nip < 0 || nip >= state.inst.len() as isize {
                    state.ip += 1;
                    return;
                }
                let inst = state.inst[nip as usize];
                state.inst[nip as usize] = match inst {
                    Inst::Inc(x) => Inst::Dec(x),
                    Inst::Dec(x) => Inst::Inc(x),
                    Inst::Tgl(x) => Inst::Inc(x),
                    Inst::Cpy(x, y) => Inst::Jnz(x, y),
                    Inst::Jnz(x, y) => Inst::Cpy(x, y),
                };
                state.ip += 1;
            }
        }
    }
}

struct ElfComp2016 {
    inst: Vec<Inst>,
    ip: usize,
    reg: Vec<isize>,
}

impl ElfComp2016 {
    fn new(inp: &[String]) -> ElfComp2016 {
        ElfComp2016 {
            inst: inp.iter().map(|l| Inst::new(l)).collect(),
            ip: 0,
            reg: vec![0; 4],
        }
    }
    fn run(&mut self) {
        while self.ip < self.inst.len() {
            let inst = self.inst[self.ip];
            inst.run(self);
        }
    }
    fn part1(&mut self) -> isize {
        self.ip = 0;
        self.reg = vec![7, 0, 0, 0];
        self.run();
        self.reg[0]
    }
    fn part2(&mut self) -> isize {
        self.ip = 0;
        self.reg = vec![12, 0, 0, 0];
        self.run();
        self.reg[0]
    }
}

#[allow(dead_code)]
const EX1: [&str; 7] = [
    "cpy 2 a", "tgl a", "tgl a", "tgl a", "cpy 1 a", "dec a", "dec a",
];

#[test]
fn part1_works() {
    let e: Vec<String> =
        EX1.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    let mut comp = ElfComp2016::new(&e);
    assert_eq!(comp.part1(), 3, "part 1 example");
}

fn main() {
    let lines = aoc::input_lines();
    let lines2 = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let mut comp = ElfComp2016::new(&lines);
        let p1 = comp.part1();
        comp = ElfComp2016::new(&lines2);
        let p2 = comp.part2();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
