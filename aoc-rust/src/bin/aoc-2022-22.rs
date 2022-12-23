type Dir = i32;

const RIGHT: Dir = 0;
const DOWN: Dir = 1;
const LEFT: Dir = 2;
const UP: Dir = 3;

const WALL: u8 = b'#';
const EMPTY: u8 = b'.';
const INVALID: u8 = b' ';

fn inc(d: Dir) -> (i32, i32) {
    match d {
        RIGHT => (1, 0),
        DOWN => (0, 1),
        LEFT => (-1, 0),
        UP => (0, -1),
        _ => unreachable!("invalid direction"),
    }
}

#[derive(Debug, Copy, Clone)]
struct Pos {
    x: i32,
    y: i32,
    dir: Dir,
}

impl Pos {
    fn password(&self) -> usize {
        1000 * (self.y as usize + 1) + 4 * (self.x as usize + 1) + (self.dir as usize)
    }
}

#[derive(Debug, Clone, Copy)]
struct Next {
    face: usize,
    dir: Dir,
}

struct Board<'a> {
    m: [&'a [u8]; 200],
    start: Pos,
    cur: Pos,
    walk: &'a [u8],
    w: usize,
    h: usize,

    dim: i32,
    faces: [(i32, i32); 6],
    next: [[Next; 4]; 6],
}

const TEST_DIM: i32 = 4;
const TEST_FACES: [(i32, i32); 6] = [(2, 0), (0, 1), (1, 1), (2, 1), (2, 2), (3, 2)];
#[rustfmt::skip]
const TEST_NEXT: [[Next; 4]; 6] = [
    [
        Next { face: 5, dir: LEFT },
        Next { face: 3, dir: DOWN },
        Next { face: 2, dir: DOWN },
        Next { face: 1, dir: DOWN },
    ],
    [
        Next { face: 2, dir: RIGHT },
        Next { face: 4, dir: UP },
        Next { face: 5, dir: UP },
        Next { face: 0, dir: DOWN },
    ],
    [
        Next { face: 3, dir: RIGHT },
        Next { face: 4, dir: RIGHT },
        Next { face: 1, dir: LEFT },
        Next { face: 0, dir: RIGHT },
    ],
    [
        Next { face: 5, dir: DOWN },
        Next { face: 4, dir: DOWN },
        Next { face: 2, dir: LEFT },
        Next { face: 0, dir: UP },
    ],
    [
        Next { face: 5, dir: RIGHT },
        Next { face: 1, dir: UP },
        Next { face: 2, dir: UP },
        Next { face: 3, dir: UP },
    ],
    [
        Next { face: 0, dir: LEFT },
        Next { face: 1, dir: RIGHT },
        Next { face: 4, dir: LEFT },
        Next { face: 3, dir: LEFT },
    ],
];
const INPUT_DIM: i32 = 50;
const INPUT_FACES: [(i32, i32); 6] = [(1, 0), (2, 0), (1, 1), (0, 2), (1, 2), (0, 3)];
#[rustfmt::skip]
const INPUT_NEXT: [[Next; 4]; 6] = [
    [
        Next { face: 1, dir: RIGHT },
        Next { face: 2, dir: DOWN },
        Next { face: 3, dir: RIGHT },
        Next { face: 5, dir: RIGHT },
    ],
    [
        Next { face: 4, dir: LEFT },
        Next { face: 2, dir: LEFT },
        Next { face: 0, dir: LEFT },
        Next { face: 5, dir: UP },
    ],
    [
        Next { face: 1, dir: UP },
        Next { face: 4, dir: DOWN },
        Next { face: 3, dir: DOWN },
        Next { face: 0, dir: UP },
    ],
    [
        Next { face: 4, dir: RIGHT },
        Next { face: 5, dir: DOWN },
        Next { face: 0, dir: RIGHT },
        Next { face: 2, dir: RIGHT },
    ],
    [
        Next { face: 1, dir: LEFT },
        Next { face: 5, dir: LEFT },
        Next { face: 3, dir: LEFT },
        Next { face: 2, dir: UP },
    ],
    [
        Next { face: 4, dir: UP },
        Next { face: 1, dir: DOWN },
        Next { face: 0, dir: DOWN },
        Next { face: 3, dir: UP },
    ],
];

