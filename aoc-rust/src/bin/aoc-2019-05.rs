fn parts(inp: &[u8]) -> (isize, isize) {
    let mut prog: [isize; 2048] = [0; 2048];
    let mut prog2: [isize; 2048] = [0; 2048];
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<isize>(inp, i);
        prog[l] = n;
        prog2[l] = n;
        l += 1;
        i = j + 1;
    }
    let mut ic = IntCode {
        pc: 0,
        prog: &mut prog,
        base: 0,
        output: 0,
    };
    let p1 = ic.run(1);
    let mut ic = IntCode {
        pc: 0,
        prog: &mut prog2,
        base: 0,
        output: 0,
    };
    let p2 = ic.run(5);
    (p1, p2)
}

struct Inst {
    op: isize,
    param: [isize; 3],
    addr: [usize; 3],
}

struct IntCode<'a, const CAP: usize> {
    pc: usize,
    prog: &'a mut [isize; CAP],
    base: isize,
    output: isize,
}

const OP_ARITY: [usize; 10] = [0, 3, 3, 1, 1, 2, 2, 3, 3, 1];

impl<'a, const CAP: usize> IntCode<'a, CAP> {
    fn run(&mut self, input: isize) -> isize {
        loop {
            let inst = self.parse_inst();
            match inst.op {
                99 => break,
                1 => {
                    self.prog[inst.addr[2]] = inst.param[0] + inst.param[1];
                }
                2 => {
                    self.prog[inst.addr[2]] = inst.param[0] * inst.param[1];
                }
                3 => {
                    self.prog[inst.addr[0]] = input;
                }
                4 => {
                    let o = inst.param[0];
                    if self.output != 0 && o != 0 {
                        eprintln!("out: prev={} cur={}", self.output, o);
                        unreachable!("output error");
                    }
                    self.output = o;
                }
                5 => {
                    if inst.param[0] != 0 {
                        self.pc = inst.param[1] as usize;
                    }
                }
                6 => {
                    if inst.param[0] == 0 {
                        self.pc = inst.param[1] as usize;
                    }
                }
                7 => {
                    self.prog[inst.addr[2]] = (inst.param[0] < inst.param[1]).into();
                }
                8 => {
                    self.prog[inst.addr[2]] = (inst.param[0] == inst.param[1]).into();
                }
                9 => {
                    self.base += inst.param[0];
                }
                _ => unreachable!("invalid op"),
            }
        }
        self.output
    }
    fn parse_inst(&mut self) -> Inst {
        let raw_op = self.prog[self.pc];
        self.pc += 1;
        let op = raw_op % 100;
        let arity = if op == 99 { 0 } else { OP_ARITY[op as usize] };
        let mode: [isize; 3] = [
            (raw_op / 100) % 10,
            (raw_op / 1000) % 10,
            (raw_op / 10000) % 10,
        ];
        let mut param: [isize; 3] = [0; 3];
        let mut addr: [usize; 3] = [0; 3];
        for i in 0..arity {
            match mode[i] {
                0 => {
                    let a = self.prog[self.pc] as usize;
                    param[i] = self.prog[a];
                    addr[i] = a;
                }
                1 => {
                    param[i] = self.prog[self.pc];
                    addr[i] = 9999999;
                }
                2 => {
                    let a = (self.base + self.prog[self.pc]) as usize;
                    param[i] = self.prog[a];
                    addr[i] = a;
                }
                _ => unreachable!("invalid mode"),
            }
            self.pc += 1;
        }
        Inst { op, param, addr }
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/05/input.txt").expect("read error");
        assert_eq!(parts(&inp), (16209841, 8834787));
        let inp = std::fs::read("../2019/05/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (15097178, 1558663));
    }
}
