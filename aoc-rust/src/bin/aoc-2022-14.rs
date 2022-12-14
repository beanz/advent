use std::cmp::Ordering;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut minx = i32::MAX;
    let mut maxx = i32::MIN;
    let mut maxy = i32::MIN;
    let mut occupied: [bool; 76800] = [false; 76800];
    let mut i = 0;
    while i < inp.len() {
        let (j, mut x) = aoc::read::uint::<i32>(inp, i);
        i = j + 1;
        let (j, mut y) = aoc::read::uint::<i32>(inp, i);
        i = j;
        occupied[((x - 300) * 192 + y) as usize] = true;
        if minx > x {
            minx = x;
        }
        if maxx < x {
            maxx = x
        }
        if maxy < y {
            maxy = y
        }
        while i < inp.len() && inp[i] != b'\n' {
            i += 4;
            let (j, nx) = aoc::read::uint::<i32>(inp, i);
            i = j + 1;
            let (j, ny) = aoc::read::uint::<i32>(inp, i);
            i = j;
            let ix = match nx.cmp(&x) {
                Ordering::Less => -1,
                Ordering::Greater => 1,
                Ordering::Equal => 0,
            };
            let iy = match ny.cmp(&y) {
                Ordering::Less => -1,
                Ordering::Greater => 1,
                Ordering::Equal => 0,
            };
            while x != nx || y != ny {
                x += ix;
                y += iy;
                if minx > x {
                    minx = x;
                }
                if maxx < x {
                    maxx = x
                }
                if maxy < y {
                    maxy = y
                }
                occupied[((x - 300) * 192 + y) as usize] = true;
            }
        }
        i += 1;
    }
    let mut p1 = 0;
    let mut c = 0;
    let mut sx = 500;
    let mut sy = 0;
    loop {
        if p1 == 0 && (sx > maxx || sx < minx) {
            p1 = c;
        }
        if sy < maxy + 1 {
            if !occupied[((sx - 300) * 192 + (sy + 1)) as usize] {
                sy += 1;
                continue;
            }
            if !occupied[(((sx - 1) - 300) * 192 + (sy + 1)) as usize] {
                sx -= 1;
                sy += 1;
                continue;
            }
            if !occupied[(((sx + 1) - 300) * 192 + (sy + 1)) as usize] {
                sx += 1;
                sy += 1;
                continue;
            }
        }
        occupied[((sx - 300) * 192 + sy) as usize] = true;
        c += 1;
        if sx == 500 && sy == 0 {
            break;
        }
        sx = 500;
        sy = 0;
    }
    (p1, c)
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
        let inp = std::fs::read("../2022/14/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (24, 93));
        let inp = std::fs::read("../2022/14/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1513, 22646));
    }
}
