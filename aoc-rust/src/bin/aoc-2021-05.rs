use std::fmt;

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Line {
    x1: i16,
    y1: i16,
    x2: i16,
    y2: i16,
}

impl Line {
    fn norm(&self) -> (i16, i16) {
        let mut nx = 0;
        let mut ny = 0;
        if self.x1 > self.x2 {
            nx = -1;
        } else if self.x1 < self.x2 {
            nx = 1;
        }
        if self.y1 > self.y2 {
            ny = -1;
        } else if self.y1 < self.y2 {
            ny = 1;
        }
        (nx, ny)
    }
}

impl fmt::Display for Line {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{},{} -> {},{}", self.x1, self.y1, self.x2, self.y2)
    }
}

struct Vents {
    lines: Vec<Line>,
}

impl Vents {
    fn new(inp: &[u8]) -> Vents {
        let mut lines: Vec<Line> = vec![];
        let i16s = read_i16s(inp);
        for chunk in i16s.chunks(4) {
            lines.push(Line {
                x1: chunk[0],
                y1: chunk[1],
                x2: chunk[2],
                y2: chunk[3],
            });
        }

        Vents { lines }
    }
    fn count(&mut self) -> (usize, usize) {
        let mut d: [u8; 1024 * 1024] = [0; 1024 * 1024];
        let mut p1 = 0;
        let mut p2 = 0;

        for line in &self.lines {
            let (nx, ny) = line.norm();
            let p1inc = nx == 0 || ny == 0;
            let mut x = line.x1;
            let mut y = line.y1;
            loop {
                let k = (y as usize) * 1024 + (x as usize);
                let v = d[k];
                let mut i1 = v % 8;
                let mut i2 = v / 8;
                if i1 <= 2 || i2 <= 2 {
                    if p1inc {
                        i1 += 1;
                        if i1 == 2 {
                            p1 += 1;
                        }
                    }
                    i2 += 1;
                    if i2 == 2 {
                        p2 += 1;
                    }
                    d[k] = i1 + (i2 << 3);
                }
                if x == line.x2 && y == line.y2 {
                    break;
                }
                x += nx;
                y += ny;
            }
        }
        (p1, p2)
    }
}

fn read_i16s(inp: &[u8]) -> Vec<i16> {
    let mut i16s: Vec<i16> = vec![];
    let mut n: i16 = 0;
    let mut is_num = false;
    for ch in inp {
        match (ch, is_num) {
            (48..=57, true) => n = n * 10 + (ch - 48) as i16,
            (48..=57, false) => {
                n = (ch - 48) as i16;
                is_num = true;
            }
            (_, true) => {
                i16s.push(n);
                is_num = false;
            }
            _ => {}
        }
    }
    i16s
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let mut vents = Vents::new(&inp);
        let (p1, p2) = vents.count();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}
