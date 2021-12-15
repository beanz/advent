use std::env;
use std::fmt;
use std::fs;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::str;
use std::time::Instant;

pub fn lines<P>(filename: P) -> Vec<String>
where
    P: AsRef<Path>,
{
    let file = File::open(filename).expect("Failed to read input");
    let lines: Vec<_> = io::BufReader::new(file)
        .lines()
        .collect::<Result<_, _>>()
        .unwrap();
    lines
}

pub fn input_lines() -> Vec<String> {
    lines(input_file())
}

pub fn read_line<P>(filename: P) -> String
where
    P: AsRef<Path>,
{
    slurp_file(filename).trim().to_string()
}

pub fn read_input_line() -> String {
    read_line(input_file())
}

pub fn slurp_file<P>(filename: P) -> String
where
    P: AsRef<Path>,
{
    fs::read_to_string(filename).expect("Failed to read file")
}

pub fn slurp_input_file() -> String {
    slurp_file(input_file())
}

pub fn is_test() -> bool {
    !input_file().ends_with("input.txt")
}

pub fn is_benchmark() -> bool {
    env::var("AoC_BENCH").is_ok()
}

pub fn black_box<T>(dummy: T) -> T {
    unsafe {
        let ret = std::ptr::read_volatile(&dummy);
        std::mem::forget(dummy);
        ret
    }
}

pub fn benchme(mut fun: impl FnMut(bool)) {
    let bench = is_benchmark();
    let start = Instant::now();
    let mut iterations = 0;
    loop {
        fun(bench);
        iterations += 1;
        if !bench || start.elapsed().as_micros() > 500000 {
            break;
        }
    }
    if bench {
        let elapsed = start.elapsed().as_micros();
        println!(
            "bench {} iterations in {}µs: {}µs",
            iterations,
            elapsed,
            elapsed / iterations
        );
    }
}

pub fn input_file() -> String {
    let args: Vec<String> = env::args().collect();
    if args.len() > 1 {
        return args[1].to_owned();
    }
    "input.txt".to_string()
}

pub fn ints<T>(s: &str) -> impl Iterator<Item = T> + '_
where
    T: num::Integer + std::str::FromStr,
    <T as std::str::FromStr>::Err: std::fmt::Debug,
{
    s.split(|c| !(c == '-' || ('0'..='9').contains(&c)))
        .filter(|x| !x.is_empty() && *x != "-")
        .map(|x| x.parse::<T>().unwrap())
}

pub fn uints<T>(s: &str) -> impl Iterator<Item = T> + '_
where
    T: num::Integer + std::str::FromStr,
    <T as std::str::FromStr>::Err: std::fmt::Debug,
{
    s.split(|c| !('0'..='9').contains(&c))
        .filter(|x| !x.is_empty())
        .map(|x| x.parse::<T>().unwrap())
}

pub fn sum_lines(lines: &[String], line_fn: fn(l: &str) -> usize) -> usize {
    lines.iter().map(|x| line_fn(x)).sum()
}

