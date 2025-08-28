fn calc(inp: &str) -> (usize, usize) {
    let nums = inp
        .chars()
        .map(|x| (x as u8 - b'0') as usize)
        .collect::<Vec<usize>>();
    let offset = nums.len() / 2;
    let mut p1 = 0;
    let mut p2 = 0;
    for (i, x) in nums.iter().enumerate() {
        if *x == nums[(i + 1) % nums.len()] {
            p1 += *x;
        }
        if *x == nums[(i + offset) % nums.len()] {
            p2 += *x;
        }
    }
    (p1, p2)
}

fn main() {
    let nums = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let (p1, p2) = calc(&nums);
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
        for tc in &[("1122", 3), ("1111", 4), ("1234", 0), ("91212129", 9)] {
            let (p1, _) = calc(&tc.0);
            assert_eq!(p1, tc.1, "{}", tc.0);
        }
    }

    #[test]
    fn part2_works() {
        for tc in &[
            ("1212", 6),
            ("1221", 0),
            ("123425", 4),
            ("123123", 12),
            ("12131415", 4),
        ] {
            let (_, p2) = calc(&tc.0);
            assert_eq!(p2, tc.1, "{}", tc.0);
        }
    }
}
