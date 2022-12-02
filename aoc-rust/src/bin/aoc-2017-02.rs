use itertools::*;

fn part1(l: &str) -> usize {
    if let MinMaxResult::MinMax(min, max) = aoc::uints::<usize>(l).minmax() {
        max - min
    } else {
        0
    }
}

fn part2(l: &str) -> usize {
    let uints: Vec<usize> = aoc::uints::<usize>(l).collect();
    for i in 0..uints.len() {
        for j in i + 1..uints.len() {
            if (uints[i] % uints[j]) == 0 {
                return uints[i] / uints[j];
            } else if (uints[j] % uints[i]) == 0 {
                return uints[j] / uints[i];
            }
        }
    }
    0
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let p1 = aoc::sum_lines(&inp, part1);
        let p2 = aoc::sum_lines(&inp, part2);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part1_works() {
        assert_eq!(part1(&"5 1 9 5".to_string()), 8);
        assert_eq!(part1(&"7 5 3".to_string()), 4);
        assert_eq!(part1(&"2 4 6 8".to_string()), 6);
    }
    #[test]
    fn part2_works() {
        assert_eq!(part2(&"5 9 2 8".to_string()), 4);
        assert_eq!(part2(&"9 4 7 3".to_string()), 3);
        assert_eq!(part2(&"3 8 6 5".to_string()), 2);
    }
}
