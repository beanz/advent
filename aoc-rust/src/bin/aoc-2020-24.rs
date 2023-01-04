use heapless::FnvIndexSet;

const DIRS: [(i8, i8); 7] = [(0, 0), (1, 0), (0, -1), (-1, -1), (-1, 0), (0, 1), (1, 1)];

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut i = 0;
    let mut hxs = FnvIndexSet::<u32, 4096>::new();
    while i < inp.len() {
        let (j, hx) = HexPointTop::read(inp, i);
        i = j;
        let hi = hx.index() as u32;
        if hxs.contains(&hi) {
            hxs.remove(&hi);
        } else {
            hxs.insert(hi).expect("set insert");
        }
    }
    let p1 = hxs.len();
    let mut cur = &mut hxs;
    let mut hxs2 = FnvIndexSet::<u32, 4096>::new();
    let mut next = &mut hxs2;
    let mut done = FnvIndexSet::<u32, 16384>::new();
    for _d in 0..100 {
        for hx in cur.iter() {
            let (q, r) = HexPointTop::index2qr(*hx);
            for d in DIRS {
                let nq = q + d.0;
                let nr = r + d.1;
                let nx = HexPointTop::new(nq, nr);
                let ni = nx.index() as u32;
                if done.contains(&ni) {
                    continue;
                }
                done.insert(ni).expect("insert works");
                let mut c = 0;
                for nbd in DIRS {
                    if nbd.0 == 0 && nbd.1 == 0 {
                        continue;
                    }
                    let nbx = HexPointTop::new(nq + nbd.0, nr + nbd.1);
                    let nbi = nbx.index() as u32;
                    if cur.contains(&nbi) {
                        c += 1;
                    }
                }
                let is_cur = cur.contains(&ni);
                if (is_cur && !(c == 0 || c > 2)) || (!is_cur && c == 2) {
                    next.insert(ni).expect("next insert");
                }
            }
        }
        (cur, next) = (next, cur);
        next.clear();
        done.clear();
    }
    (p1, cur.len())
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

struct HexPointTop {
    v: u32,
}

impl HexPointTop {
    fn new(q: i8, r: i8) -> HexPointTop {
        HexPointTop {
            v: ((((q as u8) as u32) << 8) + (r as u8) as u32),
        }
    }
    fn index2qr(i: u32) -> (i8, i8) {
        (((i >> 8) as u8) as i8, ((i & 0xff) as u8) as i8)
    }
    fn index(&self) -> usize {
        self.v as usize
    }
    #[allow(dead_code)]
    fn q(&self) -> i8 {
        ((self.v >> 8) as u8) as i8
    }
    #[allow(dead_code)]
    fn r(&self) -> i8 {
        ((self.v & 0xff) as u8) as i8
    }
    fn read(inp: &[u8], i: usize) -> (usize, HexPointTop) {
        let mut q = 0i8;
        let mut r = 0i8;
        let mut i = i;
        while i < inp.len() && inp[i] != b'\n' {
            match inp[i] {
                b'e' => {
                    q += 1;
                    i += 1;
                }
                b'w' => {
                    q -= 1;
                    i += 1;
                }
                b's' => match inp[i + 1] {
                    b'e' => {
                        r -= 1;
                        i += 2;
                    }
                    b'w' => {
                        q -= 1;
                        r -= 1;
                        i += 2;
                    }
                    _ => unreachable!("invalid hex point top move"),
                },
                b'n' => match inp[i + 1] {
                    b'e' => {
                        q += 1;
                        r += 1;
                        i += 2;
                    }
                    b'w' => {
                        r += 1;
                        i += 2;
                    }
                    _ => unreachable!("invalid hex point top move"),
                },
                _ => unreachable!("invalid hex point top move"),
            }
        }
        (i + 1, HexPointTop::new(q, r))
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/24/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (10, 2208));
        let inp = std::fs::read("../2020/24/input.txt").expect("read error");
        assert_eq!(parts(&inp), (307, 3787));
        let inp = std::fs::read("../2020/24/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (312, 3733));
    }
}
