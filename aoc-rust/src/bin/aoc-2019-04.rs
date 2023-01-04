fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut st = [inp[0], inp[1], inp[2], inp[3], inp[4], inp[5]];
    while st[0] != inp[7]
        || st[1] != inp[8]
        || st[2] != inp[9]
        || st[3] != inp[10]
        || st[4] != inp[11]
        || st[5] != inp[12]
    {
        if st[4] <= st[5]
            && st[3] <= st[4]
            && st[2] <= st[3]
            && st[1] <= st[2]
            && st[0] <= st[1]
            && (st[0] == st[1]
                || st[1] == st[2]
                || st[2] == st[3]
                || st[3] == st[4]
                || st[4] == st[5])
        {
            p1 += 1;

            if (st[0] == st[1] && st[1] != st[2])
                || (st[1] == st[2] && st[2] != st[3] && st[1] != st[0])
                || (st[2] == st[3] && st[3] != st[4] && st[2] != st[1])
                || (st[3] == st[4] && st[4] != st[5] && st[3] != st[2])
                || (st[4] == st[5] && st[4] != st[3])
            {
                p2 += 1;
            }
        }
        if st[5] != b'9' {
            st[5] += 1;
            continue;
        }
        st[5] = b'0';
        if st[4] != b'9' {
            st[4] += 1;
            continue;
        }
        st[4] = b'0';
        if st[3] != b'9' {
            st[3] += 1;
            continue;
        }
        st[3] = b'0';
        if st[2] != b'9' {
            st[2] += 1;
            continue;
        }
        st[2] = b'0';
        if st[1] != b'9' {
            st[1] += 1;
            continue;
        }
        st[1] = b'0';
        st[0] += 1;
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
        let inp = std::fs::read("../2019/04/input.txt").expect("read error");
        assert_eq!(parts(&inp), (931, 609));
        let inp = std::fs::read("../2019/04/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (921, 603));
    }
}
