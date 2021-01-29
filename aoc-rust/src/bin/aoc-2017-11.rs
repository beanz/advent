fn calc(s: &str) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut hex = aoc::HexFlatTop::new(0, 0);
    const ORIGIN: &aoc::HexFlatTop = &aoc::HexFlatTop::origin();
    for m in s.split(',') {
        hex.mov(m);
        p1 = hex.distance(ORIGIN);
        if p1 > p2 {
            p2 = p1;
        }
    }
    (p1, p2)
}

#[test]
fn calc_works() {
    assert_eq!(calc("ne,ne,ne"), (3, 3));
    assert_eq!(calc("ne,ne,sw,sw"), (0, 2));
    assert_eq!(calc("ne,ne,s,s"), (2, 2));
    assert_eq!(calc("se,sw,se,sw,sw"), (3, 3));
}

fn main() {
    let inp = aoc::read_input_line();
    let (p1, p2) = calc(&inp);
    println!("Part 1: {}", p1);
    println!("Part 2: {}", p2);
}
