use heapless::FnvIndexMap;
use smallvec::SmallVec;

const MEM_SIZE: usize = 32768;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut patterns = SmallVec::<[&[u8]; 512]>::new();
    let (mut i, mut j) = (0, 0);
    loop {
        match inp[i] {
            b',' => {
                patterns.push(&inp[j..i]);
                i += 2;
                j = i;
            }
            b'\n' => {
                patterns.push(&inp[j..i]);
                i += 2;
                j = i;
                break;
            }
            _ => i += 1,
        }
    }
    let (mut p1, mut p2) = (0, 0);
    let mut mem = FnvIndexMap::<&[u8], usize, MEM_SIZE>::new();
    while i < inp.len() {
        if inp[i] == b'\n' {
            let towel = &inp[j..i];
            let m = matches(&patterns, towel, &mut mem);
            if m != 0 {
                p1 += 1;
                p2 += m;
            }
            j = i + 1;
        }
        i += 1;
    }
    (p1, p2)
}

fn matches<'a>(
    patterns: &SmallVec<[&[u8]; 512]>,
    towel: &'a [u8],
    mem: &mut FnvIndexMap<&'a [u8], usize, MEM_SIZE>,
) -> usize {
    if towel.len() == 0 {
        return 1;
    }
    if let Some(v) = mem.get(towel) {
        return *v;
    }
    let mut c = 0;
    for pattern in patterns {
        if towel.len() < pattern.len() {
            continue;
        }
        let mut m = true;
        for i in 0..pattern.len() {
            if pattern[i] != towel[i] {
                m = false;
                break;
            }
        }
        if m {
            if towel.len() == pattern.len() {
                c += 1
            } else {
                c += matches(patterns, &towel[pattern.len()..], mem);
            }
        }
    }
    mem.insert(towel, c).expect("overflow");
    c
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
        aoc::test::auto("../2024/19/", parts);
    }
}
