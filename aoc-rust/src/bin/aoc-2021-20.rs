use std::fmt;

struct Image {
    lookup: [bool; 512],
    image: Vec<Vec<bool>>,
}

impl Image {
    fn new(inp: &[u8]) -> Image {
        let mut lookup = [false; 512];
        let mut i = 0;
        while i < inp.len() && inp[i] != b'\n' {
            if inp[i] == b'#' {
                lookup[i] = true;
            }
            i += 1;
        }
        i += 2;
        let mut image: Vec<Vec<bool>> = vec![];
        let mut row: Vec<bool> = vec![];
        while i < inp.len() {
            match inp[i] {
                b'#' => row.push(true),
                b'.' => row.push(false),
                b'\n' => {
                    image.push(row);
                    row = vec![];
                }
                _ => {
                    unreachable!()
                }
            }
            i += 1;
        }
        Image { lookup, image }
    }
    fn parts(&mut self) -> (usize, usize) {
        self.enhance(false);
        let p1 = self.enhance(true);
        let mut p2: usize = 0;
        for _ in (3..=50).step_by(2) {
            self.enhance(false);
            p2 = self.enhance(true);
        }
        (p1, p2)
    }

    fn enhance(&mut self, def: bool) -> usize {
        let mut c = 0;
        let mut image: Vec<Vec<bool>> = vec![];
        for y in -1_i32..=(self.image.len() as i32) {
            let mut row: Vec<bool> = vec![];
            for x in -1_i32..=(self.image[0].len() as i32) {
                if self.lookup[self.index(x, y, def)] {
                    c += 1;
                    row.push(true);
                } else {
                    row.push(false);
                }
            }
            image.push(row);
        }
        self.image = image;
        c
    }
    fn value(&self, x: i32, y: i32, def: bool) -> bool {
        if x < 0 || y < 0 || x >= self.image[0].len() as i32 || y >= self.image.len() as i32 {
            self.lookup[0] && def
        } else {
            self.image[y as usize][x as usize]
        }
    }
    fn index(&self, x: i32, y: i32, def: bool) -> usize {
        let mut i = 0;
        if self.value(x - 1, y - 1, def) {
            i += 256;
        }
        if self.value(x, y - 1, def) {
            i += 128;
        }
        if self.value(x + 1, y - 1, def) {
            i += 64;
        }
        if self.value(x - 1, y, def) {
            i += 32;
        }
        if self.value(x, y, def) {
            i += 16;
        }
        if self.value(x + 1, y, def) {
            i += 8;
        }
        if self.value(x - 1, y + 1, def) {
            i += 4;
        }
        if self.value(x, y + 1, def) {
            i += 2;
        }
        if self.value(x + 1, y + 1, def) {
            i += 1;
        }
        i
    }
}

impl fmt::Display for Image {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for r in &self.image {
            for c in r {
                write!(f, "{}", if *c { '#' } else { '.' })?;
            }
            writeln!(f)?;
        }
        Ok(())
    }
}

fn main() {
    aoc::benchme(|bench: bool| {
        let inp = std::fs::read(aoc::input_file()).expect("read error");
        let mut img = Image::new(&inp);
        let (p1, p2) = img.parts();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}
