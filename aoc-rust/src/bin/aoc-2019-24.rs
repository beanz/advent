use heapless::FnvIndexSet;

fn parts(inp: &[u8]) -> (u32, usize) {
    let mut i = 1;
    let mut n = 0u32;
    for y in 0..5 {
        for x in 0..5 {
            if inp[y * 6 + x] == b'#' {
                n += i;
            }
            i <<= 1;
        }
    }
    let init = n;
    let mut seen = FnvIndexSet::<u32, 128>::new();
    seen.insert(n).expect("seen set full");
    let p1;
    loop {
        let mut nn = 0;
        let mut i = 1;
        for y in 0..5 {
            for x in 0..5 {
                if life(n, x, y) {
                    nn += i;
                }
                i <<= 1;
            }
        }
        if seen.contains(&nn) {
            p1 = nn;
            break;
        }
        seen.insert(nn).expect("seen set full");
        n = nn;
    }
    let mut now: [u32; 512] = [0; 512];
    now[256] = init;
    let mut next: [u32; 512] = [0; 512];
    let now = &mut now;
    let next = &mut next;
    let mut depth = 1;
    for _n in 0..200 {
        for d in 256 - depth..=256 + depth {
            next[d] = 0;
            let mut i = 1;
            for y in 0..5 {
                for x in 0..5 {
                    if x != 2 || y != 2 {
                        if life2(now, d, x, y) {
                            next[d] += i;
                        }
                    }
                    i <<= 1;
                }
            }
        }
        std::mem::swap(now, next);
        depth += 1;
    }
    let mut p2 = 0;
    for i in 0..512 {
        p2 += now[i].count_ones() as usize;
    }
    (p1, p2)
}

#[allow(dead_code)]
fn pp(n: &[u32; 512], depth: usize) {
    for d in 256 - depth..=256 + depth {
        eprintln!("d={}", d as isize - 256);
        for y in 0..5 {
            for x in 0..5 {
                eprint!("{}", if bug(n[d], x, y) { '#' } else { '.' });
            }
            eprintln!();
        }
        eprintln!();
    }
}

fn life2(n: &[u32; 512], d: usize, x: usize, y: usize) -> bool {
    let mut c = 0;

    // neighbours above
    if y == 0 {
        c += usize::from(bug(n[d - 1], 2, 1));
    } else if y == 3 && x == 2 {
        for xa in 0..5 {
            c += usize::from(bug(n[d + 1], xa, 4));
        }
    } else {
        if y > 0 {
            c += usize::from(bug(n[d], x, y - 1));
        }
    }

    // neighbours below
    if y == 4 {
        c += usize::from(bug(n[d - 1], 2, 3));
    } else if y == 1 && x == 2 {
        for xa in 0..5 {
            c += usize::from(bug(n[d + 1], xa, 0));
        }
    } else {
        if y < 5 {
            c += usize::from(bug(n[d], x, y + 1));
        }
    }

    // neighbours left
    if x == 0 {
        c += usize::from(bug(n[d - 1], 1, 2));
    } else if x == 3 && y == 2 {
        for ya in 0..5 {
            c += usize::from(bug(n[d + 1], 4, ya));
        }
    } else {
        if x > 0 {
            c += usize::from(bug(n[d], x - 1, y));
        }
    }

    // neighbours right
    if x == 4 {
        c += usize::from(bug(n[d - 1], 3, 2));
    } else if x == 1 && y == 2 {
        for ya in 0..5 {
            c += usize::from(bug(n[d + 1], 0, ya));
        }
    } else {
        if x < 5 {
            c += usize::from(bug(n[d], x + 1, y));
        }
    }
    c == 1 || (!bug(n[d], x, y) && c == 2)
}

fn life(n: u32, x: usize, y: usize) -> bool {
    let mut c: usize = 0;
    if y > 0 {
        c += usize::from(bug(n, x, y - 1));
    }
    if x > 0 {
        c += usize::from(bug(n, x - 1, y));
    }
    c += usize::from(bug(n, x, y + 1));
    c += usize::from(bug(n, x + 1, y));
    c == 1 || (!bug(n, x, y) && c == 2)
}

fn bug(n: u32, x: usize, y: usize) -> bool {
    if y > 4 || x > 4 {
        false
    } else {
        n & (1 << (y * 5 + x)) != 0
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
        let inp = std::fs::read("../2019/24/test.txt").expect("read error");
        assert_eq!(parts(&inp), (2129920, 1922));
        let inp = std::fs::read("../2019/24/input.txt").expect("read error");
        assert_eq!(parts(&inp), (6520863, 1970));
        let inp = std::fs::read("../2019/24/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (11042850, 1967));
    }
}
