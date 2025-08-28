fn parts(inp: &[u8]) -> (usize, usize) {
    let w1 = aoc::read::skip_next_line(inp, 0);
    let h = inp.len() / w1;
    let w = w1 - 1;
    //eprintln!("{}x{}", w, h);
    let mut map = [b'.'; 512 * 512];
    let (cx, cy) = (w / 2, h / 2);
    for y in 0..h {
        for x in 0..w {
            map[(256 - cx + x) + (256 - cy + y) * 512] = inp[x + y * w1];
        }
    }
    let (mut x, mut y) = (256i32, 256i32);
    let (mut dx, mut dy) = (0i32, -1i32);
    let num = if w == 3 { 70 } else { 10000 };
    let mut p1 = 0;
    //pretty(&map, x, y);
    for _i in 0..num {
        let i = (x + y * 512) as usize;
        match map[i] {
            b'#' => {
                (dx, dy) = (-dy, dx);
                map[i] = b'.';
            }
            b'.' => {
                (dx, dy) = (dy, -dx);
                map[i] = b'#';
                p1 += 1;
            }
            _ => unreachable!("invalid map char"),
        }
        x += dx;
        y += dy;
        //pretty(&map, x, y);
    }
    let mut map = [b'.'; 512 * 512];
    let (cx, cy) = (w / 2, h / 2);
    for y in 0..h {
        for x in 0..w {
            map[(256 - cx + x) + (256 - cy + y) * 512] = inp[x + y * w1];
        }
    }
    let (mut x, mut y) = (256i32, 256i32);
    let (mut dx, mut dy) = (0i32, -1i32);
    let mut p2 = 0;
    //pretty(&map, x, y);
    for _i in 0..10000000 {
        let i = (x + y * 512) as usize;
        match map[i] {
            b'W' => {
                map[i] = b'#';
                p2 += 1;
            }
            b'#' => {
                (dx, dy) = (-dy, dx);
                map[i] = b'F';
            }
            b'F' => {
                (dx, dy) = (-dx, -dy);
                map[i] = b'.';
            }
            b'.' => {
                (dx, dy) = (dy, -dx);
                map[i] = b'W';
            }
            _ => unreachable!("invalid map char"),
        }
        x += dx;
        y += dy;
        //pretty(&map, x, y);
    }
    (p1, p2)
}

#[allow(dead_code)]
fn pretty(map: &[u8; 512 * 512], px: i32, py: i32) {
    for x in px - 6..px + 6 {
        for y in py - 6..py + 6 {
            let i = (x + y * 512) as usize;
            if x == px && y == py {
                eprint!("\x1b[31m{}\x1b[37m", map[i] as char);
            } else {
                eprint!("{}", map[i] as char);
            }
        }
        eprintln!();
    }
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
        let inp = std::fs::read("../2017/22/test.txt").expect("read error");
        assert_eq!(parts(&inp), (41, 2511944));
        let inp = std::fs::read("../2017/22/input.txt").expect("read error");
        assert_eq!(parts(&inp), (5240, 2512144));
        let inp = std::fs::read("../2017/22/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (5352, 2511475));
    }
}
