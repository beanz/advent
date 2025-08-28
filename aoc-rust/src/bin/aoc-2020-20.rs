use std::collections::HashMap;

use smallvec::SmallVec;

const MONSTER_W: usize = 20;
const MONSTER_H: usize = 3;
const MONSTER_SIZE: usize = 15;
const MONSTER: [(usize, usize); MONSTER_SIZE] = [
    (18, 0),
    (0, 1),
    (5, 1),
    (6, 1),
    (11, 1),
    (12, 1),
    (17, 1),
    (18, 1),
    (19, 1),
    (1, 2),
    (4, 2),
    (7, 2),
    (10, 2),
    (13, 2),
    (16, 2),
];

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut tiles: Vec<Tile> = vec![];
    let mut edge_map: HashMap<u16, Vec<usize>> = HashMap::default();
    let mut i = 0;
    while i < inp.len() {
        let t = Tile::new(&inp[i..i + 121]);
        for j in 0..4 {
            let m = t.canonical_edge(j);
            let e = edge_map.entry(m).or_default();
            e.push(tiles.len());
        }
        tiles.push(t);
        i += 122;
    }
    let w = aoc::isqrt(tiles.len());
    //eprintln!("{}", w);
    //eprintln!("{:?}", tiles.len());
    let mut p1: usize = 1;
    let mut starter = None;
    for (i, t) in tiles.iter_mut().enumerate() {
        let mut c = 0;
        let mut re = SmallVec::<[usize; 2]>::new();
        for j in 0..4 {
            let m = t.canonical_edge(j);
            let e = edge_map.get(&m).expect("edge");
            if e.len() == 1 {
                re.push(j);
                c += 1;
            }
        }
        if c >= 2 {
            p1 *= t.num as usize;
            t.orient = match (re[0], re[1]) {
                (0, 3) => Orient::R0,
                (0, 1) => Orient::R270,
                (1, 2) => Orient::R180,
                (2, 3) => Orient::R90,
                _ => unreachable!("invalid edge pattern"),
            };
            //eprintln!("{} {:?}", t.num, re);
            starter = Some(i);
        }
    }
    let mut ti = starter.expect("has a corner");
    //eprintln!("found {}: {} {:?}", ti, tiles[ti].num, tiles[ti].orient);
    tiles[ti].used = true;
    let mut layout: [usize; 144] = [0; 144];
    layout[0] = ti;
    for i in 1..w * w {
        let mut fi: Option<usize> = None;
        if i % w == 0 {
            //eprintln!("matching bottom edge");
            let (b, bc) = tiles[layout[i - w]].get_bottom();
            for ni in edge_map.get(&bc).expect("has edge map entry") {
                if tiles[*ni].used {
                    continue;
                }
                let nt = &mut tiles[*ni];
                let o = if nt.edge[0] == b {
                    Orient::FR180 // X
                } else if nt.edge[1] == b {
                    Orient::FR270 // X
                } else if nt.edge[2] == b {
                    Orient::FR0
                } else if nt.edge[3] == b {
                    Orient::FR90 // X
                } else if nt.edge[4] == b {
                    Orient::R0 // X
                } else if nt.edge[5] == b {
                    Orient::R270 // X
                } else if nt.edge[6] == b {
                    Orient::R180
                } else if nt.edge[7] == b {
                    Orient::R90 // X
                } else {
                    continue;
                };
                nt.orient = o;
                nt.used = true;
                fi = Some(*ni);
                break;
            }
        } else {
            //eprintln!("matching right edge");
            let (r, rc) = tiles[ti].get_right();
            for ni in edge_map.get(&rc).expect("has edge map entry") {
                if tiles[*ni].used {
                    continue;
                }
                let nt = &mut tiles[*ni];
                let o = if nt.edge[0] == r {
                    Orient::FR90
                } else if nt.edge[1] == r {
                    Orient::FR180
                } else if nt.edge[2] == r {
                    Orient::FR270 // X
                } else if nt.edge[3] == r {
                    Orient::FR0
                } else if nt.edge[4] == r {
                    Orient::R270
                } else if nt.edge[5] == r {
                    Orient::R180
                } else if nt.edge[6] == r {
                    Orient::R90 // X
                } else if nt.edge[7] == r {
                    Orient::R0 // X
                } else {
                    continue;
                };
                nt.orient = o;
                nt.used = true;
                fi = Some(*ni);
                break;
            }
        }
        let ni = fi.expect("found next index");
        //eprintln!("found {}: {} {:?}", ni, tiles[ni].num, tiles[ni].orient);
        layout[i] = ni;
        ti = ni;
    }
    //for iy in 0..w {
    //    for y in 0..10 {
    //        for ix in 0..w {
    //            let t = &tiles[layout[iy * w + ix]];
    //            for x in 0..10 {
    //                eprint!("{}", t.get(x, y) as char);
    //            }
    //            eprint!(" ");
    //        }
    //        eprintln!();
    //    }
    //    eprintln!();
    //}
    let mut image: [[u8; 96]; 96] = [[b' '; 96]; 96];
    let tl = 8;
    let mut rough = 0;
    for iy in 0..w {
        for y in 0..tl {
            for ix in 0..w {
                let t = &tiles[layout[iy * w + ix]];
                for x in 0..tl {
                    let ch = t.get(x + 1, y + 1);
                    image[iy * tl + y][ix * tl + x] = ch;
                    if ch == b'#' {
                        rough += 1;
                    }
                }
            }
        }
    }
    let nl = w * tl;
    //for y in 0..nl {
    //    eprintln!("{}", std::str::from_utf8(&image[y][0..nl]).unwrap());
    //}
    for y in 0..nl - MONSTER_H {
        for x in 0..nl - MONSTER_W {
            let mut found = true;
            for m in MONSTER {
                if image[y + m.1][x + m.0] != b'#' {
                    found = false;
                    break;
                }
            }
            if found {
                //eprintln!("found at {},{}", x, y);
                rough -= MONSTER_SIZE;
            }
            found = true;
            for m in MONSTER {
                if image[y + m.1][x + (MONSTER_W - m.0)] != b'#' {
                    found = false;
                    break;
                }
            }
            if found {
                //eprintln!("found at {},{}", x, y);
                rough -= MONSTER_SIZE;
            }
            found = true;
            for m in MONSTER {
                if image[y + (MONSTER_H - m.1)][x + (MONSTER_W - m.0)] != b'#' {
                    found = false;
                    break;
                }
            }
            if found {
                //eprintln!("found at {},{}", x, y);
                rough -= MONSTER_SIZE;
            }
            found = true;
            for m in MONSTER {
                if image[y + (MONSTER_H - m.1)][x + m.0] != b'#' {
                    found = false;
                    break;
                }
            }
            if found {
                //eprintln!("found at {},{}", x, y);
                rough -= MONSTER_SIZE;
            }
        }
    }
    // somewhat surprisingly answers are correct without considering
    // rotations of the MONSTER
    (p1, rough)
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

