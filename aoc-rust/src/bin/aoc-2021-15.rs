use std::fmt;
use std::str;

#[derive(Debug, Clone, Copy)]
struct Point {
    x: usize,
    y: usize,
}

struct Cave<'a> {
    m: Vec<&'a [u8]>,
    w: usize,
    h: usize,
}

impl Cave<'_> {
    fn new(inp: &mut [u8]) -> Cave {
        let mut w = 0;
        while w < inp.len() && inp[w] != b'\n' {
            w += 1
        }
        let h = inp.len() / (w + 1);
        let mut rows: Vec<&[u8]> = vec![];
        for y in 0..h {
            rows.push(&inp[y * (w + 1)..(y + 1) * (w + 1) - 1]);
        }
        Cave { m: rows, w, h }
    }

    fn solve(&self, dim: usize) -> usize {
        let n = dim * self.w * dim * self.h;
        let w = dim * self.w;
        let h = dim * self.h;
        let mut d = vec![1000000000; n];
        let mut todo: Vec<Vec<Point>> = vec![vec![]; 20 * n];
        let risk = |p: Point| {
            let mut r = (self.m[p.x % self.w][p.y % self.h] - b'0') as usize;
            r += p.x / self.w + p.y / self.h;
            r = 1 + ((r - 1) % 9);
            r
        };
        let add = |todo: &mut Vec<Vec<Point>>, d: &mut [usize], p: Point, pd: usize| {
            if p.x >= w || p.y >= h {
                return;
            }
            let i = p.x + p.y * w;
            let nd = pd + risk(p);
            if d[i] <= nd {
                return;
            }
            d[i] = nd;
            todo[nd].push(p);
        };

        add(&mut todo, &mut d, Point { x: 0, y: 0 }, 0);
        for j in 0..todo.len() {
            for k in 0..todo[j].len() {
                let p = todo[j][k];
                let i = p.x + p.y * w;
                let pd = d[i];
                if p.x == w - 1 && p.y == h - 1 {
                    return pd - (self.m[0][0] - b'0') as usize;
                }
                if p.x > 0 {
                    add(&mut todo, &mut d, Point { x: p.x - 1, y: p.y }, pd);
                }
                add(&mut todo, &mut d, Point { x: p.x + 1, y: p.y }, pd);
                if p.y > 0 {
                    add(&mut todo, &mut d, Point { x: p.x, y: p.y - 1 }, pd);
                }
                add(&mut todo, &mut d, Point { x: p.x, y: p.y + 1 }, pd);
            }
        }
        0
    }

    fn parts(&self) -> (usize, usize) {
        (self.solve(1), self.solve(5))
    }
}

impl fmt::Display for Cave<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for y in 0..self.h {
            writeln!(f, "{}", str::from_utf8(self.m[y]).unwrap())?;
        }
        Ok(())
    }
}

fn main() {
    aoc::benchme(|bench: bool| {
        let mut inp = std::fs::read(aoc::input_file()).expect("read error");
        let cave = Cave::new(&mut inp);
        let (p1, p2) = cave.parts();
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}
