use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (isize, usize) {
    let mut prog = SmallVec::<[isize; 2048]>::new();
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::uint::<isize>(inp, i);
        prog.push(n);
        i = j + 1;
    }
    let p1 = run(&prog, 12, 2);
    let mut p2: Option<usize> = None;
    for n in 0..100 {
        for v in 0..100 {
            let r = run(&prog, n as isize, v as isize);
            if r == 19690720 {
                p2 = Some(n * 100 + v);
                break;
            }
        }
    }
    (p1, p2.expect("didn't find answer"))
}

fn run(prog: &SmallVec<[isize; 2048]>, noun: isize, verb: isize) -> isize {
    let mut pc = 0;
    let mut p1 = (*prog).clone();
    p1[1] = noun;
    p1[2] = verb;
    loop {
        match p1[pc] {
            99 => break,
            1 => {
                let (a, b, o) = (p1[pc + 1], p1[pc + 2], p1[pc + 3]);
                p1[o as usize] = p1[a as usize] + p1[b as usize];
            }
            2 => {
                let (a, b, o) = (p1[pc + 1], p1[pc + 2], p1[pc + 3]);
                p1[o as usize] = p1[a as usize] * p1[b as usize];
            }
            _ => unreachable!("invalid op"),
        }
        pc += 4;
    }
    p1[0]
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
        let inp = std::fs::read("../2019/02/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3409710, 7912));
    }
}
