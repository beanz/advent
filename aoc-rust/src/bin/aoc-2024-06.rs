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
    let mut corners: [usize; 133643] = [0; 133643];
    let mut p1 = 0;
    {
        let (mut cx, mut cy) = (sx, sy);
        let mut dir = 0;
        let mut prev_key = (((cx << 8) + cy) << 2) as usize + dir;
        while in_bound(cx, cy) {
            let k = ((cx << 8) + cy) as usize;
            if !seen[k] {
                p1 += 1;
            }
            seen[k] = true;
            let pdir = dir;
            let (nx, ny) = {
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
            if dir != pdir {
                let nk = ((((nx - DX[dir]) << 8) + ny - DY[dir]) << 2) as usize + dir;
                corners[prev_key] = nk + 1;
                prev_key = nk;
            }
            (cx, cy) = (nx, ny);
        }
    };
    let mut p2 = 0;
    let mut seen2: [u16; 133643] = [0; 133643];
    let mut seen2_val: u16 = 1;
    for oy in 0..h {
        for ox in 0..w {
            if !seen[((ox << 8) + oy) as usize] {
                continue;
            }
            let (mut cx, mut cy) = (sx, sy);
            let mut dir = 0;
            while in_bound(cx, cy) {
                let k = (((cx << 8) + cy) << 2) as usize + dir;
                if seen2[k] == seen2_val {
                    p2 += 1;
                    break;
                }
                seen2[k] = seen2_val;
                let (mut nx, mut ny, mut ndir) = (cx + DX[dir], cy + DY[dir], dir);
                let mut jump = corners[k];
                if jump != 0 && cx != ox && cy != oy {
                    jump -= 1;
                    (nx, ny, ndir) = ((jump >> 10) as i32, ((jump >> 2) & 0xff) as i32, jump & 3);
                } else {
                    if get(nx, ny) == b'#' || (nx == ox && ny == oy) {
                        ndir = (ndir + 1) & 3;
                        (nx, ny) = (cx, cy);
                    }
                }
                (cx, cy, dir) = (nx, ny, ndir);
            }
            seen2_val += 1;
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
