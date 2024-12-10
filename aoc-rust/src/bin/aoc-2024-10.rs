fn parts(inp: &[u8]) -> (usize, usize) {
    let w = inp.iter().position(|&ch| ch == b'\n').expect("no EOL");
    let h = inp.len() / (w + 1);
    fn get(inp: &[u8], w: usize, h: usize, x: i32, y: i32) -> u8 {
        if 0 <= x && x < (w as i32) && 0 <= y && y < (h as i32) {
            inp[(x as usize) + (y as usize) * (w + 1)]
        } else {
            b'.'
        }
    }
    let score = |x, y, z| -> usize {
        let mut sc = 0;
        let mut todo = aoc::deque::Deque::<(i32, i32, u8), 512>::default();
        todo.push((x, y, z));
        let mut seen = [false; 2048];
        while let Some((x, y, z)) = todo.pop() {
            let k = (x as usize) + (y as usize) * (w + 1);
            if seen[k] {
                continue;
            }
            seen[k] = true;
            if z == b'9' {
                sc += 1;
                continue;
            }
            if get(inp, w, h, x, y - 1) == z + 1 {
                todo.push((x, y - 1, z + 1));
            }
            if get(inp, w, h, x + 1, y) == z + 1 {
                todo.push((x + 1, y, z + 1));
            }
            if get(inp, w, h, x, y + 1) == z + 1 {
                todo.push((x, y + 1, z + 1));
            }
            if get(inp, w, h, x - 1, y) == z + 1 {
                todo.push((x - 1, y, z + 1));
            }
        }
        sc
    };
    fn rank(inp: &[u8], w: usize, h: usize, x: i32, y: i32, z: u8) -> usize {
        let mut r = 0;
        if z == b'9' {
            return 1;
        }
        if get(inp, w, h, x, y - 1) == z + 1 {
            r += rank(inp, w, h, x, y - 1, z + 1);
        }
        if get(inp, w, h, x + 1, y) == z + 1 {
            r += rank(inp, w, h, x + 1, y, z + 1);
        }
        if get(inp, w, h, x, y + 1) == z + 1 {
            r += rank(inp, w, h, x, y + 1, z + 1);
        }
        if get(inp, w, h, x - 1, y) == z + 1 {
            r += rank(inp, w, h, x - 1, y, z + 1);
        }
        r
    }
    let (mut p1, mut p2) = (0, 0);
    for y in 0..h {
        for x in 0..w {
            if inp[x + y * (w + 1)] == b'0' {
                p1 += score(x as i32, y as i32, b'0');
                p2 += rank(inp, w, h, x as i32, y as i32, b'0');
            }
        }
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
        aoc::test::auto("../2024/10/", parts);
    }
}
