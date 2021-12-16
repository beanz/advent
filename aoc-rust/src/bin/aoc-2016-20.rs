fn calc(inp: &[String]) -> (usize, usize) {
    let mut ranges = inp
        .iter()
        .map(|l| {
            let i = aoc::uints::<usize>(l).collect::<Vec<usize>>();
            i[0]..=i[1]
        })
        .collect::<Vec<std::ops::RangeInclusive<usize>>>();

    ranges.sort_by(|a, b| {
        if a.start() == b.start() {
            a.end().cmp(b.end())
        } else {
            a.start().cmp(b.start())
        }
    });

    let max = std::u32::MAX as usize;
    let mut new: Vec<std::ops::RangeInclusive<usize>> = vec![ranges[0].clone()];
    let mut p2 = *new[0].start();
    for range in ranges.iter().skip(1) {
        let ni = new.len() - 1;
        if *range.start() > *new[ni].end() + 1 {
            p2 += *range.start() - *new[ni].end() - 1;
            new.push(range.clone());
        } else if *range.end() > *new[ni].end() {
            new[ni] = *new[ni].start()..=*range.end();
        }
    }
    if *new[new.len() - 1].end() < max {
        p2 += 1 + max - *new[new.len() - 1].end();
    }
    ((*new[0].end() + 1), p2)
}

#[test]
fn calc_works() {
    let (p1, p2) = calc(&vec![
        "5-8".to_string(),
        "0-2".to_string(),
        "4-7".to_string(),
    ]);
    assert_eq!(p1, 3, "example part 1");
    assert_eq!(p2, 4294967289, "example part 2");
}

fn main() {
    let lines = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let (p1, p2) = calc(&lines);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
