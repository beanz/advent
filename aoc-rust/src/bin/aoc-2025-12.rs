fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1: usize = 0;
    let mut i: usize = 96;
    while i < inp.len() {
        let (j, w) = aoc::read::uint::<usize>(inp, i);
        let (j, h) = aoc::read::uint::<usize>(inp, j + 1);
        let a = w * h;
        i = j + 2;
        let mut b: usize = 0;
        for _ in 0..6 {
            let (j, n) = aoc::read::uint::<usize>(inp, i);
            b += n * 9;
            i = j + 1;
        }
        if a >= b {
            p1 += 1;
        }
    }
    (p1, 0)
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
        aoc::test::auto("../2025/12/", parts);
    }
}
