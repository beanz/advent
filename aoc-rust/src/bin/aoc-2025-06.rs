fn parts(inp: &[u8]) -> (usize, usize) {
    let w: usize = inp.iter().position(|&ch| ch == b'\n').unwrap() + 1;
    let h = inp.len() / w;
    let mut p2: usize = 0;
    let mut nums: [usize; 5] = [0; 5];
    let mut nums_len: usize = 0;
    let mut i: usize = w - 2;
    loop {
        let mut n: usize = 0;
        for y in 0..h - 1 {
            if inp[i + y * w] == b' ' {
                continue;
            }
            n = 10 * n + (inp[i + y * w] - b'0') as usize;
        }
        if n == 0 {
            p2 += apply(inp[i + 1 + (h - 1) * w], &nums[0..nums_len]);
            nums_len = 0;
        } else {
            nums[nums_len] = n;
            nums_len += 1;
        }
        if i == 0 {
            break;
        }
        i -= 1;
    }
    i = (h - 1) * w;
    p2 += apply(inp[i], &nums[0..nums_len]);

    let mut p1: usize = 0;
    let mut lines: [usize; 5] = [0, w, 2 * w, 3 * w, 4 * w];
    while i < inp.len() - 1 {
        let op = inp[i];
        i = skip(inp, i + 1);
        nums_len = 0;
        for y in 0..h - 1 {
            lines[y] = skip(inp, lines[y]);
            let (j, n) = aoc::read::uint::<usize>(inp, lines[y]);
            lines[y] = j + 1;
            nums[nums_len] = n;
            nums_len += 1;
        }
        p1 += apply(op, &nums[0..nums_len]);
    }
    (p1, p2)
}

fn skip(inp: &[u8], i: usize) -> usize {
    let mut i = i;
    while i < inp.len() && inp[i] == b' ' {
        i += 1;
    }
    i
}

fn apply(op: u8, nums: &[usize]) -> usize {
    if op == b'+' {
        let mut s: usize = 0;
        for e in nums {
            s += e;
        }
        return s;
    }
    let mut s: usize = 1;
    for e in nums {
        s *= e;
    }
    s
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
        aoc::test::auto("../2025/06/", parts);
    }
}
