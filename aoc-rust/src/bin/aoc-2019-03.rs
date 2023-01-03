use arrayvec::ArrayVec;

#[derive(Debug, Clone, Copy, Default)]
struct Line {
    x: i16,
    y: i16,
    d: i16,
    step: u32,
}

fn parts(inp: &[u8]) -> (u32, u32) {
    let mut hor = ArrayVec::<Line, 320>::new();
    let mut vrt = ArrayVec::<Line, 320>::new();
    let mut x = 0i16;
    let mut y = 0i16;
    let mut step = 0u32;
    let mut i = 0;
    loop {
        let (mut d, vert) = match inp[i] {
            b'U' => (-1, true),
            b'D' => (1, true),
            b'L' => (-1, false),
            b'R' => (1, false),
            _ => unreachable!("invalid direction"),
        };
        let (j, n) = aoc::read::uint::<i16>(inp, i + 1);
        i = j;
        d *= n;
        if vert {
            vrt.push(Line { x, y, d, step });
            y += d;
        } else {
            hor.push(Line { x, y, d, step });
            x += d;
        }
        step += n as u32;
        if inp[i] == b'\n' {
            break;
        }
        i += 1;
    }
    i += 1;
    let mut p1 = u32::MAX;
    let mut p2 = u32::MAX;
    (x, y, step) = (0, 0, 0);
    loop {
        let (mut d, vert) = match inp[i] {
            b'U' => (-1, true),
            b'D' => (1, true),
            b'L' => (-1, false),
            b'R' => (1, false),
            _ => unreachable!("invalid direction"),
        };
        let (j, n) = aoc::read::uint::<i16>(inp, i + 1);
        i = j;
        d *= n;
        if vert {
            for h in &hor {
                let (min_x, max_x) = (h.x.min(h.x + h.d), h.x.max(h.x + h.d));
                let (min_y, max_y) = (y.min(y + d), y.max(y + d));
                if min_x < x && x < max_x && min_y < h.y && h.y < max_y {
                    let md = x.abs() as u32 + h.y.abs() as u32;
                    if md < p1 {
                        p1 = md;
                    }
                    let st = step + y.abs_diff(h.y) as u32 + h.step + x.abs_diff(h.x) as u32;
                    if st < p2 {
                        p2 = st;
                    }
                }
            }
            y += d;
        } else {
            for v in &vrt {
                let (min_y, max_y) = (v.y.min(v.y + v.d), v.y.max(v.y + v.d));
                let (min_x, max_x) = (x.min(x + d), x.max(x + d));
                if min_y < y && y < max_y && min_x < v.x && v.x < max_x {
                    let md = v.x.abs() as u32 + y.abs() as u32;
                    if md < p1 {
                        p1 = md;
                    }
                    let st = step + x.abs_diff(v.x) as u32 + v.step + y.abs_diff(v.y) as u32;
                    if st < p2 {
                        p2 = st;
                    }
                }
            }
            x += d;
        }
        step += n as u32;
        if inp[i] == b'\n' {
            break;
        }
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
        let inp = std::fs::read("../2019/03/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (6, 30));
        let inp = std::fs::read("../2019/03/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (159, 610));
        let inp = std::fs::read("../2019/03/test3.txt").expect("read error");
        assert_eq!(parts(&inp), (135, 410));
        let inp = std::fs::read("../2019/03/input.txt").expect("read error");
        assert_eq!(parts(&inp), (225, 35194));
        let inp = std::fs::read("../2019/03/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (5319, 122514));
    }
}
