fn parts(inp: &[u8]) -> (usize, usize) {
    let mut n = 0;
    let mut i = 0;
    while i < inp.len() {
        match inp[i] {
            b'\n' => {
                break;
            }
            b'0'..=b'9' => n = n * 10 + (inp[i] - b'0') as isize,
            _ => unreachable!("invalid timestamp"),
        }
        i += 1;
    }
    i += 1;
    let ts = n;
    let mut u = vec![];
    let mut m = vec![];
    let mut min = isize::max_value();
    let mut bus = 0;
    let mut num = false;
    n = 0;
    let mut t = 0;
    while i < inp.len() {
        match inp[i] {
            b',' | b'\n' => {
                if num {
                    let mt = n - (ts % n);
                    if mt < min {
                        min = mt;
                        bus = n;
                    }
                    u.push(n - t);
                    m.push(n);
                    n = 0;
                    num = false;
                }
                t += 1;
            }
            b'x' => {}
            b'0'..=b'9' => {
                num = true;
                n = n * 10 + (inp[i] - b'0') as isize;
            }
            _ => unreachable!("invalid timestamp"),
        }
        i += 1;
    }
    let a = aoc::math::crt(&u, &m).unwrap();
    ((bus as usize) * (min as usize), a as usize)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/13/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (295, 1068781));
        let inp = std::fs::read("../2020/13/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (130, 3417));
        let inp = std::fs::read("../2020/13/test3.txt").expect("read error");
        assert_eq!(parts(&inp), (295, 754018));
        let inp = std::fs::read("../2020/13/test4.txt").expect("read error");
        assert_eq!(parts(&inp), (295, 779210));
        let inp = std::fs::read("../2020/13/test5.txt").expect("read error");
        assert_eq!(parts(&inp), (295, 1261476));
        let inp = std::fs::read("../2020/13/test6.txt").expect("read error");
        assert_eq!(parts(&inp), (47, 1202161486));
        let inp = std::fs::read("../2020/13/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3035, 725169163285238));
    }
}
