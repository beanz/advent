use std::collections::VecDeque;

fn part1(l: &str) -> (usize, Vec<bool>) {
    let mut grid: Vec<bool> = vec![false; 128 * 128];
    let mut c = 0;
    for y in 0..128 {
        let seed = format!("{}-{}", l, y);
        let r = aoc::Rope::new_twisted(256, &seed);
        let row = r.map_hash();
        for (x, ch) in row.chars().enumerate() {
            if ch == '1' {
                c += 1;
                grid[x + 128 * y] = true;
            }
        }
    }
    (c, grid)
}

fn connected(p: (usize, usize), grid: &mut [bool]) {
    let mut todo: VecDeque<(usize, usize)> = VecDeque::new();
    todo.push_front(p);
    while !todo.is_empty() {
        let (x, y) = todo.pop_front().unwrap();
        grid[x + 128 * y] = false;
        let mut nb: Vec<(usize, usize)> = vec![];
        if y > 0 {
            nb.push((x, y - 1));
        }
        if y < 127 {
            nb.push((x, y + 1));
        }
        if x > 0 {
            nb.push((x - 1, y));
        }
        if x < 127 {
            nb.push((x + 1, y));
        }
        for (nx, ny) in nb {
            if !grid[nx + 128 * ny] {
                continue;
            }
            todo.push_back((nx, ny));
        }
    }
}

fn part2(grid: &mut [bool]) -> usize {
    let mut c = 0;
    for y in 0..128 {
        for x in 0..128 {
            if !grid[x + 128 * y] {
                continue;
            }
            connected((x, y), grid);
            c += 1;
        }
    }
    c
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let (p1, mut grid) = part1(&inp);
        let p2 = part2(&mut grid);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_work() {
        let (p1, mut grid) = part1("flqrgnkx");
        assert_eq!(p1, 8108, "part 1 example");
        assert_eq!(part2(&mut grid), 1242, "part 2 example");
    }
}
