use heapless::{Deque, FnvIndexSet};

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut m = [b'.'; 1000000];
    let mut bb = Bounds::default();
    let mut i = 0;
    while i < inp.len() {
        let (j, a) = aoc::read::uint::<i32>(inp, i + 2);
        let (j, b) = aoc::read::uint::<i32>(inp, j + 4);
        let (j, c) = aoc::read::uint::<i32>(inp, j + 2);
        match inp[i] {
            b'x' => {
                let x = a;
                bb.add_x(x);
                for y in b..=c {
                    bb.add_y(y);
                    m[index(x, y)] = b'#';
                }
            }
            b'y' => {
                let y = a;
                bb.add_y(y);
                for x in b..=c {
                    bb.add_x(x);
                    m[index(x, y)] = b'#';
                }
            }
            _ => {}
        }
        i = j + 1;
    }
    bb.expand_x();
    let mut todo = Deque::<(i32, i32), 512>::new();
    todo.push_back((500, 0)).expect("todo full");
    let mut visited = FnvIndexSet::<(i32, i32), 512>::new();
    while let Some((cx, cy)) = todo.pop_front() {
        let mut y = cy + 1;
        while y <= bb.max_y {
            let i = index(cx, y);
            let sq = m[i];
            if sq == b'#' || sq == b'~' {
                y -= 1;
                let mut max_x = cx;
                let mut fill = b'~';
                'LEFT: for x in cx + 1..=bb.max_x {
                    let sq_below = m[index(x, y + 1)];
                    if sq_below == b'.' || sq_below == b'|' {
                        if visited.insert((x, y)).expect("visited full") {
                            todo.push_back((x, y)).expect("todo full");
                        }
                        max_x = x;
                        fill = b'|';
                        break 'LEFT;
                    }
                    if m[index(x, y)] == b'#' {
                        max_x = x - 1;
                        break 'LEFT;
                    }
                }
                let mut min_x = cx;
                let mut x = cx - 1;
                'RIGHT: while x >= bb.min_x {
                    let sq_below = m[index(x, y + 1)];
                    if sq_below == b'.' || sq_below == b'|' {
                        if visited.insert((x, y)).expect("visited full") {
                            todo.push_back((x, y)).expect("todo full");
                        }
                        min_x = x;
                        fill = b'|';
                        break 'RIGHT;
                    }
                    if m[index(x, y)] == b'#' {
                        min_x = x + 1;
                        break 'RIGHT;
                    }
                    x -= 1;
                }
                for x in min_x..=max_x {
                    m[index(x, y)] = fill;
                }
                y -= 1;
                if fill == b'|' {
                    break;
                }
            } else {
                m[index(cx, y)] = b'|';
            }
            y += 1;
        }
    }
    let mut c_water = 0;
    let mut c_still = 0;
    for y in bb.min_y..=bb.max_y {
        for x in bb.min_x..=bb.max_x {
            match m[index(x, y)] {
                b'~' => c_still += 1,
                b'|' => c_water += 1,
                _ => {}
            }
        }
    }
    (c_still + c_water, c_still)
}

#[derive(Debug)]
struct Bounds {
    min_x: i32,
    min_y: i32,
    max_x: i32,
    max_y: i32,
}

impl Default for Bounds {
    fn default() -> Self {
        Self {
            min_x: i32::MAX,
            min_y: i32::MAX,
            max_x: i32::MIN,
            max_y: i32::MIN,
        }
    }
}

impl Bounds {
    #[allow(dead_code)]
    fn add(&mut self, x: i32, y: i32) {
        self.add_x(x);
        self.add_y(y);
    }
    fn add_x(&mut self, x: i32) {
        if x < self.min_x {
            self.min_x = x;
        }
        if x > self.max_x {
            self.max_x = x;
        }
    }
    fn add_y(&mut self, y: i32) {
        if y < self.min_y {
            self.min_y = y;
        }
        if y > self.max_y {
            self.max_y = y;
        }
    }
    fn expand_x(&mut self) {
        self.min_x -= 1;
        self.max_x += 1;
    }
    #[allow(dead_code)]
    fn size(&self) -> i32 {
        (self.max_x - self.min_x) * (self.max_y - self.min_y)
    }
}

fn index(x: i32, y: i32) -> usize {
    (y as usize) * 500 + ((x - 250) as usize)
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
        let inp = std::fs::read("../2018/17/test.txt").expect("read error");
        assert_eq!(parts(&inp), (57, 29));
        let inp = std::fs::read("../2018/17/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (56, 29));
        let inp = std::fs::read("../2018/17/input.txt").expect("read error");
        assert_eq!(parts(&inp), (36790, 30765));
        let inp = std::fs::read("../2018/17/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (31471, 24169));
    }
}
