use heapless::Deque;
use heapless::FnvIndexMap;

const MAZE_MAX: usize = 128;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut w = 0;
    while inp[w] != b'\n' {
        w += 1;
    }
    let w1 = w + 1;
    let h = inp.len() / w1;
    //eprintln!("{}x{}", w, h);
    let mut maze: [u128; MAZE_MAX] = [u128::MAX; MAZE_MAX];
    let mut xbit = 1u128;
    for x in 0..w {
        for y in 0..h {
            let i = x + y * w1;
            if inp[i] != b'#' {
                maze[y] -= xbit;
            }
        }
        xbit <<= 1;
    }
    optimaze(inp, &mut maze, w, h);
    let start = id(b'A', b'A');
    let end = id(b'Z', b'Z');
    let (mut sx, mut sy) = (0, 0);
    let (mut ex, mut ey) = (0, 0);
    let mut id2pos = FnvIndexMap::<usize, (usize, usize), 128>::new();
    let mut portals = FnvIndexMap::<(usize, usize), (usize, usize, usize), 128>::new();
    let is_portal = |ch| b'A' <= ch && ch <= b'Z';
    let mut add_outer_portal =
        |id2pos: &mut FnvIndexMap<usize, (usize, usize), 128>, a: u8, b: u8, x: usize, y: usize| {
            //eprintln!(
            //    "found outer portal {}{} at {},{}",
            //    a as char, b as char, x, y,
            //);
            let name = id(a, b);
            if name == start {
                (sx, sy) = (x, y);
                return;
            }
            if name == end {
                (ex, ey) = (x, y);
                return;
            }
            id2pos.insert(name, (x, y)).expect("id map full");
        };
    for x in 0..w {
        let top = x;
        if is_portal(inp[top]) {
            maze[1] |= 1 << x;
            add_outer_portal(&mut id2pos, inp[top], inp[top + w1], x, 2);
        }
        let bottom = x + (h - 1) * w1;
        if is_portal(inp[bottom]) {
            maze[h - 2] |= 1 << x;
            add_outer_portal(&mut id2pos, inp[bottom - w1], inp[bottom], x, h - 3);
        }
    }
    for y in 0..h {
        let left = y * w1;
        if is_portal(inp[left]) {
            maze[y] |= 1 << 1;
            add_outer_portal(&mut id2pos, inp[left], inp[left + 1], 2, y);
        }
        let right = (w - 1) + y * w1;
        if is_portal(inp[right]) {
            maze[y] |= 1 << w - 2;
            add_outer_portal(&mut id2pos, inp[right - 1], inp[right], w - 3, y);
        }
    }
    let add_inner_portal =
        |portals: &mut FnvIndexMap<(usize, usize), (usize, usize, usize), 128>,
         id2pos: &mut FnvIndexMap<usize, (usize, usize), 128>,
         a: u8,
         b: u8,
         x: usize,
         y: usize| {
            //eprintln!(
            //    "found inner portal {}{} at {},{}",
            //    a as char, b as char, x, y,
            //);
            let name = id(a, b);
            let (px, py) = id2pos.get(&name).expect("outer portal");
            portals
                .insert((x, y), (*px, *py, 2))
                .expect("portals map full");
            portals
                .insert((*px, *py), (x, y, 0))
                .expect("portals map full");
        };

    for y in 3..h - 3 {
        for x in 3..w - 3 {
            let i = x + y * w1;
            if inp[i] != b'.' {
                continue;
            }
            if is_portal(inp[i + 1]) && is_portal(inp[i + 2]) {
                maze[y] |= 1 << (x + 1);
                add_inner_portal(&mut portals, &mut id2pos, inp[i + 1], inp[i + 2], x, y);
            } else if is_portal(inp[i - 1]) && is_portal(inp[i - 2]) {
                maze[y] |= 1 << (x - 1);
                add_inner_portal(&mut portals, &mut id2pos, inp[i - 2], inp[i - 1], x, y);
            } else if is_portal(inp[i - w1]) && is_portal(inp[i - w1 * 2]) {
                maze[y - 1] |= 1 << x;
                add_inner_portal(
                    &mut portals,
                    &mut id2pos,
                    inp[i - 2 * w1],
                    inp[i - w1],
                    x,
                    y,
                );
            } else if is_portal(inp[i + w1]) && is_portal(inp[i + w1 * 2]) {
                maze[y + 1] |= 1 << x;
                add_inner_portal(
                    &mut portals,
                    &mut id2pos,
                    inp[i + w1],
                    inp[i + 2 * w1],
                    x,
                    y,
                );
            }
        }
    }
    //let (sx, sy) = xy(start, w1);
    //eprintln!("start: {},{}", sx, sy);
    //eprintln!("end: {},{}", ex, ey);
    //dump(inp, &maze, w, h, |x, y| {
    //    if let Some(_p) = portals.get(&(x, y)) {
    //        Some('~')
    //    } else if (sx, sy) == (x, y) {
    //        Some('S')
    //    } else if (ex, ey) == (x, y) {
    //        Some('E')
    //    } else {
    //        None
    //    }
    //});
    let p1 = find(&maze, &portals, sx, sy, ex, ey, false);
    let p2 = find(&maze, &portals, sx, sy, ex, ey, true);
    (p1, p2)
}

