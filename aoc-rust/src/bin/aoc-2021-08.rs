type Segments = u8;

fn digit(n: Segments) -> u8 {
    match n {
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

#[test]
fn parts_segments() {
    let s = 4 | 32;
    assert_eq!(digit(s), 1, "segments digit");
    let s = 1 | 2 | 8 | 32 | 64;
    assert_eq!(digit(s), 5, "segments digit");
}

struct Entry {
    output: [Segments; 4],
    pattern_of_len: [u8; 8],
}

impl Entry {
    fn solution(&self) -> (u8, u8, u8, u8, u8, u8, u8) {
        let cf = self.pattern_of_len[2];
        let acf = self.pattern_of_len[3];
        let bcdf = self.pattern_of_len[4];
        let abcdefg = self.pattern_of_len[7];
        let a = acf ^ cf;
        let abfg = self.pattern_of_len[6];
        let cde = abcdefg ^ abfg;
        let c = cde & cf;
        let f = cf ^ c;
        let bg = abfg ^ (f | a);
        let b = bcdf & bg;
        let g = b ^ bg;
        let de = cde ^ c;
        let d = bcdf & de;
        let e = de ^ d;
        (a, b, c, d, e, f, g)
    }
}

struct Notes {
    entries: Vec<Entry>,
    output_len_2_3_4_7: usize,
}

impl Notes {
    fn new(inp: &[u8]) -> Notes {
        let mut entries: Vec<Entry> = Vec::with_capacity(200);
        let mut pattern_of_len: [u8; 8] = [0; 8];
        let mut output: [Segments; 4] = [0; 4];
        let mut output_i = 0;
        let mut output_len_2_3_4_7 = 0;
        let mut state = true;
        let mut n: u8 = 0;
        let mut l: usize = 0;

        for ch in inp {
            match ch {
                b'a'..=b'g' => {
                    l += 1;
                    n |= 1 << (ch - b'a');
                }
                b' ' => {
                    if l != 0 {
                        if state {
                            pattern_of_len[l] ^= n;
                        } else {
                            output[output_i] = n;
                            output_i += 1;
                            if l == 2 || l == 3 || l == 4 || l == 7 {
                                output_len_2_3_4_7 += 1;
                            }
                        }
                        n = 0;
                        l = 0;
                    }
                }
                b'|' => {
                    state = false;
                }
                b'\n' => {
                    if l != 0 {
                        output[output_i] = n;
                        output_i = 0;
                        if l == 2 || l == 3 || l == 4 || l == 7 {
                            output_len_2_3_4_7 += 1;
                        }
                        n = 0;
                        l = 0;
                    }
                    entries.push(Entry {
                        output,
                        pattern_of_len,
                    });
                    state = true;
                    pattern_of_len = [0; 8];
                    output = [0; 4];
                }
                _ => panic!("parse error"),
            }
        }
        Notes {
            entries,
            output_len_2_3_4_7,
        }
    }

    fn part1(&self) -> usize {
        self.output_len_2_3_4_7
    }
    fn part2(&self) -> usize {
        let mut total = 0;
        for ent in &self.entries {
            let (a, b, c, d, e, f, g) = ent.solution();
            let mut n = 0;
            for w in &ent.output {
                let mut cvt = 0;
                if (w & a) != 0 {
                    cvt |= 1;
                }
                if (w & b) != 0 {
                    cvt |= 2;
                }
                if (w & c) != 0 {
                    cvt |= 4;
                }
                if (w & d) != 0 {
                    cvt |= 8;
                }
                if (w & e) != 0 {
                    cvt |= 16;
                }
                if (w & f) != 0 {
                    cvt |= 32;
                }
                if (w & g) != 0 {
                    cvt |= 64;
                }
                n = n * 10 + (digit(cvt) as usize);
            }
            total += n;
        }
        total
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
