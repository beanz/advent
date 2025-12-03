fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, s) = aoc::read::uint::<usize>(inp, i);
        let (j, e) = aoc::read::uint::<usize>(inp, j + 1);
        for n in s..=e {
            let l = n.ilog10() + 1;
            if l & 1 == 0 {
                let m = 10_usize.pow(l / 2);
                let first = n / m;
                if n == first + first * m {
                    p1 += n;
                    p2 += n;
                    continue;
                }
            }
            let mut j = 3;
            while (j <= l) {
                if l % j != 0 {
                    j += 2;
                    continue;
                }
                let m = 10_usize.pow(l / j);
                let d = 10_usize.pow(l - l / j);
                let first = n / d;
                let mut c = 0;
                for _ in 0..j {
                    c *= m;
                    c += first;
                }
                if n == c {
                    p2 += c;
                }
                j += 2;
            }
        }
        i = j + 1;
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
        aoc::test::auto("../2025/02/", parts);
    }
}
