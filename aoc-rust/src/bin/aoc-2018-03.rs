use arrayvec::ArrayVec;

#[derive(Debug, Default)]
struct Rect {
    x: u16,
    y: u16,
    xm: u16,
    ym: u16,
}

impl Rect {
    fn intersects(&self, other: &Rect) -> bool {
        self.x < other.xm && self.xm > other.x && self.y < other.ym && self.ym > other.y
    }
    fn intersect(&self, other: &Rect) -> Option<Rect> {
        if !self.intersects(other) {
            None
        } else {
            Some(Rect {
                x: self.x.max(other.x),
                y: self.y.max(other.y),
                xm: self.xm.min(other.xm),
                ym: self.ym.min(other.ym),
            })
        }
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut rects: ArrayVec<Rect, 1500> = ArrayVec::default();
    let mut i = 0;
    let mut area: [usize; 65536] = [0; 65536];
    while i < inp.len() {
        while inp[i] != b'@' {
            i += 1
        }
        let (j, x) = aoc::read::uint::<u16>(inp, i + 2);
        let (j, y) = aoc::read::uint::<u16>(inp, j + 1);
        let (j, w) = aoc::read::uint::<u16>(inp, j + 2);
        let (j, h) = aoc::read::uint::<u16>(inp, j + 1);
        rects.push(Rect {
            x,
            y,
            xm: x + w,
            ym: y + h,
        });
        i = j + 1;
    }
    let mut p2 = 0;
    for (i, r) in rects.iter().enumerate() {
        let mut overlap = false;
        for (j, o) in rects.iter().enumerate() {
            if i == j {
                continue;
            }
            if let Some(ri) = r.intersect(&o) {
                if i < j {
                    for y in ri.y as usize..ri.ym as usize {
                        for x in ri.x as usize..ri.xm as usize {
                            let k = x + y * 1024;
                            let (k, xb) = (k >> 6, 1 << (k & 0x3f));
                            area[k] |= xb;
                        }
                    }
                }
                overlap = true;
            }
        }
        if !overlap {
            p2 = i + 1;
        }
    }
    let mut p1 = 0;
    for i in 0..65536 {
        if area[i] == 0 {
            continue;
        }
        p1 += area[i].count_ones() as usize;
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
        let inp = std::fs::read("../2018/03/test.txt").expect("read error");
        assert_eq!(parts(&inp), (4, 3));
        let inp = std::fs::read("../2018/03/input.txt").expect("read error");
        assert_eq!(parts(&inp), (106501, 632));
        let inp = std::fs::read("../2018/03/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (120419, 445));
    }
}
