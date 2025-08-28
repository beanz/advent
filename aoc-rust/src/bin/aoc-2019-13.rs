use heapless::Deque;

const PROG_CAP: usize = 4096;
const WIDTH_ADDR: usize = 49;
const HEIGHT_ADDR: usize = 60;
//const CREDIT_OPERAND_2_ADDR: usize = 379;
//const CREDIT_OPERAND_1_ADDR: usize = 380;
//const INPUT_CMP_ADDR: usize = 381;
//const DRAW_X_ADDR: usize = 382;
//const DRAW_Y_ADDR: usize = 383;
//const INPUT_ADDR: usize = 384;
//const CREDIT_RESULT_ADDR: usize = 385;
//const SCORE_ADDR: usize = 386;
const REMAINING_BLOCKS_ADDR: usize = 387;
//const BALL_X: usize = 388;
//const BALL_Y: usize = 389;
//const PAD_X: usize = 392;
const INST_A_ADDR: usize = 611;
const INST_B_ADDR: usize = 615;
const MAP_ADDR: usize = 639;

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
    let p1 = prog[REMAINING_BLOCKS_ADDR];
    let (w, h) = (prog[WIDTH_ADDR] as usize, prog[HEIGHT_ADDR] as usize);
    //eprintln!("{}x{}", w, h);
    let a = match prog[INST_A_ADDR] {
        21101 => prog[INST_A_ADDR + 1] + prog[INST_A_ADDR + 2],
        21102 => prog[INST_A_ADDR + 1] * prog[INST_A_ADDR + 2],
        _ => unreachable!("unexpected var a instruction"),
    } as usize;
    let b = match prog[INST_B_ADDR] {
        21101 => prog[INST_B_ADDR + 1] + prog[INST_B_ADDR + 2],
        21102 => prog[INST_B_ADDR + 1] * prog[INST_B_ADDR + 2],
        _ => unreachable!("unexpected var b instruction"),
    } as usize;
    //eprintln!("f(x,y) = (x*{}+y) * {} + {}", h, a, b);
    let map_len = w * h;
    let score_table_addr = MAP_ADDR + map_len;
    let mut score = 0;
    for y in 0..h {
        for x in 1..w - 1 {
            if prog[MAP_ADDR + y * w + x] == 2 {
                score += prog[score_table_addr + ((x * h + y) * a + b) % map_len];
            }
        }
    }
    //for x in 1..w - 1 {
    //    prog[MAP_ADDR + (h - 2) * w + x] = 3;
    //}
    //prog[0] = 2;
    //run(&mut prog);
    //let p2 = prog[SCORE_ADDR];
    (p1, score)
}

#[allow(dead_code)]
fn run(prog: &mut [isize; PROG_CAP]) {
    let inp = &mut Deque::<isize, 5>::new();
    inp.push_back(0).expect("input full?");
    let mut ic = IntCode {
        pc: 0,
        prog,
        base: 0,
        input: inp,
        output: 0,
        done: false,
    };
    loop {
        let rc = ic.run();
        match rc {
            ICState::ProducedOutput => {}
            ICState::NeedInput => {
                ic.input.push_back(0).expect("input overflow");
            }
            _ => break,
        }
    }
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
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/13/input.txt").expect("read error");
        assert_eq!(parts(&inp), (398, 19447));
        let inp = std::fs::read("../2019/13/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (341, 17138));
    }
}
