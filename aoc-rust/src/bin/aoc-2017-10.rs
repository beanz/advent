fn part1(l: &str, len: usize) -> usize {
    let mut r = aoc::Rope::new(len);
    for pos in aoc::uints::<usize>(l) {
        r.twist(pos);
    }
    r.product()
}

fn part2(l: &str) -> String {
    let r = aoc::Rope::new_twisted(256, l);
    r.dense_hash()
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let p1 = part1(&inp, 256);
        let p2 = part2(&inp);
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
        assert_eq!(part1("3,4,1,5", 5), 12);
    }
    #[test]
    fn part2_works() {
        for tc in &[
            ("", "a2582a3a0e66e6e86e3812dcb672a272"),
            ("AoC 2017", "33efeb34ea91902bb2f59c9920caa6cd"),
            ("1,2,3", "3efbe78a8d82f29979031a4aa0b16a9d"),
            ("1,2,4", "63960835bcdc130f0b66d7ff4f6a5a8e"),
        ] {
            assert_eq!(part2(tc.0), tc.1, "{}", tc.0);
        }
    }
}
