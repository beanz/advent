use itertools::*;
use std::collections::HashMap;

fn find_position(usq: usize) -> aoc::Point {
    let sq = usq as isize;
    let mut side_len: isize = 1;
    while side_len * side_len < sq {
        side_len += 2;
    }
    let bottom_left = side_len * side_len;
    // which side
    if sq == bottom_left {
        aoc::Point::new(side_len / 2, side_len / 2)
    } else if sq < bottom_left - (side_len - 1) * 3 {
        // right side
        aoc::Point::new(
            side_len / 2,
            -((sq - (bottom_left - (side_len - 1) * 3)) + side_len / 2),
        )
    } else if sq < bottom_left - (side_len - 1) * 2 {
        // top edge
        aoc::Point::new(
            -((sq - (bottom_left - (side_len - 1) * 2)) + side_len / 2),
            -(side_len / 2),
        )
    } else if sq < bottom_left - (side_len - 1) {
        // left edge
        aoc::Point::new(
            -(side_len / 2),
            sq - (bottom_left - (side_len - 1)) + side_len / 2,
        )
    } else {
        // bottom edge
        aoc::Point::new(sq - bottom_left + side_len / 2, side_len / 2)
    }
}

#[test]
fn find_position_works() {
    assert_eq!(find_position(1), aoc::Point::new(0, 0), "part 1 example 1");
    assert_eq!(
        find_position(12),
        aoc::Point::new(2, -1),
        "part 1 example 2"
    );
    assert_eq!(find_position(23), aoc::Point::new(0, 2), "part 1 example 3");
    assert_eq!(
        find_position(1024),
        aoc::Point::new(-15, -16),
        "part 1 example 4"
    );
    assert_eq!(
        find_position(16),
        aoc::Point::new(-1, -2),
        "part 1 top edge"
    );
    assert_eq!(
        find_position(18),
        aoc::Point::new(-2, -1),
        "part 1 left edge"
    );
}

fn part1(square: usize) -> usize {
    find_position(square).manhattan()
}

const UP: aoc::Point = aoc::Point::new(0, -1);
const DOWN: aoc::Point = aoc::Point::new(0, 1);
const LEFT: aoc::Point = aoc::Point::new(-1, 0);
const RIGHT: aoc::Point = aoc::Point::new(1, 0);

fn part2(square: usize) -> usize {
    let mut values: HashMap<aoc::Point, usize> = HashMap::new();
    let mut cur = aoc::Point::new(0, 0);
    values.insert(cur, 1);
    for i in (2..).step_by(2) {
        for mov in repeat_n(RIGHT, 1)
            .chain(repeat_n(UP, i - 1))
            .chain(repeat_n(LEFT, i))
            .chain(repeat_n(DOWN, i).chain(repeat_n(RIGHT, i)))
        {
            cur.movdir(mov, 1);
            let mut s = 0;
            for nb in cur.eight_neighbours() {
                if let Some(n) = values.get(&nb) {
                    s += n;
                }
            }
            values.insert(cur, s);
            if s > square {
                return s;
            }
        }
    }
    0
}

#[test]
fn part2_works() {
    assert_eq!(part2(2), 4, "part 2 - 2");
    assert_eq!(part2(4), 5, "part 2 - 4");
    assert_eq!(part2(5), 10, "part 2 - 5");
    assert_eq!(part2(10), 11, "part 2 - 10");
    assert_eq!(part2(11), 23, "part 2 - 11");
    assert_eq!(part2(23), 25, "part 2 - 23");
    assert_eq!(part2(26), 54, "part 2 - 26");
    assert_eq!(part2(54), 57, "part 2 - 54");
    assert_eq!(part2(747), 806, "part 2 - 747");
    assert_eq!(part2(2380), 2391, "part 2 - 2380");
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let square = aoc::ints::<usize>(&inp).next().unwrap();
        let p1 = part1(square);
        let p2 = part2(square);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
