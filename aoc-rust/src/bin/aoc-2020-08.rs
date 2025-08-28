#[derive(Debug, PartialEq)]
enum Op {
    Nop(isize),
    Acc(isize),
    Jmp(isize),
}

use arrayvec::ArrayVec;

#[derive(Debug, PartialEq)]
struct Prog {
    inst: ArrayVec<Op, 640>, // 640 should be enough for anyone
}

enum ProgRes {
    Loop(isize),
    Fixed(isize),
}

impl Prog {
    fn new(inp: &[u8]) -> Prog {
        let mut i = 0;
        let mut inst: ArrayVec<Op, 640> = ArrayVec::default();
        while i < inp.len() {
            let ch = inp[i];
            i += 4;
            let mut n: isize = 0;
            let mut m: isize = 1;
            while i < inp.len() {
                match inp[i] {
                    b'+' => {}
                    b'-' => {
                        m = -1;
                    }
                    b'0'..=b'9' => {
                        n = n * 10 + ((inp[i] - b'0') as isize);
                    }
                    b'\n' => break,
                    _ => unreachable!("parse error"),
                }
                i += 1;
            }
            n *= m;
            inst.push(match ch {
                b'a' => Op::Acc(n),
                b'j' => Op::Jmp(n),
                b'n' => Op::Nop(n),
                _ => unreachable!("parse error"),
            });
            i += 1;
        }
        Prog { inst }
    }

    fn run(&mut self, flip: usize) -> ProgRes {
        let mut acc: isize = 0;
        let mut ip: usize = 0;
        let mut seen = [false; 640];
        while ip < self.inst.len() {
            if seen[ip] {
                return ProgRes::Loop(acc);
            }
            seen[ip] = true;
            if flip == ip {
                match &self.inst[ip] {
                    Op::Jmp(_) => ip += 1,
                    Op::Acc(v) => {
                        acc += v;
                        ip += 1
                    }
                    Op::Nop(v) => ip = ((ip as isize) + v) as usize,
                }
            } else {
                match &self.inst[ip] {
                    Op::Nop(_) => ip += 1,
                    Op::Acc(v) => {
                        acc += v;
                        ip += 1
                    }
                    Op::Jmp(v) => ip = ((ip as isize) + v) as usize,
                }
            }
        }
        ProgRes::Fixed(acc)
    }

    fn parts(&mut self) -> (isize, isize) {
        let p1 = match self.run(self.inst.len()) {
            ProgRes::Loop(v) => v,
            _ => unreachable!("must loop"),
        };
        for flip in 0..self.inst.len() {
            if let ProgRes::Fixed(acc) = self.run(flip) {
                return (p1, acc);
            }
        }
        (p1, 2)
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let mut prog = Prog::new(&inp);
        let (p1, p2) = prog.parts();
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/08/test1.txt").expect("read error");
        let mut prog = Prog::new(&inp);
        assert_eq!(prog.parts(), (5, 8));
        let inp = std::fs::read("../2020/08/input.txt").expect("read error");
        let mut prog = Prog::new(&inp);
        assert_eq!(prog.parts(), (1614, 1260));
    }
}
