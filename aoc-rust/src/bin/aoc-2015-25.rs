use mod_exp::mod_exp;

fn sum_series(r: std::ops::RangeInclusive<isize>) -> isize {
    (1 + r.end() - r.start()) * (r.start() + r.end()) / 2
}

#[test]
fn sum_series_works() {
    assert_eq!(sum_series(1..=10), 55, "sum series 1 .. 10");
    assert_eq!(sum_series(3..=10), 52, "sum series 3 .. 10");
}

fn pos_index(x: usize, y: usize) -> usize {
    (y * (x - 1))
        + sum_series(1..=x as isize - 2) as usize
        + sum_series(1..=y as isize) as usize
}

#[test]
fn pos_index_works() {
    assert_eq!(pos_index(1, 1), 1, "pos_index 1, 1");
    assert_eq!(pos_index(2, 1), 2, "pos_index 1, 2");
    assert_eq!(pos_index(1, 2), 3, "pos_index 2, 1");
    assert_eq!(pos_index(4, 2), 12, "pos_index 2, 4");
    assert_eq!(pos_index(1, 6), 21, "pos_index 6, 1");
    assert_eq!(pos_index(2, 4), 14, "pos_index 4, 2");
    assert_eq!(pos_index(2947, 3029), 17850354, "pos_index 2947, 3029");
}

fn seq(n: usize) -> usize {
    (mod_exp(252533, n - 1, 33554393) * 20151125) % 33554393
}

#[test]
fn seq_works() {
    assert_eq!(seq(1), 20151125, "seq 1");
    assert_eq!(seq(2), 31916031, "seq 2");
    assert_eq!(seq(3), 18749137, "seq 3");
    assert_eq!(seq(14), 7726640, "seq 14");
    assert_eq!(seq(17850354), 19980801, "seq input");
}

fn part1(row: usize, col: usize) -> usize {
    seq(pos_index(row, col))
}

fn main() {
    let inp = aoc::slurp_input_file();
    aoc::benchme(|bench: bool| {
        let rowcol = aoc::ints::<usize>(&inp).collect::<Vec<usize>>();
        let p1 = part1(rowcol[0], rowcol[1]);
        if !bench {
            println!("Part 1: {}", p1);
        }
    });
}
