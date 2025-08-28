use std::collections::HashMap;

struct Node {
    used: usize,
    free: usize,
}

struct Grid {
    d: HashMap<(usize, usize), Node>,
    width: usize,
    height: usize,
}

impl Grid {
    fn new(inp: &[String]) -> Grid {
        let mut d: HashMap<(usize, usize), Node> = HashMap::new();
        let mut width = 0;
        let mut height = 0;
        for l in inp.iter().skip(2) {
            let uints: Vec<usize> = aoc::uints::<usize>(l).collect();
            let x = uints[0];
            let y = uints[1];
            d.insert(
                (x, y),
                Node {
                    used: uints[3],
                    free: uints[4],
                },
            );
            if x > width {
                width = x;
            }
            if y > height {
                height = y;
            }
        }
        width += 1;
        height += 1;
        Grid { d, width, height }
    }
    fn part1(&self) -> usize {
        let mut c = 0;
        let m = self.width * self.height;
        for i in 0..m {
            for j in i + 1..m {
                let n1 = self.d.get(&(i % self.width, i / self.width)).unwrap();
                let n2 = self.d.get(&(j % self.width, j / self.width)).unwrap();
                if (n1.used != 0 && n1.used <= n2.free)
                    || (n2.used != 0 && n2.used <= n1.free)
                {
                    c += 1;
                }
            }
        }
        c
    }
    fn part2(&self) -> usize {
        let mut empty = (0, 0);
        let mut full = 0;
        for y in 0..self.height {
            for x in 0..self.width {
                let used = self.d.get(&(x, y)).unwrap().used;
                if used == 0 {
                    empty = (x, y);
                } else if used > 150 {
                    full += 1;
                }
            }
        }
        // steps to go around the full spaces
        let n = 1 + full - (self.width - empty.0) + full;
        // plus height plus steps to move across
        n + empty.1 + (self.width - 2) * 5
    }
}

fn main() {
    let lines = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let g = Grid::new(&lines);
        let p1 = g.part1();
        let p2 = g.part2();
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}
