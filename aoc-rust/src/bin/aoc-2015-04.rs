pub fn calc(l: &str) -> (usize, usize) {
    let mut p1: usize = 0;
    let mut num_str = aoc::NumStr::new(l.to_string());
    let mut i = 0;
    loop {
        let cs = aoc::md5sum(num_str.bytes());
        if cs[0] == 0 && cs[1] == 0 && (cs[2] & 0xf0 == 0) {
            if p1 == 0 {
                p1 = i;
            }
            if cs[2] == 0 {
                break;
            }
        }
        num_str.inc();
        i += 1;
    }
    (p1, i)
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let (p1, p2) = calc(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
#[cfg_attr(not(feature = "slow_tests"), ignore)]
fn calc_works() {
    for &(inp, exp) in [
        ("abcdef", (609043, 6742839)),
        ("pqrstuv", (1048970, 5714438)),
    ]
    .iter()
    {
        assert_eq!(calc(&inp.to_string()), exp, "{}", inp);
    }
}
