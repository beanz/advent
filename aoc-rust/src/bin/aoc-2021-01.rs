type Int = usize;

fn calc(depths: &[Int], n: usize) -> usize {
    depths.windows(n).filter(|c| c[0] < c[c.len() - 1]).count()
}

fn part1(depths: &[Int]) -> usize {
    calc(depths, 2)
}

fn part2(depths: &[Int]) -> usize {
    calc(depths, 4)
}
use arrayvec::ArrayVec;

fn main() {
    let inp = aoc::black_box(aoc::slurp_input_file());
    aoc::benchme(|bench: bool| {
        let depths = aoc::uints::<Int>(&inp).collect::<ArrayVec<Int, 2000>>();
        let p1 = part1(&depths);
        if !bench {
            println!("Part 1: {}", p1);
        }
        let p2 = part2(&depths);
        if !bench {
            println!("Part 2: {}", p2);
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part1_works() {
        let depths: Vec<Int> = vec![199, 200, 208, 210, 200, 207, 240, 269, 260, 263];
        assert_eq!(part1(&depths), 7, "part 1 test");
    }

    #[test]
    fn part2_works() {
        let depths: Vec<Int> = vec![199, 200, 208, 210, 200, 207, 240, 269, 260, 263];
        assert_eq!(part2(&depths), 5, "part 2 test");
    }
}
