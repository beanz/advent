use std::mem::swap;

fn calc(s: &str, rounds: i32) -> String {
    let mut cur: Vec<char> = s.chars().collect();
    let mut next: Vec<char> = Vec::new();
    for _ in 0..rounds {
        let mut n = 1;
        let mut ch = cur[0];
        for nch in cur.iter().skip(1) {
            if *nch == ch {
                n += 1;
            } else {
                let ns: Vec<char> = n.to_string().chars().collect();
                next.extend_from_slice(&ns);
                next.push(ch);
                ch = *nch;
                n = 1;
            }
        }
        let ns: Vec<char> = n.to_string().chars().collect();
        next.extend_from_slice(&ns);
        next.push(ch);
        swap(&mut cur, &mut next);
        next.clear();
    }
    let res: String = cur.iter().collect();
    res
}

fn main() {
    let inp = aoc::read_input_line();
    let s40 = calc(&inp, 40);
    println!("Part 1: {}", s40.len());
    let s50 = calc(&s40, 10);
    println!("Part 2: {}", s50.len());
}

#[test]
fn calc_works() {
    let results: Vec<&str> = vec!["11", "21", "1211", "111221", "312211"];
    let mut c = "1";
    for exp in results.iter() {
        assert_eq!(&calc(c, 1), exp, "{}", exp);
        c = exp;
    }
}
