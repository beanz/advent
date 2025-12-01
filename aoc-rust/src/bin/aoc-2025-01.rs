fn parts(inp: &[u8]) -> (usize, usize) {
    let mut i = 0;
    let mut p = 50;
    let mut a1 = 0;
    let mut a2 = 0;
    while i < inp.len() {
        let dir = if inp[i] == b'R' { 1 } else { -1 };
        i += 1;
        let (j, mut n): (usize, isize) = aoc::read::uint(inp, i);
        i = j + 1;
        a2 += (n / 100) as usize;
        n = n % 100;
        if p == 0 && dir == -1 {
            p = 100;
        }
        p += dir * n;
        if p <= 0 {
            a2 += 1;
            if p < 0 {
                p += 100;
            }
        } else if p >= 100 {
            a2 += 1;
            p -= 100;
        }
        if p == 0 {
            a1 += 1;
        }
    }
    (a1, a2)
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
        aoc::test::auto("../2025/01/", parts);
    }
}
