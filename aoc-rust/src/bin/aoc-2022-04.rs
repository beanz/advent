macro_rules! read_uint {
    ($in:expr, $i:expr, $t:ty) => {{
        let mut n: $t = 0;
        while b'0' <= $in[$i] && $in[$i] <= b'9' {
            n = 10 * n + ($in[$i] & 0xf) as $t;
            $i += 1;
        }
        n
    }};
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut c1 = 0;
    let mut c2 = 0;
    let mut i = 0;
    while i < inp.len() {
        let l0 = read_uint!(inp, i, usize);
        i += 1;
        let h0 = read_uint!(inp, i, usize);
        i += 1;
        let l1 = read_uint!(inp, i, usize);
        i += 1;
        let h1 = read_uint!(inp, i, usize);
        i += 1;
        c1 += usize::from((l0 >= l1 && h0 <= h1) || (l1 >= l0 && h1 <= h0));
        c2 += usize::from(!(l0 > h1 || l1 > h0));
    }
    (c1, c2)
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
        let inp = std::fs::read("../2022/04/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (2, 4));
        let inp = std::fs::read("../2022/04/input.txt").expect("read error");
        assert_eq!(parts(&inp), (584, 933));
    }
}
