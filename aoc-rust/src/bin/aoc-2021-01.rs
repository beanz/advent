fn calc(depths: &[usize], n: usize) -> usize {
    depths
        .windows(n)
        .filter(|c| c[0] < c[c.len()-1])
        .count()
}

fn part1(depths: &[usize]) -> usize {
    calc(depths, 2)
}

fn part2(depths: &[usize]) -> usize {
    calc(depths, 4)
}

fn main() {
    let inp = aoc::slurp_input_file();
    let depths = aoc::ints::<usize>(&inp).collect::<Vec<usize>>();
    println!("Part 1: {}", part1(&depths));
    println!("Part 2: {}", part2(&depths));
}

#[test]
fn part1_works() {
    let depths: Vec<usize> = vec![199, 200, 208, 210, 200,
				  207, 240, 269, 260, 263];
    assert_eq!(part1(&depths), 7, "part 1 test");
}

#[test]
fn part2_works() {
    let depths: Vec<usize> = vec![199, 200, 208, 210, 200,
				  207, 240, 269, 260, 263];
    assert_eq!(part2(&depths), 5, "part 2 test");
}
