use arrayvec::ArrayVec;

const P1SIZE: usize = 630;

#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
    vx: i32,
    vy: i32,
}

#[derive(Debug)]
struct Bounds {
    min_x: i32,
    min_y: i32,
    max_x: i32,
    max_y: i32,
}

impl Bounds {
    fn add(&mut self, x: i32, y: i32) {
        if x < self.min_x {
            self.min_x = x;
        }
        if y < self.min_y {
            self.min_y = y;
        }
        if x > self.max_x {
            self.max_x = x;
        }
        if y > self.max_y {
            self.max_y = y;
        }
    }
    fn size(&self) -> i32 {
        (self.max_x - self.min_x) * (self.max_y - self.min_y)
    }
}

fn parts(inp: &[u8]) -> ([u8; P1SIZE], usize, usize) {
    let mut points: ArrayVec<Point, 400> = ArrayVec::default();
    let mut i = 0;
    let mut max_y = i32::MIN;
    let mut max_vy = 0;
    let mut min_y = i32::MAX;
    let mut min_vy = 0;
    while i < inp.len() {
        i += 10;
        while inp[i] == b' ' {
            i += 1;
        }
        let (j, x) = aoc::read::int::<i32>(inp, i);
        i = j + 2;
        while inp[i] == b' ' {
            i += 1;
        }
        let (j, y) = aoc::read::int::<i32>(inp, i);
        i = j + 12;
        while inp[i] == b' ' {
            i += 1;
        }
        let (j, vx) = aoc::read::int::<i32>(inp, i);
        i = j + 2;
        while inp[i] == b' ' {
            i += 1;
        }
        let (j, vy) = aoc::read::int::<i32>(inp, i);
        points.push(Point { x, y, vx, vy });
        if y < min_y {
            min_y = y;
            min_vy = vy;
        }
        if y > max_y {
            max_y = y;
            max_vy = vy;
        }
        i = j + 2;
    }
    let rt = (max_y - min_y) / (min_vy - max_vy);
    let mut bb: [Bounds; 3] = [
        Bounds {
            min_x: i32::MAX,
            max_x: i32::MIN,
            min_y: i32::MAX,
            max_y: i32::MIN,
        },
        Bounds {
            min_x: i32::MAX,
            max_x: i32::MIN,
            min_y: i32::MAX,
            max_y: i32::MIN,
        },
        Bounds {
            min_x: i32::MAX,
            max_x: i32::MIN,
            min_y: i32::MAX,
            max_y: i32::MIN,
        },
    ];
    for p in points.iter_mut() {
        p.x += p.vx * rt;
        p.y += p.vy * rt;
        for o in 0..3 {
            bb[o].add(p.x + p.vx * (o as i32 - 1), p.y + p.vy * (o as i32 - 1));
        }
    }

    let size = bb[1].size();
    if bb[0].size() < size || bb[2].size() < size {
        eprintln!("{:?}", bb);
        unreachable!("more complex input; need to step time forward or back");
    }
    let h = 1 + bb[1].max_y - bb[1].min_y;
    let w = 1 + bb[1].max_x - bb[1].min_x;
    let w1 = w + 1;
    let mut p1 = [b'.'; P1SIZE];
    let p1l = (w1 * h) as usize;
    for y in bb[1].min_y..=bb[1].max_y {
        p1[(w + (y - bb[1].min_y) * w1) as usize] = b'\n';
    }
    for p in points.iter_mut() {
        p1[((p.x - bb[1].min_x) + (p.y - bb[1].min_y) * w1) as usize] = b'#';
    }
    (p1, p1l, rt as usize)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p1l, p2) = parts(&inp);
        if !bench {
            println!(
                "Part 1:\n{}",
                std::str::from_utf8(&p1[0..p1l]).expect("ascii")
            );
            println!("Part 2: {}", p2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/10/test.txt").expect("read error");
        let (p1, p1l, p2) = parts(&inp);
        assert_eq!(
            std::str::from_utf8(&p1[0..p1l]).expect("ascii"),
            r"#...#..###
#...#...#.
#...#...#.
#####...#.
#...#...#.
#...#...#.
#...#...#.
#...#..###
",
        );
        assert_eq!(p2, 3);
        let inp = std::fs::read("../2018/10/input.txt").expect("read error");
        let (p1, p1l, p2) = parts(&inp);
        assert_eq!(
            std::str::from_utf8(&p1[0..p1l]).expect("ascii"),
            r"#####...######...####...#.......#####...#....#..######..######
#....#..#.......#....#..#.......#....#..##...#.......#..#.....
#....#..#.......#.......#.......#....#..##...#.......#..#.....
#....#..#.......#.......#.......#....#..#.#..#......#...#.....
#####...#####...#.......#.......#####...#.#..#.....#....#####.
#..#....#.......#.......#.......#..#....#..#.#....#.....#.....
#...#...#.......#.......#.......#...#...#..#.#...#......#.....
#...#...#.......#.......#.......#...#...#...##..#.......#.....
#....#..#.......#....#..#.......#....#..#...##..#.......#.....
#....#..######...####...######..#....#..#....#..######..######
",
        );
        assert_eq!(p2, 10007);
        let inp = std::fs::read("../2018/10/input-amf.txt").expect("read error");
        let (p1, p1l, p2) = parts(&inp);
        assert_eq!(
            std::str::from_utf8(&p1[0..p1l]).expect("ascii"),
            r"#####....####...#####...#....#..#....#..#....#..#....#....##..
#....#..#....#..#....#..#...#...#....#..#...#...##...#...#..#.
#....#..#.......#....#..#..#....#....#..#..#....##...#..#....#
#....#..#.......#....#..#.#.....#....#..#.#.....#.#..#..#....#
#####...#.......#####...##......######..##......#.#..#..#....#
#..#....#..###..#..#....##......#....#..##......#..#.#..######
#...#...#....#..#...#...#.#.....#....#..#.#.....#..#.#..#....#
#...#...#....#..#...#...#..#....#....#..#..#....#...##..#....#
#....#..#...##..#....#..#...#...#....#..#...#...#...##..#....#
#....#...###.#..#....#..#....#..#....#..#....#..#....#..#....#
",
        );
        assert_eq!(p2, 10117);
    }
}
