use std::collections::HashSet;

use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut d1 = SmallVec::<[u8; 64]>::new();
    let mut d2 = SmallVec::<[u8; 64]>::new();
    let mut i = 10;
    while inp[i] != b'\n' {
        let (j, n) = aoc::read::uint::<u8>(inp, i);
        d1.push(n);
        i = j + 1;
    }
    i += 11;
    while i < inp.len() && inp[i] != b'\n' {
        let (j, n) = aoc::read::uint::<u8>(inp, i);
        d2.push(n);
        i = j + 1;
    }
    let (_, r1) = combat([&d1, &d2], false);
    let (_, r2) = combat([&d1, &d2], true);
    (score(&r1), score(&r2))
}

fn combat(d: [&[u8]; 2], part2: bool) -> (usize, Vec<u8>) {
    //let mut round = 1;
    let mut d: [_; 2] = [
        SmallVec::<[u8; 64]>::from_slice(&d[0]),
        SmallVec::<[u8; 64]>::from_slice(&d[1]),
    ];
    let mut seen: HashSet<usize> = HashSet::new();
    while d[0].len() > 0 && d[1].len() > 0 {
        //eprintln!("{}: d1={:x?} d2={:x?}", round, d[0], d[1]);
        let k = score(&d[0]) * (31 + score(&d[1]));
        if seen.contains(&k) {
            //eprintln!("{}: p1! (seen)", round);
            return (0, d[0].to_vec());
        }
        seen.insert(k);
        let c: [_; 2] = [d[0][0], d[1][0]];
        d = [
            SmallVec::<[u8; 64]>::from_slice(&d[0][1..d[0].len()]),
            SmallVec::<[u8; 64]>::from_slice(&d[1][1..d[1].len()]),
        ];
        //eprintln!("{}: c1={} c2={}", round, c[0], c[1]);
        let w = if part2 && d[0].len() >= (c[0] as usize) && d[1].len() >= (c[1] as usize) {
            let sd = [
                SmallVec::<[u8; 64]>::from_slice(&d[0][0..(c[0] as usize)]),
                SmallVec::<[u8; 64]>::from_slice(&d[1][0..(c[1] as usize)]),
            ];
            //eprintln!("{}: subgame", round);
            let res = combat([&sd[0], &sd[1]], true);
            res.0
        } else if c[0] > c[1] {
            0
        } else {
            1
        };
        //eprintln!("{}: p{}!", round, w + 1);
        d[w].push(c[w]);
        d[w].push(c[1 - w]);
        //round += 1;
    }
    if d[0].len() > 0 {
        (0, d[0].to_vec())
    } else {
        (1, d[1].to_vec())
    }
}

fn score(d: &[u8]) -> usize {
    let mut s = 0;
    for i in 0..d.len() {
        s += (d.len() - i) * (d[i] as usize);
    }
    s
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
        let inp = std::fs::read("../2020/22/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (306, 291));
        let inp = std::fs::read("../2020/22/input.txt").expect("read error");
        assert_eq!(parts(&inp), (32856, 33805));
        let inp = std::fs::read("../2020/22/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (33434, 31657));
    }
}
