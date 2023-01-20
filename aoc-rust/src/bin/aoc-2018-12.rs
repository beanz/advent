const GEN_SIZE: usize = 800;
fn parts(inp: &[u8]) -> (isize, isize) {
    let mut i = aoc::read::skip_next_line(inp, 0);
    let init = &inp[15..i - 1];
    //eprintln!("{}", std::str::from_utf8(init).expect("ascii"));
    i += 1;
    let mut rules = [false; 32];
    while i < inp.len() {
        if inp[i + 9] == b'#' {
            let v: usize = (usize::from(inp[i] == b'#') << 4)
                + (usize::from(inp[i + 1] == b'#') << 3)
                + (usize::from(inp[i + 2] == b'#') << 2)
                + (usize::from(inp[i + 3] == b'#') << 1)
                + (usize::from(inp[i + 4] == b'#'));
            rules[v] = true;
        }
        i += 11;
    }
    //eprintln!("{:?}", rules);
    let mut gen = [b'.'; GEN_SIZE];
    let mut len = init.len();
    let mut offset = 0;
    gen[..init.len()].copy_from_slice(&init);
    let mut g = 0;
    let mut p1 = 0;
    let mut p2 = 0;
    let mut prev_diff = 0;
    let mut prev_score = score(init, 0);
    while g < 200 {
        let mut state = 0;
        for i in 0..len + 4 {
            state = ((state << 1) & 0x1f) + usize::from(gen[i] == b'#');
            gen[i] = if rules[state] { b'#' } else { b'.' };
        }
        offset += 2;
        len += 4;
        g += 1;
        let sc = score(&gen, offset);
        let diff = sc - prev_score;
        if prev_diff == diff && g > 100 {
            //eprintln!("cycle found {} ++ {} @ {}", sc, diff, g);
            let rem = 50000000000 - g;
            p2 = sc + diff * rem;
            break;
        }
        prev_score = sc;
        prev_diff = diff;
        //eprintln!(
        //    "{}: {} {}",
        //    g,
        //    sc,
        //    std::str::from_utf8(&gen[0..len]).expect("ascii"),
        //);
        if g == 20 {
            p1 = sc;
        }
    }
    (p1, p2)
}

fn score(pots: &[u8], offset: usize) -> isize {
    let mut s = 0;
    for (i, p) in pots.iter().enumerate() {
        //if *p == b'#' {
        //    eprintln!("sc: {}", (i as isize - offset as isize));
        //}
        s += (i as isize - offset as isize) * isize::from(*p == b'#');
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
        let inp = std::fs::read("../2018/12/test.txt").expect("read error");
        assert_eq!(parts(&inp), (325, 999999999374));
        let inp = std::fs::read("../2018/12/input.txt").expect("read error");
        assert_eq!(parts(&inp), (2049, 2300000000006));
        let inp = std::fs::read("../2018/12/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (1623, 1600000000401));
    }
}