#[derive(Debug)]
enum Orient {
    R0,
    R90,
    R180,
    R270,
    FR0,
    FR90,
    FR180,
    FR270,
}

#[derive(Debug)]
struct Tile<'a> {
    num: u32,
    l: [&'a [u8]; 10],
    edge: [u16; 8],
    orient: Orient,
    used: bool,
}

impl<'a> Tile<'a> {
    fn new(inp: &[u8]) -> Tile {
        let (_, num) = aoc::read::uint::<u32>(inp, 5);
        let l = [
            &inp[11..21],
            &inp[22..32],
            &inp[33..43],
            &inp[44..54],
            &inp[55..65],
            &inp[66..76],
            &inp[77..87],
            &inp[88..98],
            &inp[99..109],
            &inp[110..120],
        ];
        let mut edge = [0; 8];
        for j in 0..10 {
            edge[0] |= if l[0][j] == b'#' { 1 << j } else { 0 };
            edge[1] |= if l[j][9] == b'#' { 1 << j } else { 0 };
            edge[2] |= if l[9][9 - j] == b'#' { 1 << j } else { 0 };
            edge[3] |= if l[9 - j][0] == b'#' { 1 << j } else { 0 };
            edge[4] |= if l[0][9 - j] == b'#' { 1 << j } else { 0 };
            edge[5] |= if l[9 - j][9] == b'#' { 1 << j } else { 0 };
            edge[6] |= if l[9][j] == b'#' { 1 << j } else { 0 };
            edge[7] |= if l[j][0] == b'#' { 1 << j } else { 0 };
        }
        Tile {
            num,
            edge,
            l,
            orient: Orient::R0,
            used: false,
        }
    }
    #[allow(dead_code)]
    fn pretty(&self) {
        for y in 0..10 {
            for x in 0..10 {
                eprint!("{}", self.get(x, y) as char);
            }
            eprintln!();
        }
    }
    fn get_right(&self) -> (u16, u16) {
        let j = match self.orient {
            Orient::R0 => 1,
            Orient::R90 => 0,
            Orient::R180 => 3,
            Orient::R270 => 2,
            Orient::FR0 => 5,
            Orient::FR90 => 6,
            Orient::FR180 => 7,
            Orient::FR270 => 4,
        };
        (self.edge[j], self.canonical_edge(j % 4))
    }
    fn get_bottom(&self) -> (u16, u16) {
        let j = match self.orient {
            Orient::R0 => 2,
            Orient::R90 => 1,
            Orient::R180 => 0,
            Orient::R270 => 3,
            Orient::FR0 => 4,
            Orient::FR90 => 5,
            Orient::FR180 => 6,
            Orient::FR270 => 7,
        };
        (self.edge[j], self.canonical_edge(j % 4))
    }
    fn canonical_edge(&self, j: usize) -> u16 {
        if self.edge[j] < self.edge[j + 4] {
            self.edge[j]
        } else {
            self.edge[j + 4]
        }
    }
    fn get(&self, x: usize, y: usize) -> u8 {
        match self.orient {
            Orient::R0 => self.l[y][x],
            Orient::R90 => self.l[9 - x][y],
            Orient::R180 => self.l[9 - y][9 - x],
            Orient::R270 => self.l[x][9 - y],
            Orient::FR0 => self.l[9 - y][x],
            Orient::FR90 => self.l[x][y],
            Orient::FR180 => self.l[y][9 - x],
            Orient::FR270 => self.l[9 - x][9 - y],
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/20/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (20899048083289, 273));
        let inp = std::fs::read("../2020/20/input.txt").expect("read error");
        assert_eq!(parts(&inp), (17712468069479, 2173));
        let inp = std::fs::read("../2020/20/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (14986175499719, 2161));
    }
}
