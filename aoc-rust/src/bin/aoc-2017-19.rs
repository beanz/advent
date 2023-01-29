fn parts(inp: &[u8]) -> ([u8; 26], usize, usize) {
    let mut x = 0;
    while inp[x] != b'|' {
        x += 1;
    }
    let w1 = aoc::read::skip_next_line(inp, x + 1);
    let h = inp.len() / w1;
    let w = w1 - 1;
    //eprintln!("{}x{}", w, h);
    let mut p1 = [0; 26];
    let mut p1l = 0;
    let mut x: isize = x as isize;
    let mut y: isize = 0;
    let (mut ox, mut oy) = (0, 1);
    let map = |x, y| {
        let i = x as usize + y as usize * w1;
        if x < w as isize && y < h as isize {
            inp[i]
        } else {
            b' '
        }
    };
    let mut p2 = 0;
    loop {
        let ch = map(x, y);
        match ch {
            b'A'..=b'Z' => {
                p1[p1l] = ch;
                p1l += 1;
            }
            b'|' | b'-' => {}
            b'+' => {
                (ox, oy) = match (ox, oy) {
                    (0, 1) | (0, -1) => {
                        if map(x - 1, y) != b' ' {
                            (-1, 0)
                        } else {
                            (1, 0)
                        }
                    }
                    (1, 0) | (-1, 0) => {
                        if map(x, y - 1) != b' ' {
                            (0, -1)
                        } else {
                            (0, 1)
                        }
                    }
                    _ => unreachable!("invalid direction"),
                };
            }
            b' ' => break,
            _ => unreachable!("invalid input char"),
        }
        x += ox;
        y += oy;
        p2 += 1;
    }
    (p1, p1l, p2)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p1l, p2) = parts(&inp);
        if !bench {
            println!(
                "Part 1: {}",
                std::str::from_utf8(&p1[0..p1l]).expect("ascii")
            );
            println!("Part 2: {}", p2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2017/19/test.txt").expect("read error");
        let (p1, p1l, p2) = parts(&inp);
        assert_eq!(
            (std::str::from_utf8(&p1[0..p1l]).expect("ascii"), p2),
            ("ABCDEF", 38)
        );
        let inp = std::fs::read("../2017/19/input.txt").expect("read error");
        let (p1, p1l, p2) = parts(&inp);
        assert_eq!(
            (std::str::from_utf8(&p1[0..p1l]).expect("ascii"), p2),
            ("XYFDJNRCQA", 17450)
        );
        let inp = std::fs::read("../2017/19/input-amf.txt").expect("read error");
        let (p1, p1l, p2) = parts(&inp);
        assert_eq!(
            (std::str::from_utf8(&p1[0..p1l]).expect("ascii"), p2),
            ("QPRYCIOLU", 16162)
        );
    }
}
