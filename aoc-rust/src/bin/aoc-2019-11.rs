use heapless::{Deque, FnvIndexMap};

const PROG_CAP: usize = 2048;
const MAP_SIZE: usize = 4096;

fn parts(inp: &[u8]) -> (usize, [u8; 252], usize) {
    let mut prog: [isize; PROG_CAP] = [0; PROG_CAP];
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<isize>(inp, i);
        prog[l] = n;
        l += 1;
        i = j + 1;
    }
    // part 2 is read only so we do it first
    let mut p2 = [b'.'; 252];
    let part2_addr = prog[4] as usize;
    let mut data = [0usize; 6];
    for (i, offset) in [6, 17, 64, 75, 98, 109].iter().enumerate() {
        let addr = part2_addr + offset;
        data[i] = match prog[addr] as usize {
            21101 => prog[addr + 1] + prog[addr + 2],
            21102 => prog[addr + 1] * prog[addr + 2],
            _ => unreachable!("unexpected part 2 instruction"),
        } as usize;
    }
    plot(0, 0, 1, data[0], &mut p2);
    plot(20, 0, 1, data[1], &mut p2);
    plot(41, 3, -1, data[2], &mut p2);
    plot(21, 3, -1, data[3], &mut p2);
    plot(0, 4, 1, data[4], &mut p2);
    plot(20, 4, 1, data[5], &mut p2);
    let p2l = 252;
    for y in 0..6usize {
        p2[y * 42 + 41] = b'\n';
    }
    // now we do part 1
    let mut map = FnvIndexMap::<(i8, i8), bool, MAP_SIZE>::new();
    run(&mut prog, 0, &mut map);
    (map.len(), p2, p2l)
}

fn plot(x: usize, y: usize, d: isize, data: usize, p2: &mut [u8; 252]) {
    let (mut x, mut y) = (x, y);
    let mut bit = 1 << 39;
    while bit != 0 {
        x = (x as isize + d) as usize;
        if data & bit != 0 {
            p2[y * 42 + x] = b'#'
        }
        bit >>= 1;
        y = (y as isize + d) as usize;
        if data & bit != 0 {
            p2[y * 42 + x] = b'#'
        }
        bit >>= 1;
        x = (x as isize + d) as usize;
        if data & bit != 0 {
            p2[y * 42 + x] = b'#'
        }
        bit >>= 1;
        y = (y as isize - d) as usize;
        if data & bit != 0 {
            p2[y * 42 + x] = b'#'
        }
        bit >>= 1;
    }
}

fn run(
    prog: &mut [isize; PROG_CAP],
    input: isize,
    map: &mut FnvIndexMap<(i8, i8), bool, MAP_SIZE>,
) {
    let inp = &mut Deque::<isize, 5>::new();
    inp.push_back(input).expect("input full?");
    let (mut x, mut y) = (0, 0);
    let (mut dx, mut dy) = (0, -1);
    let mut ic = IntCode {
        pc: 0,
        prog,
        base: 0,
        input: inp,
        output: 0,
        done: false,
    };
    let mut col = true;
    loop {
        let rc = ic.run();
        match rc {
            ICState::ProducedOutput => {
                let v: bool = ic.output == 1;
                if col {
                    map.insert((x, y), v).expect("map full");
                    col = false;
                } else {
                    if v {
                        (dx, dy) = (-dy, dx);
                    } else {
                        (dx, dy) = (dy, -dx);
                    }
                    (x, y) = (x + dx, y + dy);
                    col = true;
                }
            }
            ICState::NeedInput => {
                ic.input
                    .push_back(if let Some(v) = map.get(&(x, y)) {
                        isize::from(*v)
                    } else {
                        0
                    })
                    .expect("input overflow");
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
        let (p1, p2, p2l) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            print!(
                "Part 2:\n{}",
                std::str::from_utf8(&p2[0..p2l]).expect("ascii")
            );
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/11/input.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 2141);
        assert_eq!(
            std::str::from_utf8(&p2[0..p2l - 1]).expect("ascii"),
            r#".###..###....##..##..####.####.#..#.####.
.#..#.#..#....#.#..#.#.......#.#.#..#....
.#..#.#..#....#.#....###....#..##...###..
.###..###.....#.#....#.....#...#.#..#....
.#.#..#....#..#.#..#.#....#....#.#..#....
.#..#.#.....##...##..#....####.#..#.#...."#
        );
        let inp = std::fs::read("../2019/11/input-amf.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 1930);
        assert_eq!(
            std::str::from_utf8(&p2[0..p2l - 1]).expect("ascii"),
            r#".###..####.#..#.#..#.####..##..####.#..#.
.#..#.#....#.#..#..#.#....#..#....#.#..#.
.#..#.###..##...####.###..#......#..#..#.
.###..#....#.#..#..#.#....#.....#...#..#.
.#....#....#.#..#..#.#....#..#.#....#..#.
.#....#....#..#.#..#.####..##..####..##.."#,
        );
    }
}
