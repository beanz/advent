use smallvec::SmallVec;

const WAYS_SIZE: usize = 64;

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
    let mut ways: [usize; WAYS_SIZE] = [0; WAYS_SIZE];
    while i < inp.len() {
        if inp[i] == b'\n' {
            let towel = &inp[j..i];
            let m = matches(&patterns, towel, &mut ways);
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
    ways: &mut [usize; WAYS_SIZE],
) -> usize {
    let tl = towel.len();
    ways.fill(0);
    ways[0] = 1;
    for i in 0..tl {
        if ways[i] == 0 {
            continue;
        }
        'pattern: for pattern in patterns {
            let l = pattern.len();
            if towel[i..].len() < l {
                continue;
            }
            for j in 0..pattern.len() {
                if pattern[j] != towel[i + j] {
                    continue 'pattern;
                }
            }
            ways[i + l] += ways[i]
        }
    }
    return ways[tl];
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
