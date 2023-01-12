const PROG_CAP: usize = 4096;
const HULL_DATA: usize = 758;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut prog: [isize; PROG_CAP] = [0; PROG_CAP];
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<isize>(inp, i);
        prog[l] = n;
        l += 1;
        i = j + 1;
    }

    let mut p1: Option<usize> = None;
    let mut p2 = 0;
    for a in HULL_DATA..HULL_DATA + 162 {
        let holes = prog[a] as u8;
        let score = holes_score(holes);
        p2 += score * a * prog[a] as usize;
        if p1.is_none() && holes == 0 {
            p1 = Some(p2)
        }
        //eprintln!(
        //    "holes={} {:8b} {} * {} * {} / {} / {}",
        //    holes,
        //    holes,
        //    score,
        //    a,
        //    prog[a],
        //    a * prog[a] as usize,
        //    score * a * prog[a] as usize
        //);
    }
    (p1.expect("part 1 result"), p2)
}

fn holes_score(x: u8) -> usize {
    let mut sc = 0usize;
    for b in 0..=8 {
        if (x as usize) & (1 << b) == 0 {
            sc += 18 - b;
        }
    }
    sc
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 1: {}", p2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/21/input.txt").expect("read error");
        assert_eq!(parts(&inp), (19359969, 1140082748));
        let inp = std::fs::read("../2019/21/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (19354173, 1145849660));
    }
}
