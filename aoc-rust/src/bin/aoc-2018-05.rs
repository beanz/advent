fn parts(inp: &[u8]) -> (usize, usize) {
    let inp = &inp[0..inp.len() - 1];
    let mut buf = [0u8; 65536];
    let p1 = react(inp, &mut buf, b'A' - 1);
    let mut p2 = inp.len();
    for skip in b'A'..=b'Z' {
        let l = react(inp, &mut buf, skip);
        if p2 > l {
            p2 = l;
        }
    }
    (p1, p2)
}

fn react(inp: &[u8], buf: &mut [u8], skip: u8) -> usize {
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        if inp[i] == skip || inp[i] == skip + 32 {
            i += 1;
            continue;
        }
        if l > 0 && (inp[i] == buf[l - 1] + 32 || inp[i] == buf[l - 1] - 32) {
            l -= 1;
        } else {
            buf[l] = inp[i];
            l += 1;
        }
        i += 1;
    }
    l
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
        let inp = std::fs::read("../2018/05/test.txt").expect("read error");
        assert_eq!(parts(&inp), (10, 4));
        let inp = std::fs::read("../2018/05/input.txt").expect("read error");
        assert_eq!(parts(&inp), (11264, 4552));
        let inp = std::fs::read("../2018/05/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (11754, 4098));
    }
}
