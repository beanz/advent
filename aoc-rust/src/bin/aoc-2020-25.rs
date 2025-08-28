fn part1(inp: &[u8]) -> usize {
    let (i, card) = aoc::read::uint::<u64>(inp, 0);
    let (_, door) = aoc::read::uint::<u64>(inp, i + 1);
    let ls = loop_size(card);
    exp_mod(door, ls, 20201227) as usize
}

fn loop_size(t: u64) -> u64 {
    let mut p = 1u64;
    let s = 7u64;
    let mut l = 0u64;
    while p != t {
        p = (p * s) % 20201227;
        l += 1;
    }
    l
}

fn exp_mod(b: u64, e: u64, m: u64) -> u64 {
    let mut b = b;
    let mut e = e;
    let mut c: u64 = 1;
    while e > 0 {
        if (e % 2) == 1 {
            c = (c * b) % m;
        }
        b = (b * b) % m;
        e >>= 1;
    }
    c
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let p1 = part1(&inp);
        if !bench {
            println!("Part 1: {p1}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part1_works() {
        let inp = std::fs::read("../2020/25/test1.txt").expect("read error");
        assert_eq!(part1(&inp), 14897079);
        let inp = std::fs::read("../2020/25/input.txt").expect("read error");
        assert_eq!(part1(&inp), 9714832);
        let inp = std::fs::read("../2020/25/input-amf.txt").expect("read error");
        assert_eq!(part1(&inp), 354320);
    }
}
