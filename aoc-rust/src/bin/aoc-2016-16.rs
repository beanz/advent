use std::fmt;

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash)]
struct Dragon {
    a: Vec<bool>,
}

impl fmt::Display for Dragon {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let res = self
            .a
            .iter()
            .map(|b| if *b { '1' } else { '0' })
            .collect::<String>();
        write!(f, "{}", res)
    }
}

impl Dragon {
    fn new(s: &str) -> Dragon {
        Dragon {
            a: s.chars().map(|c| c == '1').collect::<Vec<bool>>(),
        }
    }
    fn dragon(&mut self) {
        let l = self.a.len();
        self.a.reserve(l + 1);
        self.a.push(false);
        for i in (0..l).rev() {
            self.a.push(!self.a[i]);
        }
    }
    fn extend(&mut self, l: usize) {
        while self.a.len() < l {
            self.dragon();
        }
        self.a.resize(l, false);
    }
    fn checksum(&mut self) {
        while (self.a.len() % 2) == 0 {
            for i in 0..(self.a.len() / 2) {
                self.a[i] = self.a[i * 2] == self.a[i * 2 + 1];
            }
            self.a.resize(self.a.len() / 2, false)
        }
    }
}

#[test]
fn dragon_works() {
    for tc in &[
        ("1", "100"),
        ("0", "001"),
        ("11111", "11111000000"),
        ("111100001010", "1111000010100101011110000"),
    ] {
        let mut d = Dragon::new(&tc.0.to_string());
        d.dragon();
        assert_eq!(format!("{}", d), tc.1, "dragon of \"{}\"", tc.0);
    }
}

#[test]
fn extend_works() {
    let mut d = Dragon::new(&"10000".to_string());
    d.extend(20);
    assert_eq!(
        format!("{}", d),
        "10000011110010000111",
        "extend to length 20"
    );
}

#[test]
fn checksum_works() {
    let mut d = Dragon::new(&"110010110100".to_string());
    d.checksum();
    assert_eq!(format!("{}", d), "100", "example checksum");
}

fn part1(init: &str, l: usize) -> Dragon {
    let mut d = Dragon::new(init);
    d.extend(l);
    d.checksum();
    d
}

#[test]
fn part1_works() {
    assert_eq!(
        format!("{}", part1(&"10000".to_string(), 20)),
        "01100",
        "part 1 works"
    );
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let p1 = part1(&inp, 272);
        let p2 = part1(&inp, 35651584);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
