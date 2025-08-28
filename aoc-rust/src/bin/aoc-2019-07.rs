use heapless::Deque;

const PROG_CAP: usize = 2048;

fn parts(inp: &[u8]) -> (isize, isize) {
    let mut prog: [isize; PROG_CAP] = [0; PROG_CAP];
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<isize>(inp, i);
        prog[l] = n;
        l += 1;
        i = j + 1;
    }
    let phase = [0, 1, 2, 3, 4];
    let mut perm = Perm::new(5);
    let mut p1 = isize::MIN;
    while !perm.done() {
        let cur = perm.get();
        let sig = try_phase(
            &prog,
            &[
                phase[cur[0]],
                phase[cur[1]],
                phase[cur[2]],
                phase[cur[3]],
                phase[cur[4]],
            ],
        );
        if sig > p1 {
            p1 = sig;
        }
        perm.next();
    }
    let phase = [5, 6, 7, 8, 9];
    let mut perm = Perm::new(5);
    let mut p2 = isize::MIN;
    while !perm.done() {
        let cur = perm.get();
        let sig = try_phase(
            &prog,
            &[
                phase[cur[0]],
                phase[cur[1]],
                phase[cur[2]],
                phase[cur[3]],
                phase[cur[4]],
            ],
        );
        if sig > p2 {
            p2 = sig;
        }
        perm.next();
    }
    (p1, p2)
}

fn try_phase(prog: &[isize; PROG_CAP], phase: &[isize; 5]) -> isize {
    let mut ic: Vec<IntCode<PROG_CAP, 5>> = Vec::new();
    let mut u: [isize; PROG_CAP] = [0; PROG_CAP];
    for j in 0..PROG_CAP {
        u[j] = prog[j];
    }
    let inp = &mut Deque::<isize, 5>::new();
    inp.push_back(phase[0]).expect("input full?");
    inp.push_back(0).expect("input full?");
    ic.push(IntCode {
        pc: 0,
        prog: &mut u,
        base: 0,
        input: inp,
        output: 0,
        done: false,
    });
    let mut u: [isize; PROG_CAP] = [0; PROG_CAP];
    for j in 0..PROG_CAP {
        u[j] = prog[j];
    }
    let inp = &mut Deque::<isize, 5>::new();
    inp.push_back(phase[1]).expect("input full?");
    ic.push(IntCode {
        pc: 0,
        prog: &mut u,
        base: 0,
        input: inp,
        output: 0,
        done: false,
    });
    let mut u: [isize; PROG_CAP] = [0; PROG_CAP];
    for j in 0..PROG_CAP {
        u[j] = prog[j];
    }
    let inp = &mut Deque::<isize, 5>::new();
    inp.push_back(phase[2]).expect("input full?");
    ic.push(IntCode {
        pc: 0,
        prog: &mut u,
        base: 0,
        input: inp,
        output: 0,
        done: false,
    });
    let mut u: [isize; PROG_CAP] = [0; PROG_CAP];
    for j in 0..PROG_CAP {
        u[j] = prog[j];
    }
    let inp = &mut Deque::<isize, 5>::new();
    inp.push_back(phase[3]).expect("input full?");
    ic.push(IntCode {
        pc: 0,
        prog: &mut u,
        base: 0,
        input: inp,
        output: 0,
        done: false,
    });
    let mut u: [isize; PROG_CAP] = [0; PROG_CAP];
    for j in 0..PROG_CAP {
        u[j] = prog[j];
    }
    let inp = &mut Deque::<isize, 5>::new();
    inp.push_back(phase[4]).expect("input full?");
    ic.push(IntCode {
        pc: 0,
        prog: &mut u,
        base: 0,
        input: inp,
        output: 0,
        done: false,
    });
    let mut done = 0;
    let mut last = 0;
    let mut out = 0;
    let mut first = true;
    while done != 5 {
        done = 0;
        for i in 0..5 {
            if ic[i].done() {
                done += 1;
                first = false;
                continue;
            }
            if !first {
                ic[i].input.push_back(out).expect("input overflow");
            }
            let rc = ic[i].run();
            match rc {
                ICState::ProducedOutput => {
                    out = ic[i].output;
                    last = out;
                }
                ICState::NeedInput => {}
                _ => {
                    done += 1;
                }
            }
            first = false;
        }
    }
    last
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
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

struct Perm {
    orig: Vec<usize>,
    perm: Vec<usize>,
}

impl Perm {
    fn new(n: usize) -> Perm {
        let mut orig = Vec::<usize>::new();
        let mut perm = Vec::<usize>::new();
        for i in 0..n {
            perm.push(0);
            orig.push(i);
        }
        Perm { orig, perm }
    }
    fn done(&self) -> bool {
        self.perm[0] == self.perm.len()
    }
    fn next(&mut self) {
        let mut i = self.perm.len() - 1;
        loop {
            if i == 0 || self.perm[i] < self.perm.len() - i - 1 {
                self.perm[i] += 1;
                break;
            }
            self.perm[i] = 0;
            if i == 0 {
                break;
            }
            i -= 1;
        }
    }
    fn get(&self) -> Vec<usize> {
        let mut res = self.orig.clone();
        for (i, v) in self.perm.iter().enumerate() {
            (res[i], res[i + v]) = (res[i + v], res[i]);
        }
        res
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/07/input.txt").expect("read error");
        assert_eq!(parts(&inp), (51679, 19539216));
        let inp = std::fs::read("../2019/07/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (95757, 4275738));
    }
}
