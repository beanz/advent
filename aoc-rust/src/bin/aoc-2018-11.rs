const SIZE: usize = 300;

fn parts(inp: &[u8]) -> ((u32, u32), (u32, u32, u32)) {
    let (_, serial) = aoc::read::uint::<u32>(inp, 0);
    let mut cache: [i32; SIZE * SIZE] = [0; SIZE * SIZE];
    for y in 0..SIZE {
        for x in 0..SIZE {
            let mut l = level(x as u32 + 1, y as u32 + 1, serial);
            if x > 0 {
                l += cache[(x - 1) + SIZE * y];
                if y > 0 {
                    l -= cache[(x - 1) + SIZE * (y - 1)];
                }
            }
            if y > 0 {
                l += cache[x + SIZE * (y - 1)];
            }
            cache[x + SIZE * y] = l;
        }
    }
    let get = |x, y| cache[x as usize + y as usize * SIZE];
    let level_square = |x, y, size| {
        let mut s = get(x + size - 1, y + size - 1);
        if x > 0 {
            s -= get(x - 1, y + size - 1);
            if y > 0 {
                s += get(x - 1, y - 1);
            }
        }
        if y > 1 {
            s -= get(x + size - 1, y - 1);
        }
        s
    };
    let (mut p1x, mut p1y) = (0, 0);
    let mut max = i32::MIN;
    // 2 is size-1 = 3-1
    for x in 0u32..SIZE as u32 - 2 {
        for y in 0u32..SIZE as u32 - 2 {
            let l = level_square(x, y, 3);
            if l > max {
                (max, p1x, p1y) = (l, x + 1, y + 1)
            }
        }
    }
    let (mut p2x, mut p2y, mut p2s) = (0, 0, 0);
    let mut max = i32::MIN;
    for size in 1..=30 {
        for x in 0u32..SIZE as u32 - size + 1 {
            for y in 0u32..SIZE as u32 - size + 1 {
                let l = level_square(x, y, size);
                if l > max {
                    (max, p2x, p2y, p2s) = (l, x + 1, y + 1, size)
                }
            }
        }
    }

    ((p1x, p1y), (p2x, p2y, p2s))
}

fn level(x: u32, y: u32, serial: u32) -> i32 {
    let r = x as i32 + 10;
    let mut p = r * y as i32;
    p += serial as i32;
    p *= r;
    p /= 100;
    p %= 10;
    p - 5
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {},{}", p1.0, p1.1);
            println!("Part 2: {},{},{}", p2.0, p2.1, p2.2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/11/input.txt").expect("read error");
        assert_eq!(parts(&inp), ((235, 14), (237, 227, 14)));
        let inp = std::fs::read("../2018/11/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), ((20, 54), (233, 93, 13)));
    }
}
