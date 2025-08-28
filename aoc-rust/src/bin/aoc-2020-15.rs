use ahash::RandomState;
use arrayvec::ArrayVec;
use std::collections::HashMap;

const TURNS: u32 = 30000000;
const DENSE: u32 = 10000000;

type Int = u32;
fn parts(inp: &[u8]) -> (Int, Int) {
    let mut nums: ArrayVec<Int, 8> = ArrayVec::default();
    let mut n = 0;
    for ch in inp {
        match ch {
            b'0'..=b'9' => n = n * 10 + (ch - b'0') as Int,
            _ => {
                nums.push(n);
                n = 0;
            }
        }
    }
    //eprintln!("{:?}", nums);
    let mut last_seen = vec![0; DENSE as usize];
    let mut last_seen_sparse: HashMap<Int, Int, RandomState> =
        HashMap::with_capacity_and_hasher(512 * 1024, RandomState::new());
    let mut p = nums[0];
    let mut turn: Int = 2;
    while (turn as usize) <= nums.len() {
        last_seen[p as usize] = turn;
        p = nums[(turn as usize) - 1];
        turn += 1;
    }
    let mut n: Int = 0;
    while turn <= 2020 {
        n = if last_seen[p as usize] != 0 {
            turn - last_seen[p as usize]
        } else {
            0
        };
        last_seen[p as usize] = turn;
        p = n;
        turn += 1;
    }
    let p1 = n;
    while (turn as usize) <= (TURNS as usize) {
        if p < DENSE {
            n = if last_seen[p as usize] != 0 {
                turn - last_seen[p as usize]
            } else {
                0
            };
            last_seen[p as usize] = turn;
        } else {
            n = if let Some(l) = last_seen_sparse.get(&p) {
                turn - l
            } else {
                0
            };
            last_seen_sparse.insert(p, turn);
        }
        p = n;
        turn += 1;
    }
    (p1, n)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/15/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (436, 175594));
        let inp = std::fs::read("../2020/15/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (1, 2578));
        let inp = std::fs::read("../2020/15/test3.txt").expect("read error");
        assert_eq!(parts(&inp), (10, 3544142));
        let inp = std::fs::read("../2020/15/test4.txt").expect("read error");
        assert_eq!(parts(&inp), (27, 261214));
        let inp = std::fs::read("../2020/15/test5.txt").expect("read error");
        assert_eq!(parts(&inp), (78, 6895259));
        let inp = std::fs::read("../2020/15/test6.txt").expect("read error");
        assert_eq!(parts(&inp), (438, 18));
        let inp = std::fs::read("../2020/15/test7.txt").expect("read error");
        assert_eq!(parts(&inp), (1836, 362));
        let inp = std::fs::read("../2020/15/input.txt").expect("read error");
        assert_eq!(parts(&inp), (260, 950));
    }
}
