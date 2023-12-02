fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut p1, mut p2) = (0, 0);
    let mut i = 0;
    while i < inp.len() {
        let (mut mr, mut mg, mut mb) = (1, 1, 1);
        let (j, id) = aoc::read::uint::<usize>(inp, i + 5);
        i = j;
        while inp[i] != b'\n' {
            i += 2;
            let (j, n) = aoc::read::uint::<usize>(inp, i);
            i = j + 1;
            match inp[i] {
                b'r' => {
                    if mr < n {
                        mr = n
                    }
                    i += 3;
                }
                b'g' => {
                    if mg < n {
                        mg = n
                    }
                    i += 5;
                }
                b'b' => {
                    if mb < n {
                        mb = n
                    }
                    i += 4;
                }
                _ => unreachable!("invalid color"),
            }
        }
        if mr <= 12 && mg <= 13 && mb <= 14 {
            p1 += id;
        }
        p2 += mr * mg * mb;
        i += 1;
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
        let inp = std::fs::read("../2023/02/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (8, 2286));
        let inp = std::fs::read("../2023/02/input.txt").expect("read error");
        assert_eq!(parts(&inp), (2101, 58269));
    }
}
