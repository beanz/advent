#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
struct Disc {
    num: usize,
    positions: usize,
    start: usize,
}

impl Disc {
    fn new(l: &str) -> Disc {
        let mut nums = aoc::ints::<usize>(l);
        Disc {
            num: nums.next().unwrap(),
            positions: nums.next().unwrap(),
            start: nums.nth(1).unwrap(),
        }
    }
    fn is_aligned(&self, t: usize) -> bool {
        ((t + self.num + self.start) % self.positions) == 0
    }
}

fn calc(discs: &[Disc]) -> usize {
    (0_usize..)
        .find(|t| discs.iter().all(|d| d.is_aligned(*t)))
        .unwrap()
}

fn part1(discs: &[Disc]) -> usize {
    calc(discs)
}

fn part2(discs: &[Disc]) -> usize {
    let mut mdiscs = discs.to_owned();
    mdiscs.push(Disc {
        num: 7,
        positions: 11,
        start: 0,
    });
    calc(&mdiscs)
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let discs = inp.iter().map(|l| Disc::new(l)).collect::<Vec<Disc>>();
        let p1 = part1(&discs);
        let p2 = part2(&discs);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[allow(dead_code)]
    const EX: [&str; 2] = [
        "Disc #1 has 5 positions; at time=0, it is at position 4.",
        "Disc #2 has 2 positions; at time=0, it is at position 1.",
    ];

    #[test]
    fn disc_is_aligned_works() {
        let d1 = Disc::new(EX[0]);
        assert_eq!(d1.num, 1, "disc 1 number");
        assert_eq!(d1.positions, 5, "disc 1 positions");
        assert_eq!(d1.start, 4, "disc 1 start");
        assert_eq!(d1.is_aligned(0), true, "disc 1 aligned at t=0");
        assert_eq!(d1.is_aligned(1), false, "disc 1 not aligned at t=1");
        assert_eq!(d1.is_aligned(5), true, "disc 1 aligned at t=5");

        let d2 = Disc::new(EX[1]);
        assert_eq!(d2.num, 2, "disc 2 number");
        assert_eq!(d2.positions, 2, "disc 2 positions");
        assert_eq!(d2.start, 1, "disc 2 start");

        assert_eq!(d2.is_aligned(0), false, "disc 2 not aligned at t=0");
        assert_eq!(d2.is_aligned(1), true, "disc 2 aligned at t=1");
        assert_eq!(d2.is_aligned(5), true, "disc 2 aligned at t=5");
    }
    #[test]
    fn calc_parts() {
        let discs = EX.iter().map(|l| Disc::new(l)).collect::<Vec<Disc>>();
        assert_eq!(part1(&discs), 5, "example part 1");
        assert_eq!(part2(&discs), 15, "example part 2");
    }
}
