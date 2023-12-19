fn parts(inp: &[u8], mul: usize) -> (usize, usize) {
    let w = inp.iter().position(|&ch| ch == b'\n').unwrap();
    let h = inp.len() / (w + 1);
    let mut cx: [usize; 140] = [0; 140];
    let mut cy: [usize; 140] = [0; 140];
    let (mut xmin, mut xmax, mut ymin, mut ymax): (usize, usize, usize, usize) = (w, 0, h, 0);
    let mut gc = 0;
    let ch = |x: usize, y: usize| inp[y * (w + 1) + x];
    for y in 0..h {
        for x in 0..w {
            if ch(x, y) != b'.' {
                gc += 1;
                cx[x] += 1;
                cy[y] += 1;
                if x > xmax {
                    xmax = x;
                }
                if x < xmin {
                    xmin = x;
                }
            }
        }
        if cy[y] > 0 {
            if y > ymax {
                ymax = y;
            }
            if y < ymin {
                ymin = y;
            }
        }
    }
    let (dx1, dx2) = dist(gc, xmin, xmax, cx, mul);
    let (dy1, dy2) = dist(gc, ymin, ymax, cy, mul);
    (dx1 + dy1, dx2 + dy2)
}

fn dist(gc: usize, min: usize, max: usize, v: [usize; 140], mul: usize) -> (usize, usize) {
    let (mut d1, mut d2) = (0, 0);
    let (mut exp1, mut exp2) = (0, 0);
    let mut px = min;
    let mut nx = v[min];
    for x in min + 1..=max {
        if v[x] > 0 {
            d1 += (x - px + exp1) * nx * (gc - nx);
            d2 += (x - px + exp2) * nx * (gc - nx);
            nx += v[x];
            px = x;
            (exp1, exp2) = (0, 0);
        } else {
            exp1 += 1;
            exp2 += mul - 1;
        }
    }
    (d1, d2)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp, 1000000);
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
        let inp = std::fs::read("../2023/11/test1.txt").expect("read error");
        assert_eq!(parts(&inp, 10), (374, 1030));
        let inp = std::fs::read("../2023/11/test1.txt").expect("read error");
        assert_eq!(parts(&inp, 100), (374, 8410));
        let inp = std::fs::read("../2023/11/test1.txt").expect("read error");
        assert_eq!(parts(&inp, 1000000), (374, 82000210));
        let inp = std::fs::read("../2023/11/input.txt").expect("read error");
        assert_eq!(parts(&inp, 1000000), (9918828, 692506533832));
    }
}