impl<'a> Board<'a> {
    fn get(&self, x: i32, y: i32) -> u8 {
        if y as usize > self.h {
            unreachable!("out of bounds y");
        }
        if x as usize > self.w {
            unreachable!("out of bounds x");
        }
        if x as usize >= self.m[y as usize].len() {
            return INVALID;
        }
        return self.m[y as usize][x as usize];
    }
    fn mov(&mut self) -> bool {
        let (ix, iy) = inc(self.cur.dir);
        let (mut nx, mut ny) = (
            (self.cur.x + ix).rem_euclid(self.w as i32),
            (self.cur.y + iy).rem_euclid(self.h as i32),
        );
        let mut sq = self.get(nx, ny);
        while sq == INVALID {
            (nx, ny) = (
                (nx + ix).rem_euclid(self.w as i32),
                (ny + iy).rem_euclid(self.h as i32),
            );
            sq = self.get(nx, ny);
        }
        if sq != EMPTY {
            return true;
        }
        self.cur.x = nx;
        self.cur.y = ny;
        false
    }
    fn mov2(&mut self) -> bool {
        let (cx, cy, mut face) = self.face(self.cur.x, self.cur.y);
        let (ix, iy) = inc(self.cur.dir);
        let (mut ncx, mut ncy) = (cx + ix, cy + iy);
        let mut ndir = self.cur.dir;
        if ncy < 0 {
            let nxt = self.next[face][UP as usize];
            (face, ndir) = (nxt.face, nxt.dir);
            (ncx, ncy) = self.wrap(ncx, ncy, self.cur.dir, ndir);
        }
        if ncy == self.dim {
            let nxt = self.next[face][DOWN as usize];
            (face, ndir) = (nxt.face, nxt.dir);
            (ncx, ncy) = self.wrap(ncx, ncy, self.cur.dir, ndir);
        }
        if ncx < 0 {
            let nxt = self.next[face][LEFT as usize];
            (face, ndir) = (nxt.face, nxt.dir);
            (ncx, ncy) = self.wrap(ncx, ncy, self.cur.dir, ndir);
        }
        if ncx == self.dim {
            let nxt = self.next[face][RIGHT as usize];
            (face, ndir) = (nxt.face, nxt.dir);
            (ncx, ncy) = self.wrap(ncx, ncy, self.cur.dir, ndir);
        }
        let (nx, ny) = self.flat(ncx, ncy, face);
        let sq = self.get(nx, ny);
        if sq != EMPTY {
            return true;
        }
        self.cur.x = nx;
        self.cur.y = ny;
        self.cur.dir = ndir;
        false
    }
    fn wrap(&self, x: i32, y: i32, old: Dir, new: Dir) -> (i32, i32) {
        if old == new {
            match old {
                UP => return (x, self.dim - 1),
                DOWN => return (x, 0),
                LEFT => return (self.dim - 1, y),
                RIGHT => return (0, y),
                _ => unreachable!("unexpected direction?"),
            }
        }
        if old == UP && new == RIGHT {
            return (0, x);
        }
        if old == DOWN && new == UP {
            return (self.dim - 1 - x, self.dim - 1);
        }
        if old == RIGHT && new == DOWN {
            return (self.dim - 1 - y, 0);
        }
        if old == DOWN && new == LEFT {
            return (self.dim - 1, x);
        }
        if old == LEFT && new == DOWN {
            return (y, 0);
        }
        if old == LEFT && new == RIGHT {
            return (0, self.dim - 1 - y);
        }
        if old == RIGHT && new == LEFT {
            return (self.dim - 1, self.dim - 1 - y);
        }
        if old == RIGHT && new == UP {
            return (y, self.dim - 1);
        }
        unreachable!("wrap case not implemented")
    }

    fn flat(&self, x: i32, y: i32, face: usize) -> (i32, i32) {
        let (cx, cy) = (self.faces[face].0, self.faces[face].1);
        (cx * self.dim + x, cy * self.dim + y)
    }

    fn face(&self, x: i32, y: i32) -> (i32, i32, usize) {
        let (cx, cy) = (x / self.dim, y / self.dim);
        let x = x.rem_euclid(self.dim);
        let y = y.rem_euclid(self.dim);
        (x, y, self.face_for(cx, cy))
    }

    fn face_for(&self, cx: i32, cy: i32) -> usize {
        for i in 0..self.faces.len() {
            if self.faces[i].0 == cx && self.faces[i].1 == cy {
                return i;
            }
        }
        unreachable!("invalid face coord?")
    }

    fn part(&mut self, part2: bool) -> usize {
        let mut walk_i = 0;
        self.cur = self.start;
        while walk_i < self.walk.len() {
            match self.walk[walk_i] {
                b'L' => {
                    walk_i += 1;
                    self.cur.dir -= 1;
                    if self.cur.dir < RIGHT {
                        self.cur.dir = UP;
                    }
                }
                b'R' => {
                    walk_i += 1;
                    self.cur.dir += 1;
                    if self.cur.dir > UP {
                        self.cur.dir = RIGHT;
                    }
                }
                ch => {
                    let mut n = (ch - b'0') as usize;
                    walk_i += 1;
                    if walk_i < self.walk.len() && self.walk[walk_i].is_ascii_digit() {
                        n = n * 10 + ((self.walk[walk_i] - b'0') as usize);
                        walk_i += 1;
                    }
                    for _ in 0..n {
                        let blocked = if part2 { self.mov2() } else { self.mov() };
                        if blocked {
                            break;
                        }
                    }
                }
            }
        }
        return self.cur.password();
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut b = Board {
        m: [&[]; 200],
        start: Pos {
            x: 0,
            y: 0,
            dir: RIGHT,
        },
        cur: Pos {
            x: 0,
            y: 0,
            dir: RIGHT,
        },
        walk: &[],
        w: 0,
        h: 0,
        dim: INPUT_DIM,
        faces: INPUT_FACES,
        next: INPUT_NEXT,
    };
    let mut i = 0;
    while i < inp.len() && inp[i] != b'\n' {
        let mut j = i;
        while inp[j] != b'\n' {
            j += 1
        }
        let l = &inp[i..j];
        b.m[b.h] = l;
        if l.len() > b.w {
            b.w = l.len();
        }
        b.h += 1;
        i = j + 1;
    }
    b.walk = &inp[i + 1..inp.len() - 1];
    while b.m[0][b.start.x as usize] == b' ' {
        b.start.x += 1;
    }
    if b.h == 12 {
        b.dim = TEST_DIM;
        b.faces = TEST_FACES;
        b.next = TEST_NEXT;
    }
    let p1 = b.part(false);
    let p2 = b.part(true);
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
        let inp = std::fs::read("../2022/22/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (6032, 5031));
        let inp = std::fs::read("../2022/22/input.txt").expect("read error");
        assert_eq!(parts(&inp), (181128, 52311));
    }
}
