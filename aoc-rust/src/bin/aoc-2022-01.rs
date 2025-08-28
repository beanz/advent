fn parts(inp: &[u8]) -> (usize, usize) {
    let mut s0 = 0;
    let mut s1 = 0;
    let mut s2 = 0;
    let mut max = 0;
    let mut s = 0;
    let mut n = 0;
    let mut eol = false;
    let mut add = |s| {
        let mut s = s;
        if s > max {
            max = s;
        }
        if s > s0 {
            (s, s0) = (s0, s)
        }
        if s > s1 {
            (s, s1) = (s1, s)
        }
        if s > s2 {
            s2 = s
        }
    };
    for ch in inp {
        match ch {
            b'\n' => {
                if eol {
                    add(s);
                    s = 0;
                    eol = false;
                } else {
                    s += n;
                    n = 0;
                    eol = true;
                }
            }
            _ => {
                eol = false;
                n = 10 * n + (ch&0xf) as usize;
            }
        }
    }
    if eol {
        add(s);
    }
    (max, s0 + s1 + s2)
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
        let inp = std::fs::read("../2022/01/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (24000, 45000));
        let inp = std::fs::read("../2022/01/input.txt").expect("read error");
        assert_eq!(parts(&inp), (66487, 197301));
    }
}
