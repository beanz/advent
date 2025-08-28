use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut t = 0;
    let mut ts = SmallVec::<[usize; 10]>::new();
    let mut i = 0;
    let mut n = 0;
    let mut num = false;
    while inp[i] != b'\n' {
        match inp[i] {
            b'0'..=b'9' => {
                num = true;
                let d = (inp[i] - b'0') as usize;
                n = n * 10 + d;
                t = t * 10 + d;
            }
            _ => {
                if num {
                    ts.push(n);
                    n = 0;
                    num = false;
                }
            }
        }
        i += 1;
    }
    if num {
        ts.push(n);
        n = 0;
        num = false;
    }
    i += 1;
    let mut r = 0;
    let mut rs = SmallVec::<[usize; 10]>::new();
    while inp[i] != b'\n' {
        match inp[i] {
            b'0'..=b'9' => {
                num = true;
                let d = (inp[i] - b'0') as usize;
                n = n * 10 + d;
                r = r * 10 + d;
            }
            _ => {
                if num {
                    rs.push(n);
                    n = 0;
                    num = false;
                }
            }
        }
        i += 1;
    }
    if num {
        rs.push(n);
    }
    let mut p1 = 1;
    for i in 0..ts.len() {
        let c = race(ts[i], rs[i]);
        if c > 0 {
            p1 *= c;
        }
    }
    (p1, race(t, r))
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

fn race(t: usize, r: usize) -> usize {
    let d = ((t * t - 4 * (r + 1)) as f64).sqrt();
    let l = (((t as f64) - d) / 2.0).ceil() as usize;
    let h = (((t as f64) + d) / 2.0).floor() as usize;
    h - l + 1
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2023/06/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (288, 71503));
        let inp = std::fs::read("../2023/06/input.txt").expect("read error");
        assert_eq!(parts(&inp), (5133600, 40651271));
    }
}
