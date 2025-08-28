use heapless::Vec;

fn parts(inp: &[u8]) -> (isize, usize) {
    let mut i = 0;
    for _ in 0..8 {
        i = aoc::read::skip_next_line(inp, i);
    }
    let (i, n) = aoc::read::uint::<usize>(inp, i + 6);
    let (_, v) = aoc::read::int::<isize>(inp, i + 7);
    let mut values = Vec::<isize, 256>::new();
    prog0(v, n, &mut values);
    let p1 = values[values.len() - 1];
    let mut c = 0;
    // bubblesort
    loop {
        c += 1;
        let mut swap = false;
        for i in 1..values.len() {
            if values[i - 1] < values[i] {
                swap = true;
                (values[i], values[i - 1]) = (values[i - 1], values[i]);
            }
        }
        if !swap {
            break;
        }
    }
    (p1, (c + 1) * values.len() / 2)
}

fn prog0(v: isize, n: usize, out: &mut Vec<isize, 256>) {
    let mut i = n;
    let mut p = v;
    while i > 0 {
        p *= 8505;
        p %= 0x7fffffff;
        p *= 129749;
        p += 12345;
        p %= 0x7fffffff;
        let b = p % 10000;
        out.push(b).expect("out full");
        i -= 1;
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
        //let inp = std::fs::read("../2017/18/test1.txt").expect("read error");
        //assert_eq!(parts(&inp), (3420, 21));
        let inp = std::fs::read("../2017/18/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (1367, 8));
        //let inp = std::fs::read("../2017/18/test3.txt").expect("read error");
        //assert_eq!(parts(&inp), (9931, 12));
        let inp = std::fs::read("../2017/18/input.txt").expect("read error");
        assert_eq!(parts(&inp), (4601, 6858));
        let inp = std::fs::read("../2017/18/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (9423, 7620));
    }
}
