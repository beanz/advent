use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut p1, mut p2) = (0, 0);
    let mut i = 0;
    let mut copies = SmallVec::<[(usize, usize); 10]>::new();
    while i < inp.len() {
        let mut w: [bool; 256] = [false; 256];
        let mut p = 0;
        while inp[i] != b':' {
            i += 1
        }
        i += 2;
        aoc::read::visit_uint_until::<usize>(inp, &mut i, b'|', |x: usize| {
            w[x] = true;
        });
        i += 2;
        aoc::read::visit_uint_until::<usize>(inp, &mut i, b'\n', |x: usize| {
            if w[x] {
                p += 1;
            }
        });
        p1 += (1 << p) >> 1;
        i += 1;
        let mut n = 1;
        copies.drain_filter(|(count, num)| {
            *count -= 1;
            n += *num;
            *count == 0
        });
        p2 += n;
        if p > 0 {
            copies.push((p, n));
        }
    }
    (p1, p2)
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
        let inp = std::fs::read("../2023/04/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (13, 30));
        let inp = std::fs::read("../2023/04/input.txt").expect("read error");
        assert_eq!(parts(&inp), (25183, 5667240));
    }
}
