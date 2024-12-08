fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let v = |i| {
        if i < inp.len() {
            inp[i]
        } else {
            b'!'
        }
    };
    let num = |i| {
        let mut i = i;
        let mut n = 0;
        let mut ch = v(i);
        while ch.is_ascii_digit() {
            n = 10 * n + ((ch - b'0') as usize);
            i += 1;
            ch = v(i);
        }
        (i, n)
    };
    let mut i = 0;
    let mut do_mul = 1;
    while i < inp.len() {
        match v(i) {
            b'd' => {
                i += 1;
                if v(i) != b'o' {
                    continue;
                }
                i += 1;
                match v(i) {
                    b'(' => {
                        i += 1;
                        if v(i) != b')' {
                            continue;
                        }
                        do_mul = 1;
                    }
                    b'n' => {
                        i += 1;
                        if v(i) != b'\'' {
                            continue;
                        }
                        i += 1;
                        if v(i) != b't' {
                            continue;
                        }
                        i += 1;
                        if v(i) != b'(' {
                            continue;
                        }
                        i += 1;
                        if v(i) != b')' {
                            continue;
                        }
                        do_mul = 0;
                    }
                    _ => continue,
                }
            }
            b'm' => {
                i += 1;
                if v(i) != b'u' {
                    continue;
                }
                i += 1;
                if v(i) != b'l' {
                    continue;
                }
                i += 1;
                if v(i) != b'(' {
                    continue;
                }
                i += 1;
                let (j, a) = num(i);
                i = j;
                if a == 0 {
                    continue;
                }
                if v(i) != b',' {
                    continue;
                }
                i += 1;
                let (j, b) = num(i);
                i = j;
                if b == 0 {
                    continue;
                }
                if v(i) != b')' {
                    continue;
                }
                i += 1;
                p1 += a * b;
                p2 += do_mul * a * b;
            }
            _ => i += 1,
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
        aoc::test::auto("../2024/03/", parts);
    }
}
