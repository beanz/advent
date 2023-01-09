use std::collections::HashSet;

use ahash::RandomState;
use heapless::binary_heap::{BinaryHeap, Min};

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut w = 0;
    while inp[w] != b'\n' {
        w += 1;
    }
    let w1 = w + 1;
    let hw = w / 2;
    let h = inp.len() / w1;
    let hh = h / 2;
    //eprintln!("{}x{}", w, h);
    let mut start = 0;
    let mut quad_keys = [0usize; 5];
    for (i, ch) in inp.iter().enumerate() {
        let (x, y) = xy(i, w1);
        let qi = (x / hw) + 2 * (y / hh);
        match ch {
            b'@' => start = i,
            b'a'..=b'z' => {
                let bit = 1 << (ch - b'a');
                quad_keys[qi] |= bit;
            }
            _ => {}
        }
    }
    quad_keys[4] = quad_keys[0] | quad_keys[1] | quad_keys[2] | quad_keys[3];
    let (sx, sy) = xy(start, w1);
    //eprintln!("{},{}", sx, sy);
    //eprintln!(" keys={:026b}", quad_keys[4]);
    //for i in 0..4 {
    //    eprintln!("   q{}={:026b}", i, quad_keys[i]);
    //}
    let mut maze: [u128; 81] = [u128::MAX; 81];
    let mut xbit = 2u128;
    for x in 1..w - 1 {
        for y in 1..h - 1 {
            let i = x + y * w1;
            if inp[i] != b'#' {
                maze[y] -= xbit;
            }
        }
        xbit <<= 1;
    }
    optimaze(inp, &mut maze, w, h);
    //dump(inp, &maze, w, h);
    let p1 = find(inp, &maze, 4, quad_keys[4], sx, sy, w1);
    let sxbit = 1 << sx;
    maze[sy] |= (sxbit << 1) | (sxbit >> 1);
    maze[sy - 1] |= sxbit;
    maze[sy + 1] |= sxbit;
    //dump(inp, &maze, w, h);
    let mut p2 = 0;
    for qi in 0..4 {
        p2 += find(inp, &maze, qi, quad_keys[qi], sx, sy, w1);
    }
    (p1, p2)
}

#[derive(Debug, PartialEq, Eq)]
struct Search {
    x: usize,
    y: usize,
    steps: usize,
    remaining: usize,
    keys: usize,
}

impl Search {
    fn visit_key(&self) -> usize {
        (((self.keys << 7) + self.x) << 7) + self.y
    }
}

impl PartialOrd for Search {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.steps.cmp(&other.steps))
    }
}
impl Ord for Search {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.steps.cmp(&other.steps)
    }
}

fn find(
    inp: &[u8],
    maze: &[u128; 81],
    quad: usize,
    quad_keys: usize,
    sx: usize,
    sy: usize,
    w1: usize,
) -> usize {
    let num_keys = quad_keys.count_ones() as usize;
    let (x, y) = match quad {
        0 => (sx - 1, sy - 1),
        1 => (sx + 1, sy - 1),
        2 => (sx - 1, sy + 1),
        3 => (sx + 1, sy + 1),
        4 => (sx, sy),
        _ => unreachable!("not implemented"),
    };
    //eprintln!("searching for {} keys from {},{}", num_keys, x, y);
    let mut visited: HashSet<usize, RandomState> =
        HashSet::with_capacity_and_hasher(1200000, RandomState::new());
    let mut todo: BinaryHeap<Search, Min, 8192> = BinaryHeap::new();
    todo.push(Search {
        x,
        y,
        steps: 0,
        remaining: num_keys,
        keys: 0,
    })
    .expect("heap full");
    while let Some(mut cur) = todo.pop() {
        let ch = inp[cur.x + cur.y * w1];
        if b'A' <= ch && ch <= b'Z' {
            let kbit = 1 << (ch - b'A');
            if cur.keys & kbit == 0 && quad_keys & kbit != 0 {
                //eprintln!("  blocked by door {}", ch as char);
                continue;
            }
        } else if b'a' <= ch && ch <= b'z' {
            let kbit = 1 << (ch - b'a');
            if cur.keys & kbit == 0 {
                //eprintln!("  found key {}", ch as char);
                cur.keys |= kbit;
                cur.remaining -= 1;
                if cur.remaining == 0 {
                    //eprintln!("found all keys in {} steps", cur.steps);
                    return cur.steps;
                }
            }
        }
        let vkey = cur.visit_key();
        if visited.contains(&vkey) {
            continue;
        }
        visited.insert(vkey);
        for (ox, oy) in [(1, 0), (2, 1), (1, 2), (0, 1)] {
            let (nx, ny) = (cur.x + ox - 1, cur.y + oy - 1);
            if maze[ny] & (1 << nx) != 0 {
                continue;
            }
            todo.push(Search {
                x: nx,
                y: ny,
                steps: cur.steps + 1,
                remaining: cur.remaining,
                keys: cur.keys,
            })
            .expect("todo full");
        }
    }
    0
}

fn neigh_wall_count(maze: &[u128; 81], xbit: u128, y: usize) -> usize {
    usize::from(maze[y - 1] & xbit != 0)
        + usize::from(maze[y + 1] & xbit != 0)
        + usize::from(maze[y] & (xbit >> 1) != 0)
        + usize::from(maze[y] & (xbit << 1) != 0)
}

fn optimaze(inp: &[u8], maze: &mut [u128; 81], w: usize, h: usize) {
    let w1 = w + 1;
    loop {
        let mut changes = false;
        let mut xbit = 2u128;
        for x in 1..w - 1 {
            for y in 1..h - 1 {
                let i = x + y * w1;
                if inp[i] != b'.' || maze[y] & xbit != 0 {
                    continue;
                }
                if neigh_wall_count(maze, xbit, y) > 2 {
                    changes = true;
                    maze[y] |= xbit;
                }
            }
            xbit <<= 1;
        }
        if !changes {
            return;
        }
    }
}

#[allow(dead_code)]
fn dump(inp: &[u8], maze: &[u128; 81], w: usize, h: usize) {
    let w1 = w + 1;
    for y in 0..h {
        let mut xbit = 1u128;
        for x in 0..w {
            if maze[y] & xbit == 0 {
                eprint!("{}", inp[x + y * w1] as char);
            } else {
                eprint!("#");
            }
            xbit <<= 1;
        }
        eprintln!();
    }
}

fn xy(i: usize, w1: usize) -> (usize, usize) {
    (i % w1, i / w1)
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
        let inp = std::fs::read("../2019/18/test2a.txt").expect("read error");
        assert_eq!(parts(&inp), (26, 8));
        let inp = std::fs::read("../2019/18/test2b.txt").expect("read error");
        assert_eq!(parts(&inp), (50, 24));
        let inp = std::fs::read("../2019/18/test2d.txt").expect("read error");
        assert_eq!(parts(&inp), (114, 70));
        let inp = std::fs::read("../2019/18/input.txt").expect("read error");
        assert_eq!(parts(&inp), (4406, 1964));
        let inp = std::fs::read("../2019/18/input2.txt").expect("read error");
        assert_eq!(parts(&inp), (3048, 1732));
        let inp = std::fs::read("../2019/18/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (6162, 1556));
    }
}
