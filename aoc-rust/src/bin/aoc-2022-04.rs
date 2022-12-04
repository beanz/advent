fn parts(inp: &[u8]) -> (usize, usize) {
    let mut c1 = 0;
    let mut c2 = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, l0) = aoc::read::uint::<usize>(inp, i);
        let (j, h0) = aoc::read::uint::<usize>(inp, j + 1);
        let (j, l1) = aoc::read::uint::<usize>(inp, j + 1);
        let (j, h1) = aoc::read::uint::<usize>(inp, j + 1);
        c1 += usize::from((l0 >= l1 && h0 <= h1) || (l1 >= l0 && h1 <= h0));
        c2 += usize::from(!(l0 > h1 || l1 > h0));
        i = j + 1
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
