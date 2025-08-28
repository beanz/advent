fn parts(inp: &[u8]) -> (u32, u32) {
    let p1 = part(inp, 4);
    (p1, part(inp, 14))
}
fn part(inp: &[u8], l: usize) -> u32 {
    let mut i: usize = 0;
    let mut n: u32 = 0;
    while i < l {
        n ^= 1 << (inp[i] & 0x1f) as u32;
        i += 1;
    }
    while i < inp.len() {
        n ^= 1 << (inp[i] & 0x1f) as u32;
        n ^= 1 << (inp[i - l] & 0x1f) as u32;
        i += 1;
        if n.count_ones() as usize == l {
            return i as u32;
        }
    }
    1
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
        let inp = std::fs::read("../2022/06/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (7, 19));
        let inp = std::fs::read("../2022/06/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1282, 3513));
    }
}
