fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut p1, mut p2) = (0, 0);
    let mut i = 0;
    while i < inp.len() {
        let mut w: Option<u32> = None;
        let mut col: [usize; 32] = [0; 32];
        let mut row: [usize; 32] = [0; 32];
        let (mut x, mut y) = (0, 0);
        while i < inp.len() {
            match inp[i] {
                b'\n' => {
                    if w.is_none() {
                        w = Some(x)
                    }
                    x = 0;
                    y += 1;
                    if i + 1 >= inp.len() || inp[i + 1] == b'\n' {
                        break;
                    }
                }
                b'#' => {
                    col[x as usize] |= 1 << y;
                    row[y as usize] |= 1 << x;
                    x += 1;
                }
                b'.' => x += 1,
                _ => unreachable!("invalid input"),
            }
            i += 1;
        }
        let w = w.unwrap() as usize;
        let h = y as usize;
        let mut s1: Option<usize> = None;
        let mut s2: Option<usize> = None;
        for i in 0..w - 1 {
            let l = if i < w - i - 1 { i + 1 } else { w - i - 1 };
            let mut c: usize = 0;
            for j in 0..l {
                c += (col[i - j] ^ col[i + j + 1]).count_ones() as usize;
            }
            if c == 0 && s1.is_none() {
                s1 = Some(i + 1);
            } else if c == 1 && s2.is_none() {
                s2 = Some(i + 1);
            }
            if s1.is_some() && s2.is_some() {
                break;
            }
        }
        for i in 0..h - 1 {
            let l = if i < h - i - 1 { i + 1 } else { h - i - 1 };
            let mut c: usize = 0;
            for j in 0..l {
                c += (row[i - j] ^ row[i + j + 1]).count_ones() as usize;
            }
            if c == 0 && s1.is_none() {
                s1 = Some(100 * (i + 1));
            } else if c == 1 && s2.is_none() {
                s2 = Some(100 * (i + 1));
            }
            if s1.is_some() && s2.is_some() {
                break;
            }
        }
        p1 += s1.expect("part 1 fail");
        p2 += s2.expect("part 2 fail");
        i += 2;
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
        let inp = std::fs::read("../2023/13/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (405, 400));
        let inp = std::fs::read("../2023/13/input.txt").expect("read error");
        assert_eq!(parts(&inp), (33520, 34824));
    }
}
