fn rotate_cw(idx: isize, idy: isize, deg: usize) -> (isize, isize) {
    let mut dx = idx;
    let mut dy = idy;
    for _ in 0..deg / 90 {
        (dx, dy) = (-dy, dx)
    }
    (dx, dy)
}

fn rotate_ccw(idx: isize, idy: isize, deg: usize) -> (isize, isize) {
    let mut dx = idx;
    let mut dy = idy;
    for _ in 0..deg / 90 {
        (dx, dy) = (dy, -dx)
    }
    (dx, dy)
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut x, mut y, mut dx, mut dy): (isize, isize, isize, isize) = (0, 0, 1, 0);
    let (mut x2, mut y2, mut wx, mut wy): (isize, isize, isize, isize) = (0, 0, 10, -1);
    let mut n = 0;
    let mut cmd = 0u8;
    for ch in inp {
        match ch {
            b'0'..=b'9' => {
                n = n * 10 + (ch - b'0') as isize;
            }
            b'\n' => {
                (x, y, dx, dy, x2, y2, wx, wy) = match cmd {
                    b'N' => (x, y - n, dx, dy, x2, y2, wx, wy - n),
                    b'E' => (x + n, y, dx, dy, x2, y2, wx + n, wy),
                    b'S' => (x, y + n, dx, dy, x2, y2, wx, wy + n),
                    b'W' => (x - n, y, dx, dy, x2, y2, wx - n, wy),
                    b'F' => (
                        x + dx * n,
                        y + dy * n,
                        dx,
                        dy,
                        x2 + wx * n,
                        y2 + wy * n,
                        wx,
                        wy,
                    ),
                    b'R' => {
                        (dx, dy) = rotate_cw(dx, dy, n as usize);
                        (wx, wy) = rotate_cw(wx, wy, n as usize);
                        (x, y, dx, dy, x2, y2, wx, wy)
                    }
                    b'L' => {
                        (dx, dy) = rotate_ccw(dx, dy, n as usize);
                        (wx, wy) = rotate_ccw(wx, wy, n as usize);
                        (x, y, dx, dy, x2, y2, wx, wy)
                    }
                    _ => unreachable!("invalid cmd"),
                };
                //eprintln!("1: {},{} {},{}", x, y, dx, dy);
                //eprintln!("2: {},{} {},{}", x2, y2, wx, wy);
                n = 0;
            }
            _ => cmd = *ch,
        }
    }
    (
        x.unsigned_abs() + y.unsigned_abs(),
        x2.unsigned_abs() + y2.unsigned_abs(),
    )
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/12/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (25, 286));
        let inp = std::fs::read("../2020/12/input.txt").expect("read error");
        assert_eq!(parts(&inp), (759, 45763));
    }
}
