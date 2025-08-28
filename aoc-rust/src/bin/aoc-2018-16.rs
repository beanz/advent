use arrayvec::ArrayVec;

fn addr(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = r[a as usize] + r[b as usize];
}

fn addi(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = r[a as usize] + b;
}

fn mulr(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = r[a as usize] * r[b as usize];
}

fn muli(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = r[a as usize] * b;
}

fn banr(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = r[a as usize] & r[b as usize];
}

fn bani(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = r[a as usize] & b;
}

fn borr(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = r[a as usize] | r[b as usize];
}

fn bori(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = r[a as usize] | b;
}

fn setr(r: &mut [u16; 4], a: u16, _b: u16, c: u16) {
    r[c as usize] = r[a as usize]
}

fn seti(r: &mut [u16; 4], a: u16, _b: u16, c: u16) {
    r[c as usize] = a
}

fn gtir(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = (a > r[b as usize]).into();
}
fn gtri(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = (r[a as usize] > b).into();
}
fn gtrr(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = (r[a as usize] > r[b as usize]).into();
}

fn eqir(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = (a == r[b as usize]).into();
}
fn eqri(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = (r[a as usize] == b).into();
}
fn eqrr(r: &mut [u16; 4], a: u16, b: u16, c: u16) {
    r[c as usize] = (r[a as usize] == r[b as usize]).into();
}

const OPS: &[for<'a> fn(&'a mut [u16; 4], u16, u16, u16); 16] = &[
    addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr,
];

struct Output {
    pre: [u16; 4],
    op: [u16; 4],
    post: [u16; 4],
}

impl Output {
    fn consistent(&self, i: usize) -> bool {
        let mut r = [self.pre[0], self.pre[1], self.pre[2], self.pre[3]];
        OPS[i](&mut r, self.op[1], self.op[2], self.op[3]);
        self.post[0] == r[0] && self.post[1] == r[1] && self.post[2] == r[2] && self.post[3] == r[3]
    }
    fn matches(&self) -> usize {
        let mut c = 0;
        for i in 0..OPS.len() {
            c += usize::from(self.consistent(i));
        }
        c
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut out: ArrayVec<Output, 850> = ArrayVec::default();
    let mut i = 0;
    while inp[i] == b'B' {
        let (j, ba) = aoc::read::uint::<u16>(inp, i + 9);
        let (j, bb) = aoc::read::uint::<u16>(inp, j + 2);
        let (j, bc) = aoc::read::uint::<u16>(inp, j + 2);
        let (j, bd) = aoc::read::uint::<u16>(inp, j + 2);
        let (j, oa) = aoc::read::uint::<u16>(inp, j + 2);
        let (j, ob) = aoc::read::uint::<u16>(inp, j + 1);
        let (j, oc) = aoc::read::uint::<u16>(inp, j + 1);
        let (j, od) = aoc::read::uint::<u16>(inp, j + 1);
        let (j, aa) = aoc::read::uint::<u16>(inp, j + 10);
        let (j, ab) = aoc::read::uint::<u16>(inp, j + 2);
        let (j, ac) = aoc::read::uint::<u16>(inp, j + 2);
        let (j, ad) = aoc::read::uint::<u16>(inp, j + 2);
        i = j + 3;
        out.push(Output {
            pre: [ba, bb, bc, bd],
            op: [oa, ob, oc, od],
            post: [aa, ab, ac, ad],
        });
    }
    i += 2;
    let mut prog: ArrayVec<[u16; 4], 1280> = ArrayVec::default();
    while i < inp.len() {
        let (j, a) = aoc::read::uint::<u16>(inp, i);
        let (j, b) = aoc::read::uint::<u16>(inp, j + 1);
        let (j, c) = aoc::read::uint::<u16>(inp, j + 1);
        let (j, d) = aoc::read::uint::<u16>(inp, j + 1);
        prog.push([a, b, c, d]);
        i = j + 1;
    }
    let mut p1 = 0;
    for o in &out {
        if o.matches() >= 3 {
            p1 += 1;
        }
    }
    let mut opt: [u16; 16] = [u16::MAX; 16];
    for o in out {
        let inst = o.op[0] as usize;
        for i in 0..OPS.len() {
            let bit = 1 << i;
            if opt[inst] & bit == 0 {
                continue;
            }
            if !o.consistent(i) {
                opt[inst] ^= bit;
            }
        }
    }
    let mut done = 0;
    let mut finished = [false; 16];
    let mut op_map: [usize; 16] = [0; 16];
    while done != OPS.len() {
        done = 0;
        for inst in 0..OPS.len() {
            if finished[inst] {
                done += 1;
                continue;
            }
            if opt[inst].count_ones() == 1 {
                let bit = opt[inst];
                finished[inst] = true;
                op_map[inst] = bit.trailing_zeros() as usize;
                for other in 0..OPS.len() {
                    if other != inst {
                        opt[other] &= u16::MAX ^ bit;
                    }
                }
            }
        }
    }
    let mut r = [0u16; 4];
    for inst in &prog {
        let fun = OPS[op_map[inst[0] as usize]];
        fun(&mut r, inst[1], inst[2], inst[3]);
    }
    (p1, r[0] as usize)
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
        let inp = std::fs::read("../2018/16/input.txt").expect("read error");
        assert_eq!(parts(&inp), (544, 600));
        let inp = std::fs::read("../2018/16/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (509, 496));
    }
}