pub fn sum_valid_lines(
    lines: &[String], valid_line_fn: fn(l: &str) -> bool,
) -> usize {
    lines
        .iter()
        .map(|x| if valid_line_fn(x) { 1 } else { 0 })
        .sum()
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
pub struct Point {
    x: isize,
    y: isize,
}

impl Point {
    pub const fn new(x: isize, y: isize) -> Point {
        Point { x, y }
    }
    pub fn manhattan(&self) -> usize {
        self.x.abs() as usize + self.y.abs() as usize
    }
    pub fn mov(&mut self, ch: char) {
        match ch {
            '^' | 'N' => self.y -= 1,
            '>' | 'E' => self.x += 1,
            'v' | 'S' => self.y += 1,
            '<' | 'W' => self.x -= 1,
            _ => panic!("Tried to move point with invalid char: {}", ch),
        }
    }
    pub fn four_neighbours(&self) -> Vec<Point> {
        vec![
            Point {
                x: self.x,
                y: self.y - 1,
            },
            Point {
                x: self.x + 1,
                y: self.y,
            },
            Point {
                x: self.x,
                y: self.y + 1,
            },
            Point {
                x: self.x - 1,
                y: self.y,
            },
        ]
    }
    pub fn eight_neighbours(&self) -> Vec<Point> {
        vec![
            Point {
                x: self.x - 1,
                y: self.y - 1,
            },
            Point {
                x: self.x,
                y: self.y - 1,
            },
            Point {
                x: self.x + 1,
                y: self.y - 1,
            },
            Point {
                x: self.x - 1,
                y: self.y,
            },
            Point {
                x: self.x + 1,
                y: self.y,
            },
            Point {
                x: self.x - 1,
                y: self.y + 1,
            },
            Point {
                x: self.x,
                y: self.y + 1,
            },
            Point {
                x: self.x + 1,
                y: self.y + 1,
            },
        ]
    }
    pub fn mov_x(&mut self, ox: isize) {
        self.x += ox;
    }
    pub fn mov_y(&mut self, oy: isize) {
        self.y += oy;
    }
    pub fn cw(&mut self) {
        let tmp = self.x;
        self.x = -self.y;
        self.y = tmp;
    }
    pub fn ccw(&mut self) {
        let tmp = self.x;
        self.x = self.y;
        self.y = -tmp;
    }
    pub fn movdir(&mut self, dir: Point, steps: usize) {
        self.x += dir.x * steps as isize;
        self.y += dir.y * steps as isize;
    }
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

pub struct NumStr {
    b: Box<[u8]>,
    l: usize,
    pl: usize,
}

impl NumStr {
    pub fn new(prefix: String) -> NumStr {
        let pl = prefix.len();
        let pb = prefix.as_bytes();
        let mut b = (vec![0; 30]).into_boxed_slice();
        for i in 0..pl {
            b[i] = pb[i];
        }
        b[pl] = b'0';
        let l = pl + 1;
        NumStr { b, l, pl }
    }
    pub fn string(&self) -> String {
        self.b[0..self.l]
            .iter()
            .map(|x| format!("{:02x}", x))
            .collect::<String>()
    }
    pub fn bytes(&self) -> &[u8] {
        &self.b[0..self.l]
    }
    pub fn inc(&mut self) {
        let mut i = self.l - 1;
        while i >= self.pl {
            self.b[i] += 1;
            if self.b[i] <= b'9' {
                return;
            }
            self.b[i] = b'0';
            i -= 1;
        }
        self.b[self.pl] = b'1';
        self.b[self.l] = b'0';
        self.l += 1;
    }
}

impl fmt::Display for NumStr {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", str::from_utf8(&self.b[0..self.l]).unwrap())
    }
}

#[allow(clippy::many_single_char_names)]
pub fn isqrt(x: usize) -> usize {
    let ix = x as isize;
    let mut q: isize = 1;
    while q <= ix {
        q <<= 2;
    }
    let mut z = ix;
    let mut r: isize = 0;
    while q > 1 {
        q >>= 2;
        let t = z - r - q;
        r >>= 1;
        if t >= 0 {
            z = t;
            r += q;
        }
    }
    r as usize
}

use crypto::digest::Digest;
use crypto::md5::Md5;

pub fn md5sum(b: &[u8]) -> Box<[u8; 16]> {
    let mut md5 = Md5::new();
    md5.input(b);
    let mut cs = [0; 16];
    md5.result(&mut cs);
    Box::new(cs)
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
pub struct HexFlatTop {
    q: isize,
    r: isize,
}

impl HexFlatTop {
    pub const fn new(q: isize, r: isize) -> HexFlatTop {
        HexFlatTop { q, r }
    }
    pub const fn origin() -> HexFlatTop {
        HexFlatTop { q: 0, r: 0 }
    }
    pub fn new_from_dir(dir: &str) -> HexFlatTop {
        let mut hft = HexFlatTop { q: 0, r: 0 };
        hft.mov(dir);
        hft
    }
    pub fn q(&self) -> isize {
        self.q
    }
    pub fn r(&self) -> isize {
        self.r
    }
    pub fn distance(&self, o: &HexFlatTop) -> usize {
        ((self.q - o.q).abs()
            + (self.q + self.r - o.q - o.r).abs()
            + (self.r - o.r).abs()) as usize
            / 2
    }
    pub fn mov(&mut self, dir: &str) {
        match dir {
            "n" => self.r -= 1,
            "s" => self.r += 1,
            "nw" => self.q -= 1,
            "se" => self.q += 1,
            "ne" => {
                self.q += 1;
                self.r -= 1
            }
            "sw" => {
                self.q -= 1;
                self.r += 1
            }
            _ => panic!("Tried to move HexFlatTop with invalid move: {}", dir),
        }
    }
    pub fn neighbours(&self) -> Vec<HexFlatTop> {
        vec![
            HexFlatTop {
                q: self.q + 1,
                r: self.r,
            },
            HexFlatTop {
                q: self.q + 1,
                r: self.r - 1,
            },
            HexFlatTop {
                q: self.q,
                r: self.r - 1,
            },
            HexFlatTop {
                q: self.q - 1,
                r: self.r,
            },
            HexFlatTop {
                q: self.q - 1,
                r: self.r + 1,
            },
            HexFlatTop {
                q: self.q,
                r: self.r + 1,
            },
        ]
    }
}

impl fmt::Display for HexFlatTop {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "<{},{}>", self.q, self.r)
    }
}

