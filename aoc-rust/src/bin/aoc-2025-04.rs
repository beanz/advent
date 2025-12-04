use heapless::Vec;

const NEIGHBOURS: [[isize; 2]; 8] = [
    [-1, -1],
    [0, -1],
    [1, -1],
    [-1, 0],
    [1, 0],
    [-1, 1],
    [0, 1],
    [1, 1],
];

fn parts(inp: &[u8]) -> (usize, usize) {
    let w: usize = inp.iter().position(|&ch| ch == b'\n').unwrap() + 1;
    let h: usize = inp.len() / w;
    let mut p1: usize = 0;
    let mut p2: usize = 0;
    let mut grid: [u8; 20480] = [0; 20480];
    let mut rolls = Vec::<usize, 16384>::new();
    for y in 0..h {
        for x in 0..w {
            let i: usize = x + y * w;
            let gi: usize = x + 1 + (y + 1) * (w + 2);
            if inp[i] != b'@' {
                grid[gi] = 0;
                continue;
            }
            let mut c = 0;
            for o in NEIGHBOURS {
                let (nx, ny) = (x as isize + o[0], y as isize + o[1]);
                if nx < 0 || ny < 0 {
                    continue;
                }
                let (nx, ny) = (nx as usize, ny as usize);
                if nx >= w || ny >= h {
                    continue;
                }
                if inp[nx + ny * w] == b'@' {
                    c += 1;
                }
            }
            if c < 4 {
                grid[gi] = 0;
                p1 += 1;
                if c == 0 {
                    p2 += 1;
                }
            }
            if c != 0 {
                grid[gi] = c;
                rolls.push(gi).expect("overflow");
            }
        }
    }
    let gw = (w + 2) as isize;
    let neighbours: [isize; 8] = [-1 - gw, -gw, 1 - gw, -1, 1, gw - 1, gw, gw + 1];
    while rolls.len() > 0 {
        let mut done = true;
        let mut j = 0;
        while j < rolls.len() {
            let i = rolls[j];
            let c = grid[i];
            if c >= 4 {
                j += 1;
                continue;
            }
            rolls.swap_remove(j);
            p2 += 1;
            done = false;
            grid[i] = 0;
            for o in neighbours {
                let ni = (i as isize + o) as usize;
                if grid[ni] > 1 {
                    grid[ni] -= 1;
                }
            }
        }
        if done {
            break;
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
        aoc::test::auto("../2025/04/", parts);
    }
}
