use ahash::RandomState;
use std::collections::HashMap;
use std::fmt;

#[derive(Debug, Clone, Copy)]
struct Rock {
    rows: &'static [u8],
    w: usize,
}

#[rustfmt::skip]
const ROCKS: &[Rock] = &[
    Rock {
        rows: &[
            0b1111000,
        ],
        w: 4,
    },
    Rock {
        rows: &[
            0b0100000,
            0b1110000,
            0b0100000,
        ],
        w: 3,
    },
    Rock {
        rows: &[
            0b1110000,
            0b0010000,
            0b0010000,
        ],
        w: 3,
    },
    Rock {
        rows: &[
            0b1000000,
            0b1000000,
            0b1000000,
            0b1000000,
        ],
        w: 1,
    },
    Rock {
        rows: &[
            0b1100000,
            0b1100000,
        ],
        w: 2,
    },
];

const CHAMBER_HEIGHT: usize = 6400;

struct Chamber<'a> {
    m: [u8; CHAMBER_HEIGHT],
    top: usize,
    jets: &'a [u8],
    jet_i: usize,
    rock_i: usize,
}

impl<'a> Chamber<'a> {
    fn jet(&mut self) -> u8 {
        let r = self.jets[self.jet_i];
        self.jet_i += 1;
        if self.jet_i == self.jets.len() {
            self.jet_i = 0;
        }
        r
    }
    fn rock(&mut self) -> usize {
        let r = self.rock_i;
        self.rock_i += 1;
        if self.rock_i == ROCKS.len() {
            self.rock_i = 0;
        }
        r
    }
    fn hit(&self, rows: &[u8], x: usize, y: usize) -> bool {
        for i in 0..rows.len() {
            if self.m[y + i] & (rows[i] >> x) != 0 {
                return true;
            }
        }
        false
    }
    fn fall(&mut self) {
        let r = ROCKS[self.rock()];
        let w = r.w;
        let (mut x, mut y) = (2, self.top + 3);
        loop {
            let jet = self.jet();
            if jet == b'<' {
                if x > 0 && !self.hit(&r.rows, x - 1, y) {
                    x -= 1;
                }
            } else {
                if x < 7 - w && !self.hit(&r.rows, x + 1, y) {
                    x += 1;
                }
            }
            if !self.hit(&r.rows, x, y - 1) {
                y -= 1;
            } else {
                break;
            }
        }
        for i in 0..r.rows.len() {
            self.m[y + i] |= r.rows[i] >> x
        }
        if self.top < y + r.rows.len() {
            self.top = y + r.rows.len();
        }
    }
    fn key(&self) -> usize {
        let y = self.top;
        let mut k = self.m[y - 4] as usize;
        k <<= 7;
        k += self.m[y - 3] as usize;
        k <<= 7;
        k += self.m[y - 2] as usize;
        k <<= 7;
        k += self.m[y - 1] as usize;
        k <<= 7;
        k += self.m[y - 0] as usize;
        k <<= 14;
        k += self.jet_i * 8 + self.rock_i;
        k
    }
}

impl<'a> fmt::Display for Chamber<'a> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut bottom = 0;
        if self.top > 5 {
            bottom = self.top - 5;
        }
        let mut y = self.top;
        loop {
            let mut bit = 0b1000000;
            while bit > 0 {
                if self.m[y] & bit != 0 {
                    write!(f, "#")?;
                } else {
                    write!(f, ".")?;
                }
                bit >>= 1;
            }
            write!(f, "\n")?;
            if y == bottom {
                break;
            }
            y -= 1;
        }
        Ok(())
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut ch = Chamber {
        m: [0; CHAMBER_HEIGHT],
        jet_i: 0,
        jets: &inp[0..inp.len() - 1],
        rock_i: 0,
        top: 1,
    };
    ch.m[0] = 0b1111111;
    let mut round = 1;
    let last = 1000000000000usize;
    let mut cycle_top = 0;
    let mut p1 = 0;
    let mut seen: HashMap<usize, (usize, usize), RandomState> =
        HashMap::with_capacity_and_hasher(4096, RandomState::new());
    while round <= 5 {
        ch.fall();
        round += 1;
    }
    while round <= last {
        ch.fall();
        if round == 2022 {
            p1 = ch.top - 1;
        }
        if cycle_top == 0 {
            let k = ch.key();
            if round >= 2022 {
                if let Some((old_round, old_top)) = seen.get(&k) {
                    let diff_top = ch.top - old_top;
                    let diff_round = round - old_round;
                    let n = (last - round) / diff_round;
                    round += n * diff_round;
                    cycle_top = n * diff_top;
                }
            }
            seen.insert(k, (round, ch.top));
        }
        round += 1;
    }
    (p1, cycle_top + ch.top - 1)
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
        let inp = std::fs::read("../2022/17/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (3068, 1514285714288));
        let inp = std::fs::read("../2022/17/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3144, 1565242165201));
    }
}
