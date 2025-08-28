use heapless::{FnvIndexMap, Vec};

#[derive(Debug)]
struct Particle {
    p: (i32, i32, i32),
    v: (i32, i32, i32),
    a: (i32, i32, i32),
    dead: bool,
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut particles = Vec::<Particle, 10240>::new();
    let mut i = 0;
    while i < inp.len() {
        let (j, x) = aoc::read::int::<i32>(inp, i + 3);
        let (j, y) = aoc::read::int::<i32>(inp, j + 1);
        let (j, z) = aoc::read::int::<i32>(inp, j + 1);
        let (j, vx) = aoc::read::int::<i32>(inp, j + 6);
        let (j, vy) = aoc::read::int::<i32>(inp, j + 1);
        let (j, vz) = aoc::read::int::<i32>(inp, j + 1);
        let (j, ax) = aoc::read::int::<i32>(inp, j + 6);
        let (j, ay) = aoc::read::int::<i32>(inp, j + 1);
        let (j, az) = aoc::read::int::<i32>(inp, j + 1);
        particles
            .push(Particle {
                p: (x, y, z),
                v: (vx, vy, vz),
                a: (ax, ay, az),
                dead: false,
            })
            .expect("particles full");
        //eprintln!("{:?}", particles[particles.len() - 1]);
        i = j + 2;
    }
    let p1 = find_closest(&particles);
    let mut p2 = particles.len();
    let mut seen = FnvIndexMap::<(i32, i32, i32), usize, 1024>::new();
    for _ in 0..1000 {
        for i in 0..particles.len() {
            if particles[i].dead {
                continue;
            }
            particles[i].v.0 += particles[i].a.0;
            particles[i].v.1 += particles[i].a.1;
            particles[i].v.2 += particles[i].a.2;
            particles[i].p.0 += particles[i].v.0;
            particles[i].p.1 += particles[i].v.1;
            particles[i].p.2 += particles[i].v.2;
            if let Some(other) = seen.get(&particles[i].p) {
                if !particles[*other].dead {
                    particles[*other].dead = true;
                    p2 -= 1;
                }
                particles[i].dead = true;
                p2 -= 1;
            }
            seen.insert(particles[i].p, i).expect("seen full");
        }
        seen.clear();
    }
    (p1, p2)
}

fn find_closest(particles: &Vec<Particle, 10240>) -> usize {
    let mut p1 = 0;
    let (mut min_a, mut min_v, mut min_p) = (i32::MAX, i32::MAX, i32::MAX);
    for (i, p) in particles.iter().enumerate() {
        let a = p.a.0.abs() + p.a.1.abs() + p.a.2.abs();
        match a.cmp(&min_a) {
            std::cmp::Ordering::Less => {
                min_a = a;
                min_v = p.v.0.abs() + p.v.1.abs() + p.v.2.abs();
                min_p = p.p.0.abs() + p.p.1.abs() + p.p.2.abs();
                p1 = i;
            }
            std::cmp::Ordering::Equal => {
                let v = p.v.0.abs() + p.v.1.abs() + p.v.2.abs();
                match v.cmp(&min_v) {
                    std::cmp::Ordering::Less => {
                        min_a = a;
                        min_v = v;
                        min_p = p.p.0.abs() + p.p.1.abs() + p.p.2.abs();
                        p1 = i;
                    }
                    std::cmp::Ordering::Equal => {
                        let pos = p.p.0.abs() + p.p.1.abs() + p.p.2.abs();
                        if pos < min_p {
                            min_a = a;
                            min_v = v;
                            min_p = pos;
                            p1 = i;
                        }
                    }
                    _ => {}
                }
            }
            _ => {}
        }
    }
    p1
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
        let inp = std::fs::read("../2017/20/input.txt").expect("read error");
        assert_eq!(parts(&inp), (91, 567));
        //let inp = std::fs::read("../2017/20/input-amf.txt").expect("read error");
        //assert_eq!(parts(&inp), (119, 471));
    }
}
