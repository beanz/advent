fn parts(inp: &[u8]) -> (usize, usize) {
    let w = inp.iter().position(|&ch| ch == b'\n').unwrap() as i32;
    let h = inp.len() as i32 / (w + 1);
    (solve(inp, w, h, 1, 3), solve(inp, w, h, 4, 10))
}

fn solve(inp: &[u8], w: i32, h: i32, min_d: i32, max_d: i32) -> usize {
    let mut todo = Queue::new();
    let (tx, ty) = (w - 1, h - 1);
    let mut seen: [bool; 80000] = [false; 80000];
    let add = |todo: &mut Queue, x: i32, y: i32, d: Dir, loss: i32| {
        let (mut x, mut y, mut loss) = (x, y, loss);
        for s in 1..=max_d {
            x += d.x();
            y += d.y();
            if x < 0 || x > tx || y < 0 || y > ty {
                return;
            }
            loss += (inp[(x + y * (w + 1)) as usize] - b'0') as i32;
            if s < min_d {
                continue;
            }
            let nr = Rec {
                x,
                y,
                d: d.clone(),
                loss,
            };
            todo.insert(nr);
        }
    };
    add(&mut todo, 0, 0, Dir::Right, 0);
    while let Some(cur) = todo.next() {
        if cur.x == tx && cur.y == ty {
            return cur.loss as usize;
        }
        let k = (((cur.x + cur.y * w) as usize) << 2) + (cur.d.clone() as usize);
        if seen[k] {
            continue;
        }
        seen[k] = true;
        add(&mut todo, cur.x, cur.y, cur.d.cw(), cur.loss);
        add(&mut todo, cur.x, cur.y, cur.d.ccw(), cur.loss);
    }
    1
}

#[derive(Debug, Clone, Hash, PartialEq)]
enum Dir {
    Up = 0,
    Right = 1,
    Down = 2,
    Left = 3,
}

impl Dir {
    fn x(&self) -> i32 {
        match &self {
            Dir::Up => 0,
            Dir::Right => 1,
            Dir::Down => 0,
            Dir::Left => -1,
        }
    }
    fn y(&self) -> i32 {
        match &self {
            Dir::Up => -1,
            Dir::Right => 0,
            Dir::Down => 1,
            Dir::Left => 0,
        }
    }
    fn cw(&self) -> Dir {
        match &self {
            Dir::Up => Dir::Right,
            Dir::Right => Dir::Down,
            Dir::Down => Dir::Left,
            Dir::Left => Dir::Up,
        }
    }
    fn ccw(&self) -> Dir {
        match &self {
            Dir::Up => Dir::Left,
            Dir::Right => Dir::Up,
            Dir::Down => Dir::Right,
            Dir::Left => Dir::Down,
        }
    }
}

#[derive(Debug, Clone, Hash, PartialEq)]
struct Rec {
    x: i32,
    y: i32,
    loss: i32,
    d: Dir,
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
        self.loss.cmp(&other.loss)
    }
}

use priority_queue::PriorityQueue;
use std::cmp::Reverse;

#[derive(Debug)]
struct Queue {
    pq: PriorityQueue<Rec, Reverse<Rec>>,
}

impl Queue {
    fn new() -> Queue {
        Queue {
            pq: PriorityQueue::new(),
        }
    }
    fn next(&mut self) -> Option<Rec> {
        self.pq.pop().map(|(b, _)| b)
    }
    fn insert(&mut self, b: Rec) {
        self.pq.push(b.clone(), Reverse(b));
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
        let inp = std::fs::read("../2023/17/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (102, 94));
        let inp = std::fs::read("../2023/17/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (59, 71));
        let inp = std::fs::read("../2023/17/input.txt").expect("read error");
        assert_eq!(parts(&inp), (967, 1101));
    }
}
