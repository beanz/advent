use std::collections::HashSet;

#[derive(Debug, Copy, Clone, Default)]
struct Sensor {
    x: isize,
    y: isize,
    bx: isize,
    by: isize,
    md: isize,
    r1x: isize,
    r1y: isize,
    r2x: isize,
    r2y: isize,
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

fn rot_ccw(x: isize, y: isize) -> (isize, isize) {
    (x + y, y - x)
}

fn rot_cc(x: isize, y: isize) -> (isize, isize) {
    ((x - y) >> 1, (y + x) >> 1)
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
        let (r1x, r1y) = rot_ccw(x - md - 1, y);
        let (r2x, r2y) = rot_ccw(x + md + 1, y);
        sensors[k] = Sensor {
            x,
            y,
            bx,
            by,
            md,
            r1x,
            r1y,
            r2x,
            r2y,
        };
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
    (p1, part2(&sensors[0..k], max_y))
}

fn part2(sensors: &[Sensor], max: isize) -> usize {
    let mut nx = vec![];
    let mut ny = vec![];
    for i in 0..sensors.len() {
        for j in i..sensors.len() {
            if sensors[i].r1x == sensors[j].r2x {
                nx.push(sensors[i].r1x);
            }
            if sensors[i].r2x == sensors[j].r1x {
                nx.push(sensors[i].r2x);
            }
            if sensors[i].r1y == sensors[j].r2y {
                ny.push(sensors[i].r1y);
            }
            if sensors[i].r2y == sensors[j].r1y {
                ny.push(sensors[i].r2y);
            }
        }
    }
    nx.sort();
    nx.dedup();
    ny.sort();
    ny.dedup();
    let mut poss: Vec<(isize, isize)> = vec![];
    for rx in &nx {
        for ry in &ny {
            let (x, y) = rot_cc(*rx, *ry);
            if 0 <= x && x <= max && 0 <= y && y <= max {
                poss.push((x, y));
            }
        }
    }
    if poss.len() == 1 {
        return (4000000 * poss[0].0 + poss[0].1) as usize;
    }
    for p in poss {
        let mut near = false;
        for s in sensors {
            let md = (s.x - p.0).abs() + (s.y - p.1).abs();
            if md <= s.md {
                near = true;
                break;
            }
        }
        if !near {
            return (4000000 * p.0 + p.1) as usize;
        }
    }
    0
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
