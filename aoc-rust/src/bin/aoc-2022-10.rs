fn parts(inp: &[u8]) -> (usize, [u8; 246]) {
    let mut inc: [i8; 512] = [0; 512];
    let mut i = 0;
    let mut j = 0;
    while i < inp.len() {
        j += 1;
        if inp[i] == b'a' {
            (i, inc[j]) = match inp[i + 5] {
                b'-' => {
                    let (k, inc) = aoc::read::uint::<u8>(inp, i + 6);
                    let mut inc: i8 = inc as i8;
                    inc *= -1;
                    (k, inc)
                }
                _ => {
                    let (k, inc) = aoc::read::uint::<u8>(inp, i + 5);
                    (k, inc as i8)
                }
            };
            i += 1;
            j += 1;
        } else {
            i += 5;
        }
    }
    let num = j;
    let mut x = 1;
    j = 0;
    let mut k = 0;
    let mut bi = 0;
    let mut p2: [u8; 246] = [b'\n'; 246];
    let mut p1 = 0;
    for i in 0..240 {
        if x >= j as i8 - 1 && x <= j as i8 + 1 {
            p2[bi] = b'#'
        } else {
            p2[bi] = b'.'
        }
        bi += 1;
        j += 1;
        if j == 20 {
            p1 += (i + 1) * x as usize;
        }
        if j == 40 {
            j = 0;
            bi += 1;
        }
        x += inc[k];
        k += 1;
        if k == num {
            k = 0;
        }
    }
    (p1, p2)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2:\n{}", std::str::from_utf8(&p2).expect("ascii"));
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/10/test1.txt").expect("read error");
        let b: [u8; 246] = *b"##..##..##..##..##..##..##..##..##..##..
###...###...###...###...###...###...###.
####....####....####....####....####....
#####.....#####.....#####.....#####.....
######......######......######......####
#######.......#######.......#######.....\n";
        assert_eq!(parts(&inp), (13140, b));
        let inp = std::fs::read("../2022/10/input.txt").expect("read error");
        let b: [u8; 246] = *b"###..#..#.#....#..#...##..##..####..##..
#..#.#..#.#....#..#....#.#..#....#.#..#.
#..#.####.#....####....#.#......#..#..#.
###..#..#.#....#..#....#.#.##..#...####.
#....#..#.#....#..#.#..#.#..#.#....#..#.
#....#..#.####.#..#..##...###.####.#..#.\n";
        assert_eq!(parts(&inp), (15360, b));
    }
}
