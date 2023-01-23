use arrayvec::ArrayVec;

const NUM_REG: usize = 6;
const INST_LEN: usize = 4;

fn addr(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = r[a as usize] + r[b as usize];
}

fn addi(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = r[a as usize] + b;
}

fn mulr(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = r[a as usize] * r[b as usize];
}

fn muli(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = r[a as usize] * b;
}

fn banr(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = r[a as usize] & r[b as usize];
}

fn bani(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = r[a as usize] & b;
}

fn borr(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = r[a as usize] | r[b as usize];
}

fn bori(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = r[a as usize] | b;
}

fn setr(r: &mut [u32; NUM_REG], a: u32, _b: u32, c: u32) {
    r[c as usize] = r[a as usize]
}

fn seti(r: &mut [u32; NUM_REG], a: u32, _b: u32, c: u32) {
    r[c as usize] = a
}

fn gtir(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = (a > r[b as usize]).into();
}
fn gtri(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = (r[a as usize] > b).into();
}
fn gtrr(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = (r[a as usize] > r[b as usize]).into();
}

fn eqir(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = (a == r[b as usize]).into();
}
fn eqri(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = (r[a as usize] == b).into();
}
fn eqrr(r: &mut [u32; NUM_REG], a: u32, b: u32, c: u32) {
    r[c as usize] = (r[a as usize] == r[b as usize]).into();
}

const OPS: &[for<'a> fn(&'a mut [u32; NUM_REG], u32, u32, u32); 16] = &[
    addr, addi, mulr, muli, banr, bani, borr, bori, setr, seti, gtir, gtri, gtrr, eqir, eqri, eqrr,
];

fn parts(inp: &[u8]) -> (u32, u32) {
    let mut prog: ArrayVec<[u32; INST_LEN], 64> = ArrayVec::default();
    let mut i = 0;
    let mut ip_reg = 0;
    while i < inp.len() {
        if inp[i] == b'#' {
            let (j, n) = aoc::read::uint::<u32>(inp, i + 4);
            ip_reg = n as usize;
            i = j + 1;
            continue;
        }
        #[rustfmt::skip]
        let inst = match &[inp[i], inp[i+1], inp[i+2], inp[i+3]] {
            b"addr" => 0, b"addi" => 1, b"mulr" => 2, b"muli" => 3,
            b"banr" => 4, b"bani" => 5, b"borr" => 6, b"bori" => 7,
            b"setr" => 8, b"seti" => 9,
            b"gtir" => 10, b"gtri" => 11, b"gtrr" => 12,
            b"eqir" => 13, b"eqri" => 14, b"eqrr" => 15,
            _ => unreachable!("invalid instruction"),
        };
        let (j, a) = aoc::read::uint::<u32>(inp, i + 5);
        let (j, b) = aoc::read::uint::<u32>(inp, j + 1);
        let (j, c) = aoc::read::uint::<u32>(inp, j + 1);
        prog.push([inst, a, b, c]);
        i = j + 1;
    }
    let mut r = [0u32; NUM_REG];
    let mut ip = 0;
    let mut c = 0;
    while ip < prog.len() && c < 100000000 {
        let inst = prog[ip];
        let fun = OPS[inst[0] as usize];
        r[ip_reg] = ip as u32;
        fun(&mut r, inst[1], inst[2], inst[3]);
        if inst[3] as usize == ip_reg {
            ip = r[ip_reg] as usize;
        }
        ip += 1;
        c += 1;
    }
    let p1 = r[0];
    let mut r = [1, 0, 0, 0, 0, 0];
    let mut ip = 0;
    let mut c = 0;
    while ip < prog.len() && c < 1000 {
        let inst = prog[ip];
        let fun = OPS[inst[0] as usize];
        r[ip_reg] = ip as u32;
        fun(&mut r, inst[1], inst[2], inst[3]);
        if inst[3] as usize == ip_reg {
            ip = r[ip_reg] as usize;
        }
        ip += 1;
        c += 1;
    }
    let mut p2 = 0;
    for factor in 1..=r[4] {
        if r[4] % factor == 0 {
            p2 += factor;
        }
    }
    (p1, p2)
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
        let inp = std::fs::read("../2018/19/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1764, 18992484));
        let inp = std::fs::read("../2018/19/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (948, 10695960));
    }
}
