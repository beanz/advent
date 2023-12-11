use smallvec::SmallVec;

fn parts(inp: &[u8], mul: usize) -> (usize, usize) {
    let w = inp.iter().position(|&ch| ch == b'\n').unwrap();
    let h = inp.len() / (w + 1);
    let mut cx: [bool; 140] = [true; 140];
    let mut cy: [bool; 140] = [true; 140];
    let ch = |x: usize, y: usize| inp[y * (w + 1) + x];
    for y in 0..h {
        for x in 0..w {
            if ch(x, y) != b'.' {
                cy[y] = false;
                break;
            }
        }
    }
    for x in 0..w {
        for y in 0..h {
            if ch(x, y) != b'.' {
                cx[x] = false;
                break;
            }
        }
    }
    let (mut ax, mut ay): (usize, usize) = (0, 0);
    let (mut ax2, mut ay2) = (0, 0);
    let mut g = SmallVec::<[(usize, usize); 512]>::new();
    let mut g2 = SmallVec::<[(usize, usize); 512]>::new();
    for y in 0..h {
        for x in 0..w {
            if ch(x, y) != b'.' {
                g.push((ax, ay));
                g2.push((ax2, ay2));
            }
            let inc: usize = cx[x].into();
            ax += 1 + inc;
            ax2 += 1 + inc * (mul - 1);
        }
        ax = 0;
        ax2 = 0;
        let inc: usize = cy[y].into();
        ay += 1 + inc;
        ay2 += 1 + inc * (mul - 1);
    }
    let mut p1 = 0;
    let mut p2 = 0;
    for i in 0..g.len() {
        for j in i + 1..g.len() {
            p1 += g[i].0.abs_diff(g[j].0) + g[i].1.abs_diff(g[j].1);
            p2 += g2[i].0.abs_diff(g2[j].0) + g2[i].1.abs_diff(g2[j].1);
        }
    }

    (p1, p2)
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
