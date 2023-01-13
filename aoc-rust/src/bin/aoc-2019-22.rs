use smallvec::SmallVec;

#[derive(Debug)]
enum Shuffle {
    DealNew,
    Cut(i64),
    DealInc(i64),
}

fn shuffle_rev_params(sh: &Shuffle, a: i128, b: i128, cards: i128) -> (i128, i128) {
    let (a, b) = match sh {
        Shuffle::DealNew => (-a, -b - 1),
        Shuffle::Cut(n) => (a, b + *n as i128),
        Shuffle::DealInc(n) => {
            let mi = modinverse(*n as i128, cards);
            (a * mi, b * mi)
        }
    };
    (a.rem_euclid(cards), b.rem_euclid(cards))
}

fn shuffle_params(sh: &Shuffle, a: i64, b: i64, cards: i64) -> (i64, i64) {
    let (a, b) = match sh {
        Shuffle::DealNew => (-a, -b - 1),
        Shuffle::Cut(n) => (a, b - n),
        Shuffle::DealInc(n) => (a * n, b * n),
    };
    (a.rem_euclid(cards), b.rem_euclid(cards))
}

fn parts(inp: &[u8]) -> (i64, i64) {
    let mut shuffles = SmallVec::<[Shuffle; 128]>::new();
    let mut i = 0;
    while i < inp.len() {
        shuffles.push(match inp[i] {
            b'c' => {
                let (j, n) = aoc::read::int::<i64>(inp, i + 4);
                i = j + 1;
                Shuffle::Cut(n)
            }
            _ => match inp[i + 5] {
                b'i' => {
                    i += 20;
                    Shuffle::DealNew
                }
                b'w' => {
                    let (j, n) = aoc::read::int::<i64>(inp, i + 20);
                    i = j + 1;
                    Shuffle::DealInc(n)
                }
                _ => unreachable!("unexpected input"),
            },
        })
    }
    //eprintln!("{:?}", shuffles);
    let (a, b) = params(&shuffles, 10007);
    let p1 = (a * 2019 + b).rem_euclid(10007);

    let rounds = 101741582076661u128;
    let pos = 2020;
    let cards = 119315717514047u128;

    let (a, b) = rev_params(&shuffles, cards as i128);
    let exp = exp_mod(a as u128, rounds, cards);
    let invmod = modinverse(a - 1, cards as i128) as u128;
    let exp_inv = ((exp - 1) * invmod) % cards;
    let exp_inv_b = (exp_inv * b as u128) % cards;
    let p2 = (exp_inv_b + (exp * pos)) % cards;
    (p1, p2 as i64)
}

fn modinverse(mut a: i128, mut b: i128) -> i128 {
    let b0 = b;
    let mut x0 = 0;
    let mut x1 = 1;
    if b == 1 {
        return 1;
    }
    while a > 1 {
        let q = a / b;
        (a, b) = (b, a % b);
        (x1, x0) = (x0, x1 - q * x0);
    }
    if x1 < 0 {
        x1 += b0;
    }
    x1
}

fn exp_mod(b: u128, e: u128, m: u128) -> u128 {
    let mut b = b;
    let mut e = e;
    let mut c: u128 = 1;
    while e > 0 {
        if (e % 2) == 1 {
            c = (c * b) % m;
        }
        b = (b * b) % m;
        e >>= 1;
    }
    c
}

fn rev_params(sh: &SmallVec<[Shuffle; 128]>, cards: i128) -> (i128, i128) {
    let mut a = 1i128;
    let mut b = 0i128;
    for i in (0..sh.len()).rev() {
        (a, b) = shuffle_rev_params(&sh[i], a, b, cards);
    }
    (a, b)
}

fn params(sh: &SmallVec<[Shuffle; 128]>, cards: i64) -> (i64, i64) {
    let mut a = 1i64;
    let mut b = 0i64;
    for i in 0..sh.len() {
        (a, b) = shuffle_params(&sh[i], a, b, cards);
    }
    (a, b)
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
        let inp = std::fs::read("../2019/22/test1a.txt").expect("read error");
        assert_eq!(parts(&inp), (7987, 119315717512026));
        let inp = std::fs::read("../2019/22/test1d.txt").expect("read error");
        assert_eq!(parts(&inp), (6057, 78347203856025));
        let inp = std::fs::read("../2019/22/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3589, 4893716342290));
    }
}
