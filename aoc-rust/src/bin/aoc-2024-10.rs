pub struct Map<'a, T>
where
    T: std::ops::Add<T> + num::Integer,
{
    w: T,
    w1: usize,
    h: T,
    inp: &'a [u8],
}

impl<'a, T> Map<'a, T>
where
    T: std::ops::Add<T>
        + std::cmp::Ord
        + TryInto<usize>
        + std::convert::TryFrom<usize>
        + std::fmt::Debug
        + Copy
        + num::Integer,
    <T as TryInto<usize>>::Error: std::fmt::Debug,
    <T as std::convert::TryFrom<usize>>::Error: std::fmt::Debug,
    usize: TryFrom<T>,
{
    pub fn new(inp: &'a [u8]) -> Map<'a, T> {
        let w = inp.iter().position(|&ch| ch == b'\n').expect("no EOL");
        let h = inp.len() / (w + 1);

        Map {
            w: w.try_into().unwrap(),
            w1: w + 1,
            h: h.try_into().unwrap(),
            inp,
        }
    }
    pub fn height(&self) -> T {
        self.h
    }
    pub fn width(&self) -> T {
        self.w
    }
    pub fn in_bounds(&self, x: &T, y: &T) -> bool {
        T::zero() <= *x && *x < self.w && T::zero() <= *y && *y < self.h
    }
    pub fn get(&self, x: T, y: T) -> Option<u8> {
        if self.in_bounds(&x, &y) {
            Some(
                self.inp[TryInto::<usize>::try_into(x).unwrap()
                    + TryInto::<usize>::try_into(y).unwrap() * self.w1],
            )
        } else {
            None
        }
    }
}

fn parts<'a>(inp: &'a [u8]) -> (usize, usize) {
    let m = Map::<'a, i32>::new(inp);
    let w = m.width();
    let score = |x, y, z| -> usize {
        let mut sc = 0;
        let mut todo = aoc::deque::Deque::<(i32, i32, u8), 512>::default();
        todo.push((x, y, z));
        let mut seen = [false; 2048];
        while let Some((x, y, z)) = todo.pop() {
            let k = (x + y * w) as usize;
            if seen[k] {
                continue;
            }
            seen[k] = true;
            if z == b'9' {
                sc += 1;
                continue;
            }
            let z = z + 1;
            let want = Some(z);
            if m.get(x, y - 1) == want {
                todo.push((x, y - 1, z));
            }
            if m.get(x + 1, y) == want {
                todo.push((x + 1, y, z));
            }
            if m.get(x, y + 1) == want {
                todo.push((x, y + 1, z));
            }
            if m.get(x - 1, y) == want {
                todo.push((x - 1, y, z));
            }
        }
        sc
    };
    fn rank(m: &Map<'_, i32>, x: i32, y: i32, z: u8) -> usize {
        let mut r = 0;
        if z == b'9' {
            return 1;
        }
        let z = z + 1;
        let want = Some(z);
        if m.get(x, y - 1) == want {
            r += rank(m, x, y - 1, z);
        }
        if m.get(x + 1, y) == want {
            r += rank(m, x + 1, y, z);
        }
        if m.get(x, y + 1) == want {
            r += rank(m, x, y + 1, z);
        }
        if m.get(x - 1, y) == want {
            r += rank(m, x - 1, y, z);
        }
        r
    }
    let (mut p1, mut p2) = (0, 0);
    let w = inp.iter().position(|&ch| ch == b'\n').expect("no EOL");
    let h = inp.len() / (w + 1);
    for y in 0..h {
        for x in 0..w {
            if inp[x + y * (w + 1)] == b'0' {
                p1 += score(x as i32, y as i32, b'0');
                p2 += rank(&m, x as i32, y as i32, b'0');
            }
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
        aoc::test::auto("../2024/10/", parts);
    }
}
