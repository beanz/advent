fn parts(inp: &[u8]) -> (usize, usize) {
    (part(inp, 4), part(inp, 14))
}
fn part(inp: &[u8], l: usize) -> usize {
    for i in 0..inp.len() - l {
        let mut ok = true;
        'Loop: for j in i..i + l {
            for k in j + 1..i + l {
                if inp[j] == inp[k] {
                    ok = false;
                    break 'Loop;
                }
            }
        }
        if ok {
            return i + l;
        }
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
