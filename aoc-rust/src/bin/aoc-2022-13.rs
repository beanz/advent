use std::cmp::Ordering;

fn read(inp: &[u8], i: usize) -> (usize, Pkt) {
    let mut i = i;
    if inp[i] == b'[' {
        i += 1;
        let mut v: Vec<Pkt> = vec![];
        if inp[i] != b']' {
            loop {
                let (j, pkt) = read(inp, i);
                v.push(pkt);
                i = j;
                if inp[i] == b']' {
                    break;
                }
                i += 1;
            }
        }
        return (i + 1, Pkt::List(v));
    }
    let (j, n) = aoc::read::uint::<u8>(inp, i);
    (j, Pkt::Num(n))
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let pkt2 = Pkt::List(vec![Pkt::Num(2)]);
    let pkt6 = Pkt::List(vec![Pkt::Num(6)]);
    let mut i = 0;
    let mut p1 = 0;
    let mut i2 = 1; // 1 indexed
    let mut i6 = 2; // 1 indexed and 2 is before it
    let mut n = 1;
    while i < inp.len() {
        let (j, pkt_a) = read(inp, i);
        let (j, pkt_b) = read(inp, j + 1);
        i = j + 2;
        if let Ordering::Less = pkt_a.cmp(&pkt_b) {
            p1 += n;
        }
        if let Ordering::Less = pkt_a.cmp(&pkt2) {
            i2 += 1;
            i6 += 1;
        } else if let Ordering::Less = pkt_a.cmp(&pkt6) {
            i6 += 1;
        }
        if let Ordering::Less = pkt_b.cmp(&pkt2) {
            i2 += 1;
            i6 += 1;
        } else if let Ordering::Less = pkt_b.cmp(&pkt6) {
            i6 += 1;
        }
        n += 1;
    }
    (p1, i2 * i6)
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

#[derive(Clone, Debug, PartialEq, Eq)]
enum Pkt {
    Num(u8),
    List(Vec<Pkt>),
}

impl PartialOrd for Pkt {
    fn partial_cmp(&self, x: &Self) -> Option<Ordering> {
        match (self, x) {
            (Pkt::Num(a), Pkt::Num(b)) => a.partial_cmp(b),
            (Pkt::List(a), Pkt::List(b)) => a.partial_cmp(b),
            (Pkt::Num(_), Pkt::List(_)) => Pkt::List(vec![self.clone()]).partial_cmp(x),
            (Pkt::List(_), Pkt::Num(_)) => self.partial_cmp(&Pkt::List(vec![x.clone()])),
        }
    }
}

impl Ord for Pkt {
    fn cmp(&self, x: &Self) -> Ordering {
        self.partial_cmp(x).expect("invalid ordering?")
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/13/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (13, 140));
        let inp = std::fs::read("../2022/13/input.txt").expect("read error");
        assert_eq!(parts(&inp), (5350, 19570));
    }
}
