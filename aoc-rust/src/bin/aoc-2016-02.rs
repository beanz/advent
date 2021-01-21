use std::collections::HashMap;

struct Keypad {
    moves: HashMap<(char, char), char>,
}

impl Keypad {
    fn new(keys: Vec<&str>) -> Keypad {
        let mut moves: HashMap<(char, char), char> = HashMap::new();
        for kl in keys {
            let mut spec = kl.chars();
            let key = spec.next().unwrap();
            for dir in &['U', 'D', 'L', 'R'] {
                moves.insert((key, *dir), spec.next().unwrap());
            }
        }
        Keypad { moves }
    }
    fn part1() -> Keypad {
        Keypad::new(vec![
            "11412", "22513", "33623", "41745", "52846", "63956", "74778",
            "85879", "96989",
        ])
    }
    fn part2() -> Keypad {
        Keypad::new(vec![
            "11311", "22623", "31724", "44834", "55556", "62A57", "73B68",
            "84C79", "99989", "A6AAB", "B7DAC", "C8CBC", "DBDDD",
        ])
    }
    fn calc(&self, inp: &[String]) -> String {
        let mut res = "".to_string();
        let mut prev = '5';
        for l in inp {
            let new = l
                .chars()
                .fold(prev, |a, dir| *self.moves.get(&(a, dir)).unwrap());
            res.push(new);
            prev = new;
        }
        res
    }
}

fn main() {
    let lines: Vec<String> = aoc::input_lines();
    println!("Part 1: {}", Keypad::part1().calc(&lines));
    println!("Part 2: {}", Keypad::part2().calc(&lines));
}

#[test]
fn part1_works() {
    let lines = vec![
        "ULL".to_string(),
        "RRDDD".to_string(),
        "LURDL".to_string(),
        "UUUUD".to_string(),
    ];
    assert_eq!(Keypad::part1().calc(&lines), "1985", "part 1 example");
}

#[test]
fn part2_works() {
    let lines = vec![
        "ULL".to_string(),
        "RRDDD".to_string(),
        "LURDL".to_string(),
        "UUUUD".to_string(),
    ];
    assert_eq!(Keypad::part2().calc(&lines), "5DB3", "part 2 example");
}
