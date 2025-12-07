fn parts(inp: &[u8]) -> (usize, usize) {
    let w: usize = inp.iter().position(|&ch| ch == b'\n').unwrap() + 1;
    let h = inp.len() / w;
    let mut p1: usize = 0;
    let mut first: usize = 0;
    let mut last: usize = w - 2;
    let mut b: [usize; 150] = [0; 150];
    for y in 0..h {
        'LL: for x in first..=last {
            match inp[x + y * w] {
                b'S' => {
                    b[x] += 1;
                    first = x - 1;
                    last = x + 1;
                    break 'LL;
                }
                b'^' => {
                    if b[x] > 0 {
                        b[x - 1] += b[x];
                        b[x + 1] += b[x];
                        b[x] = 0;
                        p1 += 1;
                        if x == first {
                            first -= 1;
                        }
                        if x == last {
                            last += 1;
                        }
                    }
                }
                _ => {}
            }
        }
    }
    (p1, b.iter().sum())
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
        aoc::test::auto("../2025/07/", parts);
    }
}
