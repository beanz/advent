use std::collections::HashMap;
use std::collections::HashSet;
use std::fmt;

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct P3 {
    i: u64,
}

impl P3 {
    fn new(x: i16, y: i16, z: i16) -> P3 {
        let mut p3: u64 = (((x as i32) + 32768) << 16) as u64;
        p3 += ((y as i32) + 32768) as u64;
        p3 <<= 16;
        p3 += ((z as i32) + 32768) as u64;
        P3 { i: p3 }
    }
    // fn v(&self) -> u64 {
    //     self.i
    // }
    fn x(&self) -> i16 {
        ((self.i >> 32) as i32 - 32768) as i16
    }
    fn y(&self) -> i16 {
        ((0xffff & (self.i >> 16)) as i32 - 32768) as i16
    }
    fn z(&self) -> i16 {
        ((0xffff & self.i) as i32 - 32768) as i16
    }
    fn manhattan(&self, o: P3) -> usize {
        ((self.x() - o.x()).unsigned_abs() as usize)
            + ((self.y() - o.y()).unsigned_abs() as usize)
            + ((self.z() - o.z()).unsigned_abs() as usize)
    }
    fn add(&self, o: P3) -> P3 {
        P3::new(self.x() + o.x(), self.y() + o.y(), self.z() + o.z())
    }
    fn rotate(&self, r: u8) -> P3 {
        match r {
            0 => P3::new(self.x(), self.y(), self.z()),
            1 => P3::new(self.x(), self.z(), -self.y()),
            2 => P3::new(self.x(), -self.y(), -self.z()),
            3 => P3::new(self.x(), -self.z(), self.y()),
            4 => P3::new(self.y(), -self.x(), self.z()),
            5 => P3::new(self.y(), self.z(), self.x()),
            6 => P3::new(self.y(), self.x(), -self.z()),
            7 => P3::new(self.y(), -self.z(), -self.x()),
            8 => P3::new(-self.x(), -self.y(), self.z()),
            9 => P3::new(-self.x(), -self.z(), -self.y()),
            10 => P3::new(-self.x(), self.y(), -self.z()),
            11 => P3::new(-self.x(), self.z(), self.y()),
            12 => P3::new(-self.y(), self.x(), self.z()),
            13 => P3::new(-self.y(), -self.z(), self.x()),
            14 => P3::new(-self.y(), -self.x(), -self.z()),
            15 => P3::new(-self.y(), self.z(), -self.x()),
            16 => P3::new(self.z(), self.y(), -self.x()),
            17 => P3::new(self.z(), self.x(), self.y()),
            18 => P3::new(self.z(), -self.y(), self.x()),
            19 => P3::new(self.z(), -self.x(), -self.y()),
            20 => P3::new(-self.z(), -self.y(), -self.x()),
            21 => P3::new(-self.z(), -self.x(), self.y()),
            22 => P3::new(-self.z(), self.y(), self.x()),
            23 => P3::new(-self.z(), self.x(), -self.y()),
            _ => panic!("invalid rotation: {}", r),
        }
    }
}

impl fmt::Display for P3 {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{},{},{}", self.x(), self.y(), self.z())
    }
}

fn i16s(inp: &[u8]) -> Vec<i16> {
    let mut r: Vec<i16> = vec![];
    let mut n: i16 = 0;
    let mut m: i16 = 1;
    let mut is_num: bool = false;
    for ch in inp {
        match ch {
            45 => m = -1, // -
            48..=57 => {
                // 0 - 9
                is_num = true;
                n = n * 10 + ((ch - 48) as i16);
            }
            _ => {
                if is_num {
                    r.push(n * m);
                    n = 0;
                    m = 1;
                    is_num = false;
                }
            }
        }
    }
    if is_num {
        r.push(n * m);
    }
    r
}

struct Scanner {
    beacons: Vec<P3>,
    position: Option<P3>,
    distances: HashMap<usize, Vec<(usize, usize)>>,
}

impl Scanner {
    fn new(inp: &[u8]) -> Scanner {
        let mut beacons: Vec<P3> = vec![];
        for ch in i16s(inp).chunks(3) {
            beacons.push(P3::new(ch[0], ch[1], ch[2]));
        }
        let mut distances: HashMap<usize, Vec<(usize, usize)>> = HashMap::new();
        for i in 0..beacons.len() {
            for j in (i + 1)..beacons.len() {
                let dist = beacons[i].manhattan(beacons[j]);
                let de = distances.entry(dist).or_insert_with(Vec::new);
                de.push((i, j));
            }
        }
        Scanner {
            beacons,
            position: None,
            distances,
        }
    }
}
struct Solver {
    scanners: Vec<Scanner>,
}

