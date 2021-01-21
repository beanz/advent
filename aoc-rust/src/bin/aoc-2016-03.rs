fn possible(sides: &[usize]) -> bool {
    sides[0] + sides[1] > sides[2]
        && sides[0] + sides[2] > sides[1]
        && sides[1] + sides[2] > sides[0]
}

#[test]
fn possible_works() {
    assert_eq!(possible(&[39, 703, 839]), false, "possible 39, 703, 839");
    assert_eq!(possible(&[237, 956, 841]), true, "possible 237, 956, 841");
}

fn part1(lines: &Vec<&str>) -> usize {
    lines
        .iter()
        .filter(|l| possible(&aoc::ints::<usize>(l).collect::<Vec<usize>>()))
        .count()
}

#[test]
fn part1_works() {
    assert_eq!(
        part1(&vec![
            "   39  703  839",
            "  229  871    3",
            "  237  956  841",
        ]),
        1,
        "part 1 sample"
    );
}

fn part2(lines: &Vec<&str>) -> usize {
    lines
        .chunks(3)
        .map(|l3| {
            let l0ints = aoc::ints::<usize>(l3[0]).collect::<Vec<usize>>();
            let l1ints = aoc::ints::<usize>(l3[1]).collect::<Vec<usize>>();
            let l2ints = aoc::ints::<usize>(l3[2]).collect::<Vec<usize>>();
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

#[test]
fn part2_works() {
    assert_eq!(
        part2(&vec![
            "   39  703  839",
            "  229  871    3",
            "  237  956  841",
        ]),
        3,
        "part 2 sample"
    );
}

fn main() {
    let input_lines = aoc::vec_input_lines();
    let lines: Vec<&str> = input_lines.iter().map(|x| &**x).collect();
    println!("Part 1: {}", part1(&lines));
    println!("Part 2: {}", part2(&lines));
}
