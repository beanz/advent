use arrayvec::ArrayVec;
use heapless::FnvIndexSet;

const INST_LEN: usize = 4;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut prog: ArrayVec<[usize; INST_LEN], 64> = ArrayVec::default();
    let mut i = 0;
    let mut _ip_reg = 0;
    while i < inp.len() {
        if inp[i] == b'#' {
            let (j, n) = aoc::read::uint::<usize>(inp, i + 4);
            _ip_reg = n;
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
        let (j, a) = aoc::read::uint::<usize>(inp, i + 5);
        let (j, b) = aoc::read::uint::<usize>(inp, j + 1);
        let (j, c) = aoc::read::uint::<usize>(inp, j + 1);
        prog.push([inst, a, b, c]);
        i = j + 1;
    }
    let mask = prog[10][2];
    let a = prog[7][1];
    let b = prog[11][2];
    let bxb = (b * b) & mask;
    let bxbxb = (bxb * b) & mask;
    let mut last_reg5;
    let mut reg5 = 0;
    let mut p1 = 0;
    let mut seen = FnvIndexSet::<usize, 16384>::new();
    loop {
        last_reg5 = reg5;
        reg5 = (((reg5 >> 16) | 1) * b + ((reg5 >> 8) & 255) * bxb + ((reg5 & 255) + a) * bxbxb)
            & mask;
        if seen.is_empty() {
            p1 = reg5;
        }
        if !seen.insert(reg5).expect("seen full") {
            return (p1, last_reg5);
        }
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
        let inp = std::fs::read("../2018/21/input.txt").expect("read error");
        assert_eq!(parts(&inp), (12446070, 13928239));
        let inp = std::fs::read("../2018/21/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (13270004, 12879142));
    }
}
