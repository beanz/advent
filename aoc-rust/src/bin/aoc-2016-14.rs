use crypto::digest::Digest;
use crypto::md5::Md5;

struct Md5er {
    ns: aoc::NumStr,
    md5: Md5,
}

struct Md5erResult {
    cs: Box<[u8; 16]>,
}

impl Md5erResult {
    fn new(cs: [u8; 16]) -> Md5erResult {
        Md5erResult { cs: Box::new(cs) }
    }
    fn string(&self) -> String {
        self.cs
            .iter()
            .map(|x| format!("{:02x}", x))
            .collect::<String>()
    }
}

impl Md5er {
    fn new(s: &String) -> Md5er {
        Md5er {
            ns: aoc::NumStr::new(s.to_string()),
            md5: Md5::new(),
        }
    }
}

impl Iterator for Md5er {
    type Item = Md5erResult;

    fn next(&mut self) -> Option<Self::Item> {
        self.md5.input(self.ns.bytes());
        let mut cs = [0; 16];
        self.md5.result(&mut cs);
        self.md5.reset();
        self.ns.inc();
        Some(Md5erResult::new(cs))
    }
}

#[test]
fn md5er_works() {
    let mut md5er = Md5er::new(&"abc".to_string());
    assert_eq!(
        md5er.next().unwrap().string(),
        "577571be4de9dcce85a041ba0410f29f"
    );
    let mut c = 0;
    for (i, md5) in md5er.enumerate() {
        println!(i, md5.string());
        c += 1;
        if c > 10 {
            break;
        }
    }
}

fn main() {
    let md5er = Md5er::new(&"abc".to_string());
    let mut c = 0;
    for (i, md5) in md5er.enumerate().filter(|(_, md5)| {
        md5.string()
            .bytes()
            .collect::<Vec<u8>>()
            .windows(3)
            .any(|c| c[0] == c[1] && c[1] == c[2])
    }) {
        println!("{:02}: {}", i, md5.string());
        c += 1;
        if c > 10 {
            break;
        }
    }
}
