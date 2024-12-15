use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut ci = 0;
    let mut w: Option<usize> = None;
    let mut start = 0;
    let mut m1: [u8; 3000] = [0; 3000];
    let mut m2: [u8; 6000] = [0; 6000];
    let mut m2i = 0;
    while ci < inp.len() && !(inp[ci] == b'\n' && inp[ci + 1] == b'\n') {
        match inp[ci] {
            b'\n' => {
                if w.is_none() {
                    w = Some(ci);
                }
                m2[m2i] = b'\n';
                m2i += 1;
            }
            b'@' => {
                start = ci;
                m2[m2i] = b'.';
                m2i += 1;
                m2[m2i] = b'.';
                m2i += 1;
            }
            b'O' => {
                m2[m2i] = b'[';
                m2i += 1;
                m2[m2i] = b']';
                m2i += 1;
            }
            b'#' => {
                m2[m2i] = b'#';
                m2i += 1;
                m2[m2i] = b'#';
                m2i += 1;
            }
            _ => {
                m2[m2i] = b'.';
                m2i += 1;
                m2[m2i] = b'.';
                m2i += 1;
            }
        }

        ci += 1;
    }
    m1[0..ci].copy_from_slice(&inp[0..ci]);
    let moves = &inp[ci + 2..];
    let w = w.unwrap() + 1;
    let start: (usize, usize) = (start % w, start / w);
    let p1 = robot(&mut m1[0..ci], w, start, moves, false);
    let w = w * 2 - 1;
    (
        p1,
        robot(&mut m2[0..m2i], w, (start.0 * 2, start.1), moves, true),
    )
}

fn robot(map: &mut [u8], w: usize, start: (usize, usize), moves: &[u8], part2: bool) -> usize {
    let h = ((map.len() + 1) / w) as i32;
    let w = w as i32;
    let (mut rx, mut ry) = (start.0 as i32, start.1 as i32);
    //println!("{}x{} start={},{}", w, h, rx, ry);
    map[(rx + ry * w) as usize] = b'.';
    let mut boxes = SmallVec::<[(i32, i32, u8); 1024]>::new();
    let mut check = SmallVec::<[(i32, i32); 128]>::new();
    let mut ncheck = SmallVec::<[(i32, i32); 128]>::new();
    for m in moves {
        if *m == b'\n' {
            continue;
        }
        //pp(map, rx as usize, ry as usize, w as usize, h as usize);
        let (dx, dy) = match *m {
            b'^' => (0, -1),
            b'>' => (1, 0),
            b'v' => (0, 1),
            _ => (-1, 0),
        };
        let (nx, ny) = (rx + dx, ry + dy);
        let ch = map[(nx + ny * w) as usize];
        if ch == b'#' {
            continue;
        }
        if ch == b'.' {
            (rx, ry) = (nx, ny);
            continue;
        }
        let mut can_move = true;
        if part2 && dx == 0 {
            check.push((rx, ry));
            ncheck.clear();
            while !check.is_empty() {
                for c in &check {
                    let (cx, cy) = (c.0, c.1 + dy);
                    let ch = map[(cx + cy * w) as usize];
                    if ch == b'#' {
                        can_move = false;
                        break;
                    } else if ch == b'[' {
                        ncheck.push((cx, cy));
                        boxes.push((cx, cy, ch));
                        ncheck.push((cx + 1, cy));
                        boxes.push((cx + 1, cy, b']'));
                    } else if ch == b']' {
                        ncheck.push((cx, cy));
                        boxes.push((cx, cy, ch));
                        ncheck.push((cx - 1, cy));
                        boxes.push((cx - 1, cy, b'['));
                    }
                }
                check.clear();
                (check, ncheck) = (ncheck, check);
            }
        } else {
            let (mut tx, mut ty) = (nx, ny);
            loop {
                let ch = map[(tx + ty * w) as usize];
                if ch == b'#' {
                    can_move = false;
                    break;
                }
                if ch == b'.' {
                    break;
                }
                boxes.push((tx, ty, ch));
                (tx, ty) = (tx + dx, ty + dy);
            }
        }
        if !can_move {
            boxes.clear();
            continue;
        }
        for b in boxes.clone() {
            map[(b.0 + w * b.1) as usize] = b'.';
        }
        for b in boxes.clone() {
            map[((b.0 + dx) + w * (b.1 + dy)) as usize] = b.2;
        }
        boxes.clear();
        (rx, ry) = (nx, ny);
    }
    //pp(map, rx as usize, ry as usize, w as usize, h as usize);
    score(map, w as usize, h as usize)
}

fn pp(map: &[u8], rx: usize, ry: usize, w: usize, h: usize) {
    for y in 0..h {
        for x in 0..w - 1 {
            if x == rx && y == ry {
                print!("@");
            } else {
                let ch = map[x + y * w];
                if ch == b'@' {
                    print!(".");
                } else {
                    print!("{}", ch as char);
                }
            }
        }
        println!();
    }
}

fn score(map: &[u8], w: usize, h: usize) -> usize {
    let mut score = 0;
    for y in 0..h {
        for x in 0..w - 1 {
            if map[x + y * w] == b'O' || map[x + y * w] == b'[' {
                score += x + y * 100;
            }
        }
    }
    score
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
        aoc::test::auto("../2024/15/", parts);
    }
}
