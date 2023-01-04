struct Set {
    intersect: usize,
    len: usize,
}

fn priority(ch: u8) -> usize {
    let p = ch - b'A';
    (if p > 26 { p - 31 } else { p + 27 }) as usize
}

impl Set {
    fn new() -> Set {
        Set {
            intersect: 0,
            len: 0,
        }
    }
    fn len(&self) -> usize {
        self.len
    }
    fn clear(&mut self) {
        self.len = 0;
        self.intersect = 0;
    }
    fn contains(&self, ch: u8) -> bool {
        let n = 1 << priority(ch);
        self.intersect & n != 0
    }
    fn add(&mut self, s: &[u8]) {
        let mut n = 0;
        for ch in s {
            n |= 1 << priority(*ch);
        }
        if self.len == 0 {
            self.intersect = n;
        } else {
            self.intersect &= n;
        }
        self.len += 1;
    }
    fn get(&self) -> usize {
        self.intersect.trailing_zeros() as usize
    }
}

use std::fmt;
impl fmt::Display for Set {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for ch in b'a'..=b'z' {
            if self.contains(ch) {
                write!(f, "{}", ch as char)?;
            }
        }
        for ch in b'A'..=b'Z' {
            if self.contains(ch) {
                write!(f, "{}", ch as char)?;
            }
        }
        Ok(())
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut s = Set::new();
    let mut p1 = 0;
    let mut p2 = 0;
    let mut i = 0;
    let mut j = 0;
    while i < inp.len() {
        if inp[i] == b'\n' {
            let k = (i + j) / 2;
            p1 += {
                let mut s = Set::new();
                s.add(&inp[j..k]);
                s.add(&inp[k..i]);
                s.get()
            };
            s.add(&inp[j..i]);
            if s.len() == 3 {
                p2 += s.get();
                s.clear();
            }
            j = i + 1;
        }
        i += 1;
    }
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
    fn priority_works() {
        assert_eq!(priority(b'p'), 16);
        assert_eq!(priority(b'L'), 38);
        assert_eq!(priority(b'P'), 42);
        assert_eq!(priority(b'v'), 22);
        assert_eq!(priority(b't'), 20);
        assert_eq!(priority(b's'), 19);
    }
    #[test]
    fn set_works() {
        let mut set = Set::new();
        set.add(b"vJrwpWtwJgWr");
        assert_eq!(format!("{}", set), "gprtvwJW");
        set.add(b"hcsFMMfFFhFp");
        assert_eq!(set.len(), 2);
        assert_eq!(set.get(), 16);
    }
    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/03/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (157, 70));
        let inp = std::fs::read("../2022/03/input.txt").expect("read error");
        assert_eq!(parts(&inp), (7428, 2650));
    }
}
