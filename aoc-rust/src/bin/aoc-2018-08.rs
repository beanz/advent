use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (u32, u32) {
    (part1(inp, 0).1, part2(inp, 0).1)
}

fn part1(inp: &[u8], i: usize) -> (usize, u32) {
    let (i, nc) = aoc::read::uint::<u32>(inp, i);
    let (mut i, nm) = aoc::read::uint::<u32>(inp, i + 1);
    i += 1;
    let mut r = 0;
    for _j in 0..nc {
        let (k, n) = part1(inp, i);
        i = k;
        r += n;
    }
    for _j in 0..nm {
        let (k, n) = aoc::read::uint::<u32>(inp, i);
        i = k + 1;
        r += n;
    }
    (i, r)
}

fn part2(inp: &[u8], i: usize) -> (usize, u32) {
    let (i, nc) = aoc::read::uint::<u32>(inp, i);
    let (mut i, nm) = aoc::read::uint::<u32>(inp, i + 1);
    i += 1;
    if nc == 0 {
        let mut r = 0;
        for _j in 0..nm {
            let (k, n) = aoc::read::uint::<u32>(inp, i);
            i = k + 1;
            r += n;
        }
        return (i, r);
    }
    let mut c = SmallVec::<[u32; 64]>::new();
    for _j in 0..nc {
        let (k, n) = part2(inp, i);
        i = k;
        c.push(n);
    }
    let mut r = 0;
    for _j in 0..nm {
        let (k, n) = aoc::read::uint::<usize>(inp, i);
        i = k + 1;
        if n <= c.len() {
            r += c[n - 1];
        }
    }
    (i, r)
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
    fn part1_works() {
        assert_eq!(part1(&b"0 1 99"[0..], 0).1, 99);
        assert_eq!(part1(&b"1 1 0 1 99 2"[0..], 0).1, 101);
        assert_eq!(part1(&b"0 3 10 11 12"[0..], 0).1, 33);
    }

    #[test]
    fn part2_works() {
        assert_eq!(part2(&b"0 1 99"[0..], 0).1, 99);
        assert_eq!(part2(&b"1 1 0 1 99 2"[0..], 0).1, 0);
        assert_eq!(part2(&b"0 3 10 11 12"[0..], 0).1, 33);
    }

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/08/test.txt").expect("read error");
        assert_eq!(parts(&inp), (138, 66));
        let inp = std::fs::read("../2018/08/input.txt").expect("read error");
        assert_eq!(parts(&inp), (42798, 23798));
        let inp = std::fs::read("../2018/08/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (43996, 35189));
    }
}
