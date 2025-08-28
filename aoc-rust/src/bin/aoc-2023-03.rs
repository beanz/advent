fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut p1, mut p2) = (0, 0);
    let mut w = 0;
    while inp[w] != b'\n' {
        w += 1;
    }
    let mut seen: [usize; 141 * 141] = [0; 141 * 141];
    let w = w + 1;
    let mut i = 0;
    while i < inp.len() {
        let ch = inp[i];
        if !ch.is_ascii_digit() {
            i += 1;
            continue;
        }
        let mut n = (ch - b'0') as usize;
        let mut j = i + 1;
        while j < inp.len() && inp[j].is_ascii_digit() {
            n = n * 10 + ((inp[j] - b'0') as usize);
            j += 1;
        }
        let l = j - i;
        let (sym, k) = symbol(inp, i, l, w);
        if sym != b'.' {
            //println!("F: {} {}", n, sym as char);
            p1 += n;
            if seen[k] != 0 {
                p2 += seen[k] * n;
            } else {
                seen[k] = n;
            }
        }
        i = j;
    }

    (p1, p2)
}

fn symbol(inp: &[u8], i: usize, l: usize, w: usize) -> (u8, usize) {
    let check = |i: usize| inp[i] != b'.' && inp[i] != b'\n' && !(b'0' <= inp[i] && inp[i] <= b'9');
    for o in w - l..=w + 1 {
        if i >= o && check(i - o) {
            return (inp[i - o], i - o);
        }
    }
    if i > 0 && check(i - 1) {
        return (inp[i - 1], i - 1);
    }
    if i + l < inp.len() && check(i + l) {
        return (inp[i + l], i + l);
    }
    for j in i + w - 1..=i + w + l {
        if j < inp.len() && check(j) {
            return (inp[j], j);
        }
    }
    (b'.', 0)
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
        let inp = std::fs::read("../2023/03/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (4361, 467835));
        let inp = std::fs::read("../2023/03/input.txt").expect("read error");
        assert_eq!(parts(&inp), (549908, 81166799));
        let inp = std::fs::read("../2023/03/input2.txt").expect("read error");
        assert_eq!(parts(&inp), (512794, 67779080));
    }
}
