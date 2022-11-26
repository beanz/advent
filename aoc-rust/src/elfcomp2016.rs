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
    Nop(),
    Add(Op, Op),
    Sub(Op, Op),
    Mul(Op, Op, Op),
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
                let j = if vx != 0 { vy } else { 1 };
                state.ip = (state.ip as isize + j) as usize;
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
                    _ => panic!("toggle of optimized instruction"),
                };
                state.opt = optimize(&state.inst);
                state.ip += 1;
            }
            Inst::Add(x, y) => {
                if let Op::Register(rx) = x {
                    if let Op::Register(ry) = y {
                        state.reg[(*rx as u8 - b'a') as usize] +=
                            state.reg[(*ry as u8 - b'a') as usize];
                        state.reg[(*ry as u8 - b'a') as usize] = 0;
                    } else {
                        panic!("invalid add: second operand must be register");
                    }
                } else {
                    panic!("invalid add: first operand must be register");
                }
                state.ip += 1;
            }
            Inst::Sub(x, y) => {
                if let Op::Register(rx) = x {
                    if let Op::Register(ry) = y {
                        state.reg[(*rx as u8 - b'a') as usize] -=
                            state.reg[(*ry as u8 - b'a') as usize];
                        state.reg[(*ry as u8 - b'a') as usize] = 0;
                    } else {
                        panic!("invalid sub: second operand must be register");
                    }
                } else {
                    panic!("invalid sub: first operand must be register");
                }
                state.ip += 1;
            }
            Inst::Mul(x, y, z) => {
                if let Op::Register(rx) = x {
                    if let Op::Register(ry) = y {
                        if let Op::Register(rz) = z {
                            state.reg[(*rx as u8 - b'a') as usize] += state.reg
                                [(*ry as u8 - b'a') as usize]
                                * state.reg[(*rz as u8 - b'a') as usize];
                            state.reg[(*ry as u8 - b'a') as usize] = 0;
                            state.reg[(*rz as u8 - b'a') as usize] = 0;
                        } else {
                            panic!(
                                "invalid mul: third operand must be register"
                            );
                        }
                    } else {
                        panic!("invalid mul: second operand must be register");
                    }
                } else {
                    panic!("invalid mul: first operand must be register");
                }
                state.ip += 1;
            }
            Inst::Nop() => {
                state.ip += 1;
            }
        }
    }
}

pub struct ElfComp2016 {
    inst: Vec<Inst>,
    opt: Vec<Inst>,
    ip: usize,
    reg: Vec<isize>,
}

fn optimize(inst: &[Inst]) -> Vec<Inst> {
    let nop = Inst::Nop();
    let mut opt: Vec<Inst> = vec![];
    let mut i = 0;
    while i < inst.len() {
        if let Inst::Jnz(a, b) = inst[i] {
            if b == Op::Immediate(-2) {
                let p1 = inst[i - 2];
                let p2 = inst[i - 1];
                if let Inst::Dec(p2a) = p2 {
                    if p2a == a {
                        if let Inst::Inc(p1a) = p1 {
                            opt[i - 2] = nop;
                            opt[i - 1] = nop;
                            opt.push(Inst::Add(p1a, a));
                            i += 1;
                            continue;
                        } else if let Inst::Dec(p1a) = p1 {
                            opt[i - 2] = nop;
                            opt[i - 1] = nop;
                            opt.push(Inst::Sub(p1a, a));
                            i += 1;
                            continue;
                        }
                    }
                }
            } else if b == Op::Immediate(-5) {
                let p1 = opt[i - 2];
                let p2 = opt[i - 1];
                if let Inst::Dec(p2a) = p2 {
                    if p2a == a {
                        if let Inst::Add(p1a, p1b) = p1 {
                            opt[i - 2] = nop;
                            opt[i - 1] = nop;
                            opt.push(Inst::Mul(p1a, p1b, a));
                            i += 1;
                            continue;
                        }
                    }
                }
            }
        }
        opt.push(inst[i]);
        i += 1;
    }
    opt
}

impl ElfComp2016 {
    pub fn new(inp: &[String]) -> ElfComp2016 {
        let inst: Vec<Inst> = inp.iter().map(|l| Inst::new(l)).collect();
        let opt = optimize(&inst);
        ElfComp2016 {
            inst,
            opt,
            ip: 0,
            reg: vec![0; 4],
        }
    }

    pub fn run(&mut self, v: &[isize]) {
        self.opt = optimize(&self.inst);
        self.ip = 0;
        self.reg = vec![0; 4];
        let mut i = 0;
        while i < v.len() {
            self.reg[i] = v[i];
            i += 1;
        }
        while self.ip < self.inst.len() {
            let inst = self.opt[self.ip];
            inst.run(self);
        }
    }

    pub fn get_reg(&mut self, b: u8) -> isize {
        self.reg[(b - b'a') as usize]
    }
}
