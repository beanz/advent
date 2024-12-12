const DX: [i32; 4] = [0, 1, 0, -1];
const DY: [i32; 4] = [-1, 0, 1, 0];

fn parts(inp: &[u8]) -> (usize, usize) {
    let w = inp.iter().position(|&ch| ch == b'\n').expect("no newline");
    let h = inp.len() / (w + 1);
    let w1 = w + 1;
    let w = w as i32;
    let h = h as i32;
    let get = |x, y| -> u8 {
        if 0 <= x && x < w && 0 <= y && y < h {
            inp[(x as usize) + (y as usize) * w1]
        } else {
            128
        }
    };
    let mut seen = [false; 20480];
    let (mut p1, mut p2) = (0, 0);
    for y in 0..h {
        for x in 0..w {
            if seen[(x + y * w) as usize] {
                continue;
            }
            let ch = get(x, y);
            let (mut area, mut perimeter, mut sides) = (0, 0, 0);
            let mut todo = aoc::deque::Deque::<(i32, i32), 512>::default();
            todo.push((x, y));
            while let Some((x, y)) = todo.pop() {
                if seen[(x + y * w) as usize] {
                    continue;
                }
                seen[(x + y * w) as usize] = true;
                area += 1;
                for dir in 0..=3 {
                    let (nx, ny) = (x + DX[dir], y + DY[dir]);
                    if get(nx, ny) == ch {
                        todo.push((nx, ny));
                        continue;
                    }
                    perimeter += 1;
                    if get(nx - DY[dir], ny - DX[dir]) == ch
                        || get(nx - DX[dir] - DY[dir], ny - DY[dir] - DX[dir]) != ch
                    {
                        sides += 1;
                    }
                }
            }
            p1 += area * perimeter;
            p2 += area * sides;
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
        aoc::test::auto("../2024/12/", parts);
    }
}
