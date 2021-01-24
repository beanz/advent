use itertools::Itertools;

struct Md5erResult {
    cs: Box<[u8; 16]>,
}

impl Md5erResult {
    fn new(cs: Box<[u8; 16]>) -> Md5erResult {
        Md5erResult { cs }
    }
    fn string(&self) -> String {
        self.cs
            .iter()
            .map(|x| format!("{:02x}", x))
            .collect::<String>()
    }
}

struct Md5er {
    ns: aoc::NumStr,
}

impl Md5er {
    fn new(s: &str) -> Md5er {
        Md5er {
            ns: aoc::NumStr::new(s.to_string()),
        }
    }
}

impl Iterator for Md5er {
    type Item = Md5erResult;

    fn next(&mut self) -> Option<Self::Item> {
        let cs = aoc::md5sum(self.ns.bytes());
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
}

struct StretchedMd5er {
    ns: aoc::NumStr,
}

impl StretchedMd5er {
    fn new(s: &str) -> StretchedMd5er {
        StretchedMd5er {
            ns: aoc::NumStr::new(s.to_string()),
        }
    }
}

impl Iterator for StretchedMd5er {
    type Item = Md5erResult;

    fn next(&mut self) -> Option<Self::Item> {
        let mut cs = aoc::md5sum(self.ns.bytes());
        for _n in 1..2017 {
            cs = aoc::md5sum(
                &cs.iter()
                    .map(|x| format!("{:02x}", x))
                    .collect::<String>()
                    .as_bytes(),
            )
        }
        self.ns.inc();
        Some(Md5erResult::new(cs))
    }
}

#[test]
fn stretched_md5er_works() {
    let mut md5er = StretchedMd5er::new(&"abc".to_string());
    assert_eq!(
        md5er.next().unwrap().string(),
        "a107ff634856bb300138cac6568c0f24"
    );
}

fn find_key<I>(md5er: I) -> usize
where
    I: Iterator<Item = Md5erResult>,
{
    let mut c = 0;
    let mut it = md5er.enumerate().multipeek();
    loop {
        let (i, md5) = it.next().unwrap();
        let s = md5.string().bytes().collect::<Vec<u8>>();
        let triple = s.windows(3).find(|c| c[0] == c[1] && c[1] == c[2]);
        if triple == None {
            continue;
        }
        let ch = triple.unwrap()[0];
        //println!("{}: {} {}", i, ch as char, md5.string());
        it.reset_peek();
        for _n in 1..1000 {
            let (_, nmd5) = it.peek().unwrap();
            let has_5 =
                nmd5.string().bytes().collect::<Vec<u8>>().windows(5).any(
                    |c| {
                        c[0] == ch
                            && c[1] == ch
                            && c[2] == ch
                            && c[3] == ch
                            && c[4] == ch
                    },
                );
            if has_5 {
                //println!("!! {} {}: {}", i, ch as char, nmd5.string());
                c += 1;
                if c == 64 {
                    return i;
                }
                break;
            }
        }
    }
}

fn part1(salt: &str) -> usize {
    let md5er = Md5er::new(salt);
    find_key(md5er)
}

fn part2(salt: &str) -> usize {
    let md5er = StretchedMd5er::new(salt);
    find_key(md5er)
}

fn main() {
    let salt = aoc::read_input_line();
    println!("Part 1: {}", part1(&salt));
    println!("Part 2: {}", part2(&salt));
}
