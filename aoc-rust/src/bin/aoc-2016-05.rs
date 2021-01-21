extern crate crypto;

use crypto::digest::Digest;
use crypto::md5::Md5;

struct Gen {
    ns: aoc::NumStr,
}

impl Gen {
    fn new(s: &str) -> Gen {
        Gen {
            ns: aoc::NumStr::new(s.to_string()),
        }
    }
    fn next(&mut self) -> String {
        let mut md5 = Md5::new();
        loop {
            md5.input(self.ns.bytes());
            let mut cs = [0; 16];
            md5.result(&mut cs);
            if cs[0] == 0 && cs[1] == 0 && (cs[2] & 0xf0 == 0) {
                self.ns.inc();
                return cs
                    .iter()
                    .map(|x| format!("{:02x}", x))
                    .collect::<String>();
            }
            md5.reset();
            self.ns.inc();
        }
    }
    fn password(&mut self) -> String {
        [0, 1, 2, 3, 4, 5, 6, 7]
            .iter()
            .map(|_| self.next().chars().nth(5).unwrap())
            .collect::<String>()
    }
    fn strong_password(&mut self) -> String {
        let mut pass = vec!['_', '_', '_', '_', '_', '_', '_', '_'];
        let mut filled = 0;
        while filled < 8 {
            let n = self.next();
            let mut p1 = n.bytes();
            let i = (p1.nth(5).unwrap() - b'0') as usize;
            if i < 8 && pass[i] == '_' {
                pass[i] = p1.next().unwrap() as char;
                filled += 1;
            }
        }
        pass.iter().collect::<String>()
    }
}

fn main() {
    let inp = aoc::read_input_line();
    let mut gen = Gen::new(&inp);
    println!("Part 1: {}", gen.password());
    gen = Gen::new(&inp);
    println!("Part 2: {}", gen.strong_password());
}

#[test]
fn gen_works() {
    let mut gen = Gen::new(&"abc".to_string());
    for _ in 1..3231920 {
        // hack to make test faster
        gen.ns.inc();
    }
    assert_eq!(gen.next(), "00000155f8105dff7f56ee10fa9b9abd");
}
