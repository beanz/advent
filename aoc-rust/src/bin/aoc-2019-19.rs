const PROG_CAP: usize = 4096;
const VAR_M_XX: usize = 80;
const VAR_M_YY: usize = 122;
const VAR_M_XY: usize = 160;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut prog: [isize; PROG_CAP] = [0; PROG_CAP];
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<isize>(inp, i);
        prog[l] = n;
        l += 1;
        i = j + 1;
    }

    let var_xx = read_var(&prog, VAR_M_XX);
    let var_yy = read_var(&prog, VAR_M_YY);
    let var_xy = read_var(&prog, VAR_M_XY);
    let in_beam = |x: isize, y: isize| (var_xx * x * x - var_yy * y * y).abs() <= var_xy * x * y;
    let mut p1 = 0usize;
    for y in 0..50 {
        for x in 0..50 {
            if in_beam(x, y) {
                p1 += 1;
            }
        }
    }
    let mul = 49;
    let mut ratio1 = 0;
    while !in_beam(ratio1, mul) {
        ratio1 += 1
    }
    let mut ratio2 = ratio1;
    while in_beam(ratio2, mul) {
        ratio2 += 1;
    }
    let size = 100 - 1;
    let square_fits = |x, y| in_beam(x, y) && in_beam(x + size, y) && in_beam(x, y + size);
    let square_fits_y = |y| {
        for x in y * ratio1 / mul..=y * ratio2 / mul {
            if square_fits(x, y) {
                return x;
            }
        }
        0
    };
    let mut upper = 1;
    while square_fits_y(upper) == 0 {
        upper *= 2;
    }
    let mut lower = upper / 2;
    loop {
        let mid = lower + (upper - lower) / 2;
        if mid == lower {
            break;
        }
        if square_fits_y(mid) > 0 {
            upper = mid;
        } else {
            lower = mid;
        }
    }
    let mut p2 = 0;
    for y in lower..lower + 5 {
        let x = square_fits_y(y);
        if x > 0 {
            p2 = (x * 10000 + y) as usize;
            break;
        }
    }
    (p1, p2)
}

fn read_var(prog: &[isize; PROG_CAP], addr: usize) -> isize {
    match prog[addr] {
        21101 => prog[addr + 1] + prog[addr + 2],
        21102 => prog[addr + 1] * prog[addr + 2],
        _ => unreachable!("unexpected instruction"),
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
        let inp = std::fs::read("../2019/19/input.txt").expect("read error");
        assert_eq!(parts(&inp), (211, 8071006));
        let inp = std::fs::read("../2019/19/input2.txt").expect("read error");
        assert_eq!(parts(&inp), (114, 10671712));
        let inp = std::fs::read("../2019/19/input3.txt").expect("read error");
        assert_eq!(parts(&inp), (131, 15231022));
        let inp = std::fs::read("../2019/19/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (121, 15090773));
    }
}
