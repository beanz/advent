use ahash::RandomState;
use std::collections::HashSet;
use std::collections::VecDeque;

fn parts(inp: &[u8]) -> (usize, usize) {
    let basin = Basin::new(inp);
    basin.parts()
}

struct Basin<'a> {
    m: &'a [u8],
    w: usize,
    h: usize,
    sx: usize,
    sy: usize,
    snow: [[u32; 122]; 1000],
}

#[derive(Debug)]
struct Search {
    x: usize,
    y: usize,
    t: usize,
    start: bool,
    end: bool,
    k: usize,
}

impl Search {
    fn new(x: usize, y: usize, t: usize, start: bool, end: bool) -> Search {
        let mut k = t;
        k = (k << 7) + x;
        k = (k << 5) + y;
        k <<= 1;
        if start {
            k += 1;
        }
        k <<= 1;
        if end {
            k += 1;
        }
        Search {
            x,
            y,
            t,
            start,
            end,
            k,
        }
    }
}

const OFF: [(isize, isize); 5] = [(0, 0), (0, -1), (0, 1), (-1, 0), (1, 0)];
impl<'a> Basin<'a> {
    fn new(inp: &[u8]) -> Basin {
        let mut w = 0;
        let mut sx = 0;
        let sy = 0;
        for (i, ch) in inp.iter().enumerate() {
            if *ch == b'.' {
                sx = i;
            }
            if *ch == b'\n' {
                w = i;
                break;
            }
        }
        let h = inp.len() / (w + 1);
        let mut snow = [[0; 122]; 1000];
        for sy in 1..h - 1 {
            for sx in 1..w - 1 {
                let (ix, iy): (isize, isize) = match inp[sx + sy * (w + 1)] {
                    b'<' => (-1, 0),
                    b'>' => (1, 0),
                    b'^' => (0, -1),
                    b'v' => (0, 1),
                    _ => {
                        continue;
                    }
                };
                let (mut x, mut y) = (sx, sy);
                snow[0][x] |= 2 << y;
                for sn in snow.iter_mut().skip(1) {
                    (x, y) = ((x as isize + ix) as usize, (y as isize + iy) as usize);
                    if x == 0 {
                        x = w - 2;
                    }
                    if y == 0 {
                        y = h - 2;
                    }
                    if x == w - 1 {
                        x = 1;
                    }
                    if y == h - 1 {
                        y = 1;
                    }
                    sn[x] |= 2 << y;
                }
            }
        }
        Basin {
            m: inp,
            w,
            h,
            sx,
            sy,
            snow,
        }
    }
    fn parts(&self) -> (usize, usize) {
        let mut todo: VecDeque<Search> = VecDeque::new();
        todo.push_front(Search::new(self.sx, self.sy, 0, false, false));
        let (mut p1, mut p2) = (0, 0);
        let mut seen: HashSet<usize, RandomState> =
            HashSet::with_capacity_and_hasher(1200000, RandomState::new());
        while let Some(mut cur) = todo.pop_front() {
            if seen.contains(&cur.k) {
                continue;
            }
            seen.insert(cur.k);
            if cur.y == self.h - 1 {
                if cur.start && cur.end {
                    p2 = cur.t - 1;
                    break;
                }
                if p1 == 0 {
                    p1 = cur.t - 1;
                }
                cur.end = true;
                cur.k |= 1;
            } else if cur.y == 0 && cur.end {
                cur.start = true;
                cur.k |= 2;
            }
            for o in OFF {
                let (nx, ny) = ((cur.x as isize + o.0), (cur.y as isize + o.1));
                if !(0 <= nx && nx < self.w as isize && 0 <= ny && ny < self.h as isize) {
                    continue;
                }
                let (nx, ny) = (nx as usize, ny as usize);
                if self.wall(nx, ny) {
                    continue;
                }
                if self.snow(nx, ny, cur.t) {
                    continue;
                }
                todo.push_back(Search::new(nx, ny, cur.t + 1, cur.start, cur.end));
            }
        }
        (p1, p2)
    }
    fn wall(&self, x: usize, y: usize) -> bool {
        self.m[x + y * (self.w + 1)] == b'#'
    }
    fn snow(&self, x: usize, y: usize, t: usize) -> bool {
        if !(x > 0 && y > 0 && x < self.w - 1 && y < self.h - 1) {
            return false;
        }
        let r_bit = 2 << y;
        r_bit & self.snow[t][x] != 0
    }
    #[allow(dead_code)]
    fn pretty(&self, t: usize) {
        for y in 0..self.h {
            for x in 0..self.w {
                if self.snow(x, y, t) {
                    eprint!("{}", b'*' as char);
                    continue;
                }
                eprint!("{}", if self.wall(x, y) { "#" } else { "." });
            }
            eprintln!();
        }
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
        let inp = std::fs::read("../2022/24/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (18, 54));
        let inp = std::fs::read("../2022/24/input.txt").expect("read error");
        assert_eq!(parts(&inp), (314, 896));
    }
}
