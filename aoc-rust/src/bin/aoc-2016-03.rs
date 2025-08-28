fn possible(sides: &[usize]) -> bool {
    sides[0] + sides[1] > sides[2]
        && sides[0] + sides[2] > sides[1]
        && sides[1] + sides[2] > sides[0]
}

fn part1(lines: &[String]) -> usize {
    lines
        .iter()
        .filter(|l| possible(&aoc::ints::<usize>(l).collect::<Vec<usize>>()))
        .count()
}

fn part2(lines: &[String]) -> usize {
    lines
        .chunks(3)
        .map(|l3| {
            let l0ints = aoc::ints::<usize>(&l3[0]).collect::<Vec<usize>>();
            let l1ints = aoc::ints::<usize>(&l3[1]).collect::<Vec<usize>>();
            let l2ints = aoc::ints::<usize>(&l3[2]).collect::<Vec<usize>>();
            let tn: Vec<usize> = vec![0, 1, 2];
            tn.into_iter()
                .filter(|n| {
                    let triangle = vec![l0ints[*n], l1ints[*n], l2ints[*n]];
                    possible(&triangle)
                })
                .count()
        })
        .sum()
}

fn main() {
    let lines = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let p1 = part1(&lines);
        let p2 = part2(&lines);
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
    fn possible_works() {
        assert_eq!(possible(&[39, 703, 839]), false, "possible 39, 703, 839");
        assert_eq!(possible(&[237, 956, 841]), true, "possible 237, 956, 841");
    }
    #[test]
    fn part1_works() {
        assert_eq!(
            part1(&[
                "   39  703  839".to_string(),
                "  229  871    3".to_string(),
                "  237  956  841".to_string(),
            ]),
            1,
            "part 1 sample"
        );
    }
    #[test]
    fn part2_works() {
        assert_eq!(
            part2(&vec![
                "   39  703  839".to_string(),
                "  229  871    3".to_string(),
                "  237  956  841".to_string(),
            ]),
            3,
            "part 2 sample"
        );
    }
}
