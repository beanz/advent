use ahash::RandomState;
use std::collections::HashSet;

fn parts(inp: &[u8]) -> (usize, usize) {
    let w = inp.iter().position(|&ch| ch == b'\n').unwrap() as i16;
    let w1 = w + 1;
    let h = inp.len() as i16 / w1;
    let s = inp.iter().position(|&ch| ch == b'S').unwrap() as i16;
    let (sx, sy) = (s % w1, s / w1);
    let mut rp: HashSet<(i16, i16), RandomState> =
        HashSet::with_capacity_and_hasher(100000, RandomState::new());
    let mut np: HashSet<(i16, i16), RandomState> =
        HashSet::with_capacity_and_hasher(100000, RandomState::new());
    rp.insert((sx, sy));
    let mut visit: HashSet<(i16, i16), RandomState> =
        HashSet::with_capacity_and_hasher(100000, RandomState::new());
    let (mut c1, mut c2): (usize, usize) = (0, 0);
    let mut p1 = 0;
    let ch_at_1 = |x: i16, y: i16| -> u8 {
        if 0 <= x && x < w && 0 <= y && y < h {
            return inp[(x + y * w1) as usize];
        }
        b'#'
    };

    for _step in 1..=64 {
        for (x, y) in rp.iter() {
            if ch_at_1(x - 1, *y) != b'#' && !visit.contains(&(x - 1, *y)) {
                visit.insert((x - 1, *y));
                np.insert((x - 1, *y));
            }
            if ch_at_1(x + 1, *y) != b'#' && !visit.contains(&(x + 1, *y)) {
                visit.insert((x + 1, *y));
                np.insert((x + 1, *y));
            }
            if ch_at_1(*x, y - 1) != b'#' && !visit.contains(&(*x, y - 1)) {
                visit.insert((*x, y - 1));
                np.insert((*x, y - 1));
            }
            if ch_at_1(*x, y + 1) != b'#' && !visit.contains(&(*x, y + 1)) {
                visit.insert((*x, y + 1));
                np.insert((*x, y + 1));
            }
        }
        (np, rp) = (rp, np);
        np.clear();
        p1 = c2 + rp.len();
        (c1, c2) = (p1, c1);
    }
    rp.clear();
    rp.insert((sx, sy));
    visit.clear();
    (c1, c2) = (0, 0);

    let target = 26501365;
    let md = target % (w as usize);
    let mut seen: [isize; 3] = [0; 3];
    let mut si = 0;

    let ch_at_2 =
        |x: i16, y: i16| -> u8 { inp[(x.rem_euclid(w) + (y.rem_euclid(h)) * w1) as usize] };

    for step in 1..=1000 {
        for (x, y) in rp.iter() {
            if ch_at_2(x - 1, *y) != b'#' && !visit.contains(&(x - 1, *y)) {
                visit.insert((x - 1, *y));
                np.insert((x - 1, *y));
            }
            if ch_at_2(x + 1, *y) != b'#' && !visit.contains(&(x + 1, *y)) {
                visit.insert((x + 1, *y));
                np.insert((x + 1, *y));
            }
            if ch_at_2(*x, y - 1) != b'#' && !visit.contains(&(*x, y - 1)) {
                visit.insert((*x, y - 1));
                np.insert((*x, y - 1));
            }
            if ch_at_2(*x, y + 1) != b'#' && !visit.contains(&(*x, y + 1)) {
                visit.insert((*x, y + 1));
                np.insert((*x, y + 1));
            }
        }
        (np, rp) = (rp, np);
        np.clear();
        let c = c2 + rp.len();
        (c1, c2) = (c, c1);
        if (step % (w as usize)) == md {
            seen[si] = c as isize;
            si += 1;
            if si == 3 {
                break;
            }
        }
    }
    let x = 1 + (target as isize) / (w as isize);
    let a = ((seen[2] - seen[1]) - (seen[1] - seen[0])) / 2;
    let b = (seen[1] - seen[0]) - 3 * a;
    let p2 = (a * x * x + b * x + seen[0] - b - a) as usize;

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
        let inp = std::fs::read("../2023/21/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (42, 533997411669553));
        let inp = std::fs::read("../2023/21/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3841, 636391426712747));
    }
}
