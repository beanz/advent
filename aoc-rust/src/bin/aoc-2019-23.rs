use arrayvec::ArrayVec;

const PROG_CAP: usize = 4096;
const FN_TABLE: usize = 11;
const DATA_SLOTS: usize = 10;

#[derive(Debug, Default)]
enum Op {
    #[default]
    Add,
    Mul,
    Div,
    Head,
}

#[derive(Debug, Default)]
struct Nic {
    ready: bool,
    slot_div: usize,
    buf_len: usize,
    buf: [Option<isize>; DATA_SLOTS],
    op: Op,
    dst_len: usize,
    dst: [(usize, usize); DATA_SLOTS],
}

impl Nic {
    fn run(&mut self) -> Option<isize> {
        if !self.ready {
            return None;
        }
        for j in 0..self.buf_len {
            if self.buf[j].is_none() {
                return None;
            }
        }
        self.ready = false;
        match &self.op {
            Op::Add => {
                let mut sum = 0;
                for j in 0..self.buf_len {
                    sum += self.buf[j].expect("not none");
                }
                Some(sum)
            }
            Op::Mul => {
                let mut prod = 1;
                for j in 0..self.buf_len {
                    prod *= self.buf[j].expect("not none");
                }
                Some(prod)
            }
            Op::Div => {
                let res = self.buf[0].expect("not none") / self.buf[1].expect("not none");
                Some(res)
            }
            Op::Head => {
                let res = self.buf[0].expect("not none");
                Some(res)
            }
        }
    }
}

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

    let mut nics: ArrayVec<Nic, 50> = ArrayVec::default();
    for i in 0..50 {
        let addr = prog[FN_TABLE + i] as usize;
        let mut buf = [None; DATA_SLOTS];
        let slot_div = read_var(&prog, addr) as usize;
        let buf_len = read_var(&prog, addr + 4) as usize;
        let buf_addr = read_var(&prog, addr + 8) as usize;
        for j in 0..buf_len {
            buf[j] = match (prog[buf_addr + j * 2], prog[buf_addr + j * 2 + 1]) {
                (0, _) => None,
                (_, n) => Some(n),
            };
        }
        let op = match read_var(&prog, addr + 12) {
            253 => Op::Add,
            302 => Op::Mul,
            351 => Op::Div,
            556 => Op::Head,
            _ => unreachable!("unsupported function"),
        };
        let mut dst = [(0, 0); DATA_SLOTS];
        let dst_len = read_var(&prog, addr + 16) as usize;
        let dst_addr = read_var(&prog, addr + 20) as usize;
        //eprintln!(
        //    "{}: {} {:?} {} {:?} {:?} {}",
        //    i, slot_div, buf, buf_len, op, dst, dst_len,
        //);
        for j in 0..dst_len {
            dst[j] = (
                prog[dst_addr + j * 2] as usize,
                prog[dst_addr + j * 2 + 1] as usize,
            );
        }
        nics.push(Nic {
            ready: true,
            slot_div,
            buf_len,
            buf,
            op,
            dst_len,
            dst,
        });
    }
    //eprintln!("nics={:?}", nics);
    let mut p1 = None;
    let mut nat = (0, 0);
    let mut prev = 0;
    loop {
        let mut busy = false;
        for i in 0..50 {
            let out = nics[i].run();
            if let Some(v) = out {
                busy = true;
                //eprintln!("{}: sending {}", i, v);
                for j in 0..nics[i].dst_len {
                    let (k, slot) = nics[i].dst[j];
                    if k == 255 {
                        if p1.is_none() {
                            p1 = Some(v);
                        }
                        nat = (slot, v);
                        continue;
                    }
                    let slot_i = slot / nics[k].slot_div - 1;
                    nics[k].buf[slot_i] = Some(v);
                    nics[k].ready = true;
                    //eprintln!("{}:   {}[{}] {} {}", i, k, slot_i, slot, v);
                }
            }
        }
        if !busy {
            //eprintln!("nat: sending {},{} ({})", nat.0, nat.1, prev);
            if nat.1 == prev {
                break;
            }
            prev = nat.1;
            let slot = nat.0 / nics[0].slot_div - 1;
            nics[0].buf[slot] = Some(nat.1);
            nics[0].ready = true;
            //eprintln!("nat:   {}", slot);
        }
    }
    (p1.expect("no p1 result"), nat.1)
}

fn read_var(prog: &[isize; PROG_CAP], addr: usize) -> isize {
    match prog[addr] {
        21101 | 1101 => prog[addr + 1] + prog[addr + 2],
        21102 | 1102 => prog[addr + 1] * prog[addr + 2],
        _ => unreachable!("unexpected instruction"),
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
        let inp = std::fs::read("../2019/23/input.txt").expect("read error");
        assert_eq!(parts(&inp), (26464, 19544));
        let inp = std::fs::read("../2019/23/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (24922, 19478));
    }
}
