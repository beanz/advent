use nohash_hasher::IntSet;

fn parts(inp: &[u8]) -> (u16, u16) {
    let mut seats: IntSet<u16> = IntSet::default();
    let mut max = 0;
    let mut n = 0;
    let mut m = 1024;
    for ch in inp {
        match ch {
            b'F' | b'L' => {
                m /= 2;
            }
            b'B' | b'R' => {
                m /= 2;
                n += m;
            }
            b'\n' => {
                seats.insert(n);
                if max < n {
                    max = n;
                }
                n = 0;
                m = 1024;
            }
            _ => unreachable!("{}", ch),
        }
    }
    for s in &seats {
        if seats.contains(&(s - 2)) && !seats.contains(&(s - 1)) {
            return (max, s - 1);
        }
    }
    (max, 2)
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
        let inp = std::fs::read("../2020/05/input.txt").expect("read error");
        let (p1, p2) = parts(&inp);
        assert_eq!(p1, 947, "part 1");
        assert_eq!(p2, 636, "part 2");
    }
}
