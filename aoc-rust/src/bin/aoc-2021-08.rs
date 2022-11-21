#[derive(Debug, Copy, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Segments {
    n: u8,
}

impl Segments {
    fn new(inp: &[u8]) -> Segments {
        let mut n: u8 = 0;
        for ch in inp {
            n |= 1 << (ch - b'a');
        }
        Segments { n }
    }
    fn digit(&self) -> u8 {
        match self.n {
            119 => 0,
            36 => 1,
            93 => 2,
            109 => 3,
            46 => 4,
            107 => 5,
            123 => 6,
            37 => 7,
            127 => 8,
            111 => 9,
            _ => panic!("invalid digit"),
        }
    }
}

#[test]
fn parts_segments() {
    let s = Segments::new(b"cf");
    assert_eq!(s.digit(), 1, "segments digit");
    assert_eq!(s.n, 36, "segments encoding");
    let s = Segments::new(b"abdfg");
    assert_eq!(s.digit(), 5, "segments digit");
    assert_eq!(s.n, 107, "segments encoding");
}

struct Entry {
    output: Vec<Segments>,
    pattern_of_len: Vec<Vec<Segments>>,
    output_of_len: Vec<Vec<Segments>>,
}

impl Entry {
    fn solution(&self) -> Vec<u8> {
        let cf = self.pattern_of_len[2][0].n;
        let acf = self.pattern_of_len[3][0].n;
        let bcdf = self.pattern_of_len[4][0].n;
        let abcdefg = self.pattern_of_len[7][0].n;
        let a = acf ^ cf;
        let abfg = self.pattern_of_len[6][0].n
            ^ self.pattern_of_len[6][1].n
            ^ self.pattern_of_len[6][2].n;
        let cde = abcdefg ^ abfg;
        let c = cde & cf;
        let f = cf ^ c;
        let bg = abfg ^ (f | a);
        let b = bcdf & bg;
        let g = b ^ bg;
        let de = cde ^ c;
        let d = bcdf & de;
        let e = de ^ d;
        vec![a, b, c, d, e, f, g]
    }
}

struct Notes {
    entries: Vec<Entry>,
}

impl Notes {
    fn new(inp: &[u8]) -> Notes {
        let mut entries: Vec<Entry> = vec![];
        let mut pl: Vec<Vec<Segments>> = vec![
            vec![],
            vec![],
            vec![],
            vec![],
            vec![],
            vec![],
            vec![],
            vec![],
        ];
        let mut os: Vec<Segments> = vec![];
        let mut ol: Vec<Vec<Segments>> = vec![
            vec![],
            vec![],
            vec![],
            vec![],
            vec![],
            vec![],
            vec![],
            vec![],
        ];
        let mut j: usize = 0;
        let mut state = true;
        let mut word = false;

        for i in 0..inp.len() {
            match inp[i] {
                97..=103 => {
                    if !word {
                        j = i;
                        word = true
                    }
                }
                32 => {
                    if word {
                        let s = Segments::new(&inp[j..i]);
                        let l = i - j;
                        if state {
                            pl[l].push(s);
                        } else {
                            os.push(s);
                            ol[l].push(s);
                        }
                        word = false;
                    }
                }
                124 => {
                    state = false;
                }
                10 => {
                    if word {
                        let s = Segments::new(&inp[j..i]);
                        let l = i - j;
                        if state {
                            pl[l].push(s);
                        } else {
                            os.push(s);
                            ol[l].push(s);
                        }
                        word = false;
                    }
                    entries.push(Entry {
                        pattern_of_len: pl,
                        output: os,
                        output_of_len: ol,
                    });
                    state = true;
                    pl = vec![
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                    ];
                    os = vec![];
                    ol = vec![
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                        vec![],
                    ];
                }
                _ => panic!("parse error"),
            }
        }
        Notes { entries }
    }

    fn part1(&self) -> usize {
        let mut c = 0;
        for e in &self.entries {
            c += e.output_of_len[2].len()
                + e.output_of_len[3].len()
                + e.output_of_len[4].len()
                + e.output_of_len[7].len();
        }
        c
    }
    fn part2(&self) -> usize {
        let mut c = 0;
        for e in &self.entries {
            let sol = e.solution();
            let mut n = 0;
            for w in &e.output {
                let mut cvt = 0;
                for (i, v) in sol.iter().enumerate() {
                    if (w.n & v) != 0 {
                        cvt |= 1 << i;
                    }
                }
                n = n * 10 + (Segments { n: cvt }.digit() as usize);
            }
            c += n;
        }
        c
    }
}

#[test]
fn parts_works() {
    let n = Notes::new(
        b"be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe\n",
    );
    assert_eq!(n.part1(), 2, "part 1 test0");
    assert_eq!(n.part2(), 8394, "part 2 test0");
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let notes = Notes::new(&inp);
        let p1 = notes.part1();
        let p2 = notes.part2();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}
