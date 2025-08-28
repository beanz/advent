const RA: usize = 0;
const RB: usize = 1;

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
enum Op {
    Hlf,
    Tpl,
    Inc,
    Jmp,
    Jie,
    Jio,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
struct Inst {
    op: Op,
    reg: usize,
    off: isize,
}

impl Inst {
    fn new(l: &str) -> Inst {
        let mut ints = aoc::ints::<isize>(l);
        let off = if let Some(n) = ints.next() { n } else { 0 };
        let mut ss = l.split(' ');
        let op = match ss.next().unwrap() {
            "hlf" => Op::Hlf,
            "tpl" => Op::Tpl,
            "inc" => Op::Inc,
            "jmp" => Op::Jmp,
            "jie" => Op::Jie,
            _ => Op::Jio,
        };
        let reg = if &ss.next().unwrap()[0..1] == "a" {
            RA
        } else {
            RB
        };
        Inst { op, reg, off }
    }
    fn run(&self, ip: &mut usize, reg: &mut [usize]) {
        match self.op {
            Op::Hlf => {
                reg[self.reg] /= 2;
                *ip += 1;
            }
            Op::Tpl => {
                reg[self.reg] *= 3;
                *ip += 1;
            }
            Op::Inc => {
                reg[self.reg] += 1;
                *ip += 1;
            }
            Op::Jmp => {
                *ip = (*ip as isize + self.off) as usize;
            }
            Op::Jie => {
                if (reg[self.reg] % 2) == 0 {
                    *ip = (*ip as isize + self.off) as usize;
                } else {
                    *ip += 1;
                }
            }
            Op::Jio => {
                if reg[self.reg] == 1 {
                    *ip = (*ip as isize + self.off) as usize;
                } else {
                    *ip += 1;
                }
            }
        }
    }
}

struct Comp {
    inst: Vec<Inst>,
}

impl Comp {
    fn new(inp: &[String]) -> Comp {
        Comp {
            inst: inp.iter().map(|l| Inst::new(l)).collect(),
        }
    }
    fn run(&self, a: usize) -> (usize, usize) {
        let mut reg: Vec<usize> = vec![a, 0];
        let mut ip = 0;
        while ip < self.inst.len() {
            let inst = self.inst[ip];
            //println!("{}: {:?} {} {}", ip, inst, reg[RA], reg[RB]);
            inst.run(&mut ip, &mut reg);
        }
        (reg[RA], reg[RB])
    }
    fn part1(&self) -> usize {
        let (_, res) = self.run(0);
        res
    }
    fn part2(&self) -> usize {
        let (_, res) = self.run(1);
        res
    }
}

fn main() {
    let lines = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let comp = Comp::new(&lines);
        let p1 = comp.part1();
        let p2 = comp.part2();
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
    fn inst_new_works() {
        {
            let inst = Inst::new("hlf a");
            assert_eq!((inst.op, inst.reg), (Op::Hlf, RA), "hlf a");
        }
        {
            let inst = Inst::new("tpl B");
            assert_eq!((inst.op, inst.reg), (Op::Tpl, RB), "tpl b");
        }
        {
            let inst = Inst::new("inc a");
            assert_eq!((inst.op, inst.reg), (Op::Inc, RA), "inc a");
        }
        {
            let inst = Inst::new("jmp +2");
            assert_eq!((inst.op, inst.off), (Op::Jmp, 2), "jmp +2");
        }
        {
            let inst = Inst::new("jie a, -3");
            assert_eq!(
                (inst.op, inst.reg, inst.off),
                (Op::Jie, RA, -3),
                "jie a, -3"
            );
        }
    }

    #[test]
    fn part1_works() {
        let comp = Comp::new(&vec![
            "inc a".to_string(),
            "jio a, +2".to_string(),
            "tpl a".to_string(),
            "inc a".to_string(),
        ]);
        assert_eq!(comp.run(0), (2, 0), "part 1 test input");
    }

    #[test]
    fn part2_works() {
        let comp = Comp::new(&vec![
            "inc a".to_string(),
            "jio a, +2".to_string(),
            "tpl a".to_string(),
            "inc a".to_string(),
        ]);
        assert_eq!(comp.run(1), (7, 0), "part 1 test input");
    }
}
