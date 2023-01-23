use heapless::FnvIndexMap;

fn parts(inp: &[u8]) -> (usize, usize) {
    let w1 = aoc::read::skip_next_line(inp, 0);
    let h = inp.len() / w1;
    let w = w1 - 1;
    //eprintln!("{}x{}", w, h);
    let mut woods = [b'.'; 2560];
    woods[..inp.len()].copy_from_slice(&inp);
    let mut next = [b'.'; 2560];
    let (mut woods, mut next) = (&mut woods, &mut next);
    for _i in 0..10 {
        iter(woods, next, w, h);
        (woods, next) = (next, woods);
    }
    let (trees, yards) = counts(woods, w, h);
    let p1 = trees * yards;
    for _i in 10..300 {
        iter(woods, next, w, h);
        (woods, next) = (next, woods);
    }
    let mut visited = FnvIndexMap::<(usize, usize), usize, 512>::new();
    let mut i = 300;
    let iterations = 1000000000;
    let mut trees = 0;
    let mut yards = 0;
    while i < iterations {
        iter(woods, next, w, h);
        (woods, next) = (next, woods);
        i += 1;
        (trees, yards) = counts(woods, w, h);
        if let Some(prev_i) = visited.get(&(trees, yards)) {
            let cycle = i - prev_i;
            let remaining = iterations - i;
            let inc = cycle * (remaining / cycle);
            i += inc;
            visited.clear();
        } else {
            visited.insert((trees, yards), i).expect("visited full");
        }
    }
    (p1, trees * yards)
}

fn counts(woods: &mut [u8; 2560], w: usize, h: usize) -> (usize, usize) {
    let mut c_tree = 0;
    let mut c_lumber = 0;
    for y in 0..h {
        for x in 0..w {
            match woods[x + y * (w + 1)] {
                b'|' => c_tree += 1,
                b'#' => c_lumber += 1,
                _ => {}
            }
        }
    }
    (c_tree, c_lumber)
}

#[allow(dead_code)]
fn pretty(woods: &mut [u8], w: usize, h: usize) {
    for y in 0..h {
        for x in 0..w {
            eprint!("{}", woods[x + y * (w + 1)] as char);
        }
        eprintln!();
    }
}

fn neighbour_counts(woods: &mut [u8], x: usize, y: usize, w: usize, h: usize) -> (usize, usize) {
    let mut c_trees = 0;
    let mut c_lumber = 0;
    for ox in -1i32..=1 {
        let nx = x as i32 + ox;
        if nx < 0 || nx >= w as i32 {
            continue;
        }
        for oy in -1i32..=1 {
            let ny = y as i32 + oy;
            if ny < 0 || ny >= h as i32 {
                continue;
            }
            if ox == 0 && oy == 0 {
                continue;
            }
            match woods[nx as usize + (ny as usize) * (w + 1)] {
                b'|' => c_trees += 1,
                b'#' => c_lumber += 1,
                _ => {}
            }
        }
    }
    (c_trees, c_lumber)
}

fn iter(woods: &mut [u8; 2560], next: &mut [u8; 2560], w: usize, h: usize) {
    for y in 0..h {
        for x in 0..w {
            let (trees, lumber) = neighbour_counts(woods, x, y, w, h);
            let i = x + y * (w + 1);
            next[i] = match woods[i] {
                b'.' => {
                    if trees >= 3 {
                        b'|'
                    } else {
                        b'.'
                    }
                }
                b'|' => {
                    if lumber >= 3 {
                        b'#'
                    } else {
                        b'|'
                    }
                }
                _ => {
                    if trees >= 1 && lumber >= 1 {
                        b'#'
                    } else {
                        b'.'
                    }
                }
            };
        }
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
        let inp = std::fs::read("../2018/18/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (10, 20));
        let inp = std::fs::read("../2018/18/input.txt").expect("read error");
        assert_eq!(parts(&inp), (100, 200));
    }
}
