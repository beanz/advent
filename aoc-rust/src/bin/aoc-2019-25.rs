const PROG_CAP: usize = 5120;
#[allow(dead_code)]
const ITEM_TABLE: usize = 4601;
#[allow(dead_code)]
const ROOM_LIST: usize = 3124;
const ITEM_DATA: usize = 1902;
const CUTOFF_A: usize = 1352;
const CUTOFF_B: usize = 2486;

fn part(inp: &[u8]) -> usize {
    let mut prog: [isize; PROG_CAP] = [0; PROG_CAP];
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<isize>(inp, i);
        prog[l] = n;
        l += 1;
        i = j + 1;
    }
    let cutoff = prog[CUTOFF_A] * prog[CUTOFF_B];
    let mut bit = 1 << 31;
    let mut res = 0usize;
    for i in 0..32 {
        if prog[ITEM_DATA + i] >= cutoff {
            res |= bit;
        }
        bit >>= 1;
    }

    res
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let p1 = part(&inp);
        if !bench {
            println!("Part 1: {p1}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/25/input.txt").expect("read error");
        assert_eq!(part(&inp), 136839232);
        let inp = std::fs::read("../2019/25/input-amf.txt").expect("read error");
        assert_eq!(part(&inp), 352325632);
    }
}
