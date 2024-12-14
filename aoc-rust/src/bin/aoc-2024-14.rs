use smallvec::SmallVec;

#[derive(Debug)]
struct Robot {
    x: i32,
    y: i32,
    vx: i32,
    vy: i32,
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut i = 0;
    let mut robots = SmallVec::<[Robot; 512]>::new();
    while i < inp.len() {
        let (j, x) = aoc::read::int::<i32>(inp, i + 2);
        let (j, y) = aoc::read::int::<i32>(inp, j + 1);
        let (j, vx) = aoc::read::int::<i32>(inp, j + 3);
        let (j, vy) = aoc::read::int::<i32>(inp, j + 1);
        i = j + 1;
        robots.push(Robot { x, y, vx, vy });
    }
    let (w, h) = if robots.len() <= 12 {
        (11, 7)
    } else {
        (101, 103)
    };
    let (qw, qh) = (w / 2, h / 2);
    let mut q: [usize; 4] = [0; 4];
    let d = 100;
    for r in &robots {
        let x = (r.x + r.vx * d).rem_euclid(w);
        let y = (r.y + r.vy * d).rem_euclid(h);
        let mut qi = 0;
        if x > qw {
            qi += 1;
        }
        if y > qh {
            qi += 2;
        }
        if x != qw && y != qh {
            q[qi] += 1;
        }
    }
    let p1 = q[0] * q[1] * q[2] * q[3];
    let mut p2 = 0;
    'outer: for d in 1..=10000 {
        let mut seen = [false; 12000];
        for r in &robots {
            let x = (r.x + r.vx * d).rem_euclid(w);
            let y = (r.y + r.vy * d).rem_euclid(h);
            if seen[(x + y * w) as usize] {
                continue 'outer;
            }
            seen[(x + y * w) as usize] = true;
        }
        p2 = d as usize;
        break;
    }
    (p1, p2)
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
        aoc::test::auto("../2024/14/", parts);
    }
}
