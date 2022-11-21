use std::fmt;

struct Packet {
    b: Vec<u8>,
    ibit: usize,
}

impl Packet {
    fn new(inp: &Vec<u8>) -> Packet {
        let mut b: Vec<u8> = vec![];
        for i in (0..inp.len()).step_by(2) {
            let mut v: u8;
            match inp[i] {
                48..=57 => v = inp[i] - 48,
                65..=70 => v = inp[i] - 55,
                _ => break,
            }
            v <<= 4;
            match inp[i + 1] {
                48..=57 => v += inp[i + 1] - 48,
                65..=70 => v += inp[i + 1] - 55,
                _ => {}
            }
            b.push(v);
        }
        Packet { b, ibit: 0 }
    }
    fn num(&mut self, n: usize) -> usize {
        let mut v: usize = 0;
        let mut r = n;
        while r > 0 {
            let rb = 8 - (self.ibit % 8);
            let i = self.ibit / 8;
            if r <= rb {
                v <<= r;
                v += ((self.b[i] as usize) >> (rb - r)) & ((1 << r) - 1);
                self.ibit += r;
                r = 0;
            } else {
                //println!("v={} r={} rb={}", v, r, self.ibit);
                v <<= rb;
                v += (self.b[i] as usize) & ((1 << rb) - 1);
                r -= rb;
                self.ibit += rb;
            }
        }
        v
    }
    fn value(&self, kind: usize, args: Vec<usize>) -> usize {
        match kind {
            0 => args.iter().sum(),
            1 => args.iter().product(),
            2 => *args.iter().min().unwrap(),
            3 => *args.iter().max().unwrap(),
            5 => usize::from(args[0] > args[1]),
            6 => usize::from(args[0] < args[1]),
            7 => usize::from(args[0] == args[1]),
            _ => panic!("invalid op"),
        }
    }

    fn eval(&mut self) -> (usize, usize) {
        let ver = self.num(3);
        let kind = self.num(3);
        if kind == 4 {
            let mut n = 0;
            loop {
                let a = self.num(5);
                n = (n << 4) + (a & 0xf);
                if a <= 0xf {
                    break;
                }
            }
            //println!("V={} T={} N={}", ver, kind, n);
            return (ver, n);
        }
        let i = self.num(1);
        if i == 0 {
            // 15-bit
            let l = self.num(15);
            //println!("V={} T={} I={} L={}", ver, kind, i, l);
            let end = self.ibit + l;
            let mut vs = ver;
            let mut args: Vec<usize> = vec![];
            while self.ibit < end {
                let (v, n) = self.eval();
                vs += v;
                args.push(n);
            }
            return (vs, self.value(kind, args));
        }
        let l = self.num(11);
        //println!("V={} T={} I={} L={}", ver, kind, i, l);
        let mut vs = ver;
        let mut args: Vec<usize> = vec![];
        for _ in 0..l {
            let (v, n) = self.eval();
            vs += v;
            args.push(n);
        }
        (vs, self.value(kind, args))
    }
}

impl fmt::Display for Packet {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}",
            self.b
                .iter()
                .map(|b| format!("{:b}", b))
                .collect::<String>()
        )
    }
}

fn main() {
    let bytes = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let mut p = Packet::new(&bytes);
        let (p1, p2) = p.eval();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}

#[test]
fn num_works() {
    let test1a = "D2FE28".to_string().into_bytes();
    let mut p = Packet::new(&test1a);
    println!("{}", p);
    assert_eq!(p.num(3), 6, "num(3) == 6");
    assert_eq!(p.num(3), 4, "num(3) == 4");
    assert_eq!(p.num(5), 23, "num(5) == 23");
    assert_eq!(p.num(5), 30, "num(5) == 30");
    assert_eq!(p.num(5), 5, "num(5) == 5");
    let test1b = "38006F45291200".to_string().into_bytes();
    p = Packet::new(&test1b);
    assert_eq!(p.num(3), 1, "num(3) == 1");
    assert_eq!(p.num(3), 6, "num(3) == 6");
    assert_eq!(p.num(1), 0, "num(0) == 0");
    assert_eq!(p.num(15), 27, "num(15) == 27");
}
