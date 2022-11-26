use nom::{bytes::complete::tag, character::complete::*, multi::many0, IResult};

#[derive(Debug)]
struct Pass<'a> {
    min: u8,
    max: u8,
    ch: u8,
    word: &'a [u8],
}

fn pass_line(input: &[u8]) -> IResult<&[u8], Pass> {
    let (input, min) = digit1(input)?;
    let min = std::str::from_utf8(min).unwrap();
    let min = min.parse::<u8>().unwrap();
    let (input, _) = tag("-")(input)?;
    let (input, max) = digit1(input)?;
    let max = std::str::from_utf8(max).unwrap();
    let max = max.parse::<u8>().unwrap();
    let (input, _) = tag(" ")(input)?;
    let (input, ch) = anychar(input)?;
    let ch = ch as u8;
    let (input, _) = tag(": ")(input)?;
    let (input, word) = alpha1(input)?;
    let (input, _) = tag("\n")(input)?;

    Ok((input, Pass { min, max, ch, word }))
}

struct DB<'a> {
    passwords: Vec<Pass<'a>>,
}

impl<'a> DB<'a> {
    fn new(inp: &'a [u8]) -> DB {
        let res = many0(pass_line)(inp).expect("parse error");
        let (_, passwords) = res;
        DB { passwords }
    }

    fn parts(&self) -> (usize, usize) {
        let mut p1 = 0;
        let mut p2 = 0;
        for e in &self.passwords {
            let mut cc = 0;
            for ch in e.word {
                if *ch == e.ch {
                    cc += 1;
                }
            }
            if e.min <= cc && cc <= e.max {
                p1 += 1;
            }
            let first = e.word[e.min as usize - 1] == e.ch;
            let second = e.word[e.max as usize - 1] == e.ch;
            if (first || second) && !(first && second) {
                p2 += 1;
            }
        }
        (p1, p2)
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");

    aoc::benchme(|bench: bool| {
        let db = DB::new(&inp);
        let (p1, p2) = db.parts();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn parts_works() {
    let inp = std::fs::read("../2020/02/test1.txt").expect("read error");
    let db = DB::new(&inp);
    assert_eq!(db.parts(), (2, 1));
    let inp = std::fs::read("../2020/02/input.txt").expect("read error");
    let db = DB::new(&inp);
    assert_eq!(db.parts(), (454, 649));
}
