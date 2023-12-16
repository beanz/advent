#[derive(Clone, Copy)]
enum D {
    UP = 1,
    RIGHT = 2,
    DOWN = 4,
    LEFT = 8,
}
use smallvec::SmallVec;
use D::*;

fn solve(inp: &[u8], w: usize, h: usize, x: usize, y: usize, d: D) -> usize {
    let mut seen: [u8; 14000] = [0; 14000];
    let mut todo = SmallVec::<[(usize, usize, D); 128]>::new();
    todo.push((x, y, d));
    while let Some(cur) = todo.pop() {
        let i = cur.0 + (w + 1) * cur.1;
        if seen[i] & (cur.2 as u8) != 0 {
            continue;
        }
        seen[i] |= cur.2 as u8;
        match (inp[i], cur.2) {
            (b'.', UP) if cur.1 > 0 => {
                todo.push((cur.0, cur.1 - 1, cur.2));
            }
            (b'.', DOWN) if cur.1 + 1 < h => {
                todo.push((cur.0, cur.1 + 1, cur.2));
            }
            (b'.', LEFT) if cur.0 > 0 => {
                todo.push((cur.0 - 1, cur.1, cur.2));
            }
            (b'.', RIGHT) if cur.0 + 1 < w => {
                todo.push((cur.0 + 1, cur.1, cur.2));
            }
            (b'-', LEFT) if cur.0 > 0 => {
                todo.push((cur.0 - 1, cur.1, cur.2));
            }
            (b'-', RIGHT) if cur.0 + 1 < w - 1 => {
                todo.push((cur.0 + 1, cur.1, cur.2));
            }
            (b'-', _) => {
                if cur.0 > 0 {
                    todo.push((cur.0 - 1, cur.1, LEFT));
                }
                if cur.0 + 1 < w {
                    todo.push((cur.0 + 1, cur.1, RIGHT));
                }
            }
            (b'|', UP) if cur.1 > 0 => {
                todo.push((cur.0, cur.1 - 1, cur.2));
            }
            (b'|', DOWN) if cur.1 + 1 < h => {
                todo.push((cur.0, cur.1 + 1, cur.2));
            }
            (b'|', _) => {
                if cur.1 > 0 {
                    todo.push((cur.0, cur.1 - 1, UP));
                }
                if cur.1 + 1 < h {
                    todo.push((cur.0, cur.1 + 1, DOWN));
                }
            }
            (b'/', UP) if cur.0 + 1 < w => {
                todo.push((cur.0 + 1, cur.1, RIGHT));
            }
            (b'/', DOWN) if cur.0 > 0 => {
                todo.push((cur.0 - 1, cur.1, LEFT));
            }
            (b'/', LEFT) if cur.1 + 1 < h => {
                todo.push((cur.0, cur.1 + 1, DOWN));
            }
            (b'/', RIGHT) if cur.1 > 0 => {
                todo.push((cur.0, cur.1 - 1, UP));
            }
            (b'\\', DOWN) if cur.0 + 1 < w => {
                todo.push((cur.0 + 1, cur.1, RIGHT));
            }
            (b'\\', UP) if cur.0 > 0 => {
                todo.push((cur.0 - 1, cur.1, LEFT));
            }
            (b'\\', RIGHT) if cur.1 + 1 < h => {
                todo.push((cur.0, cur.1 + 1, DOWN));
            }
            (b'\\', LEFT) if cur.1 > 0 => {
                todo.push((cur.0, cur.1 - 1, UP));
            }
            _ => {}
        }
    }

    let mut c = 0;
    for e in seen {
        if e != 0 {
            c += 1;
        }
    }
    return c;
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let w = inp.iter().position(|&ch| ch == b'\n').unwrap();
    let h = inp.len() / (w + 1);
    let p1 = solve(inp, w, h, 0, 0, RIGHT);
    let mut p2 = 0;
    for x in 0..w {
        let s = solve(inp, w, h, x, 0, DOWN);
        if s > p2 {
            p2 = s
        }
        let s = solve(inp, w, h, x, h - 1, UP);
        if s > p2 {
            p2 = s
        }
    }
    for y in 0..h {
        let s = solve(inp, w, h, 0, y, RIGHT);
        if s > p2 {
            p2 = s
        }
        let s = solve(inp, w, h, w - 1, y, LEFT);
        if s > p2 {
            p2 = s
        }
    }
    (p1, p2)
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
        let inp = std::fs::read("../2023/16/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (46, 51));
        let inp = std::fs::read("../2023/16/input.txt").expect("read error");
        assert_eq!(parts(&inp), (7111, 7831));
    }
}
