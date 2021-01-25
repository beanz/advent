use itertools::*;

fn swap_by_index(s: &mut Vec<char>, i: usize, j: usize) {
    s.swap(i, j);
}

#[test]
fn swap_by_index_works() {
    let mut s = vec!['a', 'b', 'c', 'd', 'e'];
    swap_by_index(&mut s, 4, 0);
    assert_eq!(s, vec!['e', 'b', 'c', 'd', 'a'], "swap by index example");
}

fn swap_by_letter(s: &mut Vec<char>, c1: char, c2: char) {
    for el in s.iter_mut() {
        if *el == c1 {
            *el = c2;
        } else if *el == c2 {
            *el = c1;
        }
    }
}

#[test]
fn swap_by_letter_works() {
    let mut s = vec!['e', 'b', 'c', 'd', 'a'];
    swap_by_letter(&mut s, 'b', 'd');
    assert_eq!(s, vec!['e', 'd', 'c', 'b', 'a'], "swap by letter example");
}

fn reverse_slice(s: &mut Vec<char>, i: usize, j: usize) {
    s[i..=j].reverse();
}

#[test]
fn reverse_slice_works() {
    let mut s = vec!['e', 'd', 'c', 'b', 'a'];
    reverse_slice(&mut s, 0, 4);
    assert_eq!(s, vec!['a', 'b', 'c', 'd', 'e'], "reverse example");
}

fn rotate(s: &mut Vec<char>, n: isize) {
    if n > 0 {
        s.rotate_left(n as usize);
    } else {
        s.rotate_right(-n as usize);
    }
}

#[test]
fn rotate_works() {
    let mut s = vec!['a', 'b', 'c', 'd', 'e'];
    rotate(&mut s, 1);
    assert_eq!(s, vec!['b', 'c', 'd', 'e', 'a'], "rotate left example");
    rotate(&mut s, -1);
    assert_eq!(s, vec!['a', 'b', 'c', 'd', 'e'], "rotate right");
}

fn move_ch(s: &mut Vec<char>, i: usize, j: usize) {
    let t = s.remove(i);
    s.insert(j, t);
}

#[test]
fn move_works() {
    let mut s = vec!['b', 'c', 'd', 'e', 'a'];
    move_ch(&mut s, 1, 4);
    assert_eq!(s, vec!['b', 'd', 'e', 'a', 'c'], "move example 1");
    move_ch(&mut s, 3, 0);
    assert_eq!(s, vec!['a', 'b', 'd', 'e', 'c'], "move example 2");
}

fn rotate_by_ch(s: &mut Vec<char>, c1: char) {
    let mut i = 0;
    while s[i] != c1 {
        i += 1;
    }
    if i >= 4 {
        i += 1;
    }
    i += 1;
    i %= s.len();
    rotate(s, -(i as isize));
}

#[test]
fn rotate_by_ch_works() {
    let mut s = vec!['a', 'b', 'd', 'e', 'c'];
    rotate_by_ch(&mut s, 'b');
    assert_eq!(
        s,
        vec!['e', 'c', 'a', 'b', 'd'],
        "rotate by letter example 1"
    );
    rotate_by_ch(&mut s, 'd');
    assert_eq!(
        s,
        vec!['d', 'e', 'c', 'a', 'b'],
        "rotate by letter example 2"
    );
}

enum Op {
    Swap(usize, usize),
    SwapC(char, char),
    Rotate(isize),
    RotateC(char),
    Reverse(usize, usize),
    Move(usize, usize),
}

impl Op {
    fn new(s: &str) -> Op {
        let uints: Vec<usize> = aoc::uints::<usize>(&s).collect();
        let mut words = s.split(' ');
        match words.next().unwrap() {
            "swap" => match words.next().unwrap() {
                "position" => Op::Swap(uints[0], uints[1]),
                "letter" => Op::SwapC(
                    words.next().unwrap().chars().next().unwrap(),
                    words.nth(2).unwrap().chars().next().unwrap(),
                ),
                _ => panic!("invalid swap op: {}", s),
            },
            "rotate" => match words.next().unwrap() {
                "left" => Op::Rotate(uints[0] as isize),
                "right" => Op::Rotate(-(uints[0] as isize)),
                "based" => {
                    Op::RotateC(words.nth(4).unwrap().chars().next().unwrap())
                }
                _ => panic!("invalid rotate op: {}", s),
            },
            "reverse" => Op::Reverse(uints[0], uints[1]),
            "move" => Op::Move(uints[0], uints[1]),
            _ => panic!("invalid op: {}", s),
        }
    }
    fn apply(&self, s: &mut Vec<char>) {
        match self {
            Op::Swap(i, j) => swap_by_index(s, *i, *j),
            Op::SwapC(a, b) => swap_by_letter(s, *a, *b),
            Op::Rotate(n) => rotate(s, *n),
            Op::RotateC(ch) => rotate_by_ch(s, *ch),
            Op::Reverse(i, j) => reverse_slice(s, *i, *j),
            Op::Move(i, j) => move_ch(s, *i, *j),
        }
    }
}

fn part1(ops: &[Op], st: &str) -> String {
    let mut s = st.chars().collect::<Vec<char>>();
    for op in ops {
        op.apply(&mut s);
    }
    s.iter().collect::<String>()
}

#[allow(dead_code)]
const EX: [&str; 8] = [
    "swap position 4 with position 0",
    "swap letter d with letter b",
    "reverse positions 0 through 4",
    "rotate left 1 step",
    "move position 1 to position 4",
    "move position 3 to position 0",
    "rotate based on position of letter b",
    "rotate based on position of letter d",
];

#[test]
fn part1_works() {
    let ops = EX.iter().map(|l| Op::new(l)).collect::<Vec<Op>>();
    assert_eq!(part1(&ops, "abcde"), "decab", "part 1 complete example");
}

fn part2(ops: &[Op], st: &str) -> String {
    let alpha = vec!['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h'];
    for p in alpha.iter().permutations(8) {
        let plain = p.iter().copied().collect::<String>();
        let scram = part1(&ops, &plain);
        if scram == st {
            return plain;
        }
    }
    "unsolved".to_string()
}

fn main() {
    let inp = aoc::input_lines();
    let ops = inp.iter().map(|l| Op::new(l)).collect::<Vec<Op>>();
    println!("Part 1: {}", part1(&ops, "abcdefgh"));
    println!("Part 1: {}", part2(&ops, "fbgdceah"));
}
