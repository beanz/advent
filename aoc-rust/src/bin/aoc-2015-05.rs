pub fn nice(s: &str) -> (bool, bool) {
    let mut vowel_count = 0;
    let mut has_double = false;
    let mut bad_pair = false;
    let mut dup_pair = false;
    let mut sep_repeat = false;
    let b: &[u8] = s.as_bytes();
    for i in 0..s.len() {
        if b[i] == b'a' || b[i] == b'e' || b[i] == b'i' || b[i] == b'o' || b[i] == b'u' {
            vowel_count += 1;
        }
        if i == s.len() - 1 {
            continue;
        }
        if b[i] == b[i + 1] {
            has_double = true;
        }
        if (b[i] == b'a' && b[i + 1] == b'b')
            || (b[i] == b'c' && b[i + 1] == b'd')
            || (b[i] == b'p' && b[i + 1] == b'q')
            || (b[i] == b'x' && b[i + 1] == b'y')
        {
            bad_pair = true;
        }
        for j in i + 2..s.len() - 1 {
            if b[i] == b[j] && b[i + 1] == b[j + 1] {
                dup_pair = true;
                break;
            }
        }
        if i == s.len() - 2 {
            continue;
        }
        if b[i] == b[i + 2] {
            sep_repeat = true;
        }
    }
    (
        vowel_count >= 3 && has_double && !bad_pair,
        dup_pair && sep_repeat,
    )
}

pub fn calc(lines: std::io::Lines<std::io::BufReader<std::fs::File>>) -> (usize, usize) {
    let mut p1: usize = 0;
    let mut p2: usize = 0;
    for l in lines.map(|x| x.unwrap()) {
        let (b1, b2) = nice(&l);
        if b1 {
            p1 += 1;
        }
        if b2 {
            p2 += 1;
        }
    }
    (p1, p2)
}

fn main() {
    let inp = aoc::read_input_lines();
    let (p1, p2) = calc(inp);
    println!("Part 1: {}", p1);
    println!("Part 2: {}", p2);
}

#[test]
fn nice_works() {
    for &(inp, exp) in [
        ("ugknbfddgicrmopn", (true, false)),
        ("aaa", (true, false)),
        ("jchzalrnumimnmhp", (false, false)),
        ("haegwjzuvuyypxyu", (false, false)),
        ("dvszwmarrgswjxmb", (false, false)),
        ("qjhvhtzxzqqjkmpb", (false, true)),
        ("xxyxx", (false, true)),
        ("uurcxstgmygtbstg", (false, false)),
        ("ieodomkazucvgmuy", (false, false)),
    ]
    .iter()
    {
        assert_eq!(nice(inp), exp, "{}", inp);
    }
}
