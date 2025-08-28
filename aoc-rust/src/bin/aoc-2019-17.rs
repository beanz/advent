const PROG_CAP: usize = 4096;
const MAP_START: usize = 1182;
const MAP_END_1_ADDR: usize = 11;
const MAP_END_2_ADDR: usize = 12;
const WIDTH_ADDR: usize = 828;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut prog: [i32; PROG_CAP] = [0; PROG_CAP];
    let mut l = 0;
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<i32>(inp, i);
        prog[l] = n;
        l += 1;
        i = j + 1;
    }

    let map_end = (prog[MAP_END_1_ADDR] + prog[MAP_END_2_ADDR]) as usize;
    let w = prog[WIDTH_ADDR] as usize;
    let mut map = [false; 2048];
    let mut v = false;
    let mut l = 0;
    for i in MAP_START..map_end {
        for _j in 0..prog[i] {
            map[l] = v;
            l += 1;
        }
        v = !v;
    }
    let h = l / w;
    let mut p1 = 0;
    let mut p2 = 0;
    let mut c = 0;
    for y in 0..h {
        for x in 0..w {
            let i = x + y * w;
            //eprint!("{}", if map[i] { "#" } else { "." });
            if !map[i] {
                continue;
            }
            if x > 1 && x < w - 1 && y > 1 {
                if map[i - 1] && map[i + 1] && map[i - w] {
                    p1 += x * y;
                }
            }
            c += 1;
            p2 += i + x * y;
        }
        //eprintln!();
    }
    p2 += map_end * c + (1 + c) * c / 2;
    //eprintln!("{}x{}", w, h);

    (p1, p2)
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
        let inp = std::fs::read("../2019/17/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3448, 762405));
        let inp = std::fs::read("../2019/17/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (4372, 945911));
    }
}
