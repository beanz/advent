pub fn calc(s: &str) -> (i32, i32) {
    let mut c1: i32 = -2;
    let mut c2: i32 = 2;
    let chs: Vec<char> = s.chars().collect();
    let mut i: usize = 0;
    while i < s.len() {
        let ch = chs[i];
        c1 += 1;
        if ch == '\\' {
            let esc = chs[i + 1];
            match esc {
                '\\' | '"' => {
                    i += 1;
                    c2 += 2;
                }
                'x' => {
                    i += 3;
                    c2 += 1;
                }
                _ => panic!("Invalid escape {}", esc),
            }
        } else if ch == '"' {
            c2 += 1;
        }
        i += 1;
    }
    (s.len() as i32 - c1, c2)
}

fn main() {
    let (p1, p2) = aoc::input_lines()
        .iter()
        .map(|x| calc(&x))
        .fold((0, 0), |(a1, a2), (b1, b2)| (a1 + b1, a2 + b2));
    println!("Part 1: {}", p1);
    println!("Part 2: {}", p2);
}

#[test]
fn calc_works() {
    for &(inp, exp) in [
        ("\"\"", (2 - 0, 6 - 2)),
        ("\"abc\"", (5 - 3, 9 - 5)),
        ("\"aaa\\\"aaa\"", (10 - 7, 16 - 10)),
        ("\"\\x27\"", (6 - 1, 11 - 6)),
        ("\"h\\\\\"", (5 - 2, 11 - 5)),
    ]
    .iter()
    {
        assert_eq!(calc(&inp.to_string()), exp, "{}", inp);
    }
}
