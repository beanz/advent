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

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2: Vec<usize> = vec![];
    let mut st: Vec<u8> = vec![];
    let mut i = 0;
    while i < inp.len() {
        match inp[i] {
            b'(' | b'[' | b'{' | b'<' => {
                let rch = {
                    if inp[i] == b'(' {
                        b')'
                    } else {
                        inp[i] + 2
                    }
                };
                st.push(rch);
            }
            b'\n' => {
                let mut s = 0;
                let mut j = st.len() - 1;
                loop {
                    s = s * 5 + score2(st[j]);
                    if j == 0 {
                        break;
                    }
                    j -= 1;
                }
                p2.push(s);
                st = vec![];
            }
            _ => {
                let expected = st.pop().expect("empty stack");
                if inp[i] != expected {
                    p1 += score1(inp[i]);
                    while inp[i] != b'\n' {
                        i += 1;
                    }
                    st = vec![];
                    i += 1;
                    continue;
                }
            }
        }
        i += 1;
    }
    p2.sort();
    (p1, p2[p2.len() / 2])
}

fn score1(b: u8) -> usize {
    match b {
        b')' => 3,
        b']' => 57,
        b'}' => 1197,
        b'>' => 25137,
        _ => panic!("bad score 1"),
    }
}

fn score2(b: u8) -> usize {
    match b {
        b')' => 1,
        b']' => 2,
        b'}' => 3,
        b'>' => 4,
        _ => panic!("bad score 2"),
    }
}
