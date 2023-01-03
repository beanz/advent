use std::collections::HashMap;

fn parts(inp: &[u8]) -> (u32, u32) {
    let mut points: HashMap<(i16, i16), (u32, u32)> = HashMap::new();
    let mut p1 = u32::MAX;
    let mut p2 = u32::MAX;
    let mut i = 0;
    let mut l = 0;
    let mut x = 0i16;
    let mut y = 0i16;
    let mut step = 0u32;
    while i < inp.len() {
        loop {
            let d = match inp[i] {
                b'U' => (0, -1),
                b'D' => (0, 1),
                b'L' => (-1, 0),
                b'R' => (1, 0),
                _ => unreachable!("invalid direction"),
            };
            let (j, n) = aoc::read::uint::<usize>(inp, i + 1);
            i = j;
            for _ in 0..n {
                x += d.0;
                y += d.1;
                step += 1;
                if l == 0 {
                    points.insert((x, y), ((x.abs() + y.abs()) as u32, step));
                    continue;
                }
                let prev = match points.get(&(x, y)) {
                    None => continue,
                    Some(x) => x,
                };
                if p1 > prev.0 {
                    p1 = prev.0;
                }
                if p2 > step + prev.1 {
                    p2 = step + prev.1;
                }
            }
            if inp[i] == b'\n' {
                break;
            }
            i += 1;
        }
        l += 1;
        (x, y, step) = (0, 0, 0);
        i += 1;
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
        let inp = std::fs::read("../2019/03/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (6, 30));
        let inp = std::fs::read("../2019/03/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (159, 610));
        let inp = std::fs::read("../2019/03/test3.txt").expect("read error");
        assert_eq!(parts(&inp), (135, 410));
        let inp = std::fs::read("../2019/03/input.txt").expect("read error");
        assert_eq!(parts(&inp), (225, 35194));
        let inp = std::fs::read("../2019/03/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (5319, 122514));
    }
}
