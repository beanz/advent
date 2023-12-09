use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (i32, i32) {
    let (mut p1, mut p2) = (0, 0);
    let mut i: usize = 0;
    while i < inp.len() {
        let mut l = SmallVec::<[i32; 32]>::new();
        loop {
            let (j, n) = aoc::read::int(inp, i);
            l.push(n);
            i = j;
            if inp[j] == b'\n' {
                break;
            }
            i += 1;
        }
        let mut l2 = SmallVec::<[i32; 32]>::new();
        let mut l = l.as_mut_slice();
        for j in 0..l.len() {
            l2.push(l[l.len() - 1 - j]);
        }
        p1 += solve(&mut l);
        let mut l2 = l2.as_mut_slice();
        p2 += solve(&mut l2);
        i += 1;
    }
    (p1, p2)
}

fn solve(l: &mut [i32]) -> i32 {
    let mut len = l.len();
    let mut f = l[len - 1];
    loop {
        let mut done = true;
        for i in 0..(len - 1) {
            let d = l[i + 1] - l[i];
            if d != 0 {
                done = false;
            }
            l[i] = d;
        }
        if done {
            return f;
        }
        len -= 1;
        f += l[len - 1];
    }
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
        let inp = std::fs::read("../2023/09/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (114, 2));
        let inp = std::fs::read("../2023/09/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1584748274, 1026));
    }
}
