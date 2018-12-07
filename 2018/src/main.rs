use std::env;
use std::fs;
use std::collections::HashMap;
use std::collections::HashSet;
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
}
