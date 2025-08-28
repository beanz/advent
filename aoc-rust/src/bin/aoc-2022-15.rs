use smallvec::SmallVec;

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

#[derive(Debug, PartialEq, Clone, Eq)]
struct Span {
    s: isize,
    e: isize,
}

impl PartialOrd for Span {
    fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
        Some(self.s.cmp(&other.s))
    }
}

impl Ord for Span {
    fn cmp(&self, other: &Self) -> std::cmp::Ordering {
        self.s.cmp(&other.s)
    }
}

fn rot_ccw(x: isize, y: isize) -> (isize, isize) {
    (x + y, y - x)
}

fn rot_cw(x: isize, y: isize) -> (isize, isize) {
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
    let (y, max) = if k < 15 { (10, 20) } else { (2000000, 4000000) };
    (part1(&sensors, y), part2(&sensors[0..k], max))
}

fn part1(sensors: &[Sensor], y: isize) -> usize {
    let mut beacons_on_y = SmallVec::<[isize; 30]>::new();
    for s in sensors {
        if s.by == y {
            beacons_on_y.push(s.bx);
        }
    }
    beacons_on_y.sort();
    beacons_on_y.dedup();
    let beacon_count = beacons_on_y.len();
    let mut spans = SmallVec::<[Span; 30]>::new();
    for sensor in sensors {
        let d = sensor.md - (sensor.y - y).abs();
        if d < 0 {
            continue;
        }
        spans.push(Span {
            s: sensor.x - d,
            e: sensor.x + d + 1,
        })
    }
    spans.sort();
    let mut j = 0;
    let mut i = 1;
    while i < spans.len() {
        if spans[i].s <= spans[j].e {
            if spans[i].e > spans[j].e {
                spans[j].e = spans[i].e
            }
            i += 1;
            continue;
        }
        j += 1;
        spans[j].s = spans[i].s;
        spans[j].e = spans[i].e;
        i += 1;
    }
    let mut p1 = 0;
    for span in &spans[0..j + 1] {
        p1 += (span.e - span.s) as usize;
    }
    p1 -= beacon_count;
    p1
}

fn part2(sensors: &[Sensor], max: isize) -> usize {
    let mut nx = SmallVec::<[isize; 30]>::new();
    let mut ny = SmallVec::<[isize; 30]>::new();
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
    let mut poss = SmallVec::<[(isize, isize); 30]>::new();
    for rx in &nx {
        for ry in &ny {
            let (x, y) = rot_cw(*rx, *ry);
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
        let inp = std::fs::read("../2022/15/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (26, 56000011));
        let inp = std::fs::read("../2022/15/input.txt").expect("read error");
        assert_eq!(parts(&inp), (4985193, 11583882601918));
    }
}
