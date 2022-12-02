fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut i = 0;
    while i < inp.len() {
        let a = (inp[i] - b'A') as isize;
        let b = (inp[i + 2] - b'X') as isize;
        p1 += b + 1 + 3 * ((4 + b - a) % 3);
        p2 += 3 * b + 1 + (a + b + 2) % 3;
        i += 4;
    }
    (p1 as usize, p2 as usize)
}

#[test]
fn parts_works() {
    let inp = std::fs::read("../2022/02/test1.txt").expect("read error");
    assert_eq!(parts(&inp), (15, 12));
    let inp = std::fs::read("../2022/02/input.txt").expect("read error");
    assert_eq!(parts(&inp), (9651, 10560));
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
