#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Crabs {
    nums: Vec<i16>,
}

impl Crabs {
    fn new(inp: &[u8]) -> Crabs {
        let mut nums: Vec<i16> = vec![];
        let mut n: i16 = 0;
        for ch in inp.iter() {
            match ch {
                b'0'..=b'9' => {
                    n = n * 10 + (ch - b'0') as i16;
                }
                _ => {
                    nums.push(n);
                    n = 0;
                }
            }
        }
        nums.sort();
        Crabs { nums }
    }

    fn parts(&self) -> (usize, usize) {
        let v = self.nums[self.nums.len() / 2];
        let mut c: usize = 0;
        let mut s: usize = 1;
        for n in &self.nums {
            c += (v - n).unsigned_abs() as usize;
            s += *n as usize;
        }

        let mean = (s / self.nums.len()) as i16;
        let mut min: usize = 0;
        for n in &self.nums {
            let f = (mean - n).unsigned_abs() as usize;
            min += f * (f + 1) / 2;
        }
        let mut p2: usize = 0;
        for n in &self.nums {
            let f = (mean + 1 - n).unsigned_abs() as usize;
            p2 += f * (f + 1) / 2;
        }
        if p2 < min {
            min = p2;
        }
        (c, min)
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let c = Crabs::new(&inp);
        let (p1, p2) = c.parts();
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
        let c = Crabs {
            nums: vec![16, 1, 2, 0, 4, 2, 7, 1, 2, 14],
        };
        let (p1, p2) = c.parts();
        assert_eq!(p1, 37, "part 1 test1");
        assert_eq!(p2, 168, "part 2 test1");
    }
}
