use heapless::FnvIndexSet;

const WAYS_SIZE: usize = 64;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut patterns = FnvIndexSet::<usize, 2048>::new();
    let (mut i, mut pat) = (0, 0);
    loop {
        match inp[i] {
            b',' => {
                patterns.insert(pat).expect("overflow");
                pat = 0;
                i += 2;
            }
            b'\n' => {
                patterns.insert(pat).expect("overflow");
                i += 2;
                break;
            }
            _ => {
                pat = (pat << 3) + col(inp[i]);
                i += 1;
            }
        }
    }
    let matches = |towel: &[u8], ways: &mut [usize; WAYS_SIZE]| -> usize {
        let tl = towel.len();
        ways.fill(0);
        ways[0] = 1;
        for i in 0..tl {
            if ways[i] == 0 {
                continue;
            }
            let mut t = 0;
            for j in 0..8 {
                if i + j >= towel.len() {
                    break;
                }
                t = (t << 3) + col(towel[i + j]);
                if patterns.contains(&t) {
                    ways[i + j + 1] += ways[i];
                }
            }
        }
        ways[tl]
    };
    let (mut p1, mut p2) = (0, 0);
    let mut ways: [usize; WAYS_SIZE] = [0; WAYS_SIZE];
    let mut j = i;
    while i < inp.len() {
        if inp[i] == b'\n' {
            let towel = &inp[j..i];
            let m = matches(towel, &mut ways);
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

fn col(ch: u8) -> usize {
    match ch {
        b'b' => 1,
        b'g' => 2,
        b'r' => 3,
        b'u' => 4,
        b'w' => 5,
        _ => unreachable!("invalid towel colour"),
    }
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
        aoc::test::auto("../2024/19/", parts);
    }
}
