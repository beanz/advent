fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut p1, mut p2) = (0, 0);
    let (mut f1, mut l1) = (0, 0);
    let (mut f2, mut l2) = (0, 0);
    let mut i = 0;
    let first = |f: &mut usize, x: usize| {
        if *f == 0 {
            *f = x;
        }
    };
    let binp = |i| {
        if i < inp.len() {
            inp[i]
        } else {
            0
        }
    };
    while i < inp.len() {
        if inp[i] == b'\n' {
            p1 += f1 * 10 + l1;
            p2 += f2 * 10 + l2;
            (f1, l1) = (0, 0);
            (f2, l2) = (0, 0);
        } else if inp[i] >= b'1' && inp[i] <= b'9' {
            let n = (inp[i] - b'0') as usize;
            first(&mut f1, n);
            first(&mut f2, n);
            l1 = n;
            l2 = n;
        } else if inp[i] == b'o' && binp(i + 1) == b'n' && binp(i + 2) == b'e' {
            first(&mut f2, 1);
            l2 = 1;
        } else if inp[i] == b't' {
            if binp(i + 1) == b'w' && binp(i + 2) == b'o' {
                first(&mut f2, 2);
                l2 = 2;
            } else if binp(i + 1) == b'h'
                && binp(i + 2) == b'r'
                && binp(i + 3) == b'e'
                && binp(i + 4) == b'e'
            {
                first(&mut f2, 3);
                l2 = 3;
            }
        } else if inp[i] == b'f' {
            if binp(i + 1) == b'o' && binp(i + 2) == b'u' && binp(i + 3) == b'r' {
                first(&mut f2, 4);
                l2 = 4;
            } else if binp(i + 1) == b'i' && binp(i + 2) == b'v' && binp(i + 3) == b'e' {
                first(&mut f2, 5);
                l2 = 5;
            }
        } else if inp[i] == b's' {
            if binp(i + 1) == b'i' && binp(i + 2) == b'x' {
                first(&mut f2, 6);
                l2 = 6;
            } else if binp(i + 1) == b'e'
                && binp(i + 2) == b'v'
                && binp(i + 3) == b'e'
                && binp(i + 4) == b'n'
            {
                first(&mut f2, 7);
                l2 = 7;
            }
        } else if inp[i] == b'e'
            && binp(i + 1) == b'i'
            && binp(i + 2) == b'g'
            && binp(i + 3) == b'h'
            && binp(i + 4) == b't'
        {
            first(&mut f2, 8);
            l2 = 8;
        } else if inp[i] == b'n'
            && binp(i + 1) == b'i'
            && binp(i + 2) == b'n'
            && binp(i + 3) == b'e'
        {
            first(&mut f2, 9);
            l2 = 9;
        }

        i += 1;
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
        let inp = std::fs::read("../2023/01/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (142, 142));
        let inp = std::fs::read("../2023/01/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (209, 281));
        let inp = std::fs::read("../2023/01/input.txt").expect("read error");
        assert_eq!(parts(&inp), (54390, 54277));
    }
}
