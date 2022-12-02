use std::cmp::{max, min};

#[derive(Debug, Clone, Copy)]
struct Cuboid {
    value: bool,
    x_min: i32,
    x_max: i32,
    y_min: i32,
    y_max: i32,
    z_min: i32,
    z_max: i32,
}

impl Cuboid {
    fn new(value: bool, x: i32, xm: i32, y: i32, ym: i32, z: i32, zm: i32) -> Cuboid {
        Cuboid {
            value,
            x_min: x,
            x_max: xm,
            y_min: y,
            y_max: ym,
            z_min: z,
            z_max: zm,
        }
    }
    fn volume(&self) -> usize {
        (self.x_max - self.x_min) as usize
            * (self.y_max - self.y_min) as usize
            * (self.z_max - self.z_min) as usize
    }
    fn contains(&self, other: &Cuboid) -> bool {
        self.x_min <= other.x_min
            && self.x_max >= other.x_max
            && self.y_min <= other.y_min
            && self.y_max >= other.y_max
            && self.z_min <= other.z_min
            && self.z_max >= other.z_max
    }
    fn intersects(&self, other: &Cuboid) -> bool {
        self.x_min <= other.x_max
            && self.x_max >= other.x_min
            && self.y_min <= other.y_max
            && self.y_max >= other.y_min
            && self.z_min <= other.z_max
            && self.z_max >= other.z_min
    }
    fn intersection(&self, other: &Cuboid) -> Option<Cuboid> {
        if !self.intersects(other) {
            return None;
        }
        Some(Cuboid {
            value: self.value,
            x_min: max(self.x_min, other.x_min),
            x_max: min(self.x_max, other.x_max),
            y_min: max(self.y_min, other.y_min),
            y_max: min(self.y_max, other.y_max),
            z_min: max(self.z_min, other.z_min),
            z_max: min(self.z_max, other.z_max),
        })
    }
    fn difference(&self, other: &Cuboid) -> Vec<Cuboid> {
        let mut x = vec![self.x_min];
        if self.x_min < other.x_min && other.x_min < self.x_max {
            x.push(other.x_min);
        }
        if self.x_min < other.x_max && other.x_max < self.x_max {
            x.push(other.x_max);
        }
        x.push(self.x_max);
        let mut y = vec![self.y_min];
        if self.y_min < other.y_min && other.y_min < self.y_max {
            y.push(other.y_min);
        }
        if self.y_min < other.y_max && other.y_max < self.y_max {
            y.push(other.y_max);
        }
        y.push(self.y_max);
        let mut z = vec![self.z_min];
        if self.z_min < other.z_min && other.z_min < self.z_max {
            z.push(other.z_min);
        }
        if self.z_min < other.z_max && other.z_max < self.z_max {
            z.push(other.z_max);
        }
        z.push(self.z_max);
        let mut res = vec![];
        for xi in 0..x.len() - 1 {
            for yi in 0..y.len() - 1 {
                for zi in 0..z.len() - 1 {
                    let n = Cuboid {
                        value: self.value,
                        x_min: x[xi],
                        x_max: x[xi + 1],
                        y_min: y[yi],
                        y_max: y[yi + 1],
                        z_min: z[zi],
                        z_max: z[zi + 1],
                    };
                    if !other.contains(&n) {
                        res.push(n);
                    }
                }
            }
        }
        res
    }
}

struct Reactor {
    cuboids: Vec<Cuboid>,
}

impl Reactor {
    fn new(inp: &[u8]) -> Reactor {
        let mut cuboids: Vec<Cuboid> = vec![];
        let mut j = 0;
        for i in 0..inp.len() {
            if inp[i] == b'\n' {
                let i32s: Vec<_> =
                    aoc::ints::<i32>(std::str::from_utf8(&inp[j..i]).expect("valid input"))
                        .collect();
                let value = inp[j + 1] == b'n';
                j = i + 1;
                cuboids.push(Cuboid {
                    value,
                    x_min: i32s[0],
                    x_max: i32s[1] + 1,
                    y_min: i32s[2],
                    y_max: i32s[3] + 1,
                    z_min: i32s[4],
                    z_max: i32s[5] + 1,
                })
            }
        }
        Reactor { cuboids }
    }
    fn parts(&self) -> (usize, usize) {
        let mut cuboids: Vec<Cuboid> = vec![];
        let mut next: Vec<Cuboid> = vec![];
        for c in &self.cuboids {
            for old in &cuboids {
                if c.contains(old) {
                    continue;
                }
                if !old.intersects(c) {
                    next.push(*old);
                    continue;
                }
                let mut diff = old.difference(c);
                next.append(&mut diff);
            }
            if c.value {
                next.push(*c)
            }
            (cuboids, next) = (next, cuboids);
            next.clear();
        }
        let mut p1 = 0;
        let mut p2 = 0;
        let p1c = Cuboid::new(true, -50, 51, -50, 51, -50, 51);
        for c in cuboids {
            p2 += c.volume();
            if let Some(i) = c.intersection(&p1c) {
                p1 += i.volume();
            }
        }
        (p1, p2)
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let reactor = Reactor::new(&inp);
        let (p1, p2) = reactor.parts();
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
        let r1 = Reactor::new(&std::fs::read("../2021/22/test1.txt").expect("read error"));
        assert_eq!((39, 39), r1.parts());
        let r2 = Reactor::new(&std::fs::read("../2021/22/test2.txt").expect("read error"));
        assert_eq!((590784, 39769202357779), r2.parts());
        let r3 = Reactor::new(&std::fs::read("../2021/22/test3.txt").expect("read error"));
        assert_eq!((474140, 2758514936282235), r3.parts());
        let r = Reactor::new(&std::fs::read("../2021/22/input.txt").expect("read error"));
        assert_eq!((598616, 1193043154475246), r.parts());
    }
}
