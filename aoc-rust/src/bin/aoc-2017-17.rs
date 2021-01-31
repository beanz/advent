fn calc(v: &mut Vec<usize>, num: usize, steps: usize) {
    let mut cur = 0;
    for n in 1..=num {
        for _ in 0..steps {
            cur = v[cur];
        }
        let tmp = v[cur];
        v[cur] = n;
        v[n] = tmp;
        cur = n;
    }
}

fn part1(num: usize, steps: usize) -> usize {
    let mut v: Vec<usize> = vec![0; num + 1];
    calc(&mut v, num, steps);
    v[num]
}

#[test]
fn part1_works() {
    assert_eq!(part1(9, 3), 5, "part 1 example after 9");
    assert_eq!(part1(2017, 3), 638, "part 1 example after 2017");
}

fn part2(num: usize, steps: usize) -> usize {
    let mut cur = 0;
    let mut ans = 0;
    for n in 1..=num {
        cur = (cur + steps) % n;
        if cur == 0 {
            ans = n
        }
        cur += 1;
    }
    ans
}

#[test]
fn part2_works() {
    assert_eq!(part2(9, 3), 9, "part 2 example after 9");
    assert_eq!(part2(2017, 3), 1226, "part 2 example after 2017");
    assert_eq!(
        part2(50_000_000, 3),
        1222153,
        "part 2 example after 50million"
    );
}

fn main() {
    let steps = aoc::uints::<usize>(&aoc::read_input_line()).next().unwrap();
    println!("Part 1: {}", part1(2017, steps));
    println!("Part 2: {}", part2(50_000_000, steps));
}
