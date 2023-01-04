use ahash::RandomState;
use std::collections::HashMap;
use std::collections::HashSet;

const ID_LEN: usize = 9;

fn parts(inp: &[u8]) -> (usize, [u8; 46], usize) {
    let mut ln = 0;
    let mut i = 0;
    let mut al_line: HashMap<usize, HashSet<usize>, RandomState> =
        HashMap::with_capacity_and_hasher(8, RandomState::new());
    let mut in_line: HashMap<usize, HashSet<usize>, RandomState> =
        HashMap::with_capacity_and_hasher(200, RandomState::new());
    while i < inp.len() {
        while inp[i] != b'(' {
            let (j, n) = read_id(inp, i, ID_LEN);
            i = j;
            let e = in_line.entry(n).or_insert_with(HashSet::new);
            e.insert(ln);
            i += 1;
        }
        i += 10;
        loop {
            let (j, n) = read_id(inp, i, ID_LEN);
            i = j;
            let e = al_line.entry(n).or_insert_with(HashSet::new);
            e.insert(ln);
            if inp[i] == b')' {
                i += 2;
                break;
            }
            i += 2;
        }
        ln += 1;
    }
    //eprintln!("al: {:?}", al_line);
    //eprintln!("in: {:?}", in_line);
    let mut poss: HashMap<usize, HashSet<usize>, RandomState> =
        HashMap::with_capacity_and_hasher(8, RandomState::new());
    for (ing, in_lines) in &in_line {
        for (al, al_lines) in &al_line {
            let mut maybe_this = true;
            for aln in al_lines {
                if !in_lines.contains(aln) {
                    maybe_this = false;
                    break;
                }
            }
            if maybe_this {
                let e = poss.entry(*ing).or_insert_with(HashSet::new);
                e.insert(*al);
            }
        }
    }
    //eprintln!("poss: {:?}", poss);
    let mut p1 = 0;
    for (ing, in_lines) in &in_line {
        if !poss.contains_key(ing) {
            p1 += in_lines.len();
        }
    }
    let mut res: Vec<(usize, usize)> = Vec::new();
    while !poss.is_empty() {
        for (ing, als) in &poss {
            if als.len() != 1 {
                continue;
            }
            let al = als.iter().next().expect("one element");
            //eprintln!("{} is {}", ing, al);
            res.push((*ing, *al));
            break;
        }
        let (ing, al) = res[res.len() - 1];
        poss.remove(&ing);
        for als in poss.values_mut() {
            als.remove(&al);
        }
        //eprintln!("poss: {:?}", poss);
    }
    res.sort_by(|a, b| a.1.cmp(&b.1));
    //eprintln!("res: {:?}", res);
    let mut p2l = 0;
    let mut p2: [u8; 46] = [32; 46];
    for (ing, _al) in res {
        let l = ing & 0xf;
        let mut n = ing >> 4;
        for _k in 0..(ID_LEN - l) {
            n /= 26;
        }
        //eprintln!("{} => {} / {}", ing, l, n);
        p2l += l;
        for j in 0..l {
            p2[p2l - j - 1] = b'a' + (n % 26) as u8;
            n /= 26;
        }
        p2[p2l] = b',';
        p2l += 1;
    }
    (p1, p2, p2l - 1)
}

fn read_id(inp: &[u8], i: usize, ll: usize) -> (usize, usize) {
    let mut i = i;
    let j = i;
    let mut n = 0;
    while b'a' <= inp[i] && inp[i] <= b'z' {
        n = 26 * n + (inp[i] - b'a') as usize;
        i += 1;
    }
    let l = i - j;
    for _k in 0..ll - l {
        n *= 26;
    }
    n = (n << 4) + l;
    (i, n)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2, p2l) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!(
                "Part 2: {}",
                std::str::from_utf8(&p2[0..p2l]).expect("ascii")
            );
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/21/test1.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 5);
        assert_eq!(
            std::str::from_utf8(&p2[0..p2l]).expect("ascii"),
            "mxmxvkd,sqjhc,fvjkl"
        );
        let inp = std::fs::read("../2020/21/input.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 2874);
        assert_eq!(
            std::str::from_utf8(&p2[0..p2l]).expect("ascii"),
            "gfvrr,ndkkq,jxcxh,bthjz,sgzr,mbkbn,pkkg,mjbtz"
        );
    }
}
