fn parts(inp: &[u8]) -> (usize, usize) {
    let mut v1 = Visit::<16384>::new(); // 512*2*512*2/64
    let mut v2 = Visit::<16384>::new();
    let mut t: [Point; 10] = [Point::default(); 10];
    let mut i = 0;
    while i < inp.len() {
        let ch = inp[i];
        let (j, n) = aoc::read::uint::<usize>(inp, i + 2);
        i = j;
        let inc = match ch {
            b'L' => Point { x: -1, y: 0 },
            b'R' => Point { x: 1, y: 0 },
            b'U' => Point { x: 0, y: -1 },
            b'D' => Point { x: 0, y: 1 },
            _ => unreachable!(),
        };
        for _j in 0..n {
            t[0].x += inc.x;
            t[0].y += inc.y;
            for k in 1..t.len() {
                let dragged = t[k].mov(t[k - 1].x, t[k - 1].y);
                if !dragged {
                    break;
                }
            }
            let (i, bit) = t[1].index();
            v1.visit(i, bit);
            let (i, bit) = t[9].index();
            v2.visit(i, bit);
        }
        i += 1;
    }
    (v1.len(), v2.len())
}

#[derive(Clone, Copy, Default)]
struct Point {
    x: isize,
    y: isize,
}

impl Point {
    fn mov(&mut self, hx: isize, hy: isize) -> bool {
        let dx = hx - self.x;
        let dy = hy - self.y;
        if (-1..=1).contains(&dx) && (-1..=1).contains(&dy) {
            return false;
        }
        match 0.cmp(&dx) {
            std::cmp::Ordering::Greater => self.x -= 1,
            std::cmp::Ordering::Less => self.x += 1,
            _ => {}
        }
        match 0.cmp(&dy) {
            std::cmp::Ordering::Greater => self.y -= 1,
            std::cmp::Ordering::Less => self.y += 1,
            _ => {}
        }
        true
    }
    fn index(&self) -> (usize, u64) {
        let i = (self.x + 512) + (self.y + 512) * 1024;
        let b = (i as usize) >> 6;
        let bit = 1 << (i & 0x3f);
        (b, bit)
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

struct Visit<const N: usize> {
    set: [u64; N],
    len: usize,
}

impl<const N: usize> Visit<{ N }> {
    fn new() -> Visit<{ N }> {
        Visit {
            set: [0; N],
            len: 0,
        }
    }
    fn visit(&mut self, i: usize, bit: u64) {
        if self.set[i] & bit != 0 {
            return;
        }
        self.set[i] |= bit;
        self.len += 1;
    }
    fn len(&self) -> usize {
        self.len
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/09/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (13, 1));
        let inp = std::fs::read("../2022/09/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (88, 36));
        let inp = std::fs::read("../2022/09/input.txt").expect("read error");
        assert_eq!(parts(&inp), (5513, 2427));
    }
}
