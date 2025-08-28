fn cost(ax: isize, ay: isize, bx: isize, by: isize, px: isize, py: isize, add: isize) -> usize {
    let px = px + add;
    let py = py + add;
    let d = ax * by - ay * bx;
    if d == 0 {
        return 0;
    }
    let x = px * by - py * bx;
    let m = x / d;
    if m * d != x {
        return 0;
    }
    let y = py - ay * m;
    let n = y / by;
    if n * by != y {
        return 0;
    }
    (3 * m + n) as usize
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut p1, mut p2) = (0, 0);
    let mut i = 0;
    while i < inp.len() {
        let (j, ax) = aoc::read::int::<isize>(inp, i + 12);
        let (j, ay) = aoc::read::int::<isize>(inp, j + 4);
        let (j, bx) = aoc::read::int::<isize>(inp, j + 13);
        let (j, by) = aoc::read::int::<isize>(inp, j + 4);
        let (j, px) = aoc::read::int::<isize>(inp, j + 10);
        let (j, py) = aoc::read::int::<isize>(inp, j + 4);
        i = j + 1;
        p1 += cost(ax, ay, bx, by, px, py, 0);
        p2 += cost(ax, ay, bx, by, px, py, 10000000000000);
    }
    (p1, p2)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/13/", parts);
    }
}
