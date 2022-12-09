fn parts(inp: &[u8]) -> (usize, usize) {
    let p1 = part(inp, 4, 0);
    (p1, part(inp, 14, p1 - 4))
}
fn part(inp: &[u8], l: usize, o: usize) -> usize {
    let mut i = o;
    while i < inp.len() - l {
        let mut set = 0;
        for ch in inp.iter().skip(i).take(l) {
            let bit = 1 << (ch - b'a') as usize;
            if set & bit != 0 {
                //i = j;
                set = 0;
                break;
            }
            set |= bit;
        }
        if set != 0 {
            return i + l;
        }
        i += 1;
    }
    1
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
        let inp = std::fs::read("../2022/06/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (7, 19));
        let inp = std::fs::read("../2022/06/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1282, 3513));
    }
}
