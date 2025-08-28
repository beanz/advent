fn parts(inp: &[u8]) -> (usize, usize) {
    let mut cups: [u8; 9] = [0; 9];
    for i in 0..8 {
        let c = (inp[i] & 0xf) as usize;
        let n = inp[i + 1] & 0xf;
        cups[c - 1] = n - 1;
    }
    let mut cur = (inp[0] & 0xf) - 1;
    let last = (inp[8] & 0xf) as usize - 1;
    cups[last] = cur;

    for _ in 0..100 {
        let r1 = cups[cur as usize];
        let r2 = cups[r1 as usize];
        let r3 = cups[r2 as usize];
        let next = cups[r3 as usize];
        cups[cur as usize] = next;
        let mut new = if cur == 0 { 8 } else { cur - 1 };
        while new == r1 || new == r2 || new == r3 {
            new = if new == 0 { 8 } else { new - 1 };
        }
        let new_next = cups[new as usize];
        cups[r3 as usize] = new_next;
        cups[new as usize] = r1;
        cur = next;
    }
    let p1 = part1(&cups);
    let mut cups: [u32; 1_000_000] = [0; 1_000_000];
    for i in 0..8 {
        let c = (inp[i] & 0xf) as usize;
        let n = (inp[i + 1] & 0xf) as u32;
        cups[c - 1] = n - 1;
    }
    let mut cur = (inp[0] & 0xf) as u32 - 1;
    let last = (inp[8] & 0xf) as usize - 1;
    cups[last] = 9;
    for i in 9..1_000_000 - 1 {
        cups[i] = (i + 1) as u32;
    }
    cups[1_000_000 - 1] = cur;

    //eprintln!("{}", part1(&cups));
    for _ in 0..10_000_000 {
        let r1 = cups[cur as usize];
        let r2 = cups[r1 as usize];
        let r3 = cups[r2 as usize];
        let next = cups[r3 as usize];
        cups[cur as usize] = next;
        let mut new = if cur == 0 { 1_000_000 - 1 } else { cur - 1 };
        while new == r1 || new == r2 || new == r3 {
            new = if new == 0 { 1_000_000 - 1 } else { new - 1 };
        }
        //eprintln!("removed [{} {} {}]", r1 + 1, r2 + 1, r3 + 1);
        //eprintln!("{} -> {} / {}", cur + 1, next + 1, new + 1);
        let new_next = cups[new as usize];
        cups[r3 as usize] = new_next;
        cups[new as usize] = r1;
        //eprintln!("{}", part1(&cups));
        cur = next;
    }
    let p2a = cups[0] as usize;
    let p2b = cups[p2a] as usize;
    //eprintln!("{} x {} = {}", (p2a + 1), (p2b + 1), (p2a + 1) * (p2b + 1));
    let p2 = (p2a + 1) * (p2b + 1);
    (p1, p2)
}

fn part1(cups: &[u8]) -> usize {
    let mut cup = cups[0] as usize;
    let mut p1 = cup + 1;
    loop {
        cup = cups[cup] as usize;
        if cup == 0 {
            return p1;
        }
        p1 = 10 * p1 + cup + 1;
    }
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
        let inp = std::fs::read("../2020/23/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (67384529, 149245887792));
        let inp = std::fs::read("../2020/23/input.txt").expect("read error");
        assert_eq!(parts(&inp), (46978532, 163035127721));
        let inp = std::fs::read("../2020/23/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (25398647, 363807398885));
    }
}
