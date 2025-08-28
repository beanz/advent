use arrayvec::ArrayVec;

trait MinMaxTrait {
    const MIN: Self;
    const MAX: Self;
}

impl MinMaxTrait for i32 {
    const MIN: Self = i32::MIN;
    const MAX: Self = i32::MAX;
}

#[derive(Debug, Clone)]
struct MinMax<T>
where
    T: std::cmp::PartialOrd + Copy + MinMaxTrait + std::ops::Sub,
{
    pub min: T,
    pub max: T,
}

impl<T> Default for MinMax<T>
where
    T: std::cmp::PartialOrd + Copy + MinMaxTrait + std::ops::Sub,
{
    fn default() -> Self {
        Self {
            min: T::MAX,
            max: T::MIN,
        }
    }
}
impl<T> MinMax<T>
where
    T: std::cmp::PartialOrd + Copy + MinMaxTrait + std::ops::Sub<Output = T>,
{
    fn add(&mut self, a: T) {
        if a < self.min {
            self.min = a;
        }
        if a > self.max {
            self.max = a;
        }
    }
    fn size(&self) -> T {
        self.max - self.min
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut bots = ArrayVec::<(i32, i32, i32, u32), 1024>::new();
    let mut i = 0;
    let (mut max_r, mut max_i) = (0, 0);
    let mut bb = [
        MinMax::<i32>::default(),
        MinMax::<i32>::default(),
        MinMax::<i32>::default(),
    ];
    while i < inp.len() {
        let (j, x) = aoc::read::int::<i32>(inp, i + 5);
        let (j, y) = aoc::read::int::<i32>(inp, j + 1);
        let (j, z) = aoc::read::int::<i32>(inp, j + 1);
        let (j, r) = aoc::read::uint::<u32>(inp, j + 5);
        bots.push((x, y, z, r));
        if r > max_r {
            max_r = r;
            max_i = bots.len() - 1;
        }
        bb[0].add(x);
        bb[1].add(y);
        bb[2].add(z);
        i = j + 1;
    }
    let mut p1 = 0;
    let (mx, my, mz, mr) = bots[max_i];
    for (x, y, z, _) in &bots {
        if manhattan((mx, my, mz), (*x, *y, *z)) <= mr {
            p1 += 1;
        }
    }
    let mut scale = 1;
    while bb[0].size() / scale > 64 || bb[1].size() / scale > 64 || bb[2].size() / scale > 64 {
        scale <<= 1;
    }
    let mut bb = [
        MinMax {
            min: scale_i32(bb[0].min, scale),
            max: scale_i32(bb[0].max, scale),
        },
        MinMax {
            min: scale_i32(bb[1].min, scale),
            max: scale_i32(bb[1].max, scale),
        },
        MinMax {
            min: scale_i32(bb[2].min, scale),
            max: scale_i32(bb[2].max, scale),
        },
    ];
    let mut best_bots = ArrayVec::<(i32, i32, i32), 4096>::new();
    loop {
        let mut scaled_bots = ArrayVec::<(i32, i32, i32, u32), 1024>::new();
        for (x, y, z, r) in &bots {
            scaled_bots.push((
                scale_i32(*x, scale),
                scale_i32(*y, scale),
                scale_i32(*z, scale),
                scale_i32(*r as i32, scale) as u32,
            ))
        }
        let mut min = scaled_bots.len() - 1;
        for z in bb[2].min..=bb[2].max {
            for y in bb[1].min..=bb[1].max {
                for x in bb[0].min..=bb[0].max {
                    let count = count_in_range(&scaled_bots, (x, y, z));
                    let missing = scaled_bots.len() - count;
                    if missing == min {
                        best_bots.push((x, y, z));
                    } else if missing < min {
                        //eprintln!("New best {},{},{}, missing {}", x, y, z, missing);
                        best_bots.clear();
                        best_bots.push((x, y, z));
                        min = missing;
                    }
                }
            }
        }
        if scale == 1 {
            break;
        }
        scale /= 2;
        bb = [
            MinMax::<i32>::default(),
            MinMax::<i32>::default(),
            MinMax::<i32>::default(),
        ];
        for (x, y, z) in &best_bots {
            let x = x * 2;
            if x - 2 < bb[0].min {
                bb[0].min = x - 2;
            }
            if x + 2 > bb[0].max {
                bb[0].max = x + 2;
            }
            let y = y * 2;
            if y - 2 < bb[1].min {
                bb[1].min = y - 2;
            }
            if y + 2 > bb[1].max {
                bb[1].max = y + 2;
            }
            let z = z * 2;
            if z - 2 < bb[2].min {
                bb[2].min = z - 2;
            }
            if z + 2 > bb[2].max {
                bb[2].max = z + 2;
            }
        }
        best_bots.clear();
        scaled_bots.clear();
    }
    (
        p1,
        manhattan((0, 0, 0), (best_bots[0].0, best_bots[0].1, best_bots[0].2)) as usize,
    )
}

fn scale_i32(a: i32, s: i32) -> i32 {
    ((a as f64) / (s as f64)).round() as i32
}

fn scale_i32_old(a: i32, s: i32) -> i32 {
    if a > 0 {
        1 + a / s
    } else {
        -1 + a / s
    }
}

fn manhattan(a: (i32, i32, i32), b: (i32, i32, i32)) -> u32 {
    a.0.abs_diff(b.0) + a.1.abs_diff(b.1) + a.2.abs_diff(b.2)
}

fn count_in_range(bots: &ArrayVec<(i32, i32, i32, u32), 1024>, p: (i32, i32, i32)) -> usize {
    let mut c = 0;
    for (x, y, z, r) in bots {
        if manhattan((*x, *y, *z), p) <= *r {
            c += 1;
        }
    }
    c
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
        let inp = std::fs::read("../2018/23/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (7, 1));
        let inp = std::fs::read("../2018/23/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (6, 36));
        let inp = std::fs::read("../2018/23/input.txt").expect("read error");
        assert_eq!(parts(&inp), (442, 100985898));
        let inp = std::fs::read("../2018/23/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (889, 160646364));
    }
}
