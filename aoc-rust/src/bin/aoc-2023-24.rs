use aoc::{math::crt, read::visit_ints};
use heapless::Vec;

const X: usize = 0;
const Y: usize = 1;
const Z: usize = 2;
const VX: usize = 3;
const VY: usize = 4;
const VZ: usize = 5;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut k = 0;
    let mut r: [isize; 6] = [0; 6];
    let mut p = Vec::<[isize; 6], 320>::new();
    visit_ints::<isize>(inp, |n| {
        r[k] = n;
        k += 1;
        if k == 6 {
            p.push([r[0], r[1], r[2], r[3], r[4], r[5]])
                .expect("insert");
            k = 0;
        }
    });
    let (min, max): (f64, f64) = if p.len() < 100 {
        (7.0, 27.0)
    } else {
        (200000000000000.0, 400000000000000.0)
    };
    let mut p1 = 0;
    for i in 0..p.len() {
        for j in i + 1..p.len() {
            if intersect(&p[i], &p[j], min, max) {
                p1 += 1;
            }
        }
    }
    let mut p2 = 1;
    'outer: for rv in -1000..=1000 {
        //262..263 {
        let mut u = Vec::<isize, 320>::new();
        let mut m = Vec::<isize, 320>::new();
        for a in &p {
            let v = a[VX] + a[VY] + a[VZ];
            let s = a[X] + a[Y] + a[Z];
            let dv = (v - rv).abs();
            if dv == 0 {
                continue 'outer;
            }
            let au = s.rem_euclid(dv);
            println!("{} {}", au, dv);
            u.push(au).expect("insert");
            m.push(dv).expect("insert");
            if u.len() > 60 {
                break;
            }
        }
        let r = crt(&u, &m);
        if let Some(rr) = r {
            p2 = rr as usize;
            break;
        }
    }
    (p1, p2)
}

fn intersect(p1: &[isize; 6], p2: &[isize; 6], min: f64, max: f64) -> bool {
    let f1: [f64; 6] = [
        p1[0] as f64,
        p1[1] as f64,
        p1[2] as f64,
        p1[3] as f64,
        p1[4] as f64,
        p1[5] as f64,
    ];
    let f2: [f64; 6] = [
        p2[0] as f64,
        p2[1] as f64,
        p2[2] as f64,
        p2[3] as f64,
        p2[4] as f64,
        p2[5] as f64,
    ];
    let m1 = f1[VY] / f1[VX];
    let m2 = f2[VY] / f2[VX];
    if m1 == m2 {
        return false;
    }
    let c1 = f1[Y] - m1 * f1[X];
    let c2 = f2[Y] - m2 * f2[X];
    let px = (c2 - c1) / (m1 - m2);
    let py = m1 * px + c1;
    if !(min <= px && px <= max) {
        return false;
    }
    if !(min <= py && py <= max) {
        return false;
    }
    let future = (p1[VX] > 0 && px > f1[X])
        || (p1[VX] < 0 && px < f1[X])
        || (p1[VY] > 0 && py > f1[Y])
        || (p1[VY] < 0 && py < f1[Y]);
    if !future {
        return false;
    }
    (p2[VX] > 0 && px > f2[X])
        || (p2[VX] < 0 && px < f2[X])
        || (p2[VY] > 0 && py > f2[Y])
        || (p2[VY] < 0 && py < f2[Y])
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
        let inp = std::fs::read("../2023/24/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (2, 47));
        let inp = std::fs::read("../2023/24/input.txt").expect("read error");
        assert_eq!(parts(&inp), (16502, 673641951253289));
        let inp = std::fs::read("../2023/24/input2.txt").expect("read error");
        assert_eq!(parts(&inp), (20361, 558415252330828));
    }
}
