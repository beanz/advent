#[derive(Debug, Clone, Copy)]
struct Pos {
    x: i8,
    y: i8,
}

impl Pos {
    fn new(x: i8, y: i8) -> Pos {
        Pos { x, y }
    }
    fn index(&self) -> usize {
        (((self.x as i16 + 128) as usize) << 8) + ((self.y as i16 + 128) as usize)
    }
}

#[derive(Clone, Debug)]
struct Elves {
    m: [bool; 65536],
    el: [Pos; 3000],
    l: usize,
    x_min: i8,
    x_max: i8,
    y_min: i8,
    y_max: i8,
    ri: usize,
}

impl Elves {
    fn new() -> Elves {
        Elves {
            m: [false; 65536],
            el: [Pos { x: 0, y: 0 }; 3000],
            l: 0,
            x_min: std::i8::MAX,
            x_max: std::i8::MIN,
            y_min: std::i8::MAX,
            y_max: std::i8::MIN,
            ri: 0,
        }
    }
    fn reset_bounds(&mut self) {
        self.x_min = std::i8::MAX;
        self.x_max = std::i8::MIN;
        self.y_min = std::i8::MAX;
        self.y_max = std::i8::MIN;
    }
    fn contains(&self, x: i8, y: i8) -> bool {
        self.m[Pos::new(x, y).index()]
    }
    fn add(&mut self, x: i8, y: i8) {
        let p = Pos::new(x, y);
        self.m[p.index()] = true;
        self.el[self.l] = p;
        self.l += 1;
        self.bound(x, y)
    }
    fn mov(&mut self, i: usize, p: Pos, np: Pos) {
        self.m[p.index()] = false;
        self.m[np.index()] = true;
        self.el[i] = np;
        self.bound(np.x, np.y)
    }
    fn bound(&mut self, x: i8, y: i8) {
        if self.x_min > x {
            self.x_min = x
        }
        if self.x_max < x {
            self.x_max = x
        }
        if self.y_min > y {
            self.y_min = y
        }
        if self.y_max < y {
            self.y_max = y
        }
    }
    fn neighbits(&self, x: i8, y: i8) -> usize {
        let mut b = 0;
        if self.contains(x - 1, y - 1) {
            b += 1;
        }
        if self.contains(x, y - 1) {
            b += 2;
        }
        if self.contains(x + 1, y - 1) {
            b += 4;
        }
        if self.contains(x - 1, y) {
            b += 8;
        }
        if self.contains(x + 1, y) {
            b += 16;
        }
        if self.contains(x - 1, y + 1) {
            b += 32;
        }
        if self.contains(x, y + 1) {
            b += 64;
        }
        if self.contains(x + 1, y + 1) {
            b += 128;
        }
        b
    }
    fn count(&self) -> usize {
        ((1 + self.x_max - self.x_min) as usize) * ((1 + self.y_max - self.y_min) as usize) - self.l
    }
    fn iter(&mut self) -> usize {
        let mut prop: [Option<Pos>; 65536] = [None; 65536];
        let mut count: [u8; 65536] = [0; 65536];
        for j in 0..self.l {
            let p = self.el[j];
            const CHECK_BITS: [usize; 4] = [1 + 2 + 4, 32 + 64 + 128, 1 + 8 + 32, 4 + 16 + 128];
            const CHECK_OFFSET: [[i8; 2]; 4] = [[0, -1], [0, 1], [-1, 0], [1, 0]];
            let nb = self.neighbits(p.x, p.y);
            if nb == 0 {
                continue;
            }
            for i in 0..4 {
                let j = (self.ri + i) % 4;
                if nb & CHECK_BITS[j] == 0 {
                    let o = CHECK_OFFSET[j];
                    let np = Pos::new(p.x + o[0], p.y + o[1]);
                    prop[p.index()] = Some(np);
                    count[np.index()] += 1;
                    break;
                }
            }
        }
        let mut moved = 0;
        self.reset_bounds();
        for j in 0..self.l {
            let p = self.el[j];
            if let Some(np) = prop[p.index()] {
                if count[np.index()] == 1 {
                    self.mov(j, p, np);
                    moved += 1;
                    continue;
                }
            }
            self.bound(p.x, p.y);
        }
        self.ri += 1;
        if self.ri == 4 {
            self.ri = 0;
        }
        moved
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut x, mut y) = (0, 0);
    let mut elves = Elves::new();
    for ch in inp {
        match ch {
            b'#' => {
                elves.add(x, y);
                x += 1;
            }
            b'\n' => {
                y += 1;
                x = 0;
            }
            _ => x += 1,
        }
    }
    let mut p1 = 0;
    let mut p2 = 0;
    for r in 1..10000 {
        let moved = elves.iter();
        if r == 10 {
            p1 = elves.count();
        }
        if moved == 0 {
            p2 = r;
            break;
        }
    }
    (p1, p2)
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
        let inp = std::fs::read("../2022/23/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (110, 20));
        let inp = std::fs::read("../2022/23/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3923, 1019));
    }
}
