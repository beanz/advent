use std::env;
use std::fmt;
use std::fs;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::str;

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
    return s
        .split(|c| !(c == '-' || ('0'..='9').contains(&c)))
        .filter(|x| !x.is_empty() && *x != "-")
        .map(|x| x.parse::<T>().unwrap());
}

pub fn uints<T>(s: &str) -> impl Iterator<Item = T> + '_
where
    T: num::Integer + std::str::FromStr,
    <T as std::str::FromStr>::Err: std::fmt::Debug,
{
    return s
        .split(|c| !('0'..='9').contains(&c))
        .filter(|x| !x.is_empty())
        .map(|x| x.parse::<T>().unwrap());
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
