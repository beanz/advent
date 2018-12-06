use std::env;
use std::fs;
use std::collections::HashSet;

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
}