#[derive(Debug, PartialEq, Eq)]
struct Search {
    x: usize,
    y: usize,
    z: usize,
    steps: usize,
}

impl Search {
    fn visit_key(&self) -> usize {
        ((((self.z & 0x7f) << 7) + self.x) << 7) + self.y
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
    maze: &[u128; MAZE_MAX],
    portals: &FnvIndexMap<(usize, usize), (usize, usize, usize), 128>,
    sx: usize,
    sy: usize,
    ex: usize,
    ey: usize,
    p2: bool,
) -> usize {
    //eprintln!("searching for {} keys from {},{}", num_keys, x, y);
    let mut visited: [bool; 2097152] = [false; 2097152];
    let mut todo = Deque::<Search, 8192>::new();
    todo.push_back(Search {
        x: sx,
        y: sy,
        z: 0,
        steps: 0,
    })
    .expect("heap full");
    while let Some(cur) = todo.pop_front() {
        if cur.x == ex && cur.y == ey && cur.z == 0 {
            return cur.steps;
        }
        let vkey = cur.visit_key();
        if visited[vkey] {
            continue;
        }
        visited[vkey] = true;
        if let Some(p) = portals.get(&(cur.x, cur.y)) {
            if !p2 || cur.z > 0 || p.2 == 2 {
                todo.push_back(Search {
                    x: p.0,
                    y: p.1,
                    z: if p2 { cur.z + p.2 - 1 } else { cur.z },
                    steps: cur.steps + 1,
                })
                .expect("todo full");
            }
        }
        for (ox, oy) in [(1, 0), (2, 1), (1, 2), (0, 1)] {
            let (nx, ny) = (cur.x + ox - 1, cur.y + oy - 1);
            if maze[ny] & (1 << nx) != 0 {
                continue;
            }
            todo.push_back(Search {
                x: nx,
                y: ny,
                z: cur.z,
                steps: cur.steps + 1,
            })
            .expect("todo full");
        }
    }
    0
}

fn neigh_wall_count(maze: &[u128; MAZE_MAX], xbit: u128, y: usize) -> usize {
    usize::from(maze[y - 1] & xbit != 0)
        + usize::from(maze[y + 1] & xbit != 0)
        + usize::from(maze[y] & (xbit >> 1) != 0)
        + usize::from(maze[y] & (xbit << 1) != 0)
}

fn optimaze(inp: &[u8], maze: &mut [u128; MAZE_MAX], w: usize, h: usize) {
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
fn dump<F>(inp: &[u8], maze: &[u128; MAZE_MAX], w: usize, h: usize, ff: F)
where
    F: Fn(usize, usize) -> Option<char>,
{
    let w1 = w + 1;
    for y in 0..h {
        let mut xbit = 1u128;
        for x in 0..w {
            if let Some(ch) = ff(x, y) {
                eprint!("{}", ch);
            } else if maze[y] & xbit == 0 {
                eprint!("{}", inp[x + y * w1] as char);
            } else {
                eprint!("#");
            }
            xbit <<= 1;
        }
        eprintln!();
    }
}

fn id(a: u8, b: u8) -> usize {
    (a - b'A') as usize * 26 + (b - b'A') as usize
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
        let inp = std::fs::read("../2019/20/test1a.txt").expect("read error");
        assert_eq!(parts(&inp), (23, 26));
        let inp = std::fs::read("../2019/20/test1b.txt").expect("read error");
        assert_eq!(parts(&inp), (58, 0));
        let inp = std::fs::read("../2019/20/test2a.txt").expect("read error");
        assert_eq!(parts(&inp), (77, 396));
        let inp = std::fs::read("../2019/20/input.txt").expect("read error");
        assert_eq!(parts(&inp), (482, 5912));
        let inp = std::fs::read("../2019/20/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (664, 7334));
        let inp = std::fs::read("../2019/20/input-dh.txt").expect("read error");
        assert_eq!(parts(&inp), (578, 6592));
    }
}
