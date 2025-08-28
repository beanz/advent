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

#[derive(Clone, Copy)]
enum Op {
    Sq,
    Add(usize),
    Mul(usize),
}

impl Default for Op {
    fn default() -> Self {
        Op::Sq
    }
}

#[derive(Clone, Copy, Default)]
struct Monkey {
    c: usize,
    l: usize,
    items: [usize; 32],
    l2: usize,
    items2: [usize; 32],
    div: usize,
    op: Op,
    to_true: usize,
    to_false: usize,
}

fn next_monkey(inp: &[u8], i: usize) -> (usize, Monkey) {
    debug_assert!(inp[i] == b'M');
    let mut j = i + 28;
    let mut items: [usize; 32] = [0; 32];
    let mut items2: [usize; 32] = [0; 32];
    let mut l = 0;
    loop {
        let (k, n) = aoc::read::uint(inp, j);
        j = k;
        items[l] = n;
        items2[l] = n;
        l += 1;
        if inp[k] == b'\n' {
            break;
        }
        j += 2;
    }
    j += 24;
    let (mut j, op) = if inp[j] == b'+' {
        let (k, n) = aoc::read::uint::<usize>(inp, j + 2);
        (k + 1, Op::Add(n))
    } else if inp[j + 2] == b'o' {
        (j + 6, Op::Sq)
    } else {
        let (k, n) = aoc::read::uint::<usize>(inp, j + 2);
        (k + 1, Op::Mul(n))
    };
    j += 21;
    let (mut j, div) = aoc::read::uint::<usize>(inp, j);
    j += 30;
    let (mut j, to_true) = aoc::read::uint::<usize>(inp, j);
    j += 31;
    let (j, to_false) = aoc::read::uint::<usize>(inp, j);
    (
        j + 2,
        Monkey {
            c: 0,
            l,
            items,
            l2: l,
            items2,
            div,
            op,
            to_true,
            to_false,
        },
    )
}

fn solve(mk: &mut [Monkey; 8], len: usize, rounds: usize, reduce: usize) -> usize {
    for _r in 0..rounds {
        for i in 0..len {
            for j in 0..mk[i].l {
                mk[i].c += 1;
                let mut w = mk[i].items[j];
                w = match mk[i].op {
                    Op::Add(n) => w + n,
                    Op::Mul(n) => w * n,
                    Op::Sq => w * w,
                };
                w = if reduce == 0 {
                    w / 3
                } else if w >= reduce {
                    w % reduce
                } else {
                    w
                };
                let to = if w % mk[i].div == 0 {
                    mk[i].to_true
                } else {
                    mk[i].to_false
                };
                mk[to].items[mk[to].l] = w;
                mk[to].l += 1;
            }
            mk[i].l = 0;
        }
    }
    let (mut m0, mut m1) = (0, 0);
    for m in mk {
        let mut c = m.c;
        if c > m0 {
            (c, m0) = (m0, c);
        }
        if c > m1 {
            m1 = c;
        }
    }
    m0 * m1
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut mk: [Monkey; 8] = [Monkey::default(); 8];
    let mut l = 0;
    let mut lcm = 1;
    let mut i = 0;
    while i < inp.len() {
        let (j, m) = next_monkey(inp, i);
        lcm *= m.div;
        mk[l] = m;
        l += 1;
        i = j;
    }
    let p1 = solve(&mut mk, l, 20, 0);
    for e in mk.iter_mut().take(l) {
        e.items = e.items2;
        e.l = e.l2;
        e.c = 0;
    }
    (p1, solve(&mut mk, l, 10000, lcm))
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/11/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (10605, 2713310158));
        let inp = std::fs::read("../2022/11/input.txt").expect("read error");
        assert_eq!(parts(&inp), (62491, 17408399184));
    }
}
