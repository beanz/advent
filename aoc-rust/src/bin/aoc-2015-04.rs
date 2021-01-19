extern crate crypto;

use crypto::digest::Digest;
use crypto::md5::Md5;

pub fn calc(l: String) -> (usize, usize) {
    let mut md5 = Md5::new();
    let mut p1: usize = 0;
    let mut num_str = aoc::NumStr::new(l);
    let mut i = 0;
    loop {
        md5.input(num_str.bytes());
        let mut cs = [0; 16];
        md5.result(&mut cs);
        if cs[0] == 0 && cs[1] == 0 && (cs[2] & 0xf0 == 0) {
            if p1 == 0 {
                p1 = i;
            }
            if cs[2] == 0 {
                break;
            }
        }
        md5.reset();
        num_str.inc();
        i += 1;
    }
    (p1, i)
}

fn main() {
    let inp = aoc::read_input_line();
    let (p1, p2) = calc(inp);
    println!("Part 1: {}", p1);
    println!("Part 2: {}", p2);
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
        assert_eq!(calc(inp.to_string()), exp, "{}", inp);
    }
}
