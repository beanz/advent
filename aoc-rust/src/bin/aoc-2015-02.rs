pub fn calc(v: Vec<i32>) -> (i32, i32) {
    return (
        3 * (v[0] * v[1]) + 2 * (v[1] * v[2] + v[0] * v[2]),
        2 * (v[0] + v[1]) + v.iter().product::<i32>(),
    );
}

pub fn parse_line(l: &str) -> Vec<i32> {
    let mut v = l
        .split('x')
        .map(|x| x.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();
    v.sort_unstable();
    v
}

fn main() {
    let inp = aoc::read_input_lines().map(|l| parse_line(&l.unwrap()));
    let (p1, p2) = inp
        .map(calc)
        .fold((0, 0), |(a1, a2), (b1, b2)| (a1 + b1, a2 + b2));
    println!("Part 1: {}", p1);
    println!("Part 2: {}", p2);
}

#[test]
fn parse_line_works() {
    for &(inp, exp) in [("2x4x3", "[2, 3, 4]"), ("1x10x1", "[1, 1, 10]")].iter() {
        assert_eq!(
            format!("{:?}", parse_line(&inp.to_string())),
            exp,
            "{}",
            inp
        );
    }
}

#[test]
fn calc_works() {
    for &(inp, exp) in [("2x3x4", (58, 34)), ("1x1x10", (43, 14))].iter() {
        assert_eq!(calc(parse_line(&inp.to_string())), exp, "{}", inp);
    }
}