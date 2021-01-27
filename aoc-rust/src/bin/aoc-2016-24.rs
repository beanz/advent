use itertools::*;
use std::collections::HashMap;
use std::collections::VecDeque;

struct Game {
    walls: Vec<bool>,
    width: usize,
    height: usize,
    numbers: Vec<(usize, usize)>,
}

struct SearchState {
    x: usize,
    y: usize,
    steps: usize,
}

impl Game {
    fn new(inp: &[String]) -> Game {
        let height = inp.len();
        let width = inp[0].len();
        let mut numbers: Vec<(usize, usize)> = vec![(0, 0); 10];
        let mut max: usize = 0;
        let mut walls: Vec<bool> = vec![];
        for (y, l) in inp.iter().enumerate() {
            for (x, ch) in l.chars().enumerate() {
                if ('0'..='9').contains(&ch) {
                    let n = ch as u8 - b'0';
                    numbers[n as usize] = (x, y);
                    if n as usize > max {
                        max = n as usize;
                    }
                }
                if ch == '#' {
                    walls.push(true);
                    continue;
                }
                walls.push(false);
            }
        }
        numbers.resize(max + 1, (0, 0));
        Game {
            walls,
            width,
            height,
            numbers,
        }
    }

    fn dist(&self, a: usize, b: usize) -> usize {
        let mut visited: Vec<bool> = vec![false; self.width * self.height];
        let mut todo: VecDeque<Box<SearchState>> = VecDeque::new();
        let start = self.numbers[a];
        let end = self.numbers[b];
        let first = SearchState {
            x: start.0,
            y: start.1,
            steps: 0,
        };
        todo.push_front(Box::new(first));
        while !todo.is_empty() {
            let cur = todo.pop_front().unwrap();
            let i = cur.x + self.width * cur.y;
            if visited[i] {
                continue;
            }
            visited[i] = true;
            for o in &[(0, -1), (-1, 0), (1, 0), (0, 1)] {
                let nx = (cur.x as i64 + o.0) as usize;
                let ny = (cur.y as i64 + o.1) as usize;
                if self.walls[nx + self.width * ny] {
                    continue;
                }
                if nx == end.0 && ny == end.1 {
                    return cur.steps + 1;
                }
                todo.push_back(Box::new(SearchState {
                    x: nx,
                    y: ny,
                    steps: cur.steps + 1,
                }));
            }
        }
        0
    }
    fn distances(&self) -> HashMap<(usize, usize), usize> {
        let mut d: HashMap<(usize, usize), usize> = HashMap::new();
        for a in 0..self.numbers.len() - 1 {
            for b in a + 1..self.numbers.len() {
                let dist = self.dist(a, b);
                d.insert((a, b), dist);
                d.insert((b, a), dist);
            }
        }
        d
    }
    fn calc(&self) -> (usize, usize) {
        let dist = self.distances();
        let mut p1min = std::usize::MAX;
        let mut p2min = std::usize::MAX;
        for perm in (1..self.numbers.len()).permutations(self.numbers.len() - 1)
        {
            let mut d = *dist.get(&(0, perm[0])).unwrap();
            for i in 0..perm.len() - 1 {
                d += *dist.get(&(perm[i], perm[i + 1])).unwrap();
            }
            if p1min > d {
                p1min = d;
            }
            d += *dist.get(&(0, perm[perm.len() - 1])).unwrap();
            if p2min > d {
                p2min = d;
            }
        }
        (p1min, p2min)
    }
}

fn main() {
    let inp = aoc::input_lines();
    let g = Game::new(&inp);
    let (p1, p2) = g.calc();
    println!("Part 1: {}", p1);
    println!("Part 2: {}", p2);
}

#[test]
fn calc_works() {
    let g = Game::new(
        &[
            "###########",
            "#0.1.....2#",
            "#.#######.#",
            "#4.......3#",
            "###########",
        ]
        .iter()
        .map(|x| x.to_string())
        .collect::<Vec<String>>(),
    );
    let (p1, p2) = g.calc();
    assert_eq!(p1, 14, "part 1 example");
    assert_eq!(p2, 20, "part 2 example");
}
