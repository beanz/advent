fn parts(inp: &[u8]) -> (usize, usize) {
    let w: usize = inp.iter().position(|&ch| ch == b'\n').unwrap() + 1;
    let h = inp.len() / w - 1;
    let mut p1: usize = 0;
    let mut p2: usize = 0;
    let mut i: usize = h * w;
    while i < inp.len() {
        let op = inp[i];
        let j = i;
        i = skip(inp, i + 1);
        if op == b'+' {
            p1 += add(inp, j - w * h, 1, w, i - j - 1, h);
            p2 += add(inp, j - w * h, w, 1, h, i - j - 1);
        } else {
            p1 += mul(inp, j - w * h, 1, w, i - j - 1, h);
            p2 += mul(inp, j - w * h, w, 1, h, i - j - 1);
        }
    }
    (p1, p2)
}

fn skip(inp: &[u8], i: usize) -> usize {
    let mut i = i;
    while i < inp.len() && inp[i] <= b' ' {
        i += 1;
    }
    i
}

fn add(inp: &[u8], i: usize, di: usize, ni: usize, d: usize, nums: usize) -> usize {
    let mut res: usize = 0;
    for j in 0..nums {
        let mut n: usize = 0;
        for k in 0..d {
            let ch = inp[i + k * di + j * ni];
            if ch == b' ' {
                continue;
            }
            n = 10 * n + ((ch & 0xf) as usize);
        }
        res += n;
    }
    return res;
}

fn mul(inp: &[u8], i: usize, di: usize, ni: usize, d: usize, nums: usize) -> usize {
    let mut res: usize = 1;
    for j in 0..nums {
        let mut n: usize = 0;
        for k in 0..d {
            let ch = inp[i + k * di + j * ni];
            if ch == b' ' {
                continue;
            }
            n = 10 * n + ((ch & 0xf) as usize);
        }
        res *= n;
    }
    return res;
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
        aoc::test::auto("../2025/06/", parts);
    }
}
