use aoc::Point;
use std::collections::HashSet;

pub fn calc(l: String) -> (usize, Option<usize>) {
    let mut visited = HashSet::new();
    let mut p = Point::new(0, 0);
    let mut dir = Point::new(0, -1);
    let mut p2: Option<usize> = None;
    visited.insert(p);
    for mv in l.split(", ") {
        match &mv[0..1] {
            "R" => dir.cw(),
            "L" => dir.ccw(),
            _ => {
                panic!("invalid rotation: {}", mv)
            }
        }
        for _ in 1..=mv[1..].parse::<usize>().unwrap() {
            p.movdir(dir, 1);
            if visited.contains(&p) && p2 == None {
                p2 = Some(p.manhattan());
            }
            visited.insert(p);
        }
    }
    (p.manhattan(), p2)
}

fn main() {
    let inp = aoc::read_input_line();
    let (p1, p2) = calc(inp);
    println!("Part 1: {}", p1);
    println!("Part 2: {}", p2.unwrap());
}

#[test]
fn calc_works() {
    for &(inp, exp) in [
        ("R2, L3", (5, None)),
        ("R2, R2, R2", (2, None)),
        ("R5, L5, R5, R3", (12, None)),
        ("R8, R4, R4, R8", (8, Some(4))),
    ]
    .iter()
    {
        assert_eq!(calc(inp.to_string()), exp, "calc: {}", inp);
    }
}
