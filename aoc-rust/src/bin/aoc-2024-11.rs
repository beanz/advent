const CACHE_SIZE: usize = 131072;

fn blink(mem: &mut [usize], s: usize, n: usize) -> usize {
    if n == 0 {
        return 1;
    }
    let k = (s << 7) + n;
    if k < mem.len() && mem[k] != 0 {
        return mem[k] - 1;
    }
    let mut res;
    if s == 0 {
        res = blink(mem, 1, n - 1);
    } else {
        let (a, b, split) = split_uint(s);
        if split {
            res = blink(mem, a, n - 1);
            res += blink(mem, b, n - 1);
        } else {
            res = blink(mem, 2024 * s, n - 1);
        }
    }
    if k < mem.len() {
        mem[k] = res + 1;
    }
    res
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut p1, mut p2) = (0, 0);
    let mut mem: [usize; CACHE_SIZE] = [0; CACHE_SIZE];
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::uint::<usize>(inp, i);
        i = j + 1;
        p2 += blink(&mut mem, n, 75);
        p1 += blink(&mut mem, n, 25);
    }
    (p1, p2)
}

fn split_uint(n: usize) -> (usize, usize, bool) {
    let mut l = 1;
    let mut m = 10;
    loop {
        if n < m {
            break;
        }
        l += 1;
        m *= 10;
    }
    if l & 1 == 1 {
        return (0, 0, false);
    }
    m = 10;
    for _ in 0..l / 2 - 1 {
        m *= 10;
    }
    let a = n / m;
    let b = n - a * m;
    (a, b, true)
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
    fn split_uint_works() {
        assert_eq!(split_uint(12), (1, 2, true));
        assert_eq!(split_uint(123), (0, 0, false));
        assert_eq!(split_uint(1234567890), (12345, 67890, true));
        assert_eq!(split_uint(123456789), (0, 0, false));
    }
    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/11/", parts);
    }
}
