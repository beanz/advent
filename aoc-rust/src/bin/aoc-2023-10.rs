#[derive(PartialEq)]
enum D {
    NORTH = 1,
    SOUTH = 2,
    EAST = 4,
    WEST = 8,
    NONE = 0,
}
use D::*;

fn parts(inp: &[u8]) -> (usize, usize) {
    let w = 1 + inp.iter().position(|&ch| ch == b'\n').unwrap();
    let s = inp.iter().position(|&ch| ch == b'S').unwrap();
    let mut from = {
        if s >= w && (dirs(inp[s - w]).0 == SOUTH || dirs(inp[s - w]).1 == SOUTH) {
            NORTH
        } else if s > 0 && (dirs(inp[s - 1]).0 == EAST || dirs(inp[s - 1]).1 == EAST) {
            WEST
        } else if s + w < inp.len() && (dirs(inp[s + w]).0 == NORTH || dirs(inp[s + w]).1 == NORTH)
        {
            SOUTH
        } else if s + 1 < inp.len() && (dirs(inp[s + 1]).0 == WEST || dirs(inp[s + 1]).1 == WEST) {
            EAST
        } else {
            unreachable!("invalid start?")
        }
    };
    let mut p = mov(s, w, &from);
    let mut p1 = 1;
    let mut area = shoelace(s as isize, p as isize, w as isize);
    loop {
        let step = {
            let ds = dirs(inp[p]);
            if ds.0 == opposite(from) {
                ds.1
            } else {
                ds.0
            }
        };
        let n = mov(p, w, &step);
        area += shoelace(p as isize, n as isize, w as isize);
        p = n;
        from = step;
        p1 += 1;
        if p == s {
            break;
        }
    }
    p1 /= 2;
    (p1, (area.abs() as usize) / 2 - p1 + 1)
}

fn shoelace(a: isize, b: isize, w: isize) -> isize {
    let (ax, ay) = (a / w, a % w);
    let (bx, by) = (b / w, b % w);
    (ax - bx) * (ay + by)
}

fn mov(i: usize, w: usize, d: &D) -> usize {
    match d {
        NORTH => i - w,
        EAST => i + 1,
        SOUTH => i + w,
        WEST => i - 1,
        NONE => unreachable!("invalid move"),
    }
}

fn opposite(d: D) -> D {
    match d {
        NORTH => SOUTH,
        SOUTH => NORTH,
        EAST => WEST,
        WEST => EAST,
        NONE => unreachable!("invalid opposite"),
    }
}

fn dirs(ch: u8) -> (D, D) {
    match ch {
        b'|' => (NORTH, SOUTH),
        b'-' => (EAST, WEST),
        b'L' => (NORTH, EAST),
        b'J' => (NORTH, WEST),
        b'7' => (SOUTH, WEST),
        b'F' => (SOUTH, EAST),
        b'.' => (NONE, NONE),
        b'\n' => (NONE, NONE),
        _ => unreachable!("invalid char"),
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
        let inp = std::fs::read("../2023/10/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (4, 1));
        let inp = std::fs::read("../2023/10/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (8, 1));
        let inp = std::fs::read("../2023/10/test3.txt").expect("read error");
        assert_eq!(parts(&inp), (23, 4));
        let inp = std::fs::read("../2023/10/test4.txt").expect("read error");
        assert_eq!(parts(&inp), (70, 8));
        let inp = std::fs::read("../2023/10/test5.txt").expect("read error");
        assert_eq!(parts(&inp), (80, 10));
        let inp = std::fs::read("../2023/10/input.txt").expect("read error");
        assert_eq!(parts(&inp), (7086, 317));
    }
}
