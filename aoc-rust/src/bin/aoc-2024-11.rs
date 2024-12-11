use heapless::FnvIndexMap;

const SIZE: usize = 4096;
fn parts(inp: &[u8]) -> (usize, usize) {
    let mut nums = FnvIndexMap::<usize, usize, SIZE>::new();
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::uint::<usize>(inp, i);
        if let Some(e) = nums.get_mut(&n) {
            *e += 1;
        } else {
            nums.insert(n, 1).expect("insert");
        }
        i = j + 1
    }
    //println!("{:?}", nums);
    let mut next = FnvIndexMap::<usize, usize, SIZE>::new();
    let mut cur = &mut nums;
    let mut next = &mut next;
    let (mut p1, mut p2) = (0, 0);
    for b in 1..=75 {
        p2 = 0;
        for (k, v) in &mut *cur {
            if *k == 0 {
                p2 += *v;
                let n = 1;
                if let Some(e) = next.get_mut(&n) {
                    *e += *v;
                } else {
                    next.insert(n, *v).expect("insert");
                }
                continue;
            }
            let (a, b, split) = split_uint(*k);
            if split {
                p2 += *v * 2;
                if let Some(e) = next.get_mut(&a) {
                    *e += *v;
                } else {
                    next.insert(a, *v).expect("insert");
                }
                if let Some(e) = next.get_mut(&b) {
                    *e += *v;
                } else {
                    next.insert(b, *v).expect("insert");
                }
                continue;
            }
            p2 += *v;
            let n = *k * 2024;
            if let Some(e) = next.get_mut(&n) {
                *e += *v;
            } else {
                next.insert(n, *v).expect("insert");
            }
        }
        if b == 25 {
            p1 = p2;
        }
        cur.clear();
        (cur, next) = (next, cur);
        //println!("{}: {:?}", p2, cur);
        //println!("{}", p2);
    }
    (p1, p2)
}

fn split_uint(n: usize) -> (usize, usize, bool) {
    let mut l = 1;
    let mut m = 10;
    loop {
        if n < m {
            break;
        }
        l += 1;
        m *= 10;
    }
    if l & 1 == 1 {
        return (0, 0, false);
    }
    m = 10;
    for _ in 0..l / 2 - 1 {
        m *= 10;
    }
    let a = n / m;
    let b = n - a * m;
    (a, b, true)
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
    fn split_uint_works() {
        assert_eq!(split_uint(12), (1, 2, true));
        assert_eq!(split_uint(123), (0, 0, false));
        assert_eq!(split_uint(1234567890), (12345, 67890, true));
        assert_eq!(split_uint(123456789), (0, 0, false));
    }
    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/11/", parts);
    }
}
