use indexmap::set::IndexSet;

#[derive(Debug)]
struct Polymer {
    init: [usize; 256],
    rules: [usize; 256],
    last: usize,
}

impl Polymer {
    fn new(inp: &[u8]) -> Polymer {
        let mut letters = IndexSet::with_capacity(26);
        let mut init: [usize; 256] = [0; 256];
        let mut rules: [usize; 256] = [0; 256];
        let mut last = 0;
        let mut i = 0;
        while i < inp.len() - 1 {
            if inp[i + 1] == b'\n' {
                break;
            }
            let (ai, _) = letters.insert_full(inp[i]);
            let (bi, _) = letters.insert_full(inp[i + 1]);
            last = bi;
            init[(ai << 4) + bi] += 1;
            i += 1;
        }
        i += 3;
        while i < inp.len() {
            let (ai, _) = letters.insert_full(inp[i]);
            let (bi, _) = letters.insert_full(inp[i + 1]);
            let (ci, _) = letters.insert_full(inp[i + 6]);
            rules[(ai << 4) + bi] = ci;
            i += 8;
        }
        Polymer { init, rules, last }
    }
    fn parts(&self) -> (usize, usize) {
        let mut c = self.init;
        let mut p1 = 0;
        let mut p2 = 0;
        for day in 0..40 {
            let mut nc: [usize; 256] = [0; 256];
            for i in 0..256 {
                if c[i] == 0 {
                    continue;
                }
                let n = self.rules[i];
                nc[(i & 0xf0) + n] += c[i];
                nc[(n << 4) + (i & 0xf)] += c[i];
            }
            c = nc;
            p2 = self.most_minus_least(&c);
            if day == 9 {
                p1 = p2;
            }
        }
        (p1, p2)
    }
    fn most_minus_least(&self, c: &[usize; 256]) -> usize {
        let mut count: [usize; 16] = [0; 16];
        count[self.last] += 1;
        for i in 0..256 {
            if c[i] == 0 {
                continue;
            }
            count[i >> 4] += c[i];
        }
        let max = count.iter().max().unwrap();
        let min = count.iter().filter(|x| **x != 0).min().unwrap();
        max - min
    }
}

#[test]
fn parts() {
    let t1 = Polymer::new(
        &std::fs::read("../2021/14/test1.txt").expect("read error"),
    );
    let (tp1, tp2) = t1.parts();
    assert_eq!(tp1, 1588);
    assert_eq!(tp2, 2188189693529);
}

fn main() {
    aoc::benchme(|bench: bool| {
        let inp = std::fs::read(aoc::input_file()).expect("read error");
        let poly = Polymer::new(&inp);
        let (p1, p2) = poly.parts();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}