impl Solver {
    fn new(inp: &[u8]) -> Solver {
        let mut scanners: Vec<Scanner> = vec![];
        let mut i = 0;
        let mut j = 0;
        while i < inp.len() - 1 {
            if inp[i] == 10 {
                if inp[i + 1] == 10 {
                    scanners.push(Scanner::new(&inp[j..i]));
                    i += 1;
                    j = 0;
                } else if j == 0 {
                    j = i + 1;
                }
            }
            i += 1;
        }
        scanners.push(Scanner::new(&inp[j..i]));
        scanners[0].position = Some(P3::new(0, 0, 0));
        Solver { scanners }
    }
    fn compare_distances(&self, i: usize, j: usize) -> Vec<usize> {
        let mut res: Vec<usize> = vec![];
        for dist in self.scanners[i].distances.keys() {
            if self.scanners[j].distances.contains_key(dist) {
                res.push(*dist);
            }
        }
        res
    }
    fn align(&mut self, known: usize, unknown: usize) {
        let mut nb: Vec<P3> = Vec::with_capacity(24);
        //println!("trying to align known {} with unknown {}", known, unknown);
        for kb in &self.scanners[known].beacons {
            for ub in &self.scanners[unknown].beacons {
                //println!("  assuming kb {} == ub {}", kb, ub);
                for r in 0..24 {
                    let rub = ub.rotate(r);
                    let transform = P3::new(
                        kb.x() - rub.x(),
                        kb.y() - rub.y(),
                        kb.z() - rub.z(),
                    );
                    //println!("  rotation {} transform {}", r, transform);
                    nb.truncate(0);
                    let mut c = 0;
                    for oub in &self.scanners[unknown].beacons {
                        if ub.i == oub.i {
                            continue;
                        }
                        let roub = oub.rotate(r);
                        let troub = roub.add(transform);
                        let mut found = false;
                        for fb in &self.scanners[known].beacons {
                            if fb.i == troub.i {
                                found = true;
                                break;
                            }
                        }
                        // println!(
                        //     "  {} > {} > {} > {}",
                        //     oub, roub, troub, found
                        // );
                        if found {
                            c += 1;
                        }
                        nb.push(troub);
                    }
                    if c >= 10 {
                        //println!("  found {} rotation {}", c, transform);
                        self.scanners[unknown].position = Some(transform);
                        self.scanners[unknown].beacons = nb;
                        return;
                    }
                }
            }
        }
        panic!("failed to align: {}\n", unknown);
    }
    fn solve(&mut self) -> (usize, usize) {
        let mut next: HashMap<usize, Vec<usize>> = HashMap::new();
        for i in 0..self.scanners.len() {
            for j in i + 1..self.scanners.len() {
                let common = self.compare_distances(i, j);
                if common.len() >= 60 {
                    let ne = next.entry(i).or_insert_with(Vec::new);
                    ne.push(j);
                    let ne2 = next.entry(j).or_insert_with(Vec::new);
                    ne2.push(i);
                }
            }
        }
        //println!("{:?}", next);
        let mut todo: Vec<usize> = vec![0];
        while let Some(i) = todo.pop() {
            for j in next.get(&i).unwrap() {
                if self.scanners[*j].position.is_none() {
                    self.align(i, *j);
                    todo.push(*j);
                    // println!(
                    //     "scanner position {:?}",
                    //     self.scanners[*j].position
                    // );
                }
            }
        }

        let mut seen: HashSet<u64> = HashSet::new();
        for s in &self.scanners {
            for b in &s.beacons {
                seen.insert(b.i);
            }
        }
        let mut p2 = 0;
        for i in 0..self.scanners.len() {
            for j in i + 1..self.scanners.len() {
                let s0 = self.scanners[i].position.unwrap();
                let s1 = self.scanners[j].position.unwrap();
                let md = s0.manhattan(s1);
                if md > p2 {
                    p2 = md;
                }
            }
        }
        (seen.len(), p2)
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let mut s = Solver::new(&inp);
        let (p1, p2) = s.solve();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}
