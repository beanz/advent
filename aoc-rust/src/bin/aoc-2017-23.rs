fn parts(inp: &[u8]) -> (usize, usize) {
    let (_, n) = aoc::read::uint::<usize>(inp, 6);
    let mut p2 = 0;
    let mut b = n * 100 + 100000;
    let c = b + 17000;
    while b <= c {
        if b % 2 == 0 {
            p2 += 1;
            b += 17;
            continue;
        }
        let mut d = 3;
        while d * d < b {
            if b % d == 0 {
                p2 += 1;
                break;
            }
            d += 2;
        }
        b += 17;
    }
    ((n - 2) * (n - 2), p2)
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
        let inp = std::fs::read("../2017/23/input.txt").expect("read error");
        assert_eq!(parts(&inp), (9409, 913));
        let inp = std::fs::read("../2017/23/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (5929, 907));
    }
}
