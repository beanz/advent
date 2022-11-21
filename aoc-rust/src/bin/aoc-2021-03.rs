#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Report {
    nums: Vec<u16>,
    bits: usize,
}

impl Report {
    fn new(inp: &[u8]) -> Report {
        let mut nums: Vec<u16> = vec![];
        let mut n: u16 = 0;
        let mut bits: Option<usize> = None;
        for (i, ch) in inp.iter().enumerate() {
            match ch {
                48 | 49 => {
                    n = (n << 1) + (ch - 48) as u16;
                }
                10 => {
                    nums.push(n);
                    n = 0;
                    if bits.is_none() {
                        bits = Some(i - 1);
                    }
                }
                _ => {}
            }
        }
        Report {
            nums,
            bits: bits.unwrap(),
        }
    }
    fn part1(&self) -> usize {
        let half = self.nums.len() / 2;
        let mut gamma = 0;
        let mut bit = 1 << self.bits;
        while bit >= 1 {
            let mut c = 0;
            for n in &self.nums {
                if n & bit != 0 {
                    c += 1;
                }
            }
            if c > half {
                gamma += bit;
            }
            bit /= 2;
        }
        (gamma as usize) * (((2 << self.bits) - 1) - gamma) as usize
    }
    fn reduce(&self, most: bool) -> u16 {
        let mut mask = 0;
        let mut val = 0;
        let mut bit = 1 << self.bits;
        while bit >= 1 {
            let mut c = 0;
            let mut total = 0;
            let mut ans = 0;
            for n in &self.nums {
                if (n & mask) != val {
                    continue;
                }
                total += 1;
                ans = *n;
                if (n & bit) != 0 {
                    c += 1;
                }
            }
            if total == 1 {
                return ans;
            }
            if (c >= (total + 1) / 2) == most {
                val += bit;
            }
            mask += bit;
            bit /= 2;
        }
        val
    }
    fn part2(&self) -> usize {
        (self.reduce(true) as usize) * (self.reduce(false) as usize)
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let r = Report::new(&inp);
        let p1 = r.part1();
        let p2 = r.part2();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}
