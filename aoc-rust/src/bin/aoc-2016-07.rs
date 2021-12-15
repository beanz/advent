fn has_abba(s: &str) -> bool {
    s.chars()
        .collect::<Vec<char>>()
        .windows(4)
        .any(|c| c[0] != c[1] && c[0] == c[3] && c[1] == c[2])
}

#[test]
fn has_abba_works() {
    assert_eq!(has_abba("ioxxoj"), true, "has abba");
    assert_eq!(has_abba("abcd"), false, "no abba 1");
    assert_eq!(has_abba("gggg"), false, "no abba 2");
}

fn supports_tls(ip: &&String) -> bool {
    let segments = ip.split(|c| c == '[' || c == ']');
    segments.clone().step_by(2).any(has_abba)
        && !segments.skip(1).step_by(2).any(has_abba)
}

fn supports_ssl(ip: &&String) -> bool {
    let segments = ip.split(|c| c == '[' || c == ']');
    segments.clone().step_by(2).any(|s| {
        s.chars()
            .collect::<Vec<char>>()
            .windows(3)
            .filter(|c| c[0] != c[1] && c[0] == c[2])
            .map(|c| [c[1], c[0], c[1]].iter().collect::<String>())
            .any(|bab| {
                segments
                    .clone()
                    .skip(1)
                    .step_by(2)
                    .any(|inside| inside.contains(&bab))
            })
    })
}

fn count_ips(inp: &[String], validator: fn(&&String) -> bool) -> usize {
    inp.iter().filter(validator).count()
}

fn part1(inp: &[String]) -> usize {
    count_ips(inp, supports_tls)
}

fn part2(inp: &[String]) -> usize {
    count_ips(inp, supports_ssl)
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let p1 = part1(&inp);
        let p2 = part2(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[allow(dead_code)]
const EX1: [&str; 4] = [
    "abba[mnop]qrst",
    "abcd[bddb]xyyx",
    "aaaa[qwer]tyui",
    "ioxxoj[asdfgh]zxcvbn",
];

#[allow(dead_code)]
const EX2: [&str; 4] =
    ["aba[bab]xyz", "xyx[xyx]xyx", "aaa[kek]eke", "zazbz[bzb]cdb"];

#[test]
fn part1_works() {
    let e: Vec<String> =
        EX1.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    assert_eq!(part1(&e), 2, "part 1 example");
}

#[test]
fn part2_works() {
    let e: Vec<String> =
        EX2.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    assert_eq!(part2(&e), 3, "part 2 example");
}
