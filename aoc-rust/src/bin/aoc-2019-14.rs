use std::collections::HashMap;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut i = 0;
    let mut fact: HashMap<u32, (usize, Vec<(usize, u32)>)> = HashMap::new();
    while i < inp.len() {
        let mut ing: Vec<(usize, u32)> = Vec::new();
        loop {
            let (j, n) = aoc::read::uint::<usize>(inp, i);
            i = j + 1;
            let (j, a) = read_id(inp, i, 27, b'@');
            i = j + 2;
            ing.push((n, a));
            if inp[i] == b'>' {
                break;
            }
        }
        let (j, n) = aoc::read::uint::<usize>(inp, i + 2);
        i = j + 1;
        let (j, a) = read_id(inp, i, 27, b'@');
        i = j + 1;
        fact.insert(a, (n, ing));
    }
    let p1 = ore_for(1, &fact);
    let target = 1_000_000_000_000;
    let mut upper = 1;
    while ore_for(upper, &fact) < target {
        upper *= 2;
    }
    let mut lower = upper / 2;
    loop {
        let mid = lower + (upper - lower) / 2;
        if mid == lower {
            break;
        }
        if ore_for(mid, &fact) > target {
            upper = mid;
        } else {
            lower = mid;
        }
    }

    (p1, lower)
}

fn ore_for(n: usize, fact: &HashMap<u32, (usize, Vec<(usize, u32)>)>) -> usize {
    let mut surplus: HashMap<u32, usize> = HashMap::new();
    let mut total: HashMap<u32, usize> = HashMap::new();
    let (_, fuel) = read_id(&[b'F', b'U', b'E', b'L', b' '], 0, 27, b'@');
    let (_, ore) = read_id(&[b'O', b'R', b'E', b' '], 0, 27, b'@');
    requirements(fuel, n, fact, &mut total, &mut surplus, ore);
    *total.get(&ore).expect("should have produced ore")
}

fn requirements(
    chem: u32,
    needed: usize,
    fact: &HashMap<u32, (usize, Vec<(usize, u32)>)>,
    total: &mut HashMap<u32, usize>,
    surplus: &mut HashMap<u32, usize>,
    last: u32,
) {
    if chem == last {
        return;
    }
    let mut needed = needed;
    let avail = surplus.entry(chem).or_default();
    if *avail > needed {
        *avail -= needed;
        return;
    }
    if *avail > 0 {
        needed -= *avail;
        *avail = 0;
    }
    let (n, ing) = fact.get(&chem).expect("missing inputs");
    let required = (needed + n - 1) / n;
    let leftover = n * required - needed;
    *(surplus.entry(chem).or_default()) += leftover;
    for (n, ch) in ing {
        *(total.entry(*ch).or_default()) += n * required;
        requirements(*ch, n * required, fact, total, surplus, last);
    }
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

fn read_id(inp: &[u8], i: usize, mul: u32, off: u8) -> (usize, u32) {
    let mut i = i;
    let mut id = 0;
    debug_assert!(i < inp.len() && b'A' <= inp[i] && inp[i] <= b'Z');
    while b'A' <= inp[i] && inp[i] <= b'Z' {
        id = id * mul + ((inp[i] - off) as u32);
        i += 1;
    }
    (i, id)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/14/test1a.txt").expect("read error");
        assert_eq!(parts(&inp), (31, 34482758620));
        let inp = std::fs::read("../2019/14/test1b.txt").expect("read error");
        assert_eq!(parts(&inp), (165, 6323777403));
        let inp = std::fs::read("../2019/14/test1c.txt").expect("read error");
        assert_eq!(parts(&inp), (13312, 82892753));
        let inp = std::fs::read("../2019/14/test1d.txt").expect("read error");
        assert_eq!(parts(&inp), (180697, 5586022));
        let inp = std::fs::read("../2019/14/test1e.txt").expect("read error");
        assert_eq!(parts(&inp), (2210736, 460664));
        let inp = std::fs::read("../2019/14/input.txt").expect("read error");
        assert_eq!(parts(&inp), (598038, 2269325));
        let inp = std::fs::read("../2019/14/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (301997, 6216589));
    }
}
