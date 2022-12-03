fn triple_digit(sum: &[u8]) -> Option<u8> {
    for i in 0..sum.len() - 1 {
        if (sum[i] >> 4) == (sum[i] & 0xf) && (sum[i] >> 4) == (sum[i + 1] >> 4) {
            return Some(sum[i] >> 4);
        }
        if (sum[i] & 0xf) == (sum[i + 1] >> 4) && (sum[i] & 0xf) == (sum[i + 1] & 0xf) {
            return Some(sum[i] & 0xf);
        }
    }
    None
}

fn has_five(sum: &[u8], d: u8) -> bool {
    let d0 = d << 4;
    let dd = d | d0;
    for i in 0..sum.len() - 2 {
        if sum[i + 1] != dd {
            continue;
        }
        if sum[i] == dd && sum[i + 2] & 0xf0 == d0 {
            return true;
        }
        if sum[i] & 0xf == d && sum[i + 2] == dd {
            return true;
        }
    }
    false
}

struct OTP<'a> {
    salt: &'a [u8],
}
impl<'a> OTP<'a> {
    fn new(inp: &[u8]) -> OTP {
        OTP {
            salt: &inp[0..inp.len() - 1],
        }
    }
    fn find_key(&self, num: usize, stretched: bool) -> usize {
        let mut ring: [[u8; 16]; 1001] = [[0; 16]; 1001];
        let salt = std::str::from_utf8(self.salt).expect("ascii").into();
        let mut num_str = aoc::NumStr::new(salt);
        let next_md5 = if !stretched {
            |ns: &mut aoc::NumStr| {
                let b = ns.bytes();
                let r = aoc::md5sum2(b);
                ns.inc();
                r
            }
        } else {
            |ns: &mut aoc::NumStr| {
                const DIGITS: &[u8; 16] = b"0123456789abcdef";
                let b = ns.bytes();
                let mut r = aoc::md5sum2(b);
                let mut n: [u8; 32] = [0; 32];
                for _ in 0..2016 {
                    for j in 0..16 {
                        n[j * 2] = DIGITS[(r[j] >> 4) as usize];
                        n[1 + j * 2] = DIGITS[(r[j] & 0xf) as usize];
                    }
                    r = aoc::md5sum2(&n);
                }
                ns.inc();
                r
            }
        };
        for i in 0..1001 {
            ring[i] = next_md5(&mut num_str);
        }
        let mut ring_i = 0;
        let mut n = 1;
        loop {
            let ti = ring_i;
            let sum = ring[ti % 1001];
            ring[ti % 1001] = next_md5(&mut num_str);
            ring_i += 1;
            if let Some(ch) = triple_digit(&sum) {
                for i in 1..1001 {
                    if has_five(&ring[(ti + i) % 1001], ch) {
                        if n == num {
                            return ti;
                        }
                        n += 1;
                    }
                }
            }
        }
    }
    fn parts(&self) -> (usize, usize) {
        (self.find_key(64, false), self.find_key(64, true))
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let otp = OTP::new(&inp);
        let (p1, p2) = otp.parts();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    pub fn decode_hex(s: &str) -> Vec<u8> {
        (0..s.len())
            .step_by(2)
            .map(|i| u8::from_str_radix(&s[i..i + 2], 16).expect("hex"))
            .collect()
    }
    #[test]
    fn triple_digit_works() {
        let t = decode_hex("01234567890123456789012345678901");
        assert_eq!(triple_digit(&t), None);
        let t = decode_hex("0034e0923cc38887a57bd7b1d4f953df");
        assert_eq!(triple_digit(&t), Some(0x8));
        let t = decode_hex("347dac6ee8eeea4652c7476d0f97bee5");
        assert_eq!(triple_digit(&t), Some(0xe));
        let t = decode_hex("01234567890123456789012345678999");
        assert_eq!(triple_digit(&t), Some(0x9));
        let t = decode_hex("01234567890123456789012345678881");
        assert_eq!(triple_digit(&t), Some(0x8));
        let t = decode_hex("00034567890123456789012345678901");
        assert_eq!(triple_digit(&t), Some(0x0));
        let t = decode_hex("01114567890123456789012345678901");
        assert_eq!(triple_digit(&t), Some(0x1));
    }
    #[test]
    fn has_five_works() {
        let t = decode_hex("aaaa4567890123456789012345678901");
        assert!(!has_five(&t, 0xa));
        let t = decode_hex("aaaaa567890123456789012345678901");
        assert!(has_five(&t, 0xa));
        let t = decode_hex("c3d313e7a72ea2111114dd4963979596");
        assert!(has_five(&t, 0x1));
    }
}
