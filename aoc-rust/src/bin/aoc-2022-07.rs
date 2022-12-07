macro_rules! next_line {
    ($in:expr, $i:expr) => {{
        while $in[$i] != b'\n' {
            $i += 1;
        }
        $i += 1;
    }};
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut t = 0;
    let mut n = 0;
    for ch in inp {
        match ch {
            b'0'..=b'9' => {
                n = 10 * n + (ch & 0xf) as usize;
            }
            _ => {
                t += n;
                n = 0;
            }
        }
    }
    let mut p1 = 0;
    let mut min = 70000000;
    let need = 30000000 - (min - t);
    let mut i = 0;
    next_line!(inp, i);
    let _ = size(inp, i, need, &mut min, &mut p1);
    (p1, min)
}

fn size(inp: &[u8], i: usize, n: usize, m: &mut usize, p1: &mut usize) -> (usize, usize) {
    let mut c = 0;
    let mut i = i;
    while i < inp.len() {
        if b'0' <= inp[i] && inp[i] <= b'9' {
            let (j, n) = aoc::read::uint::<usize>(inp, i);
            i = j + 1;
            c += n;
        } else if inp[i + 5] == b'.' {
            i += 8;
            return (i, c);
        } else if inp[i + 2] == b'c' {
            // no single digit sizes so we don't need to check '$'
            i += 6;
            next_line!(inp, i);
            let (j, s) = size(inp, i, n, m, p1);
            if s < 100000 {
                *p1 += s;
            } else if s < *m && s > n {
                *m = s;
            }
            c += s;
            i = j;
            continue;
        }
        next_line!(inp, i);
    }
    (i, c)
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
        let inp = std::fs::read("../2022/07/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (95437, 24933642));
        let inp = std::fs::read("../2022/07/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1432936, 272298));
    }
}
