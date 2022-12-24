use ahash::RandomState;
use std::collections::HashSet;
use std::collections::VecDeque;

fn parts(inp: &[u8]) -> (usize, usize) {
    let basin = Basin::new(inp);
    return basin.parts();
}

struct Basin<'a> {
    m: &'a [u8],
    w: usize,
    h: usize,
    sx: usize,
    sy: usize,
    snow_r_l: [u128; 27],
    snow_r_r: [u128; 27],
    snow_c_u: [u32; 122],
    snow_c_d: [u32; 122],
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
        for i in 0..inp.len() {
            if inp[i] == b'.' {
                sx = i;
            }
            if inp[i] == b'\n' {
                w = i;
                break;
            }
        }
        let h = inp.len() / (w + 1);
        let mut snow_r_l = [0; 27];
        let mut snow_r_r = [0; 27];
        let mut snow_c_u = [0; 122];
        let mut snow_c_d = [0; 122];
        let mut r_bit = 2;
        for y in 1..h - 1 {
            let mut c_bit = 2;
            for x in 1..w - 1 {
                match inp[x + y * (w + 1)] {
                    b'<' => snow_r_l[y] |= c_bit,
                    b'>' => snow_r_r[y] |= c_bit,
                    b'^' => snow_c_u[x] |= r_bit,
                    b'v' => snow_c_d[x] |= r_bit,
                    _ => {}
                };
                c_bit <<= 1;
            }
            r_bit <<= 1;
        }
        Basin {
            m: inp,
            w,
            h,
            sx,
            sy,
            snow_r_l,
            snow_r_r,
            snow_c_u,
            snow_c_d,
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
                if let Some(_) = self.snow(nx, ny, cur.t) {
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
    fn snow(&self, x: usize, y: usize, t: usize) -> Option<u8> {
        if !(x > 0 && y > 0 && x < self.w - 1 && y < self.h - 1) {
            return None;
        }
        let c_r_bit = 1 << (1 + ((x - 1 + t * (self.w - 3)) % (self.w - 2)));
        let c_l_bit = 1 << (1 + ((x - 1 + t) % (self.w - 2)));
        let r_u_bit = 1 << (1 + ((y - 1 + t) % (self.h - 2)));
        let r_d_bit = 1 << (1 + ((y - 1 + t * (self.h - 3)) % (self.h - 2)));
        match (
            c_r_bit & self.snow_r_r[y] != 0,
            c_l_bit & self.snow_r_l[y] != 0,
            r_u_bit & self.snow_c_u[x] != 0,
            r_d_bit & self.snow_c_d[x] != 0,
        ) {
            (true, false, false, false) => Some(b'>'),
            (false, true, false, false) => Some(b'<'),
            (false, false, true, false) => Some(b'^'),
            (false, false, false, true) => Some(b'v'),
            (false, false, false, false) => None,
            (_, _, _, _) => Some(b'*'),
        }
    }
    #[allow(dead_code)]
    fn pretty(&self, t: usize) {
        for y in 0..self.h {
            for x in 0..self.w {
                if let Some(snow) = self.snow(x, y, t) {
                    eprint!("{}", snow as char);
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
