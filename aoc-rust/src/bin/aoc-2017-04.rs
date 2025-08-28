use itertools::*;

fn part1(l: &str) -> bool {
    !l.split(' ')
        .permutations(2)
        .any(|word_pair| word_pair[0] == word_pair[1])
}

fn part2(l: &str) -> bool {
    !l.split(' ')
        .map(|w| w.chars().sorted().collect::<String>())
        .permutations(2)
        .any(|word_pair| word_pair[0] == word_pair[1])
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let p1 = aoc::sum_valid_lines(&inp, part1);
        let p2 = aoc::sum_valid_lines(&inp, part2);
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
        assert_eq!(part1("aa bb cc dd ee"), true);
        assert_eq!(part1("aa bb cc dd aa"), false);
        assert_eq!(part1("aa bb cc dd aaa"), true);
    }
    #[test]
    fn part2_works() {
        assert_eq!(part2("abcde fghij"), true);
        assert_eq!(part2("abcde xyz ecdab"), false);
        assert_eq!(part2("a ab abc abd abf abj"), true);
        assert_eq!(part2("iiii oiii ooii oooi oooo"), true);
        assert_eq!(part2("oiii ioii iioi iiio"), false);
    }
}
