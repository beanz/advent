fn part1(inp: &[String]) -> isize {
    let mut x: isize = 0;
    let mut y: isize = 0;
    for l in inp {
        let lb: &[u8] = l.as_bytes();
        match lb[0] {
            102 => x += (lb[8] - 48) as isize,
            117 => y -= (lb[3] - 48) as isize,
            100 => y += (lb[5] - 48) as isize,
            _ => (),
        }
    }
    return x * y;
}

fn part2(inp: &[String]) -> isize {
    let mut x: isize = 0;
    let mut a: isize = 0;
    let mut y: isize = 0;
    for l in inp {
        let lb: &[u8] = l.as_bytes();
        match lb[0] {
            102 => {
                let n = (lb[8] - 48) as isize;
                x += n;
                y += n * a;
            }
            117 => a -= (lb[3] - 48) as isize,
            100 => a += (lb[5] - 48) as isize,
            _ => (),
        }
    }
    return x * y;
}

fn main() {
    let inp = aoc::input_lines();
    println!("Part 1: {}", part1(&inp));
    println!("Part 2: {}", part2(&inp));
}

#[allow(dead_code)]
const EX: [&str; 6] = [
    "forward 5",
    "down 5",
    "forward 8",
    "up 3",
    "down 8",
    "forward 2",
];

#[test]
fn part1_works() {
    let ex: Vec<String> =
        EX.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    assert_eq!(part1(&ex), 150, "part 1 test");
}

#[test]
fn part2_works() {
    let ex: Vec<String> =
        EX.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    assert_eq!(part2(&ex), 900, "part 2 test");
}