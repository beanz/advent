// Numberphile The Josephus Problem
// https://oeis.org/A006257

fn winner(elves: usize) -> usize {
    let mut msb = 1;
    while msb <= elves {
        msb *= 2;
    }
    msb /= 2;
    if elves == msb {
        return 1;
    }
    1 + (elves - msb) * 2
}

#[test]
fn winner_working() {
    for tc in &[
        (1, 1),
        (2, 1),
        (3, 3),
        (4, 1),
        (5, 3),
        (6, 5),
        (7, 7),
        (8, 1),
        (9, 3),
        (10, 5),
        (11, 7),
        (12, 9),
        (13, 11),
        (14, 13),
        (15, 15),
        (16, 1),
        (17, 3),
        (18, 5),
        (19, 7),
        (20, 9),
        (100, 73),
        (3012210, 1830117),
    ] {
        assert_eq!(winner(tc.0), tc.1, "winner with {} elves", tc.0);
    }
}

// https://oeis.org/A334473

fn winner2(elves: usize) -> usize {
    let mut mst = 1;
    while mst <= elves {
        mst *= 3;
    }
    mst /= 3;
    if elves == mst {
        return elves;
    } else if elves < 2 * mst {
	return elves % mst
    }
    mst + 2 * (elves%mst)
}

#[test]
fn winner2_working() {
    for tc in &[
        (1, 1),
        (2, 1),
        (3, 3),
        (4, 1),
        (5, 2),
        (6, 3),
        (7, 5),
        (8, 7),
        (9, 9),
        (10, 1),
        (11, 2),
        (12, 3),
        (13, 4),
        (14, 5),
        (15, 6),
        (16, 7),
        (17, 8),
        (18, 9),
        (19, 11),
        (20, 13),
        (100, 19),
        (3012210, 1417887),
    ] {
        assert_eq!(winner2(tc.0), tc.1, "winner2 with {} elves", tc.0);
    }
}

fn main() {
    let elves = aoc::ints::<usize>(&aoc::read_input_line()).next().unwrap();
    println!("Part 1: {}", winner(elves));
    println!("Part 2: {}", winner2(elves));
}
