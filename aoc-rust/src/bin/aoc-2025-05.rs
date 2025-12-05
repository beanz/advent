use heapless::Vec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut ranges = Vec::<[usize; 2], 1024>::new();
    let mut i: usize = 0;
    while i < inp.len() {
        if inp[i] == b'\n' {
            break;
        }
        let (j, s) = aoc::read::uint::<usize>(inp, i);
        let (j, e) = aoc::read::uint::<usize>(inp, j + 1);
        ranges.push([s, e + 1]).expect("overflow");
        i = j + 1;
    }
    ranges.sort();
    i += 1;
    let mut p1: usize = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::uint::<usize>(inp, i);
        i = j + 1;
        for r in &ranges {
            if r[0] <= n && n < r[1] {
                p1 += 1;
                break;
            }
            if n < r[0] {
                break;
            }
        }
    }
    let mut p2: usize = 0;
    let mut end: usize = 0;
    for r in &ranges {
        let s = end.max(r[0]);
        if s < r[1] {
            p2 += r[1] - s;
        }
        end = end.max(r[1]);
    }
    (p1, p2)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        aoc::test::auto("../2025/05/", parts);
    }
}
