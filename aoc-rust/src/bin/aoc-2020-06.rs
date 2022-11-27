fn parts(inp: &[u8]) -> (u32, u32) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut bp1: u32 = 0;
    let mut bp2: u32 = 0;
    let mut bits: u32 = 0;
    let mut eol = false;
    let mut first = true;
    for ch in inp {
        match ch {
            b'\n' => {
                if eol {
                    eol = false;
                    p1 += bp1.count_ones();
                    bp1 = 0;
                    p2 += bp2.count_ones();
                    bp2 = 0;
                    first = true;
                } else {
                    eol = true;
                    if first {
                        bp1 = bits;
                        bp2 = bits;
                        first = false;
                    } else {
                        bp1 |= bits;
                        bp2 &= bits;
                    }
                    bits = 0;
                }
            }
            b'a'..=b'z' => {
                eol = false;
                bits |= 1 << (ch - b'a') as usize;
            }
            _ => unreachable!(),
        }
    }
    p1 += bp1.count_ones();
    p2 += bp2.count_ones();
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

#[test]
fn parts_works() {
    let inp = std::fs::read("../2020/06/test1.txt").expect("read error");
    let (p1, p2) = parts(&inp);
    assert_eq!(p1, 11, "part 1");
    assert_eq!(p2, 6, "part 2");
    let inp = std::fs::read("../2020/06/input.txt").expect("read error");
    let (p1, p2) = parts(&inp);
    assert_eq!(p1, 6506, "part 1");
    assert_eq!(p2, 3243, "part 2");
}
