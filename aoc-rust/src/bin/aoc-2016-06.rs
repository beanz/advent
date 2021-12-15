use itertools::Itertools;

fn calc(inp: &[String], mul: isize) -> String {
    (0..inp[0].len())
        .map(|i| {
            let chs = inp.iter().map(|l| l.chars().nth(i).unwrap());
            chs.clone()
                .unique()
                .max_by_key(|x| {
                    chs.clone().filter(|y| y == x).count() as isize * mul
                })
                .unwrap()
        })
        .collect::<String>()
}

fn part1(inp: &[String]) -> String {
    calc(inp, 1)
}

fn part2(inp: &[String]) -> String {
    calc(inp, -1)
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
const EX: [&str; 16] = [
    "eedadn", "drvtee", "eandsr", "raavrd", "atevrs", "tsrnev", "sdttsa",
    "rasrtv", "nssdts", "ntnada", "svetve", "tesnvt", "vntsnd", "vrdear",
    "dvrsen", "enarar",
];

#[test]
fn part1_works() {
    let e: Vec<String> =
        EX.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    assert_eq!(part1(&e), "easter", "part 1 example");
}

#[test]
fn part2_works() {
    let e: Vec<String> =
        EX.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    assert_eq!(part2(&e), "advent", "part 2 example");
}
