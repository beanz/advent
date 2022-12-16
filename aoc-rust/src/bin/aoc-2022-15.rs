use std::collections::HashSet;

#[derive(Debug, Copy, Clone, Default)]
struct Sensor {
    x: isize,
    y: isize,
    bx: isize,
    by: isize,
    md: isize,
}

#[derive(Debug, PartialEq, Clone, Eq, Ord)]
struct Span {
    s: isize,
    e: isize,
}

impl PartialOrd for Span {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        return Some(self.s.cmp(&other.s));
    }
}

fn spans_of_row(sensors: &[Sensor], y: isize) -> Vec<Span> {
    let mut res = vec![];
    for sensor in sensors {
        let d = sensor.md - (sensor.y - y).abs();
        if d < 0 {
            continue;
        }
        res.push(Span {
            s: sensor.x - d,
            e: sensor.x + d + 1,
        })
    }
    res.sort();
    let mut j = 0;
    let mut i = 1;
    while i < res.len() {
        if res[i].s <= res[j].e {
            if res[i].e > res[j].e {
                res[j].e = res[i].e
            }
            i += 1;
            continue;
        }
        j += 1;
        res[j].s = res[i].s;
        res[j].e = res[i].e;
        i += 1;
    }
    res[0..j + 1].to_vec()
}
fn parts(inp: &[u8]) -> (usize, usize) {
    let mut sensors: [Sensor; 30] = [Sensor::default(); 30];
    let mut k = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, x) = aoc::read::int::<isize>(inp, i + 12);
        let (j, y) = aoc::read::int::<isize>(inp, j + 4);
        let (j, bx) = aoc::read::int::<isize>(inp, j + 25);
        let (j, by) = aoc::read::int::<isize>(inp, j + 4);
        let md = (x - bx).abs() + (y - by).abs();
        sensors[k] = Sensor { x, y, bx, by, md };
        k += 1;
        i = j + 1;
    }
    let (y, max_y) = if k < 15 { (10, 20) } else { (2000000, 4000000) };
    let mut done: HashSet<isize> = HashSet::default();
    for s in &sensors[0..k] {
        if s.by == y {
            done.insert(s.bx);
        }
    }
    let beacon_count = done.len();
    let spans = spans_of_row(&sensors[0..k], y);
    let mut p1 = 0;
    for span in spans {
        p1 += (span.e - span.s) as usize;
    }
    p1 -= beacon_count;
    let mut p2 = 0;
    let mid = max_y / 2;
    for iy in 0..mid {
        let y = mid - iy - 1;
        let spans = spans_of_row(&sensors, y);
        if spans.len() == 2 {
            p2 = 4000000 * spans[0].e + y;
            break;
        }
        let y = mid + iy;
        let spans = spans_of_row(&sensors, y);
        if spans.len() == 2 {
            p2 = 4000000 * spans[0].e + y;
            break;
        }
    }
    (p1, p2 as usize)
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
        let inp = std::fs::read("../2022/15/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (26, 56000011));
        let inp = std::fs::read("../2022/15/input.txt").expect("read error");
        assert_eq!(parts(&inp), (4985193, 11583882601918));
    }
}
