fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::uint::<usize>(inp, i);
        p1 += fuel(n);
        p2 += fuelr(n);
        i = j + 1;
    }
    (p1, p2)
}

fn fuel(n: usize) -> usize {
    let f = n / 3;
    if f <= 2 {
        0
    } else {
        f - 2
    }
}

fn fuelr(n: usize) -> usize {
    let mut s = 0;
    let mut n = n;
    while n > 0 {
        n = fuel(n);
        s += n;
    }
    s
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
        let inp = std::fs::read("../2019/01/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (34241, 51316));
        let inp = std::fs::read("../2019/01/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3363033, 5041680));
        let inp = std::fs::read("../2019/01/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (3367126, 5047796));
    }
}
