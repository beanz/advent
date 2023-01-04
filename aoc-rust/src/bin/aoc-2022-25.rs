const ANS_LEN: usize = 20;

fn part(inp: &[u8]) -> [u8; ANS_LEN] {
    let mut s = 0;
    let mut n: usize = 0;
    for ch in inp {
        match ch {
            b'\n' => {
                s += n;
                n = 0;
            }
            b'2' => {
                n = 5 * n + 2;
            }
            b'1' => {
                n = 5 * n + 1;
            }
            b'0' => {
                n *= 5;
            }
            b'-' => {
                n = 5 * n - 1;
            }
            b'=' => {
                n = 5 * n - 2;
            }
            _ => unreachable!("invalid digit"),
        }
    }
    let mut res = [32; ANS_LEN];
    let mut l = ANS_LEN - 1;
    loop {
        let m = s % 5;
        match m {
            0 => {
                res[l] = b'0';
                s /= 5
            }
            1 => {
                res[l] = b'1';
                s /= 5
            }
            2 => {
                res[l] = b'2';
                s /= 5
            }
            3 => {
                res[l] = b'=';
                s = (s + 2) / 5
            }
            4 => {
                res[l] = b'-';
                s = (s + 1) / 5
            }
            _ => unreachable!("mod"),
        }
        if s == 0 {
            break;
        }
        l -= 1;
    }
    if l > 0 {
        l -= 1;
        loop {
            res[l] = b' ';
            if l == 0 {
                break;
            }
            l -= 1;
        }
    }
    res
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let p1 = part(&inp);
        if !bench {
            println!("Part 1: {}", std::str::from_utf8(&p1[0..]).expect("ascii"));
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/25/test1.txt").expect("read error");
        assert_eq!(part(&inp), *b"              2=-1=0");
        let inp = std::fs::read("../2022/25/input.txt").expect("read error");
        assert_eq!(part(&inp), *b"122-12==0-01=00-0=02");
    }
}
