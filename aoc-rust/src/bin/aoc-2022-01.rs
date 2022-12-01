use arrayvec::ArrayVec;
fn parts(inp: &[u8]) -> (usize, usize) {
    let mut sums: ArrayVec<usize, 256> = ArrayVec::default();
    let mut s = 0;
    let mut n = 0;
    let mut eol = false;
    for ch in inp {
        match ch {
            b'\n' => {
                if eol {
                    sums.push(s);
                    s = 0;
                    eol = false;
                } else {
                    s += n;
                    n = 0;
                    eol = true;
                }
            }
            _ => {
                eol = false;
                n = 10 * n + (ch - b'0') as usize;
            }
        }
    }
    sums.sort_by_key(|e| std::cmp::Reverse(*e));
    (sums[0], sums[0] + sums[1] + sums[2])
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
