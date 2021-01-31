use std::collections::HashMap;
use std::fmt;

struct Programs {
    p: Vec<char>,
}

impl fmt::Display for Programs {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}", self.p.iter().collect::<String>())
    }
}

impl Programs {
    fn new(end: char) -> Programs {
        Programs {
            p: ('a'..=end).collect(),
        }
    }
    fn spin(&mut self, i: usize) {
        self.p.rotate_right(i);
    }
    fn swap(&mut self, i: usize, j: usize) {
        self.p.swap(i, j);
    }
    fn swap_ch(&mut self, a: char, b: char) {
        for el in self.p.iter_mut() {
            if *el == a {
                *el = b;
            } else if *el == b {
                *el = a;
            }
        }
    }
    fn dance(&mut self, inp: &[String]) {
        for l in inp {
            let mut chs = l.chars();
            let ints = aoc::uints::<usize>(l).collect::<Vec<usize>>();
            match chs.next().unwrap() {
                's' => self.spin(ints[0]),
                'x' => self.swap(ints[0], ints[1]),
                'p' => self.swap_ch(chs.next().unwrap(), chs.nth(1).unwrap()),
                _ => panic!("dance: invalid move: {}", l),
            }
        }
    }
}

#[test]
fn programs_works() {
    let mut p = Programs::new('e');
    p.spin(1);
    assert_eq!(format!("{}", p), "eabcd");
    p.swap(3, 4);
    assert_eq!(format!("{}", p), "eabdc");
    p.swap_ch('e', 'b');
    assert_eq!(format!("{}", p), "baedc");
    let mut p2 = Programs::new('e');
    p2.dance(&["s1".to_string(), "x3/4".to_string(), "pe/b".to_string()]);
    assert_eq!(format!("{}", p2), "baedc");
}

fn part2(ch: char, moves: &[String]) -> String {
    let mut p = Programs::new(ch);
    const END: usize = 10_000_000;
    let mut seen: HashMap<String, usize> = HashMap::new();
    let mut c = 1;
    let mut cycle_found = false;
    while c <= END {
        p.dance(&moves);
        let k = format!("{}", p);
        if !cycle_found {
            if let Some(prev) = seen.get(&k) {
                let remaining = END - c;
                let cycle_len = c - prev;
                c += (remaining / cycle_len) * cycle_len;
                cycle_found = true;
            }
        }
        seen.insert(k, c);
        c += 1;
    }
    format!("{}", p)
}

#[test]
fn part2_works() {
    assert_eq!(
        part2(
            'e',
            &["s1".to_string(), "x3/4".to_string(), "pe/b".to_string()]
        ),
        "abcde"
    );
}

fn main() {
    let moves = aoc::read_input_line()
        .split(',')
        .map(|x| x.to_string())
        .collect::<Vec<String>>();
    let mut p = Programs::new('p');
    p.dance(&moves);
    println!("Part 1: {}", p);
    println!("Part 2: {}", part2('p', &moves));
}
