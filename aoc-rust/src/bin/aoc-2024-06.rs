const DX: [i32; 4] = [0, 1, 0, -1];
const DY: [i32; 4] = [-1, 0, 1, 0];

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut pos = 0;
    let mut w = 0;
    while pos < inp.len() {
        match inp[pos] {
            b'^' => {
                break;
            }
            b'\n' => {
                if w == 0 {
                    w = pos + 1
                }
            }
            _ => {}
        }
        pos += 1;
    }
    let h = (inp.len() / w) as i32;
    let sx = (pos % w) as i32;
    let sy = (pos / w) as i32;
    let w = (w - 1) as i32;
    let in_bound = |x, y| 0 <= x && x < w && 0 <= y && y < h;
    let get = |x, y| {
        if in_bound(x, y) {
            inp[(x + y * (w + 1)) as usize]
        } else {
            b'!'
        }
    };
    let mut seen = [false; 33410];
    let mut p1 = 0;
    {
        let (mut cx, mut cy) = (sx, sy);
        let mut dir = 0;
        while in_bound(cx, cy) {
            let k = ((cx << 8) + cy) as usize;
            if !seen[k] {
                p1 += 1;
            }
            seen[k] = true;
            (cx, cy) = {
                let (mut nx, mut ny);
                loop {
                    (nx, ny) = (cx + DX[dir], cy + DY[dir]);
                    if get(nx, ny) != b'#' {
                        break;
                    }
                    dir = (dir + 1) & 3;
                }
                (nx, ny)
            };
        }
    };
    let mut p2 = 0;
    for oy in 0..h {
        for ox in 0..w {
            if !seen[((ox << 8) + oy) as usize] {
                continue;
            }
            let mut seen = [false; 133643];
            let (mut cx, mut cy) = (sx, sy);
            let mut dir = 0;
            while in_bound(cx, cy) {
                let k = (((cx << 8) + cy) << 2) as usize + dir;
                if seen[k] {
                    p2 += 1;
                    break;
                }
                seen[k] = true;
                let (nx, ny) = (cx + DX[dir], cy + DY[dir]);
                if get(nx, ny) == b'#' || (nx == ox && ny == oy) {
                    dir = (dir + 1) & 3;
                    continue;
                }
                (cx, cy) = (nx, ny);
            }
        }
    }

    (p1, p2)
}

fn main() {
    let mut inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&mut inp);
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
        aoc::test::auto("../2024/06/", parts);
    }
}
