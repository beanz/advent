use std::collections::HashSet;

fn valid(s: &str) -> bool {
    let mut seen_dup: HashSet<u8> = HashSet::new();
    let b: &[u8] = s.as_bytes();
    let mut has_straight = false;
    let mut has_bad = false;
    let mut num_pairs = 0;
    for i in 0..s.len() {
        if b[i] == b'i' || b[i] == b'o' || b[i] == b'l' {
            has_bad = true;
            break;
        }
        if i == s.len() - 1 {
            continue;
        }
        if b[i] == b[i + 1] && !seen_dup.contains(&b[i]) {
            seen_dup.insert(b[i]);
            num_pairs += 1;
        }
        if i == s.len() - 2 || has_straight {
            continue;
        }
        if b[i] + 1 == b[i + 1] && b[i] + 2 == b[i + 2] {
            has_straight = true;
        }
    }
    has_straight && !has_bad && num_pairs >= 2
}

pub struct PerlyString {
    b: Box<[u8]>,
    l: usize,
}

impl PerlyString {
    pub fn new(s: &str) -> PerlyString {
        let sb = s.as_bytes();
        let l = s.len();
        let mut b = (vec![0; l + 3]).into_boxed_slice();
        for i in 0..l {
            b[i] = sb[i];
        }
        PerlyString { b, l }
    }
    pub fn bytes(&self) -> &[u8] {
        &self.b[0..self.l]
    }
    pub fn string(&self) -> String {
        let s: String = self.b[0..self.l].iter().map(|x| *x as char).collect();
        s
    }
    pub fn inc(&mut self) {
        let mut i = self.l - 1;
        loop {
            self.b[i] += 1;
            if self.b[i] <= b'z' {
                return;
            }
            self.b[i] = b'a';
            i -= 1;
            if i == 0 {
                break;
            }
        }
        self.b[0] = b'a';
        self.b[self.l] = b'a';
        self.l += 1;
    }
}

pub fn next(s: &str) -> String {
    let mut perly = PerlyString::new(s);
    perly.inc();
    while !valid(&perly.string()) {
        perly.inc();
    }
    perly.string()
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let p1 = next(&inp);
        let p2 = next(&p1);
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
    fn valid_works() {
        assert_eq!(valid("hijklmmn"), false);
        assert_eq!(valid("abbceffg"), false);
        assert_eq!(valid("abbcegjk"), false);
        assert_eq!(valid("abcdffaa"), true);
        assert_eq!(valid("ghjaabcc"), true);
    }
    #[test]
    #[cfg_attr(not(feature = "slow_tests"), ignore)]
    fn next_works() {
        assert_eq!(next("abcdefgh"), "abcdffaa", "next(abcdffaa)");
        assert_eq!(next("ghijklmn"), "ghjaabcc", "next(ghijklmn)");
    }
}
