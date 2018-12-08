use std::env;
use std::fs;
use std::collections::HashMap;
use std::collections::HashSet;
use std::collections::VecDeque;
use regex::Regex;

fn f01a(contents: String) -> String {
    let sum = contents
        .split('\n')
        .map(|s: &str| s.parse::<i32>().unwrap())
        .fold(0, |acc: i32, x: i32| acc + x);
    return format!("{}", sum);
}

fn f01b(contents: String) -> String {
    let nums = contents
        .split('\n')
        .map(|s: &str| s.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();

    let mut s = 0;
    let mut seen = HashSet::<i32>::new();

    loop {
        for i in 0..nums.len() {
            s += nums[i];
            if seen.contains(&s) {
                return format!("{}", s);
            }
            seen.insert(s);
        }
    }
}

fn f02a(contents: String) -> String {
    let mut twos = 0;
    let mut threes = 0;
    for line in contents.lines() {
        let mut counts = HashMap::new();
        for c in line.chars() {
            let count = counts.entry(c).or_insert(0);
            *count += 1;
        }
        if counts.values().any(|&f| f == 2) {
            twos += 1;
        }
        if counts.values().any(|&f| f == 3) {
            threes += 1;
        }
    }
    return format!("{}", twos * threes);
}

fn common_characters(s1: &str, s2: &str) -> String {
   let mut res = String::new();
    for (c1, c2) in s1.chars().zip(s2.chars()) {
        if c1 == c2 {
            res.push(c1);
        }
    }
    return res;
}

fn f02b(contents: String) -> String {
    let lines: Vec<&str> = contents.lines().collect();
    for i in 0 .. lines.len() {
        for j in i .. lines.len() {
            let common = common_characters(lines[i], lines[j]);
            if common.len() == lines[i].len() - 1 {
                return format!("{}", common);
            }
        }
    }
    return "none?".to_owned();
}

struct Claim {
    id: u32,
    x: u32,
    y: u32,
    w: u32,
    d: u32,
}

type Grid = HashMap<(u32, u32), u32>;

fn read_claims(contents: String) -> Vec<Claim> {
    let re: Regex = Regex::new(r"(?x)
                \#
                (?P<id>[0-9]+)
                \s+@\s+
                (?P<x>[0-9]+),(?P<y>[0-9]+):
                \s+
                (?P<w>[0-9]+)x(?P<d>[0-9]+)
            ").unwrap();
    let mut claims: Vec<Claim> = vec![];
    for line in contents.lines() {
        let cap = match re.captures(line) {
            None => return vec![],
            Some(cap) => cap,
        };
        let claim = Claim{id: cap["id"].parse::<u32>().unwrap(),
                          x: cap["x"].parse::<u32>().unwrap(),
                          y: cap["y"].parse::<u32>().unwrap(),
                          w: cap["w"].parse::<u32>().unwrap(),
                          d: cap["d"].parse::<u32>().unwrap()};
        claims.push(claim)
    }
    return claims;
}

fn map_claims(claims: &Vec<Claim>) -> (Grid, i32) {
    let mut grid = Grid::new();
    let mut c = 0;
    for claim in claims {
        for x in claim.x .. claim.x + claim.w {
            for y in claim.y .. claim.y + claim.d {
                *grid.entry((x, y)).or_default() += 1;
                if *grid.get(&(x,y)).unwrap() == 2u32 {
                    c += 1;
                }
            }
        }
    }
    return (grid, c)
}

fn f03a(contents: String) -> String {
    let claims = read_claims(contents);
    let (_grid, c) = map_claims(&claims);
    return format!("{}", c);
}

fn f03b(contents: String) -> String {
    let claims = read_claims(contents);
    let (grid, _c) = map_claims(&claims);
    for claim in claims {
        let mut unique = true;
        for x in claim.x .. claim.x + claim.w {
            for y in claim.y .. claim.y + claim.d {
                if *grid.get(&(x,y)).unwrap() != 1u32 {
                    unique = false;
                    break;
                }
            }
        }
        if unique {
            return format!("{}", claim.id)
        }
    }
    return "none".to_owned();
}

type Counts = HashMap<i32, i32>;
type GuardMinutes = HashMap<(i32,i32), i32>;
type MaxMinutes = HashMap<i32, i32>;

fn f04a(contents: String) -> String {
    let line_re: Regex = Regex::new(r"(\d{2})\] (.*)").unwrap();
    let guard_re: Regex = Regex::new(r"Guard #(\d+)").unwrap();
    let mut lines = contents.lines().collect::<Vec<&str>>();
    lines.sort();
    let mut start = 0;
    let mut guard_id = -1;
    let mut max_id = -1;
    let mut counts = Counts::new();
    let mut guard_mins = GuardMinutes::new();
    let mut max_mins = MaxMinutes::new();
    for line in &lines {
        let caps = line_re.captures(line).unwrap();
        let minute = caps.get(1).unwrap().as_str().parse::<i32>().unwrap();
        let event = caps.get(2).unwrap().as_str();
        //println!("{} {}", minute, event);
        match event {
            "falls asleep" => start = minute,
            "wakes up" => {
                *counts.entry(guard_id).or_default() += minute-start;
                if max_id == -1 ||
                    *counts.get(&guard_id).unwrap() > *counts.get(&max_id).unwrap() {
                    max_id = guard_id;
                }
                for min in start..minute {
                    *guard_mins.entry((guard_id,min)).or_default() += 1;
                    let max_min = *max_mins.get(&guard_id).unwrap_or(&-1i32);
                    if max_min == -1 || *guard_mins.get(&(guard_id,min)).unwrap() > *guard_mins.get(&(guard_id,max_min)).unwrap() {
                        *max_mins.entry(guard_id).or_default() = min
                    }
                }
            },
            _ => {
                let guard_caps = guard_re.captures(event).unwrap();
                guard_id = guard_caps.get(1).unwrap().as_str()
                    .parse::<i32>().unwrap();
            }
        }
    }
    return format!("{}", max_id * *max_mins.get(&max_id).unwrap() as i32);
}

fn f04b(contents: String) -> String {
    let line_re: Regex = Regex::new(r"(\d{2})\] (.*)").unwrap();
    let guard_re: Regex = Regex::new(r"Guard #(\d+)").unwrap();
    let mut lines = contents.lines().collect::<Vec<&str>>();
    lines.sort();
    let mut start = 0;
    let mut guard_id = -1;
    let mut max_id = -1;
    let mut max_min = -1;
    let mut guard_mins = GuardMinutes::new();
    for line in &lines {
        let caps = line_re.captures(line).unwrap();
        let minute = caps.get(1).unwrap().as_str().parse::<i32>().unwrap();
        let event = caps.get(2).unwrap().as_str();
        //println!("{} {}", minute, event);
        match event {
            "falls asleep" => start = minute,
            "wakes up" => {
                for min in start..minute {
                    *guard_mins.entry((guard_id,min)).or_default() += 1;
                    if max_min == -1 || *guard_mins.get(&(guard_id,min)).unwrap() > *guard_mins.get(&(max_id,max_min)).unwrap() {
                        max_id = guard_id;
                        max_min = min;
                    }
                }
            },
            _ => {
                let guard_caps = guard_re.captures(event).unwrap();
                guard_id = guard_caps.get(1).unwrap().as_str()
                    .parse::<i32>().unwrap();
            }
        }
    }
    return format!("{}", max_id * max_min);
}

fn react(poly: &str) -> String {
    let pat = regex::Regex::new(r"aA|bB|cC|dD|eE|fF|gG|hH|iI|jJ|kK|lL|mM|nN|oO|pP|qQ|rR|sS|tT|uU|vV|wW|xX|yY|zZ|Aa|Bb|Cc|Dd|Ee|Ff|Gg|Hh|Ii|Jj|Kk|Ll|Mm|Nn|Oo|Pp|Qq|Rr|Ss|Tt|Uu|Vv|Ww|Xx|Yy|Zz").unwrap();
    let mut p = poly.to_owned();
    loop {
        let n = pat.replace_all(&p, "").to_string();
        if n == p {
            return n;
        }
        p = n;
    }
}

fn f05a(contents: String) -> String {
    let lines = contents.lines().collect::<Vec<&str>>();
    let poly = react(lines[0]);
    return format!("{}", poly.len());
}

fn f05b(contents: String) -> String {
    let lines = contents.lines().collect::<Vec<&str>>();
    let line = lines[0];
    let mut min = line.len();
    for (lower, upper) in [('a', 'A'), ('b', 'B'), ('c', 'C'), ('d', 'D'),
                           ('e', 'E'), ('f', 'F'), ('g', 'G'), ('h', 'H'),
                           ('i', 'I'), ('j', 'J'), ('k', 'K'), ('l', 'L'),
                           ('m', 'M'), ('n', 'N'), ('o', 'O'), ('p', 'P'),
                           ('q', 'Q'), ('r', 'R'), ('s', 'S'), ('t', 'T'),
                           ('u', 'U'), ('v', 'V'), ('w', 'W'), ('x', 'X'),
                           ('y', 'Y'), ('z', 'Z')].iter() {
        let stripped = line.replace(*lower, "").replace(*upper, "");
        let l = react(&stripped).len();
        if l < min {
            min = l
        }
    }
    return format!("{}", min);
}

fn f08a_parse(e: &mut VecDeque<i32>) -> i32 {
    let mut s = 0;
    let c = match e.pop_front() { Some(x) => x, None => 0 };
    let m = match e.pop_front() { Some(x) => x, None => 0 };
    for _i in 0..c {
        s += f08a_parse(e);
    }
    for _i in 0..m {
        s += match e.pop_front() { Some(x) => x, None => 0 };
    }
    return s;
}

fn f08a(contents: String) -> String {
    let lines = contents.lines().collect::<Vec<&str>>();
    let mut e = lines[0].split(' ').map(|s: &str| s.parse::<i32>().unwrap())
        .collect::<VecDeque<i32>>();

    return format!("{}", f08a_parse(&mut e));
}

fn f08b_parse(e: &mut VecDeque<i32>) -> i32 {
    let mut s = 0;
    let c = match e.pop_front() { Some(x) => x, None => 0 };
    let m = match e.pop_front() { Some(x) => x, None => 0 };
    if c > 0 {
        let mut cc: Vec<i32> = vec![];
        for _i in 0..c {
            cc.push(f08b_parse(e));
        }
        for _i in 0..m {
            let me = match e.pop_front() { Some(x) => x, None => 0 };
            if me <= cc.len() as i32 {
                s += cc[(me-1) as usize];
            }
        }
    } else {
        for _i in 0..m {
            s += match e.pop_front() { Some(x) => x, None => 0 };
        }
    }
    return s;
}

fn f08b(contents: String) -> String {
    let lines = contents.lines().collect::<Vec<&str>>();
    let mut e = lines[0].split(' ').map(|s: &str| s.parse::<i32>().unwrap())
        .collect::<VecDeque<i32>>();

    return format!("{}", f08b_parse(&mut e));
}

fn f_unknown(_contents: String) -> String {
    return "unknown command".to_owned();
}

fn main() {

    let args: Vec<String> = env::args().collect();

    let command = &args[1];
    let filename = &args[2];
    let mut contents = fs::read_to_string(filename)
        .expect("Something went wrong reading the file");
    contents.pop();
    let command_str = &command[..];
    let fun = match command_str {
        "01a" => f01a,
        "01b" => f01b,
        "02a" => f02a,
        "02b" => f02b,
        "03a" => f03a,
        "03b" => f03b,
        "04a" => f04a,
        "04b" => f04b,
        "05a" => f05a,
        "05b" => f05b,
        "08a" => f08a,
        "08b" => f08b,
        _ => f_unknown,
    };
    println!("{}", fun(contents));
}

#[cfg(test)]
mod tests {
    use super::*;

    fn run(f: fn(String) -> String, filename: &str) -> String {
        let mut contents = fs::read_to_string(filename)
            .expect("Something went wrong reading the file");
        contents.pop();
        return f(contents);
    }

    #[test]
    fn test_01() {
        assert_eq!(run(f01a, "01/test.txt"), "3");
        assert_eq!(run(f01a, "01/input.txt"), "505");
        assert_eq!(run(f01b, "01/test.txt"), "2");
        assert_eq!(run(f01b, "01/input.txt"), "72330");
    }

    #[test]
    fn test_02() {
        assert_eq!(run(f02a, "02/test-1.txt"), "12");
        assert_eq!(run(f02a, "02/input.txt"), "9633");
        assert_eq!(run(f02b, "02/test-2.txt"), "fgij");
        assert_eq!(run(f02b, "02/input.txt"), "lujnogabetpmsydyfcovzixaw");
    }
    #[test]
    fn test_03() {
        assert_eq!(run(f03a, "03/test.txt"), "4");
        assert_eq!(run(f03a, "03/input.txt"), "106501");
        assert_eq!(run(f03b, "03/test.txt"), "3");
        assert_eq!(run(f03b, "03/input.txt"), "632");
    }
    #[test]
    fn test_04() {
        assert_eq!(run(f04a, "04/test.txt"), "240");
        assert_eq!(run(f04a, "04/input.txt"), "71748");
        assert_eq!(run(f04b, "04/test.txt"), "4455");
        assert_eq!(run(f04b, "04/input.txt"), "106850");
    }

    #[test]
    fn test_05() {
        assert_eq!(run(f05a, "05/test.txt"), "10");
        assert_eq!(run(f05a, "05/input.txt"), "11264");
        assert_eq!(run(f05b, "05/test.txt"), "4");
        assert_eq!(run(f05b, "05/input.txt"), "4552");
    }

    #[test]
    fn test_08() {
        assert_eq!(run(f08a, "08/test.txt"), "138");
        assert_eq!(run(f08a, "08/input.txt"), "42798");
        assert_eq!(run(f08b, "08/test.txt"), "66");
        assert_eq!(run(f08b, "08/input.txt"), "23798");
    }
}
