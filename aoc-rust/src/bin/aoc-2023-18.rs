fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut p1a, mut p1p): (isize, isize) = (0, 0);
    let (mut p2a, mut p2p): (isize, isize) = (0, 0);
    let (mut x1, mut y1): (isize, isize) = (0, 0);
    let (mut x2, mut y2): (isize, isize) = (0, 0);
    let mut i: usize = 0;
    while i < inp.len() {
        let (mut ox, mut oy) = oxoy(inp[i]);
        let (j, mut n) = aoc::read::uint(inp, i + 2);
        i = j + 3;
        let (mut nx, mut ny) = (x1 + ox * n, y1 + oy * n);
        p1a += (x1 - nx) * (y1 + ny);
        p1p += n;
        (x1, y1) = (nx, ny);
        (ox, oy) = oxoy(inp[i + 5]);
        n = hex(&inp[i..i + 5]);
        (nx, ny) = (x2 + ox * n, y2 + oy * n);
        p2a += (x2 - nx) * (y2 + ny);
        p2p += n;
        (x2, y2) = (nx, ny);
        i += 8;
    }
    (
        ((p1a.abs() + p1p + 2) / 2) as usize,
        ((p2a.abs() + p2p + 2) / 2) as usize,
    )
}

fn hex(inp: &[u8]) -> isize {
    let mut n: isize = 0;
    for ch in inp {
        let d = match ch {
            b'a'..=b'f' => 10 + ch - b'a',
            _ => ch - b'0',
        };
        n = 16 * n + (d as isize);
    }
    n
}

fn oxoy(ch: u8) -> (isize, isize) {
    match ch {
        b'R' => (1, 0),
        b'0' => (1, 0),
        b'D' => (0, 1),
        b'1' => (0, 1),
        b'L' => (-1, 0),
        b'2' => (-1, 0),
        _ => (0, -1),
    }
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
        let inp = std::fs::read("../2023/18/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (62, 952408144115));
        let inp = std::fs::read("../2023/18/input.txt").expect("read error");
        assert_eq!(parts(&inp), (45159, 134549294799713));
    }
}
