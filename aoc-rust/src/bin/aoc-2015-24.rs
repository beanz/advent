use itertools::*;

fn calc(sizes: &[usize], num_groups: usize) -> usize {
    let target = sizes.iter().sum::<usize>() / num_groups;
    let l = sizes.len();
    (1..l)
        .map(|n| {
            sizes
                .iter()
                .combinations(n)
                .filter(|c| c.iter().copied().sum::<usize>() == target)
                .map(|c| c.iter().copied().product())
        })
        .flatten()
        .next()
        .unwrap()
}

fn part1(sizes: &[usize]) -> usize {
    calc(sizes, 3)
}

fn part2(sizes: &[usize]) -> usize {
    calc(sizes, 4)
}

fn main() {
    let inp = aoc::slurp_input_file();
    let sizes = aoc::ints::<usize>(&inp).collect::<Vec<usize>>();
    println!("Part 1: {}", part1(&sizes));
    println!("Part 2: {}", part2(&sizes));
}

#[test]
fn part1_works() {
    let sizes: Vec<usize> = vec![1, 2, 3, 4, 5, 7, 8, 9, 10, 11];
    assert_eq!(part1(&sizes), 99, "part 1 test");
}

#[test]
fn part2_works() {
    let sizes: Vec<usize> = vec![1, 2, 3, 4, 5, 7, 8, 9, 10, 11];
    assert_eq!(part2(&sizes), 44, "part 2 test");
}
