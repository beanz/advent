use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut hands = SmallVec::<[(usize, usize, usize); 1024]>::new();
    for line in inp.split(|x| *x == b'\n') {
        if line.is_empty() {
            continue;
        }
        let mut cards: [(u8, usize); 5] = [(0, 0), (0, 0), (0, 0), (0, 0), (0, 0)];
        let mut s1: usize = 0;
        let mut s2: usize = 0;
        let mut jc: usize = 0;
        for ch in &line[0..5] {
            for e in cards.iter_mut() {
                if e.0 == *ch {
                    e.1 += 1;
                    break;
                } else if e.1 == 0 {
                    e.0 = *ch;
                    e.1 = 1;
                    break;
                }
            }
            let mut s = match ch {
                b'0'..=b'9' => ch - b'0',
                b'T' => 10,
                b'J' => {
                    jc += 1;
                    11
                }
                b'Q' => 12,
                b'K' => 13,
                b'A' => 14,
                _ => unreachable!("invalid card"),
            };
            s1 = (s1 << 4) + (s as usize);
            if s == 11 {
                s = 0;
            }
            s2 = (s2 << 4) + (s as usize);
        }
        cards.select_nth_unstable_by(2, |a, b| b.1.cmp(&a.1));
        // println!("{:?}", cards);
        s1 += (cards[0].1 * 10 + cards[1].1) << 20;
        let mut n = 0;
        for i in 0..5 {
            if cards[i].0 != b'J' {
                cards[n].0 = cards[i].0;
                cards[n].1 = cards[i].1 + jc;
                jc = 0;
                if i != n {
                    cards[i].1 = 0;
                }
                n += 1;
            }
        }
        // println!("{:?}", cards);
        s2 += (cards[0].1 * 10 + cards[1].1) << 20;
        let mut bid = 0;
        for ch in &line[6..] {
            bid = 10 * bid + ((ch - b'0') as usize);
        }
        hands.push((bid, s1, s2));
    }
    let hands = hands.as_mut_slice();
    hands.sort_by(|a, b| a.1.cmp(&b.1));
    let mut p1 = 0;
    for (i, e) in hands.iter().enumerate() {
        p1 += e.0 * (i + 1);
    }
    hands.sort_by(|a, b| a.2.cmp(&b.2));
    let mut p2 = 0;
    for (i, e) in hands.iter().enumerate() {
        p2 += e.0 * (i + 1);
    }
    (p1, p2)
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
        let inp = std::fs::read("../2023/07/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (6440, 5905));
        let inp = std::fs::read("../2023/07/input.txt").expect("read error");
        assert_eq!(parts(&inp), (256448566, 254412181));
    }
}
