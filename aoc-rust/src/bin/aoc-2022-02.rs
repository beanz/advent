fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let s1 = [4, 8, 3, 0, 1, 5, 9, 0, 7, 2, 6];
    let s2 = [3, 4, 8, 0, 1, 5, 9, 0, 2, 6, 7];
    for i in (0..inp.len()).step_by(4) {
        let j = (((inp[i] - b'A') as usize) << 2) + (inp[i + 2] - b'X') as usize;
        p1 += s1[j];
        p2 += s2[j];
    }
    (p1, p2)
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
