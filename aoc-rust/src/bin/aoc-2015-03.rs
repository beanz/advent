use aoc::Point;
use std::collections::HashSet;

pub fn calc(l: &str) -> (usize, usize) {
    let mut v1 = HashSet::new();
    let mut v2 = HashSet::new();
    let mut p1p = Point::new(0, 0);
    let mut p2p = [Point::new(0, 0), Point::new(0, 0)];
    v1.insert(p1p);
    v2.insert(p2p[0]);
    for (i, ch) in l.chars().enumerate() {
        p1p.mov(ch);
        v1.insert(p1p);
        p2p[i % 2].mov(ch);
        v2.insert(p2p[i % 2]);
    }
    (v1.len(), v2.len())
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let (p1, p2) = calc(&inp);
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
    fn calc_works() {
        for &(inp, exp) in [
            (">", (2, 2)),
            ("^v", (2, 3)),
            ("^>v<", (4, 3)),
            ("^v^v^v^v^v", (2, 11)),
        ]
        .iter()
        {
            assert_eq!(calc(&inp.to_string()), exp, "{}", inp);
        }
    }
}
