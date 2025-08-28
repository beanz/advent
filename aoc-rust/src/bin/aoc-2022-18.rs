use aoc::deque::Deque;
use arrayvec::ArrayVec;

macro_rules! read_uint {
    ($in:expr, $i:expr, $t:ty) => {{
        let mut n: $t = 0;
        while b'0' <= $in[$i] && $in[$i] <= b'9' {
            n = 10 * n + ($in[$i] & 0xf) as $t;
            $i += 1;
        }
        n += 2; // +1 to make min 1 but +2 so min-1 0 to avoid overflow
        n
    }};
}

type Pos = usize;

fn pos(x: u8, y: u8, z: u8) -> Pos {
    ((x as Pos) << 10) + ((y as Pos) << 5) + (z as Pos)
}

fn xyz(p: Pos) -> (u8, u8, u8) {
    ((p >> 10) as u8, ((p >> 5) & 0x1f) as u8, (p & 0x1f) as u8)
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut i = 0;
    let mut mx: u8 = 0;
    let mut my: u8 = 0;
    let mut mz: u8 = 0;
    let mut cubes: ArrayVec<Pos, 2560> = ArrayVec::default();
    while i < inp.len() {
        let x = read_uint!(inp, i, u8);
        i += 1;
        let y = read_uint!(inp, i, u8);
        i += 1;
        let z = read_uint!(inp, i, u8);
        i += 1;
        mx = x.max(mx);
        my = y.max(my);
        mz = z.max(mz);
        cubes.push(pos(x, y, z))
    }
    let mut p1 = 6 * cubes.len();
    let mut thing = [false; 32768];
    for i in 0..cubes.len() {
        thing[cubes[i]] = true;
        if thing[cubes[i] - 1024] {
            p1 -= 2
        }
        if thing[cubes[i] + 1024] {
            p1 -= 2
        }
        if thing[cubes[i] - 32] {
            p1 -= 2
        }
        if thing[cubes[i] + 32] {
            p1 -= 2
        }
        if thing[cubes[i] - 1] {
            p1 -= 2
        }
        if thing[cubes[i] + 1] {
            p1 -= 2
        }
    }
    let mut todo = Deque::<Pos, 768>::default();
    todo.push(pos(mx + 1, my + 1, mz + 1));
    let mut visit = [false; 32768];
    let mut p2 = 0;
    while let Some(cur) = todo.pop() {
        if thing[cur] || visit[cur] {
            continue;
        }
        visit[cur] = true;
        let (x, y, z) = xyz(cur);
        if thing[cur - 1024] {
            p2 += 1;
        } else if !visit[cur - 1024] && x > 1 {
            todo.push(cur - 1024);
        }
        if thing[cur + 1024] {
            p2 += 1;
        } else if !visit[cur + 1024] && x < mx {
            todo.push(cur + 1024);
        }
        if thing[cur - 32] {
            p2 += 1;
        } else if !visit[cur - 32] && y > 1 {
            todo.push(cur - 32);
        }
        if thing[cur + 32] {
            p2 += 1;
        } else if !visit[cur + 32] && y < my {
            todo.push(cur + 32);
        }
        if thing[cur - 1] {
            p2 += 1;
        } else if !visit[cur - 1] && z > 1 {
            todo.push(cur - 1);
        }
        if thing[cur + 1] {
            p2 += 1;
        } else if !visit[cur + 1] && z < mz {
            todo.push(cur + 1);
        }
    }
    (p1, p2)
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
        let inp = std::fs::read("../2022/18/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (64, 58));
        let inp = std::fs::read("../2022/18/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3498, 2008));
    }
}
