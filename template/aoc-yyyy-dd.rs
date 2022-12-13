fn parts(inp: &[u8]) -> (usize, usize) {
    (1, 2)
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
        let inp = std::fs::read("../YYYY/DD/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (10, 20));
        let inp = std::fs::read("../YYYY/DD/input.txt").expect("read error");
        assert_eq!(parts(&inp), (100, 200));
    }
}
