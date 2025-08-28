use std::collections::HashMap;

use arrayvec::ArrayVec;

const PARENTS_LEN: usize = 512;

fn id_ch(ch: u8) -> u16 {
    match ch {
        b'0'..=b'9' => (ch - b'0') as u16,
        b'A'..=b'Z' => (ch - b'A' + 10) as u16,
        _ => unreachable!("unexpected id char"),
    }
}

fn id(a: u8, b: u8, c: u8) -> u16 {
    (id_ch(a) * 36 + id_ch(b)) * 36 + id_ch(c)
}

fn read_id(inp: &[u8], i: usize) -> u16 {
    id(inp[i], inp[i + 1], inp[i + 2])
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut i = 0;
    let mut orb: HashMap<u16, Vec<u16>> = HashMap::new();
    let mut parents: HashMap<u16, u16> = HashMap::new();
    while i < inp.len() {
        let a = read_id(inp, i);
        let b = read_id(inp, i + 4);
        let e = orb.entry(a).or_default();
        e.push(b);
        parents.insert(b, a);
        i += 8;
    }
    let p1 = count(&orb, id(b'C', b'O', b'M'), 0);
    let mut san = ArrayVec::<u16, PARENTS_LEN>::new();
    all_parents(&parents, id(b'S', b'A', b'N'), &mut san);
    let mut you = ArrayVec::<u16, PARENTS_LEN>::new();
    all_parents(&parents, id(b'Y', b'O', b'U'), &mut you);
    for i in 0..san.len() {
        for j in 0..you.len() {
            if san[i] == you[j] {
                return (p1, i + j);
            }
        }
    }
    (p1, 0)
}

fn all_parents(parents: &HashMap<u16, u16>, id: u16, p: &mut ArrayVec<u16, PARENTS_LEN>) {
    if let Some(parent) = parents.get(&id) {
        p.push(*parent);
        all_parents(parents, *parent, p);
    }
}

fn count(orb: &HashMap<u16, Vec<u16>>, id: u16, d: usize) -> usize {
    let mut s = d;
    if let Some(orbits) = orb.get(&id) {
        for child in orbits {
            s += count(orb, *child, d + 1);
        }
    }
    s
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

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/06/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (42, 0));
        let inp = std::fs::read("../2019/06/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (54, 4));
        let inp = std::fs::read("../2019/06/input.txt").expect("read error");
        assert_eq!(parts(&inp), (122782, 271));
        let inp = std::fs::read("../2019/06/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (295936, 457));
    }
}
