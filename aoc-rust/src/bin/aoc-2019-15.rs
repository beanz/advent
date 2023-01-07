use heapless::Deque;

const PROG_CAP: usize = 4096;
const WIDTH_ADDR: usize = 132;
const HEIGHT_ADDR: usize = 139;
const START_X_ADDR: usize = 1034;
const START_Y_ADDR: usize = 1035;
const OXY_X_ADDR: usize = 146;
const OXY_Y_ADDR: usize = 153;
const WALL_BASE_ADDR: usize = 252;
const WALL_CUTOFF_ADDR: usize = 212;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut prog: [isize; PROG_CAP] = [0; PROG_CAP];
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<isize>(inp, i);
        prog[l] = n;
        l += 1;
        i = j + 1;
    }

    let (sx, sy) = (prog[START_X_ADDR] as usize, prog[START_Y_ADDR] as usize);
    let (ox, oy) = (prog[OXY_X_ADDR] as usize, prog[OXY_Y_ADDR] as usize);
    let (w, h) = (prog[WIDTH_ADDR] as usize, prog[HEIGHT_ADDR] as usize);
    //eprintln!("{}x{}", w, h);
    //eprintln!("start: {},{}", sx, sy);
    //eprintln!("end: {},{}", ox, oy);

    let mut visited = [false; 1640];
    let mut todo = Deque::<_, 2048>::new();
    todo.push_back((sx, sy, 0usize)).expect("todo list full");
    let mut p1 = 0;
    while let Some((x, y, st)) = todo.pop_front() {
        let vi = x + y * w;
        if visited[vi] {
            continue;
        }
        visited[vi] = true;
        if x == ox && y == oy {
            p1 = st;
            break;
        }
        if !visited[vi - w] && !is_wall(&prog, x, y - 1) {
            todo.push_back((x, y - 2, st + 2)).expect("todo list full");
        }
        if !visited[vi + w] && !is_wall(&prog, x, y + 1) {
            todo.push_back((x, y + 2, st + 2)).expect("todo list full");
        }
        if !visited[vi - 1] && !is_wall(&prog, x - 1, y) {
            todo.push_back((x - 2, y, st + 2)).expect("todo list full");
        }
        if !visited[vi + 1] && !is_wall(&prog, x + 1, y) {
            todo.push_back((x + 2, y, st + 2)).expect("todo list full");
        }
    }

    let mut visited = [false; 1640];
    let mut todo = Deque::<_, 2048>::new();
    todo.push_back((ox, oy, 0usize)).expect("todo list full");
    let mut p2 = 0;
    while let Some((x, y, st)) = todo.pop_front() {
        let vi = x + y * w;
        if visited[vi] {
            continue;
        }
        visited[vi] = true;
        if st > p2 {
            p2 = st;
        }
        if !visited[vi - w] && !is_wall(&prog, x, y - 1) {
            todo.push_back((x, y - 2, st + 2)).expect("todo list full");
        }
        if !visited[vi + w] && !is_wall(&prog, x, y + 1) {
            todo.push_back((x, y + 2, st + 2)).expect("todo list full");
        }
        if !visited[vi - 1] && !is_wall(&prog, x - 1, y) {
            todo.push_back((x - 2, y, st + 2)).expect("todo list full");
        }
        if !visited[vi + 1] && !is_wall(&prog, x + 1, y) {
            todo.push_back((x + 2, y, st + 2)).expect("todo list full");
        }
    }

    (p1, p2)
}

fn is_wall(prog: &[isize; PROG_CAP], x: usize, y: usize) -> bool {
    if x == 0 || y == 0 || x == prog[WIDTH_ADDR] as usize || y == prog[HEIGHT_ADDR] as usize {
        return true;
    }
    let mx = x % 2;
    let my = y % 2;
    if mx == 0 && my == 0 {
        return true;
    }
    if mx == 1 && my == 1 {
        return false;
    }
    let wy = (y - 1 + my) / 2;
    let wi = WALL_BASE_ADDR + wy * 39 + x - 1;
    prog[wi] >= prog[WALL_CUTOFF_ADDR]
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 1: {}", p2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/15/input.txt").expect("read error");
        assert_eq!(parts(&inp), (308, 328));
        let inp = std::fs::read("../2019/15/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (252, 350));
    }
}
