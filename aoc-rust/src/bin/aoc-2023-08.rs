use heapless::FnvIndexMap;
use num::integer::lcm;
use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, u64) {
    let mut i = 0;
    while inp[i] != b'\n' {
        i += 1
    }
    let steps = &inp[0..i];
    i += 2;
    let mut g = SmallVec::<[u32; 1024]>::new();
    let mut m = FnvIndexMap::<u32, (u32, u32), 1024>::new();
    while i < inp.len() {
        let f = id(inp, i);
        let l = id(inp, i + 7);
        let r = id(inp, i + 12);
        m.insert(f, (l, r)).expect("moves map full");
        if inp[i + 2] == b'A' {
            g.push(f);
        }
        i += 17;
    }
    let mut p1: usize = 0;
    let mut p: u32 = 0;
    while let Some(mv) = m.get(&p) {
        if steps[p1 % steps.len()] == b'L' {
            p = mv.0;
        } else {
            p = mv.1;
        }
        p1 += 1;
        if p == 26425 {
            break;
        }
    }
    let p2 = |p: u32| -> usize {
        let mut p = p;
        let mut c: usize = 0;
        loop {
            if let Some(mv) = m.get(&p) {
                if steps[c % steps.len()] == b'L' {
                    p = mv.0;
                } else {
                    p = mv.1;
                }
            }
            c += 1;
            if (p & 0x1f) == 25 {
                return c;
            }
        }
    };
    let mut l: u64 = 1;
    for p in g {
        let s = p2(p);
        l = lcm(l, s as u64);
    }

    (p1, l)
}

fn id(inp: &[u8], i: usize) -> u32 {
    (((inp[i] - b'A') as u32) << 10)
        + (((inp[i + 1] - b'A') as u32) << 5)
        + ((inp[i + 2] - b'A') as u32)
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
        let inp = std::fs::read("../2023/08/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (2, 2));
        let inp = std::fs::read("../2023/08/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (6, 6));
        let inp = std::fs::read("../2023/08/test3.txt").expect("read error");
        assert_eq!(parts(&inp), (0, 6));
        let inp = std::fs::read("../2023/08/input.txt").expect("read error");
        assert_eq!(parts(&inp), (20569, 21366921060721));
    }
}
