const X: usize = 0;
const Y: usize = 1;
const Z: usize = 2;
const VX: usize = 3;
const VY: usize = 4;
const VZ: usize = 5;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut moons: [[i16; 6]; 4] = [[0; 6]; 4];
    let mut moons2: [[i16; 6]; 4] = [[0; 6]; 4];
    let mut i = 0;
    let mut k = 0;
    while i < inp.len() {
        let (j, x) = aoc::read::int(inp, i + 3);
        i = j + 4;
        moons[k][X] = x;
        moons2[k][X] = x;
        let (j, y) = aoc::read::int(inp, i);
        i = j + 4;
        moons[k][Y] = y;
        moons2[k][Y] = y;
        let (j, z) = aoc::read::int(inp, i);
        moons[k][Z] = z;
        moons2[k][Z] = z;
        i = j + 2;
        k += 1;
    }
    for _s in 0..1000 {
        for a in X..=Z {
            step_axis(&mut moons, a);
        }
    }
    let p1 = total_energy(&moons);
    let mut cycle = [0; 3];
    for axis in X..=Z {
        let initial = axis_state(&moons2, axis);
        let mut st = 0;
        loop {
            st += 1;
            step_axis(&mut moons2, axis);
            if initial == axis_state(&moons2, axis) && axis_state(&moons2, VX + axis) == 0 {
                cycle[axis] = st;
                break;
            }
        }
    }
    let p2 = num::integer::lcm(cycle[X], num::integer::lcm(cycle[Y], cycle[Z]));
    (p1, p2)
}

fn energy(m: &[i16; 6]) -> usize {
    (m[X].unsigned_abs() as usize + m[Y].unsigned_abs() as usize + m[Z].unsigned_abs() as usize)
        * (m[VX].unsigned_abs() as usize
            + m[VY].unsigned_abs() as usize
            + m[VZ].unsigned_abs() as usize)
}

fn total_energy(moons: &[[i16; 6]; 4]) -> usize {
    let mut s = 0;
    for i in 0..4 {
        s += energy(&moons[i]);
    }
    s
}

fn axis_state(moons: &[[i16; 6]; 4], axis: usize) -> usize {
    let mut s = 0usize;
    for i in 0..4 {
        s = (s << 16) + (moons[i][axis] as u16) as usize;
    }
    s
}

fn step_axis(moons: &mut [[i16; 6]; 4], axis: usize) {
    for i in 0..4 {
        for j in i + 1..4 {
            match moons[i][axis].cmp(&moons[j][axis]) {
                std::cmp::Ordering::Greater => {
                    moons[i][VX + axis] -= 1;
                    moons[j][VX + axis] += 1;
                }
                std::cmp::Ordering::Less => {
                    moons[i][VX + axis] += 1;
                    moons[j][VX + axis] -= 1;
                }
                _ => {}
            }
        }
    }
    for i in 0..4 {
        moons[i][axis] += moons[i][VX + axis];
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
        let inp = std::fs::read("../2019/12/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (183, 2772));
        let inp = std::fs::read("../2019/12/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (14645, 4686774924));
        let inp = std::fs::read("../2019/12/input.txt").expect("read error");
        assert_eq!(parts(&inp), (8044, 362375881472136));
        let inp = std::fs::read("../2019/12/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (6227, 331346071640472));
    }
}
