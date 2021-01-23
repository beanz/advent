use std::collections::HashMap;
use std::collections::HashSet;
use std::collections::VecDeque;
use std::fmt;

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
enum Space {
    Wall,
    Open,
}

impl fmt::Display for Space {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}",
            match self {
                Space::Wall => '#',
                Space::Open => '.',
            }
        )
    }
}

struct Maze {
    fav: u64,
    cache: HashMap<(u64, u64), Space>,
}

struct SearchState {
    pos: (u64, u64),
    steps: usize,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
enum End {
    Pos(u64, u64),
    Steps(usize),
}

impl Maze {
    fn new(fav: u64) -> Maze {
        let cache: HashMap<(u64, u64), Space> = HashMap::new();
        Maze { fav, cache }
    }
    fn get(&mut self, x: u64, y: u64) -> Space {
        let v = self.cache.get(&(x, y));
        if let Some(b) = v {
            return *b;
        }
        let mut n = x * x + 3 * x + 2 * x * y + y + y * y;
        n += self.fav;
        let res = if (n.count_ones() % 2) == 0 {
            Space::Open
        } else {
            Space::Wall
        };
        self.cache.insert((x, y), res);
        res
    }
    fn search(&mut self, end: End) -> usize {
        let mut part2 = false;
        let max_steps = match end {
            End::Steps(n) => {
                part2 = true;
                n
            }
            _ => 0,
        };
        let mut visited: HashSet<(u64, u64)> = HashSet::new();
        let mut todo: VecDeque<Box<SearchState>> = VecDeque::new();
        let first = SearchState {
            pos: (1, 1),
            steps: 0,
        };
        todo.push_front(Box::new(first));
        while !todo.is_empty() {
            let cur = todo.pop_front().unwrap();
            if !visited.insert(cur.pos) {
                // already present
                continue;
            }
            if End::Pos(cur.pos.0, cur.pos.1) == end {
                return cur.steps;
            }
            if part2 && cur.steps == max_steps {
                continue;
            }
            for o in &[(0, -1), (-1, 0), (1, 0), (0, 1)] {
                let nx = cur.pos.0 as i64 + o.0;
                let ny = cur.pos.1 as i64 + o.1;
                if nx < 0 || ny < 0 {
                    continue;
                }
                let n = (nx as u64, ny as u64);
                if self.get(n.0, n.1) == Space::Wall {
                    continue;
                }
                todo.push_back(Box::new(SearchState {
                    pos: n,
                    steps: cur.steps + 1,
                }));
            }
        }
        visited.len()
    }
    fn part1(&mut self) -> usize {
        self.search(End::Pos(31, 39))
    }
    fn part2(&mut self) -> usize {
        self.search(End::Steps(50))
    }
}

#[test]
fn maze_gen_works() {
    let mut ex1 = Maze::new(10);
    let mut s = "".to_string();
    for y in 0..4 {
        for x in 0..10 {
            s.push(if ex1.get(x, y) == Space::Wall {
                '#'
            } else {
                '.'
            });
        }
        s.push('\n');
    }
    assert_eq!(s, ".#.####.##\n..#..#...#\n#....##...\n###.#.###.\n");
}

#[test]
fn solve_search_works() {
    let mut ex1 = Maze::new(10);
    assert_eq!(ex1.search(End::Pos(7, 4)), 11, "example part 1");
    assert_eq!(ex1.search(End::Steps(50)), 151, "example part 2");
}

fn main() {
    let fav = aoc::read_input_line().parse::<u64>().unwrap();
    let mut maze = Maze::new(fav);
    println!("Part 1: {}", maze.part1());
    println!("Part 2: {}", maze.part2());
}
