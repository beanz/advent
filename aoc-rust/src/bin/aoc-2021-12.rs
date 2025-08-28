use indexmap::set::IndexSet;

#[derive(Debug)]
struct Caves {
    graph: [u16; 16],
    small: u16,
    start: u16,
    end: u16,
}

impl Caves {
    fn new(inp: &[u8]) -> Caves {
        let mut graph: [u16; 16] = [0; 16];
        let mut small: u16 = 0;
        let mut nodes = IndexSet::with_capacity(16);
        let start = {
            let (i, _) = nodes.insert_full("start");
            i as u16
        };
        let end = {
            let (i, _) = nodes.insert_full("end");
            i as u16
        };
        small |= 1 << start;
        small |= 1 << end;
        for l in String::from_utf8(inp.into())
            .expect("invalid input")
            .lines()
        {
            let (s, e) = l.split_once('-').expect("hyphen per line");
            let si = {
                let (i, _) = nodes.insert_full(s);
                i as u16
            };
            if s.as_bytes().first().expect("non-empty node") & 32 != 0 {
                small |= 1 << si;
            }
            let ei = {
                let (i, _) = nodes.insert_full(e);
                i as u16
            };
            if e.as_bytes().first().expect("non-empty node") & 32 != 0 {
                small |= 1 << ei;
            }
            graph[si as usize] |= 1 << ei;
            graph[ei as usize] |= 1 << si;
        }
        Caves {
            graph,
            small,
            start,
            end,
        }
    }
    fn solve(&self, pos: u16, seen: u16, p2: bool, twice: bool) -> usize {
        let mut nseen = seen;
        if pos == self.end {
            return 1;
        }
        if self.small & (1 << pos) != 0 {
            nseen |= 1 << pos;
        }
        let mut paths = 0;
        let neighbors = self.graph[pos as usize];
        for b in 1..15 {
            let nb = 1 << b;
            if nb & neighbors == 0 {
                continue;
            }
            let mut ntwice = twice;
            if nseen & nb != 0 {
                if !p2 || twice {
                    continue;
                }
                ntwice = true;
            }
            paths += self.solve(b, nseen, p2, ntwice);
        }
        paths
    }

    fn parts(&self) -> (usize, usize) {
        (
            self.solve(self.start, 0, false, false),
            self.solve(self.start, 0, true, false),
        )
    }
}

fn main() {
    aoc::benchme(|bench: bool| {
        let inp = std::fs::read(aoc::input_file()).expect("read error");
        let caves = Caves::new(&inp);
        let (p1, p2) = caves.parts();
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
    fn solve_works() {
        let c1 = Caves::new(&std::fs::read("../2021/12/test1.txt").expect("read error"));
        assert_eq!(c1.solve(c1.start, 0, false, false), 10);
        let c2 = Caves::new(&std::fs::read("../2021/12/test2.txt").expect("read error"));
        assert_eq!(c2.solve(c2.start, 0, false, false), 19);
        let c3 = Caves::new(&std::fs::read("../2021/12/test3.txt").expect("read error"));
        assert_eq!(c3.solve(c3.start, 0, false, false), 226);
        let ci = Caves::new(&std::fs::read("../2021/12/input.txt").expect("read error"));
        assert_eq!(ci.solve(ci.start, 0, false, false), 4691);
        assert_eq!(c1.solve(c1.start, 0, true, false), 36);
        assert_eq!(c2.solve(c2.start, 0, true, false), 103);
        assert_eq!(c3.solve(c3.start, 0, true, false), 3509);
        assert_eq!(ci.solve(ci.start, 0, true, false), 140718);
    }
}
