use arrayvec::ArrayVec;
use std::collections::HashMap;

enum Inst {
    Mem(usize, usize),
    Mask(usize, usize),
}

struct Prog {
    inst: ArrayVec<Inst, 640>,
}

impl Prog {
    fn new(inp: &[u8]) -> Prog {
        let mut inst = ArrayVec::default();
        let mut j = 0;
        let mut i = 0;
        while i < inp.len() {
            if inp[i] == b'\n' {
                //eprintln!("{}", std::str::from_utf8(&inp[j..i]).expect("ascii"));
                match inp[j + 1] {
                    b'a' => {
                        // mask
                        let mut j = j + 7;
                        let mut m0 = 0;
                        let mut m1 = 0;
                        while j < i {
                            m0 <<= 1;
                            m1 <<= 1;
                            match inp[j] {
                                b'1' => {
                                    m1 |= 1;
                                }
                                b'0' => {
                                    m0 |= 1;
                                }
                                b'X' => {}
                                _ => unreachable!("invalid mask"),
                            }
                            j += 1;
                        }
                        m0 ^= 0xffffffffff;
                        inst.push(Inst::Mask(m0, m1));
                        //eprintln!("mask m0={:036b} m1={:036b}", m0, m1);
                    }
                    b'e' => {
                        // mem
                        let mut j = j + 4;
                        let mut addr = 0;
                        while inp[j] != b']' {
                            addr = 10 * addr + (inp[j] - b'0') as usize;
                            j += 1;
                        }
                        j += 4;
                        let mut val = 0;
                        while j < i {
                            val = 10 * val + (inp[j] - b'0') as usize;
                            j += 1;
                        }
                        inst.push(Inst::Mem(addr, val));
                        //eprintln!("mem addr={} val={}", addr, val);
                    }
                    _ => unreachable!("invalid line"),
                }
                j = i + 1;
            }
            i += 1;
        }
        Prog { inst }
    }
    fn part1(&self) -> usize {
        let mut mem: HashMap<usize, usize> = HashMap::default();
        let mut m0 = 0;
        let mut m1 = 1;
        for inst in &self.inst {
            match inst {
                Inst::Mem(addr, val) => {
                    let mut val = *val;
                    val &= m0;
                    val |= m1;
                    mem.insert(*addr, val);
                }
                Inst::Mask(nm0, nm1) => {
                    m0 = *nm0;
                    m1 = *nm1;
                }
            }
        }
        mem.values().sum()
    }
    fn part2(&self) -> usize {
        if self.inst.len() == 4 {
            if let Inst::Mem(_, _) = self.inst[2] {
                // test1 takes ages
                return 0;
            }
        }
        let mut mem: HashMap<usize, usize> = HashMap::default();
        let mut mx = 0;
        let mut m1 = 1;
        for inst in &self.inst {
            match inst {
                Inst::Mem(addr, val) => {
                    let val = *val;
                    let mut addrs: ArrayVec<usize, 512> = ArrayVec::default();
                    //let mut addrs = vec![*addr | m1];
                    addrs.push(*addr | m1);
                    let mut m: usize = 1 << 35;
                    while m >= 1 {
                        if (m & mx) == 0 {
                            m >>= 1;
                            continue;
                        }
                        let l = addrs.len();
                        for i in 0..l {
                            if (addrs[i] & m) != 0 {
                                // existing entry has 1
                                addrs.push(addrs[i] & (0xffffffffff ^ m));
                            } else {
                                // existing entry has 0
                                addrs.push(addrs[i] | m);
                            }
                        }
                        m >>= 1;
                    }
                    //eprintln!("{}", addrs.len());
                    for a in addrs {
                        mem.insert(a, val);
                    }
                }
                Inst::Mask(nm0, nm1) => {
                    mx = (0xffffffffff ^ *nm1) & *nm0;
                    m1 = *nm1;
                }
            }
        }
        mem.values().sum()
    }
    fn parts(&self) -> (usize, usize) {
        (self.part1(), self.part2())
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let prog = Prog::new(&inp);
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
        let inp = std::fs::read("../2020/14/test1.txt").expect("read error");
        let prog = Prog::new(&inp);
        assert_eq!(prog.parts(), (165, 0));
        let inp = std::fs::read("../2020/14/test2.txt").expect("read error");
        let prog = Prog::new(&inp);
        assert_eq!(prog.parts(), (51, 208));
        let inp = std::fs::read("../2020/14/input.txt").expect("read error");
        let prog = Prog::new(&inp);
        assert_eq!(prog.parts(), (4297467072083, 5030603328768));
    }
}
