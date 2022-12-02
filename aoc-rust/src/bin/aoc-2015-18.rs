use std::mem::swap;

#[derive(Debug, Clone, PartialEq, Eq)]
struct Grid {
    w: usize,
    h: usize,
    lights: Vec<bool>,
}

impl Grid {
    fn new(inp: &[String]) -> Grid {
        let mut lights: Vec<bool> = Vec::new();
        let mut w = 0;
        let mut h = 0;
        for l in inp.iter() {
            h += 1;
            w = l.len();
            for ch in l.chars() {
                lights.push(ch == '#');
            }
        }
        Grid { w, h, lights }
    }
    fn iter(&self, rounds: usize, part2: bool) -> usize {
        let mut cur = self.lights.to_vec();
        let mut next = self.lights.to_vec();
        if part2 {
            for i in [
                0usize,
                self.w - 1,
                (self.h - 1) * self.w,
                self.h * self.w - 1,
            ]
            .iter()
            {
                cur[*i] = true;
            }
        }
        let mut on = 0;
        for _r in 1..=rounds {
            on = 0;
            for y in 0..self.h as i32 {
                for x in 0..self.w as i32 {
                    let i = x as usize + y as usize * self.w;
                    let mut c = 0;
                    for o in &[
                        (-1, -1),
                        (0, -1),
                        (1, -1),
                        (-1, 0),
                        (1, 0),
                        (-1, 1),
                        (0, 1),
                        (1, 1),
                    ] {
                        let (ox, oy) = (x + o.0, y + o.1);
                        if 0 <= ox
                            && (ox as usize) < self.w
                            && 0 <= oy
                            && (oy as usize) < self.h
                            && cur[ox as usize + oy as usize * self.w]
                        {
                            c += 1
                        }
                    }
                    next[i] = (cur[i] && c == 2) || c == 3;
                    if next[i] {
                        on += 1;
                    }
                }
            }
            if part2 {
                for i in [
                    0usize,
                    self.w - 1,
                    (self.h - 1) * self.w,
                    self.h * self.w - 1,
                ]
                .iter()
                {
                    if !next[*i] {
                        next[*i] = true;
                        on += 1;
                    }
                }
            }
            swap(&mut cur, &mut next);
        }
        on
    }
    fn part1(&self) -> usize {
        self.iter(100, false)
    }
    fn part2(&self) -> usize {
        self.iter(100, true)
    }
}

fn main() {
    let lines = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let g = Grid::new(&lines);
        let p1 = g.part1();
        let p2 = g.part2();
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
    fn part1_iter_works() {
        let g = Grid::new(&vec![
            ".#.#.#".to_string(),
            "...##.".to_string(),
            "#....#".to_string(),
            "..#...".to_string(),
            "#.#..#".to_string(),
            "####..".to_string(),
        ]);
        assert_eq!(g.iter(4, false), 4, "part 1 of test input");
    }

    #[test]
    fn part2_iter_works() {
        let g = Grid::new(&vec![
            "##.#.#".to_string(),
            "...##.".to_string(),
            "#....#".to_string(),
            "..#...".to_string(),
            "#.#..#".to_string(),
            "####.#".to_string(),
        ]);
        assert_eq!(g.iter(5, true), 17, "part 2 of test input");
    }
}
