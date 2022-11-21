use std::fmt;
use std::str;

struct Octo<'a> {
    m: &'a mut [u8],
    w: usize,
    h: usize,
}

impl Octo<'_> {
    fn new(inp: &mut [u8]) -> Octo {
        let mut w = 0;
        while w < inp.len() && inp[w] != b'\n' {
            w += 1
        }
        w += 1;
        let h = inp.len() / w;
        Octo { m: inp, w, h }
    }

    fn flash(&mut self, i: usize, x: isize, y: isize) -> usize {
        self.m[i] = b'/';
        let mut c = 1;
        for (ox, oy) in &[
            (-1, -1),
            (0, -1),
            (1, -1),
            (-1, 0),
            (1, 0),
            (-1, 1),
            (0, 1),
            (1, 1),
        ] {
            let (nx, ny) = (x + ox, y + oy);
            if nx < 0
                || nx >= (self.w - 1) as isize
                || ny < 0
                || ny >= self.h as isize
            {
                continue;
            }
            let ni = (ny as usize) * self.w + (nx as usize);
            if self.m[ni] == b'/' {
                continue;
            }
            self.m[ni] += 1;
            if self.m[ni] > b'9' {
                c += self.flash(ni, nx, ny)
            }
        }
        c
    }
    fn step(&mut self) -> usize {
        for i in 0..self.m.len() {
            if self.m[i] == b'\n' {
                continue;
            }
            self.m[i] += 1;
        }
        let mut c = 0;
        for y in 0..self.h as isize {
            for x in 0..(self.w - 1) as isize {
                let i = (y as usize) * self.w + (x as usize);
                if self.m[i] > b'9' {
                    c += self.flash(i, x, y);
                }
            }
        }
        for i in 0..self.m.len() {
            if self.m[i] == b'/' {
                self.m[i] = b'0';
            }
        }
        c
    }

    fn parts(&mut self, max: usize) -> (usize, usize) {
        let (mut flashes, mut steps) = (0, 0);
        loop {
            let c = self.step();
            steps += 1;
            if steps <= max {
                flashes += c;
            }
            if c == (self.w - 1) * self.h {
                break;
            }
        }
        (flashes, steps)
    }
}

impl fmt::Display for Octo<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", str::from_utf8(self.m).unwrap())
    }
}

#[test]
fn step_works() {
    // let mut inp: Vec<u8> = vec![];
    // for ch in b"11111\n19991\n19191\n19991\n11111\n" {
    //     inp.push(*ch);
    // }
    // let mut n = Octo::new(&mut inp);
    // assert_eq!(n.step(), 9, "first example");
    // assert_eq!(format!("{}", n), "34543\n40004\n50005\n40004\n34543\n");
    let mut inp2: Vec<u8> = vec![];
    for ch in b"5483143223\n2745854711\n5264556173\n6141336146\n6357385478\n4167524645\n2176841721\n6882881134\n4846848554\n5283751526\n" {
        inp2.push(*ch);
    }
    let mut n2 = Octo::new(&mut inp2);
    assert_eq!(n2.step(), 0, "second example: step 1");
    assert_eq!(format!("{}", n2), "6594254334\n3856965822\n6375667284\n7252447257\n7468496589\n5278635756\n3287952832\n7993992245\n5957959665\n6394862637\n");
    assert_eq!(n2.step(), 35, "second example: step 2");
    assert_eq!(format!("{}", n2), "8807476555\n5089087054\n8597889608\n8485769600\n8700908800\n6600088989\n6800005943\n0000007456\n9000000876\n8700006848\n");
}

#[test]
fn parts_works() {}

fn main() {
    aoc::benchme(|bench: bool| {
        let mut inp = std::fs::read(aoc::input_file()).expect("read error");
        let mut octo = Octo::new(&mut inp);
        let (p1, p2) = octo.parts(100);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}
