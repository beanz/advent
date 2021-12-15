fn calc(jumps: &mut [isize], part2: bool) -> usize {
    let mut c = 0;
    let mut i: isize = 0;
    let len = jumps.len() as isize;
    while 0 <= i && i < len {
        let offset = jumps[i as usize];
        let n = i + offset;
        jumps[i as usize] += if part2 && offset >= 3 { -1 } else { 1 };
        i = n;
        c += 1;
    }
    c
}

#[test]
fn calc_works() {
    assert_eq!(calc(&mut [0, 3, 0, 1, -3], false), 5, "part 1 example");
    assert_eq!(calc(&mut [0, 3, 0, 1, -3], true), 10, "part 2 example");
}

fn main() {
    let inp = aoc::slurp_input_file();
    aoc::benchme(|bench: bool| {
        let mut jumps = aoc::ints::<isize>(&inp).collect::<Vec<isize>>();
        let p1 = calc(&mut jumps.clone(), false);
        let p2 = calc(&mut jumps, true);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
