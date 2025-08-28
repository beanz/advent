use itertools::*;

fn part1(sizes: &[usize], target: usize) -> usize {
    let l = sizes.len();
    (1..l)
        .map(|n| {
            sizes
                .iter()
                .combinations(n)
                .filter(|c| c.iter().copied().sum::<usize>() == target)
                .count()
        })
        .sum::<usize>()
}

fn part2(sizes: &[usize], target: usize) -> usize {
    let l = sizes.len();
    (1..l)
        .map(|n| {
            sizes
                .iter()
                .combinations(n)
                .filter(|c| c.iter().copied().sum::<usize>() == target)
                .count()
        })
        .find(|x| *x > 0)
        .unwrap()
}

fn main() {
    let inp = aoc::slurp_input_file();
    aoc::benchme(|bench: bool| {
        let sizes = aoc::ints::<usize>(&inp).collect::<Vec<usize>>();
        let target: usize = {
            if aoc::is_test() {
                25
            } else {
                150
            }
        };
        let p1 = part1(&sizes, target);
        let p2 = part2(&sizes, target);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part1_works() {
        assert_eq!(part1(&vec![20usize, 15, 10, 5, 5], 25), 4, "part 1 test");
    }

    #[test]
    fn part2_works() {
        assert_eq!(part2(&vec![20usize, 15, 10, 5, 5], 25), 3, "part 2 test");
    }
}
