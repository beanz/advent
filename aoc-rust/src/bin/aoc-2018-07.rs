const IDLE: u32 = 255;

fn parts(inp: &[u8]) -> ([u8; 26], usize, usize) {
    let mut i = 0;
    let mut deps: [u32; 26] = [0; 26];
    let mut deps2: [u32; 26] = [0; 26];
    let mut todo = 0u32;
    let mut has_deps = 0u32;
    while i < inp.len() {
        let (a, b) = (inp[i + 5] - b'A', inp[i + 36] - b'A');
        let (ba, bb) = (1u32 << a, 1u32 << b);
        todo |= ba | bb;
        deps[b as usize] |= ba;
        has_deps |= bb;
        i += 49;
    }
    for i in 0..26 {
        deps2[i] = deps[i];
    }
    let mut available = todo ^ has_deps;
    let mut p1 = [0u8; 26];
    let mut p1l = 0;
    while available != 0 {
        let n = available.trailing_zeros();
        available ^= 1 << n;
        available |= step(n, &mut deps);
        p1[p1l] = b'A' + n as u8;
        p1l += 1;
    }

    let mut doing: [u32; 5] = [IDLE; 5];
    let mut available = todo ^ has_deps;
    let mut timeleft = [0usize; 26];
    let (workload, workers) = if todo.count_ones() < 10 {
        (0, 2)
    } else {
        (60, 5)
    };
    let mut total_left = 0;
    for i in 0..26 {
        if todo & (1 << i) != 0 {
            timeleft[i] = workload + 1 + i;
            total_left += workload + 1 + i;
        }
    }
    let mut t = 0;
    while available != 0 || total_left != 0 {
        let mut cur_avail = available;
        for wn in 0..workers {
            let n = if doing[wn] != IDLE {
                doing[wn]
            } else if cur_avail != 0 {
                let n = cur_avail.trailing_zeros();
                cur_avail ^= 1 << n;
                available ^= 1 << n;
                doing[wn] = n;
                //eprintln!("{}.{}: starting {}", t, wn, (b'A' + n as u8) as char);
                n
            } else {
                continue;
            };
            timeleft[n as usize] -= 1;
            total_left -= 1;
            if timeleft[n as usize] > 0 {
                continue;
            }
            //eprintln!("{}.{}: finished {}", t, wn, (b'A' + n as u8) as char);
            doing[wn] = IDLE;
            available |= step(n, &mut deps2);
        }
        t += 1;
    }
    (p1, p1l, t)
}

fn step(n: u32, deps: &mut [u32; 26]) -> u32 {
    let mut avail = 0;
    let mask = u32::MAX ^ (1 << n);
    for k in 0..26 {
        if deps[k as usize] == 0 {
            continue;
        }
        deps[k as usize] &= mask;
        if deps[k as usize] != 0 {
            continue;
        }
        avail |= 1 << k;
    }
    avail
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p1l, p2) = parts(&inp);
        if !bench {
            println!(
                "Part 1: {}",
                std::str::from_utf8(&p1[0..p1l]).expect("ascii")
            );
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/07/test.txt").expect("read error");
        let (p1, p1l, p2) = parts(&inp);
        assert_eq!(std::str::from_utf8(&p1[0..p1l]).expect("ascii"), "CABDFE",);
        assert_eq!(p2, 15);
        let inp = std::fs::read("../2018/07/input.txt").expect("read error");
        let (p1, p1l, p2) = parts(&inp);
        assert_eq!(
            std::str::from_utf8(&p1[0..p1l]).expect("ascii"),
            "BETUFNVADWGPLRJOHMXKZQCISY",
        );
        assert_eq!(p2, 848);
        let inp = std::fs::read("../2018/07/input-amf.txt").expect("read error");
        let (p1, p1l, p2) = parts(&inp);
        assert_eq!(
            std::str::from_utf8(&p1[0..p1l]).expect("ascii"),
            "CFMNLOAHRKPTWBJSYZVGUQXIDE",
        );
        assert_eq!(p2, 971);
    }
}
