use arrayvec::ArrayVec;

fn parts(inp: &[u8]) -> (usize, [u8; 25], usize) {
    let mut cc: [u8; 26] = [0; 26];
    let (mut two, mut three) = (0, 0);
    let mut lines: ArrayVec<usize, 256> = ArrayVec::default();
    let mut j = 0;
    let mut l = 0;
    for (i, ch) in inp.iter().enumerate() {
        match ch {
            b'\n' => {
                let (mut inc2, mut inc3) = (0, 0);
                for c in cc.iter_mut() {
                    match c {
                        2 => inc2 = 1,
                        3 => inc3 = 1,
                        _ => {}
                    }
                    *c = 0;
                }
                two += inc2;
                three += inc3;
                lines.push(j);
                l = i - j;
                j = i + 1;
            }
            b'a'..=b'z' => {
                cc[(ch - b'a') as usize] += 1;
            }
            _ => unreachable!(),
        }
    }
    let mut p2 = [0u8; 25];
    let mut p2l = 0;
    'outer: for i in 0..lines.len() {
        for j in i + 1..lines.len() {
            p2l = 0;
            for k in 0..l {
                if inp[lines[i] + k] == inp[lines[j] + k] {
                    p2[p2l] = inp[lines[i] + k];
                    p2l += 1;
                }
            }
            if p2l == l - 1 {
                break 'outer;
            }
        }
    }

    (two * three, p2, p2l)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2, p2l) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!(
                "Part 2: {}",
                std::str::from_utf8(&p2[0..p2l]).expect("ascii")
            );
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/02/test1.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 12);
        assert_eq!(std::str::from_utf8(&p2[0..p2l]).expect("ascii"), "abcde");
        let inp = std::fs::read("../2018/02/test2.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 0);
        assert_eq!(std::str::from_utf8(&p2[0..p2l]).expect("ascii"), "fgij");
        let inp = std::fs::read("../2018/02/input.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 9633);
        assert_eq!(
            std::str::from_utf8(&p2[0..p2l]).expect("ascii"),
            "lujnogabetpmsydyfcovzixaw"
        );
        let inp = std::fs::read("../2018/02/input-amf.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 5434);
        assert_eq!(
            std::str::from_utf8(&p2[0..p2l]).expect("ascii"),
            "agimdjvlhedpsyoqfzuknpjwt"
        );
    }
}
