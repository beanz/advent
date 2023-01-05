use heapless::Deque;

const PROG_CAP: usize = 2048;

fn parts(inp: &[u8]) -> (isize, isize) {
    let mut prog: [isize; PROG_CAP] = [0; PROG_CAP];
    let mut prog2: [isize; PROG_CAP] = [0; PROG_CAP];
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<isize>(inp, i);
        prog[l] = n;
        prog2[l] = n;
        l += 1;
        i = j + 1;
    }
    (run(&mut prog, 1), run(&mut prog2, 2))
}

fn run(prog: &mut [isize; PROG_CAP], input: isize) -> isize {
    let inp = &mut Deque::<isize, 5>::new();
    inp.push_back(input).expect("input full?");
    let mut ic = IntCode {
        pc: 0,
        prog,
        base: 0,
        input: inp,
        output: 0,
        done: false,
    };
    loop {
        match ic.run() {
            ICState::ProducedOutput => return ic.output,
            _ => break,
        }
    }
    -1
}

#[derive(Debug)]
struct Inst {
    op: isize,
    param: [isize; 3],
    addr: [usize; 3],
}

struct IntCode<'a, const CAP: usize, const INPUT_CAP: usize> {
    pc: usize,
    prog: &'a mut [isize; CAP],
    base: isize,
    input: &'a mut Deque<isize, INPUT_CAP>,
    output: isize,
    done: bool,
}

const OP_ARITY: [usize; 10] = [0, 3, 3, 1, 1, 2, 2, 3, 3, 1];

enum ICState {
    Finished,
    //FinishedOpError,
    NeedInput,
    ProducedOutput,
}

impl<'a, const CAP: usize, const INPUT_CAP: usize> IntCode<'a, CAP, INPUT_CAP> {
    #[allow(dead_code)]
    fn done(&self) -> bool {
        self.done
    }
    fn run(&mut self) -> ICState {
        loop {
            let inst = self.parse_inst();
            match inst.op {
                99 => {
                    self.done = true;
                    return ICState::Finished;
                }
                1 => {
                    self.prog[inst.addr[2]] = inst.param[0] + inst.param[1];
                }
                2 => {
                    self.prog[inst.addr[2]] = inst.param[0] * inst.param[1];
                }
                3 => {
                    if let Some(inp) = self.input.pop_front() {
                        self.prog[inst.addr[0]] = inp;
                    } else {
                        self.pc -= 2;
                        return ICState::NeedInput;
                    }
                }
                4 => {
                    let o = inst.param[0];
                    self.output = o;
                    return ICState::ProducedOutput;
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
        let inp = std::fs::read("../2019/09/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (109, 109));
        let inp = std::fs::read("../2019/09/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (1219070632396864, 1219070632396864));
        let inp = std::fs::read("../2019/09/test3.txt").expect("read error");
        assert_eq!(parts(&inp), (1125899906842624, 1125899906842624));
        let inp = std::fs::read("../2019/09/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3100786347, 87023));
        let inp = std::fs::read("../2019/09/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (3063082071, 81348));
    }
}
