use std::collections::HashSet;

use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (i32, i32) {
    let mut p1 = 0;
    let mut i = 0;
    let mut nums = SmallVec::<[i32; 1024]>::new();
    let mut seen: HashSet<i32> = HashSet::new();
    while i < inp.len() {
        let (j, n) = aoc::read::int::<i32>(inp, i);
        p1 += n;
        nums.push(n);
        seen.insert(p1);
        i = j + 1;
    }
    let mut p2 = p1;
    'outer: loop {
        for n in &nums {
            p2 += n;
            if seen.contains(&p2) {
                break 'outer;
            }
            seen.insert(p2);
        }
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
        let inp = std::fs::read("../2018/01/test.txt").expect("read error");
        assert_eq!(parts(&inp), (3, 2));
        let inp = std::fs::read("../2018/01/input.txt").expect("read error");
        assert_eq!(parts(&inp), (505, 72330));
        let inp = std::fs::read("../2018/01/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (490, 70357));
    }
}