pub struct Rope {
    rope: Vec<u8>,
    cur: usize,
    skip: usize,
}

impl fmt::Display for Rope {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut s = "".to_string();
        for (i, n) in self.rope.iter().enumerate() {
            if self.cur == i {
                s.push_str(&format!("[{}] ", n));
            } else {
                s.push_str(&format!("{} ", n));
            }
        }
        write!(f, "{}", s.trim())
    }
}

impl Rope {
    pub fn new(len: usize) -> Rope {
        let rope: Vec<u8> = (0..len).map(|x| x as u8).collect::<Vec<u8>>();
        Rope {
            rope,
            cur: 0,
            skip: 0,
        }
    }
    pub fn new_twisted(len: usize, seed: &str) -> Rope {
        let mut r = Rope::new(len);
        let positions = seed
            .as_bytes()
            .iter()
            .chain(&[17u8, 31, 73, 47, 23])
            .map(|x| *x as usize);
        for _ in 0..64 {
            for pos in positions.clone() {
                r.twist(pos);
            }
        }
        r
    }
    pub fn twist(&mut self, i: usize) {
        self.rope.rotate_left(self.cur);
        self.rope[0..i].reverse();
        self.rope.rotate_right(self.cur);
        self.cur = (self.cur + i + self.skip) % self.rope.len();
        self.skip += 1;
    }
    pub fn product(&self) -> usize {
        self.rope[0] as usize * self.rope[1] as usize
    }
    pub fn dense_hash(&self) -> String {
        self.rope
            .chunks(16)
            .map(|ch| ch.iter().fold(0, |a, v| a ^ v))
            .map(|x| format!("{:02x?}", x))
            .collect::<Vec<String>>()
            .concat()
    }
    pub fn map_hash(&self) -> String {
        self.rope
            .chunks(16)
            .map(|ch| ch.iter().fold(0, |a, v| a ^ v))
            .map(|x| format!("{:08b}", x))
            .collect::<Vec<String>>()
            .concat()
    }
}

#[test]
fn twist_works() {
    let mut r = Rope::new(5);
    assert_eq!(format!("{}", r), "[0] 1 2 3 4", "twist example 0");
    r.twist(3);
    assert_eq!(format!("{}", r), "2 1 0 [3] 4", "twist example 1");
    r.twist(4);
    assert_eq!(format!("{}", r), "4 3 0 [1] 2", "twist example 2");
    r.twist(1);
    assert_eq!(format!("{}", r), "4 [3] 0 1 2", "twist example 3");
    r.twist(5);
    assert_eq!(format!("{}", r), "3 4 2 1 [0]", "twist example 4");
}
