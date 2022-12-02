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
        loop {
            let cs = aoc::md5sum(self.ns.bytes());
            if cs[0] == 0 && cs[1] == 0 && (cs[2] & 0xf0 == 0) {
                self.ns.inc();
                return cs.iter().map(|x| format!("{:02x}", x)).collect::<String>();
            }
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
    aoc::benchme(|bench: bool| {
        let mut gen = Gen::new(&inp);
        let p1 = gen.password();
        if !bench {
            println!("Part 1: {}", p1);
        }
        gen = Gen::new(&inp);
        let p2 = gen.strong_password();
        if !bench {
            println!("Part 2: {}", p2);
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn gen_works() {
        let mut gen = Gen::new(&"abc".to_string());
        for _ in 1..3231920 {
            // hack to make test faster
            gen.ns.inc();
        }
        assert_eq!(gen.next(), "00000155f8105dff7f56ee10fa9b9abd");
    }
}
