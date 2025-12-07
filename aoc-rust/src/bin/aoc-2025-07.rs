fn parts(inp: &[u8]) -> (usize, usize) {
    let mut x: usize = 0;
    let mut p1: usize = 0;
    let mut b: [usize; 150] = [0; 150];
    for ch in inp {
        match ch {
            b'S' => b[x] += 1,
            b'\n' => {
                x = 0;
                continue;
            }
            b'^' => {
                if b[x] > 0 {
                    b[x - 1] += b[x];
                    b[x + 1] += b[x];
                    b[x] = 0;
                    p1 += 1;
                }
            }
            _ => {}
        }
        x += 1;
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
