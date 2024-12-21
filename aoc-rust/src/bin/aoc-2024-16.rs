use heapless::binary_heap::{BinaryHeap, Min};

const DX: [i32; 4] = [0, 1, 0, -1];
const DY: [i32; 4] = [-1, 0, 1, 0];

fn parts(inp: &[u8]) -> (usize, usize) {
    let w = inp.iter().position(|&ch| ch == b'\n').expect("no EOL");
    let h = inp.len() / (w + 1);
    let (sx, sy) = (1, (h - 2) as i32);
    let (tx, ty) = ((w - 2) as i32, 1);
    let mut todo: BinaryHeap<_, Min, 2048> = BinaryHeap::new();
    let mut seen = [false; 80000];
    let mut sd: [Option<usize>; 80000] = [None; 80000];
    let mut p1: Option<usize> = None;
    todo.push(Rec {
        x: sx,
        y: sy,
        dir: 1,
        cost: 0,
    })
    .expect("overflow");
    while let Some(cur) = todo.pop() {
        let k = cur.key();
        if sd[k].is_none() {
            sd[k] = Some(cur.cost);
        }
        if let Some(p1) = p1 {
            if cur.cost > p1 {
                continue;
            }
        } else {
            if cur.x == tx && cur.y == ty {
                p1 = Some(cur.cost);
            }
        }
        if seen[k] {
            continue;
        }
        seen[k] = true;
        let (nx, ny) = (cur.x + DX[cur.dir], cur.y + DY[cur.dir]);
        if inp[(nx as usize) + (ny as usize) * (w + 1)] != b'#' {
            todo.push(Rec {
                x: nx,
                y: ny,
                cost: cur.cost + 1,
                dir: cur.dir,
            })
            .expect("overflow");
        }
        todo.push(Rec {
            x: cur.x,
            y: cur.y,
            cost: cur.cost + 1000,
            dir: (cur.dir + 1) & 3,
        })
        .expect("overflow");
        todo.push(Rec {
            x: cur.x,
            y: cur.y,
            cost: cur.cost + 1000,
            dir: (cur.dir + 3) & 3,
        })
        .expect("overflow");
    }
    for d in 0..4 {
        todo.push(Rec {
            x: tx,
            y: ty,
            cost: 0,
            dir: d,
        })
        .expect("overflow");
    }
    let p1 = p1.unwrap();
    let mut seen = [false; 80000];
    let mut p2set: [bool; 80000] = [false; 80000];
    let mut p2 = 0;
    while let Some(cur) = todo.pop() {
        let k = cur.key();
        let cost = cur.cost + sd[k].unwrap_or(0);
        if cost > p1 {
            continue;
        }
        if cost == p1 {
            if !p2set[(k | 3) ^ 3] {
                p2 += 1;
                p2set[(k | 3) ^ 3] = true;
            }
        }
        if seen[k] {
            continue;
        }
        seen[k] = true;
        let (nx, ny) = (cur.x - DX[cur.dir], cur.y - DY[cur.dir]);
        if inp[(nx as usize) + (ny as usize) * (w + 1)] != b'#' {
            todo.push(Rec {
                x: nx,
                y: ny,
                cost: cur.cost + 1,
                dir: cur.dir,
            })
            .expect("overflow");
        }
        todo.push(Rec {
            x: cur.x,
            y: cur.y,
            cost: cur.cost + 1000,
            dir: (cur.dir + 1) & 3,
        })
        .expect("overflow");
        todo.push(Rec {
            x: cur.x,
            y: cur.y,
            cost: cur.cost + 1000,
            dir: (cur.dir + 3) & 3,
        })
        .expect("overflow");
    }
    (p1, p2)
}

#[derive(PartialEq, Hash, Clone, Debug)]
struct Rec {
    x: i32,
    y: i32,
    cost: usize,
    dir: usize,
}

impl Rec {
    fn key(&self) -> usize {
        ((self.x * 141 + self.y) << 2) as usize + self.dir
    }
}

impl Eq for Rec {}

use std::cmp::Ordering;
impl PartialOrd for Rec {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

impl Ord for Rec {
    fn cmp(&self, other: &Self) -> Ordering {
        self.cost.cmp(&other.cost)
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
        aoc::test::auto("../2024/16/", parts);
    }
}
