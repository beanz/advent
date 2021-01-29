use std::fmt;

struct Rope {
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
    fn new(len: usize) -> Rope {
        let rope: Vec<u8> = (0..len).map(|x| x as u8).collect::<Vec<u8>>();
        Rope {
            rope,
            cur: 0,
            skip: 0,
        }
    }
    fn twist(&mut self, i: usize) {
        self.rope.rotate_left(self.cur);
        self.rope[0..i].reverse();
        self.rope.rotate_right(self.cur);
        self.cur = (self.cur + i + self.skip) % self.rope.len();
        self.skip += 1;
    }
    fn product(&self) -> usize {
        self.rope[0] as usize * self.rope[1] as usize
    }
    fn dense_hash(&self) -> String {
        self.rope
            .chunks(16)
            .map(|ch| ch.iter().fold(0, |a, v| a ^ v))
            .map(|x| format!("{:02x?}", x))
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

fn part1(l: &str, len: usize) -> usize {
    let mut r = Rope::new(len);
    for pos in aoc::uints::<usize>(&l) {
        r.twist(pos);
    }
    r.product()
}

#[test]
fn part1_works() {
    assert_eq!(part1("3,4,1,5", 5), 12);
}

fn part2(l: &str) -> String {
    let mut r = Rope::new(256);
    let positions = l
        .as_bytes()
        .iter()
        .chain(&[17u8, 31, 73, 47, 23])
        .map(|x| *x as usize);
    for _ in 0..64 {
        for pos in positions.clone() {
            r.twist(pos);
        }
    }
    r.dense_hash()
}

fn main() {
    let inp = aoc::read_input_line();
    println!("Part 1: {}", part1(&inp, 256));
    println!("Part 2: {}", part2(&inp));
}

#[test]
fn part2_works() {
    for tc in &[
        ("", "a2582a3a0e66e6e86e3812dcb672a272"),
        ("AoC 2017", "33efeb34ea91902bb2f59c9920caa6cd"),
        ("1,2,3", "3efbe78a8d82f29979031a4aa0b16a9d"),
        ("1,2,4", "63960835bcdc130f0b66d7ff4f6a5a8e"),
    ] {
        assert_eq!(part2(tc.0), tc.1, "{}", tc.0);
    }
}
