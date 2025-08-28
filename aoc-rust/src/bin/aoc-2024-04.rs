fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let w = inp.iter().position(|&ch| ch == b'\n').expect("no newline") + 1;
    let mut i = 0;
    while i + w * 3 < inp.len() {
        match inp[i] {
            b'X' => {
                if inp[i + w] == b'M' && inp[i + w * 2] == b'A' && inp[i + w * 3] == b'S' {
                    p1 += 1;
                }
            }
            b'S' => {
                if inp[i] == b'S'
                    && inp[i + w] == b'A'
                    && inp[i + w * 2] == b'M'
                    && inp[i + w * 3] == b'X'
                {
                    p1 += 1;
                }
            }
            _ => {}
        }
        i += 1;
    }
    i = 0;
    while i + 3 < inp.len() {
        match inp[i] {
            b'X' => {
                if inp[i + 3] == b'S' && inp[i + 2] == b'A' && inp[i + 1] == b'M' {
                    p1 += 1;
                }
            }
            b'S' => {
                if inp[i + 3] == b'X' && inp[i + 2] == b'M' && inp[i + 1] == b'A' {
                    p1 += 1;
                }
            }
            _ => {}
        }
        i += 1;
    }
    i = 0;
    while i + 3 + w * 3 < inp.len() {
        match inp[i] {
            b'X' => {
                if inp[i + 3 + 3 * w] == b'S'
                    && inp[i + 1 + w] == b'M'
                    && inp[i + 2 + 2 * w] == b'A'
                {
                    p1 += 1;
                }
            }
            b'S' => {
                if inp[i + 3 + 3 * w] == b'X'
                    && inp[i + 1 + w] == b'A'
                    && inp[i + 2 + 2 * w] == b'M'
                {
                    p1 += 1;
                }
            }
            _ => {}
        }
        i += 1;
    }
    i = 0;
    while i + w * 3 - 3 < inp.len() {
        match inp[i] {
            b'X' => {
                if inp[i + 3 * w - 3] == b'S'
                    && inp[i + w - 1] == b'M'
                    && inp[i + 2 * w - 2] == b'A'
                {
                    p1 += 1;
                }
            }
            b'S' => {
                if inp[i + 3 * w - 3] == b'X'
                    && inp[i + w - 1] == b'A'
                    && inp[i + 2 * w - 2] == b'M'
                {
                    p1 += 1;
                }
            }
            _ => {}
        }
        i += 1;
    }
    i = 0;
    while i + 2 + 2 * w < inp.len() {
        if inp[i + 1 + w] != b'A' {
            i += 1;
            continue;
        }
        if (inp[i] == b'M' && inp[i + 2 + 2 * w] == b'S'
            || inp[i] == b'S' && inp[i + 2 + 2 * w] == b'M')
            && (inp[i + 2] == b'M' && inp[i + 2 * w] == b'S'
                || inp[i + 2] == b'S' && inp[i + 2 * w] == b'M')
        {
            p2 += 1;
        }
        i += 1;
    }
    (p1, p2)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/04/", parts);
    }
}
