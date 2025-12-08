#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
    z: i32,
}

#[derive(Debug)]
struct Dist {
    d: u32,
    a: u16,
    b: u16,
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut point = heapless::Vec::<Point, 1024>::new();
    let mut i: usize = 0;
    while i < inp.len() {
        let (j, x) = aoc::read::uint::<i32>(inp, i);
        let (j, y) = aoc::read::uint::<i32>(inp, j + 1);
        let (j, z) = aoc::read::uint::<i32>(inp, j + 1);
        point.push(Point { x, y, z }).expect("overflow");
        i = j + 1;
    }
    let mut dist = Vec::<Dist>::new();
    for i in 0..point.len() {
        for j in i + 1..point.len() {
            let dx = (point[i].x - point[j].x) as isize;
            let dy = (point[i].y - point[j].y) as isize;
            let dz = (point[i].z - point[j].z) as isize;
            let d: u32 = aoc::isqrt((dx * dx + dy * dy + dz * dz) as usize) as u32;
            dist.push(Dist {
                d,
                a: i as u16,
                b: j as u16,
            });
        }
    }
    dist.sort_by(|a, b| a.d.cmp(&b.d));

    let conns = if point.len() < 30 { 10 } else { 1000 };

    let mut p1: usize = 0;
    let mut p2: usize = 0;
    let mut uf = UnionFind::new(point.len());
    let mut count: usize = 0;
    for d in dist {
        let s = uf.union(d.a as usize, d.b as usize);
        count += 1;
        if s == point.len() {
            p2 = (point[d.a as usize].x * point[d.b as usize].x) as usize;
            break;
        }

        if count == conns {
            let mut s0: usize = 0;
            let mut s1: usize = 0;
            let mut s2: usize = 0;
            for i in 0..uf.size.len() {
                let mut n = uf.size[i];
                if s0 < n {
                    (s0, n) = (n, s0);
                }
                if s1 < n {
                    (s1, n) = (n, s1);
                }
                if s2 < n {
                    s2 = n;
                }
            }
            p1 = s0 * s1 * s2;
        }
    }

    (p1, p2)
}

struct UnionFind {
    parent: [usize; 1000],
    size: [usize; 1000],
}

impl UnionFind {
    fn new(n: usize) -> UnionFind {
        let mut uf = UnionFind {
            parent: [0; 1000],
            size: [1; 1000],
        };
        for i in 0..n {
            uf.parent[i] = i;
        }
        return uf;
    }
    fn find(&mut self, i: usize) -> usize {
        let mut p = self.parent[i];
        if p == i {
            return i;
        }
        p = self.find(p);
        self.parent[i] = p;
        p
    }
    fn union(&mut self, i: usize, j: usize) -> usize {
        let ir = self.find(i);
        let jr = self.find(j);
        if ir == jr {
            return self.size[ir];
        }
        self.parent[jr] = ir;
        self.size[ir] += self.size[jr];
        self.size[jr] = 0;
        self.size[ir]
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
        aoc::test::auto("../2025/08/", parts);
    }
}
