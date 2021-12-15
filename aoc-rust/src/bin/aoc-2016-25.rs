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
    Out(Op),
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
            "out" => Inst::Out(Op::Register(
                words.next().unwrap().chars().next().unwrap(),
            )),
            _ => panic!("invalid instruction: {}", l),
        }
    }
    fn run(&self, state: &mut ElfComp2016State) -> Result<(), &'static str> {
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
            Inst::Out(x) => {
                let vx = x.value(&state.reg);
                if vx != state.exp {
                    return Err("unexpected output");
                }
                state.out_count += 1;
                state.exp = 1 - state.exp;
                state.ip += 1;
            }
        }
        Ok(())
    }
}

struct ElfComp2016State {
    ip: usize,
    reg: Vec<isize>,
    exp: isize,
    out_count: usize,
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
    fn run(&self, s: &mut ElfComp2016State) -> Result<(), &'static str> {
        while s.ip < self.inst.len() {
            let inst = &self.inst[s.ip];
            let res = inst.run(s);
            if res.is_err() {
                return res;
            } else if s.out_count >= 20 {
                return Ok(());
            }
        }
        Err("expected to run forever")
    }
    fn part1(&self) -> isize {
        for n in 0.. {
            let mut state = ElfComp2016State {
                ip: 0,
                reg: vec![n, 0, 0, 0],
                exp: 0,
                out_count: 0,
            };
            let res = self.run(&mut state);
            if res.is_ok() {
                return n;
            }
        }
        -1
    }
}

fn main() {
    let lines = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let comp = ElfComp2016::new(&lines);
        let p1 = comp.part1();
        if !bench {
            println!("Part 1: {}", p1);
        }
    });
}
