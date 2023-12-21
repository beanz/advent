use ahash::AHasher;
use heapless::FnvIndexMap;
use std::hash::Hasher;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut cpy: [u8; 10240] = [0; 10240];
    for i in 0..inp.len() {
        cpy[i] = inp[i];
    }
    let mut inp = cpy;
    let w = inp.iter().position(|&ch| ch == b'\n').unwrap();
    rotate_and_tilt(&mut inp, w);
    let mut p1 = 0;
    for y in 0..w {
        let yi = (w + 1) * y;
        for x in 0..w {
            if inp[yi + x] == b'O' {
                p1 += x + 1;
            }
        }
    }
    let mut seen = FnvIndexMap::<_, _, 256>::new();
    let tar = 1000000000;
    let mut c = 1;
    let mut found = false;
    while c <= tar {
        rotate_and_tilt(&mut inp, w);
        rotate_and_tilt(&mut inp, w);
        rotate_and_tilt(&mut inp, w);
        let mut hasher = AHasher::default();
        hasher.write(&inp);
        let hash = hasher.finish();
        if !found {
            if let Some(pc) = seen.get(&hash) {
                found = true;
                let l = c - pc;
                c += ((tar - c) / l) * l;
            } else {
                seen.insert(hash, c).expect("hash full");
            }
        }
        c += 1;
        if c > tar {
            break;
        }
        rotate_and_tilt(&mut inp, w);
    }
    let mut p2 = 0;
    for y in 0..w {
        let yi = (w + 1) * y;
        for x in 0..w {
            if inp[yi + x] == b'O' {
                p2 += w - y;
            }
        }
    }
    (p1, p2)
}

fn rotate_and_tilt(inp: &mut [u8], w: usize) {
    for x in 0..w / 2 {
        let xo = w - x - 1;
        let xyi = x * (w + 1);
        let xyoi = (w - x - 1) * (w + 1);
        for y in x..w - x - 1 {
            let yo = w - y - 1;
            let yi = y * (w + 1);
            let yoi = yo * (w + 1);
            (inp[xyi + y], inp[yi + xo], inp[xyoi + yo], inp[yoi + x]) =
                (inp[yoi + x], inp[xyi + y], inp[yi + xo], inp[xyoi + yo]);
        }
    }
    for y in 0..w {
        let mut xm: isize = w as isize - 1;
        for x in (0..w).rev() {
            match inp[(w + 1) * y + x] {
                b'#' => {
                    xm = x as isize - 1;
                }
                b'O' => {
                    inp[(w + 1) * y + x] = b'.';
                    inp[(((w + 1) * y) as isize + xm) as usize] = b'O';
                    xm -= 1;
                }
                _ => {}
            }
        }
    }
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
        let inp = std::fs::read("../2023/14/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (136, 64));
        let inp = std::fs::read("../2023/14/input.txt").expect("read error");
        assert_eq!(parts(&inp), (109424, 102509));
    }
}
