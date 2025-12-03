fn best(line: &[u8], o: usize, rem: usize) -> (usize, usize) {
    let mut o = o;
    let mut r = line[o];
    for i in o + 1..line.len() - rem {
        if line[i] > r {
            r = line[i];
            o = i;
            if r == b'9' {
                break;
            }
        }
    }
    ((r - b'0') as usize, o + 1)
}

fn part(line: &[u8], n: usize) -> usize {
    let mut r = 0;
    let mut i = 0;
    for rem in (0..n).rev() {
        r *= 10;
        let (b, j) = best(line, i, rem);
        r += b;
        i = j;
    }
    r
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut j = 0;
    let mut p1 = 0;
    let mut p2 = 0;
    for i in 0..inp.len() {
        if inp[i] == b'\n' {
            p1 += part(&inp[j..i], 2);
            p2 += part(&inp[j..i], 12);
            j = i + 1
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
        aoc::test::auto("../2025/03/", parts);
    }
}
