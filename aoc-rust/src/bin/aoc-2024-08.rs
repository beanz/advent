fn parts(inp: &[u8]) -> (usize, usize) {
    let mut a: [Option<(i32, i32)>; 4 * 80] = [None; 4 * 80];
    let (mut x, mut y, mut w) = (0, 0, 0);
    for ch in inp {
        match ch {
            b'\n' => {
                w = x;
                y += 1;
                x = 0;
                continue;
            }
            b'.' => {}
            _ => {
                let mut ai = (ch - b'0') as usize * 4;
                while a[ai].is_some() {
                    ai += 1
                }
                a[ai] = Some((x, y));
            }
        }
        x += 1;
    }
    let h = inp.len() as i32 / (w + 1);
    let mut p1 = 0;
    let mut an1: [bool; 4096] = [false; 4096];
    let mut p1s = |x: i32, y: i32| {
        if !(0 <= x && x < w && 0 <= y && y < h) {
            return false;
        }
        let k = (x + y * w) as usize;
        if !an1[k] {
            p1 += 1;
        }
        an1[k] = true;
        true
    };
    let mut p2 = 0;
    let mut an2: [bool; 4096] = [false; 4096];
    let mut p2s = |x: i32, y: i32| {
        if !(0 <= x && x < w && 0 <= y && y < h) {
            return false;
        }
        let k = (x + y * w) as usize;
        if !an2[k] {
            p2 += 1;
        }
        an2[k] = true;
        true
    };
    for k in 0..80 {
        for i in 0..4 {
            if a[k * 4 + i].is_none() {
                break;
            }
            let (ax, ay) = a[k * 4 + i].unwrap();
            for j in i + 1..4 {
                if a[k * 4 + j].is_none() {
                    break;
                }
                let (bx, by) = a[k * 4 + j].unwrap();
                p2s(ax, ay);
                p2s(bx, by);
                let (dx, dy) = (ax - bx, ay - by);
                let (mut x, mut y) = (ax + dx, ay + dy);
                if p1s(x, y) {
                    while p2s(x, y) {
                        (x, y) = (x + dx, y + dy);
                    }
                }
                (x, y) = (bx - dx, by - dy);
                if p1s(x, y) {
                    while p2s(x, y) {
                        (x, y) = (x - dx, y - dy);
                    }
                }
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
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/08/", parts);
    }
}
