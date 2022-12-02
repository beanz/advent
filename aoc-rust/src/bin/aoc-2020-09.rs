use arrayvec::ArrayVec;

#[derive(Debug)]
struct Xmas {
    ints: ArrayVec<usize, 1000>, // 640 should be enough for anyone
}

impl Xmas {
    fn new(inp: &[u8]) -> Xmas {
        let mut ints: ArrayVec<usize, 1000> = ArrayVec::default();
        let mut n: usize = 0;
        let mut is_num = false;
        for ch in inp {
            match ch {
                b'0'..=b'9' => {
                    n = n * 10 + ((ch - b'0') as usize);
                    is_num = true;
                }
                _ => {
                    if is_num {
                        ints.push(n);
                        n = 0;
                        is_num = false;
                    }
                }
            }
        }
        if is_num {
            ints.push(n);
        }
        Xmas { ints }
    }

    fn part1(&self, pre: usize) -> usize {
        for i in pre..self.ints.len() {
            let v = self.ints[i];
            let mut found = false;
            for j in (i - pre)..i {
                for k in j + 1..i {
                    if self.ints[j] + self.ints[k] == v {
                        found = true;
                        break;
                    }
                }
            }
            if !found {
                return v;
            }
        }
        1
    }
    fn part2(&self, p1: usize) -> usize {
        for n in 2..self.ints.len() {
            for i in 0..self.ints.len() - n {
                let mut s = 0;
                for j in 0..n {
                    s += self.ints[i + j];
                }
                if s != p1 {
                    continue;
                }
                let min = (self.ints[i..i + n]).iter().min().expect("min");
                let max = (self.ints[i..i + n]).iter().max().expect("max");
                return min + max;
            }
        }
        2
    }

    fn parts(&self) -> (usize, usize) {
        let pre = if self.ints.len() > 100 { 25 } else { 5 };
        let p1 = self.part1(pre);
        (p1, self.part2(p1))
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let xmas = Xmas::new(&inp);
        let (p1, p2) = xmas.parts();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/09/test1.txt").expect("read error");
        let xmas = Xmas::new(&inp);
        assert_eq!(xmas.parts(), (127, 62));
        let inp = std::fs::read("../2020/09/input.txt").expect("read error");
        let xmas = Xmas::new(&inp);
        assert_eq!(xmas.parts(), (31161678, 5453868));
    }
}
