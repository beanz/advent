fn factors(house: usize) -> Vec<usize> {
    let mut v: Vec<usize> = Vec::new();
    for i in (1..).take_while(|x| x * x <= house) {
        if (house % i) == 0 {
            v.push(i);
            let div = house / i;
            if div != i {
                v.push(div);
            }
        }
    }
    v
}

fn num_presents(house: usize) -> usize {
    factors(house).iter().sum::<usize>() * 10
}

fn part1(presents: usize) -> usize {
    let mut n = 0;
    // s = (1+n)*n/2 => n = (sqrt(8*s+1) - 1)/2
    // so we could start at:
    //   h = (aoc::isqrt(8 * presents + 1) - 1) / 20;
    // but that's only 761 for my input so not worth it. Is there a better
    // lower bound?
    let mut h = 1;
    while n < presents {
        n = num_presents(h);
        h += 1;
    }
    h - 1
}

fn factors2(house: usize) -> Vec<usize> {
    let mut v: Vec<usize> = Vec::new();
    for i in (1..).take_while(|x| x * x <= house) {
        if (house % i) == 0 {
            let div = house / i;
            if div <= 50 {
                v.push(i);
            }
            if i <= 50 && div != i {
                v.push(div);
            }
        }
    }
    v
}

fn num_presents2(house: usize) -> usize {
    factors2(house).iter().sum::<usize>() * 11
}

fn part2(presents: usize) -> usize {
    let mut n = 0;
    let mut h = 1;
    while n < presents {
        n = num_presents2(h);
        h += 1;
    }
    h - 1
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let presents = inp.parse::<usize>().unwrap();
        let p1 = part1(presents);
        let p2 = part2(presents);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn factors_works() {
    for tc in &[
        (4, vec![1usize, 2, 4]),
        (6, vec![1usize, 2, 3, 6]),
        (12, vec![1usize, 2, 3, 4, 6, 12]),
    ] {
        let mut f = factors(tc.0);
        f.sort();
        assert_eq!(f, tc.1, "factors({})", tc.0);
    }
}

#[test]
fn part1_works() {
    assert_eq!(part1(70), 4, "part 1 example");
}

#[test]
#[cfg_attr(not(feature = "slow_tests"), ignore)]
fn part1_works_slow() {
    assert_eq!(part1(29000000), 665280, "part 1");
}

#[test]
#[cfg_attr(not(feature = "slow_tests"), ignore)]
fn part2_works() {
    assert_eq!(part2(29000000), 705600, "part 2");
}
