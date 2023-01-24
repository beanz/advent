use heapless::binary_heap::{BinaryHeap, Min};

const EXTRA: i32 = 32;

const ROCKY: i32 = 0;
const WET: i32 = 1;
const NARROW: i32 = 2;

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
enum Tool {
    Neither = 0,
    Torch = 1,
    Climbing = 2,
}

impl Into<usize> for Tool {
    fn into(self) -> usize {
        self as usize
    }
}
fn parts(inp: &[u8]) -> (usize, usize) {
    let (i, depth) = aoc::read::uint::<i32>(inp, 7);
    let (i, tx) = aoc::read::uint::<i32>(inp, i + 9);
    let (_, ty) = aoc::read::uint::<i32>(inp, i + 1);
    let w = tx + EXTRA;
    let h = ty + EXTRA;
    let mut m: [i32; 65536] = [0; 65536];
    for x in 1..w {
        m[x as usize] = (x * 16807 + depth) % 20183;
    }
    for y in 1..h {
        m[(y * w) as usize] = (y * 48271 + depth) % 20183;
    }
    for y in 1..h {
        for x in 1..w {
            let el = if x == tx && y == ty {
                0
            } else {
                let el1 = m[((x - 1) + y * w) as usize];
                let el2 = m[(x + (y - 1) * w) as usize];
                el1 * el2
            };
            m[(x + y * w) as usize] = (el + depth) % 20183;
        }
    }
    for y in 0..h {
        for x in 0..w {
            let i = (x + y * w) as usize;
            m[i] %= 3;
        }
    }
    let mut p1 = 0;
    for y in 0..=ty {
        for x in 0..=tx {
            let risk = m[(x + y * w) as usize];
            //eprint!(
            //    "{}",
            //    match risk {
            //        0 => '.',
            //        1 => '=',
            //        2 => '|',
            //        _ => unreachable!("invalid risk"),
            //    }
            //);
            p1 += risk;
        }
        //eprintln!();
    }
    let mut visited = [false; 65536 << 2];
    let mut todo: BinaryHeap<Search, Min, 8192> = BinaryHeap::new();
    todo.push(Search {
        x: 0,
        y: 0,
        tool: Tool::Torch,
        minutes: 0,
    })
    .expect("heap full");
    let mut p2 = 0;
    while let Some(mut cur) = todo.pop() {
        if cur.x == tx && cur.y == ty {
            if cur.tool != Tool::Torch {
                cur.minutes += 7
            }
            p2 = cur.minutes;
            break;
        }
        let vk = cur.visit_key();
        if visited[vk] {
            continue;
        }
        visited[vk] = true;
        for (ox, oy) in [(0, -1), (0, 1), (-1, 0), (1, 0)] {
            let (nx, ny) = (cur.x + ox, cur.y + oy);
            if nx < 0 || ny < 0 {
                continue;
            }
            if nx >= w || ny >= h {
                continue;
                //unreachable!("need bigger bounds");
            }
            match (m[(nx + ny * w) as usize], cur.tool) {
                (ROCKY, Tool::Neither) => continue,
                (WET, Tool::Torch) => continue,
                (NARROW, Tool::Climbing) => continue,
                _ => {}
            }
            todo.push(Search {
                x: nx,
                y: ny,
                minutes: cur.minutes + 1,
                tool: cur.tool,
            })
            .expect("todo full");
        }
        let alt_tool = match (m[(cur.x + cur.y * w) as usize], cur.tool) {
            (ROCKY, Tool::Climbing) => Tool::Torch,
            (ROCKY, Tool::Torch) => Tool::Climbing,
            (WET, Tool::Climbing) => Tool::Neither,
            (WET, Tool::Neither) => Tool::Climbing,
            (NARROW, Tool::Torch) => Tool::Neither,
            (NARROW, Tool::Neither) => Tool::Torch,
            _ => unreachable!("invalid terrain"),
        };
        todo.push(Search {
            x: cur.x,
            y: cur.y,
            minutes: cur.minutes + 7,
            tool: alt_tool,
        })
        .expect("todo full");
    }
    (p1 as usize, p2)
}

#[derive(Debug, PartialEq, Eq)]
struct Search {
    x: i32,
    y: i32,
    tool: Tool,
    minutes: usize,
}

impl Search {
    fn visit_key(&self) -> usize {
        ((((self.tool as usize) << 6) + self.x as usize) << 10) + self.y as usize
    }
}

impl PartialOrd for Search {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.minutes.cmp(&other.minutes))
    }
}
impl Ord for Search {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.minutes.cmp(&other.minutes)
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
        let inp = std::fs::read("../2018/22/test.txt").expect("read error");
        assert_eq!(parts(&inp), (114, 45));
        let inp = std::fs::read("../2018/22/input.txt").expect("read error");
        assert_eq!(parts(&inp), (10204, 1004));
        //let inp = std::fs::read("../2018/22/input-amf.txt").expect("read error");
        //assert_eq!(parts(&inp), (5637, 969));
    }
}
