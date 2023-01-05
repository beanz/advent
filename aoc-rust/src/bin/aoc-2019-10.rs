use std::f64::consts::TAU;

use arrayvec::ArrayVec;
use num::integer::gcd;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut points: ArrayVec<(i8, i8), 512> = ArrayVec::default();
    let mut map: [u64; 40] = [0; 40];
    let mut y = 0;
    let mut x = 0;
    for ch in inp {
        match ch {
            b'\n' => {
                y += 1;
                x = 0
            }
            b'#' => {
                points.push((x, y));
                map[y as usize] |= 1 << x;
                x += 1;
            }
            b'.' => {
                x += 1;
            }
            _ => unreachable!("invalid input"),
        }
    }
    let mut vc: [usize; 512] = [0; 512];
    let mut max = 0;
    let mut max_i = 0;
    for i in 0..points.len() {
        for j in i + 1..points.len() {
            if visible(&map, points[i], points[j]) {
                vc[i] += 1;
                if vc[i] > max {
                    max = vc[i];
                    max_i = i;
                }
                vc[j] += 1;
                if vc[j] > max {
                    max = vc[j];
                    max_i = j;
                }
            }
        }
    }
    let mut angles: ArrayVec<((i8, i8), f64), 512> = ArrayVec::default();
    let best = points[max_i];
    for (i, other) in points.iter().enumerate() {
        if i == max_i {
            continue;
        }
        let mut a = angle(best, *other);
        a += num_blockers(&map, best, *other) as f64 * TAU;
        angles.push((*other, a));
    }
    angles.select_nth_unstable_by(200 - 1, |(_, a), (_, b)| a.partial_cmp(b).unwrap());
    let ((x, y), _) = angles[200 - 1];
    (max, x as usize * 100 + y as usize)
}

fn angle((x1, y1): (i8, i8), (x2, y2): (i8, i8)) -> f64 {
    let mut a = ((x2 - x1) as f64).atan2((y1 - y2) as f64);
    if a < 0f64 {
        a += TAU
    }
    a
}

fn num_blockers(map: &[u64; 40], (x1, y1): (i8, i8), (x2, y2): (i8, i8)) -> usize {
    let mut dx = x2 - x1;
    let mut dy = y2 - y1;
    if dx != 0 || dy != 0 {
        let d = gcd(dx, dy);
        dx /= d;
        dy /= d;
    }
    let mut x = x1 + dx;
    let mut y = y1 + dy;
    let mut res = 0;
    while x != x2 || y != y2 {
        if map[y as usize] & (1 << x) != 0 {
            res += 1;
        }
        x += dx;
        y += dy;
    }
    res
}

fn visible(map: &[u64; 40], (x1, y1): (i8, i8), (x2, y2): (i8, i8)) -> bool {
    let mut dx = x2 - x1;
    let mut dy = y2 - y1;
    if dx != 0 || dy != 0 {
        let d = gcd(dx, dy);
        dx /= d;
        dy /= d;
    }
    let mut x = x1 + dx;
    let mut y = y1 + dy;
    while x != x2 || y != y2 {
        if map[y as usize] & (1 << x) != 0 {
            return false;
        }
        x += dx;
        y += dy;
    }
    true
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
        let inp = std::fs::read("../2019/10/test1e.txt").expect("read error");
        assert_eq!(parts(&inp), (210, 802));
        let inp = std::fs::read("../2019/10/input.txt").expect("read error");
        assert_eq!(parts(&inp), (278, 1417));
        let inp = std::fs::read("../2019/10/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (221, 806));
    }
}
