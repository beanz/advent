use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, (usize, usize)) {
    let (ex, ey, corrupt) = if inp.len() < 150 {
        (6, 6, 12)
    } else {
        (70, 70, 1024)
    };
    let w = ex + 1;
    let mut drops = SmallVec::<[(usize, usize); 4096]>::new();
    let mut m: [usize; 8192] = [0; 8192];
    let mut n = 1;
    let mut i = 0;
    while i < inp.len() {
        let (j, x) = aoc::read::uint::<usize>(inp, i);
        let (j, y) = aoc::read::uint::<usize>(inp, j + 1);
        i = j + 1;

        drops.push((x, y));
        m[x + y * w] = n;
        n += 1;
    }
    let mut dq = aoc::deque::Deque::<(i32, i32, usize), 128>::default();
    let p1 = search(&m, ex as i32, ey, corrupt, &mut dq);
    let mut hi = n;
    let mut lo = corrupt + 1;
    loop {
        let mid = (lo + hi) / 2;
        if search(&m, ex as i32, ey, mid, &mut dq).is_some() {
            lo = mid + 1;
        } else {
            hi = mid
        }
        if lo == hi {
            break;
        }
    }
    let mut c = 1;
    let (mut p2s, mut p2e) = (0, 0);
    for (s, ch) in inp.iter().enumerate() {
        if *ch == b'\n' {
            c += 1;
            if lo == c {
                p2s = s + 1;
            } else if lo + 1 == c {
                p2e = s;
                break;
            }
        }
    }
    (p1.unwrap(), (p2s, p2e))
}

const DX: [i32; 4] = [0, 1, 0, -1];
const DY: [i32; 4] = [-1, 0, 1, 0];

fn search(
    m: &[usize],
    ex: i32,
    ey: i32,
    corrupt: usize,
    dq: &mut aoc::deque::Deque<(i32, i32, usize), 128>,
) -> Option<usize> {
    let (w, h) = (ex + 1, ey + 1);
    dq.clear();
    dq.push((0, 0, 0));
    let mut seen: [bool; 8192] = [false; 8192];
    while let Some((x, y, st)) = dq.pop() {
        if x == ex && y == ey {
            return Some(st);
        }
        for d in 0..4 {
            let (nx, ny) = (x + DX[d], y + DY[d]);
            if !(0 <= nx && nx < w && 0 <= ny && ny < h) {
                continue;
            }
            let k = (nx + ny * w) as usize;
            if seen[k] {
                continue;
            }
            seen[k] = true;
            let c = m[k];
            if c != 0 && (c - 1) < corrupt {
                continue;
            }
            dq.push((nx, ny, st + 1));
        }
    }
    None
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!(
                "Part 2: {}",
                std::str::from_utf8(&inp[p2.0..p2.1]).expect("ascii")
            );
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/18/", parts);
    }
}
