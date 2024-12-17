use smallvec::SmallVec;

const SIZE: usize = 32;

fn parts(inp: &[u8]) -> ([u8; 30], usize) {
    let (i, a) = aoc::read::uint::<usize>(inp, 12);
    let prog = &inp[i + 39..inp.len() - 1];
    let mut out = SmallVec::<[u8; SIZE]>::new();
    run(prog, a, &mut out);
    let mut p1r = [32; 30];
    for (i, ch) in out.iter().enumerate() {
        p1r[i] = *ch;
    }
    out.clear();
    let mut p2 = 0;
    let mut todo = aoc::deque::Deque::<(usize, usize), 512>::default();
    let l = (1 + prog.len()) / 2;
    todo.push((1, 0));
    'outer: while let Some((i, a)) = todo.pop() {
        for c in 0..8 {
            let v = c + 8 * a;
            run(prog, v, &mut out);
            if comp(prog, &out, i) {
                if i == l {
                    p2 = v;
                    break 'outer;
                }
                todo.push((i + 1, v));
            }
            out.clear();
        }
    }
    (p1r, p2)
}

fn comp(exp: &[u8], got: &SmallVec<[u8; SIZE]>, i: usize) -> bool {
    if got.len() < i * 2 - 1 {
        return false;
    }
    let mut j = i;
    while j > 0 {
        let k = j * 2 - 1;
        if exp[exp.len() - k] != got[got.len() - k] {
            return false;
        }
        j -= 1;
    }
    true
}

fn run(prog: &[u8], a: usize, out: &mut SmallVec<[u8; SIZE]>) {
    let (mut a, mut b, mut c) = (a, 0, 0);
    let mut ip = 0;
    while ip < prog.len() - 2 {
        let op = prog[ip] - b'0';
        let lit = (prog[ip + 2] - b'0') as usize;
        let combo = match lit {
            0 | 1 | 2 | 3 => lit as usize,
            4 => a,
            5 => b,
            6 => c,
            7 => 7,
            _ => unreachable!(),
        };
        match op {
            0 => a >>= combo,
            1 => b ^= lit,
            2 => b = combo & 7,
            3 => {
                if a != 0 {
                    ip = lit * 2;
                    continue;
                }
            }
            4 => b ^= c,
            5 => {
                if out.len() == 0 {
                    out.push((combo & 7) as u8 + b'0')
                } else {
                    out.push(b',');
                    out.push((combo & 7) as u8 + b'0')
                }
            }
            6 => b = a >> combo,
            7 => c = a >> combo,
            _ => unreachable!(),
        }
        ip += 4;
    }
}
fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", std::str::from_utf8(&p1[0..]).expect("ascii"));
            println!("Part 2: {}", p2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/17/", parts);
    }
}
