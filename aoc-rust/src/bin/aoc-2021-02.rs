fn parts(inp: &[u8]) -> (isize, isize) {
    let mut x: isize = 0;
    let mut y: isize = 0;
    let mut x2: isize = 0;
    let mut a: isize = 0;
    let mut y2: isize = 0;
    let mut i = 0;
    while i < inp.len() {
        match inp[i] {
            b'f' => {
                let n = (inp[i + 8] - b'0') as isize;
                x += n;
                x2 += n;
                y2 += n * a;
                i += 10;
            }
            b'u' => {
                let n = (inp[i + 3] - b'0') as isize;
                y -= n;
                a -= n;
                i += 5;
            }
            b'd' => {
                let n = (inp[i + 5] - b'0') as isize;
                y += n;
                a += n;
                i += 7;
            }
            _ => (),
        }
    }
    (x * y, x2 * y2)
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
    let ex = std::fs::read("../2021/02/test1.txt").expect("read");
    let (p1, p2) = parts(&ex);
    assert_eq!(p1, 150, "part 1 test");
    assert_eq!(p2, 900, "part 2 test");
}
