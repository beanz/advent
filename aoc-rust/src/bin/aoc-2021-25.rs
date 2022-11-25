use std::fmt;

struct Trench {
    sc: Vec<Vec<u8>>,
    w: usize,
    h: usize,
}

impl Trench {
    fn new(inp: &mut [u8]) -> Trench {
        let mut w = 0;
        while w < inp.len() && inp[w] != b'\n' {
            w += 1;
        }
        let h = inp.len() / (w + 1);
        let mut sc: Vec<Vec<u8>> = vec![];
        for y in 0..h {
            let mut row: Vec<u8> = vec![];
            for x in 0..w {
                row.push(inp[x + y * (w + 1)]);
            }
            sc.push(row);
        }
        Trench { sc, w, h }
    }
    fn part(&mut self) -> usize {
        for steps in 1.. {
            if self.step() == 0 {
                return steps;
            }
        }
        0
    }
    fn step(&mut self) -> usize {
        let mut c = self.east();
        for x in 0..self.w {
            let mut mh = self.h - 1;
            let mut y = 0;
            if self.sc[mh][x] == b'v' && self.sc[0][x] == b'.' {
                c += 1;
                self.sc[0][x] = b'v';
                self.sc[mh][x] = b'.';
                mh -= 1;
                y += 1;
            }
            while y < mh {
                if self.sc[y][x] == b'v' && self.sc[y + 1][x] == b'.' {
                    c += 1;
                    self.sc[y + 1][x] = b'v';
                    self.sc[y][x] = b'.';
                    y += 1;
                }
                y += 1;
            }
        }
        c
    }
    fn east(&mut self) -> usize {
        let mut c = 0;
        for y in 0..self.h {
            let mut mw = self.w - 1;
            let mut x = 0;
            if self.sc[y][mw] == b'>' && self.sc[y][0] == b'.' {
                c += 1;
                self.sc[y][0] = b'>';
                self.sc[y][mw] = b'.';
                mw -= 1;
                x += 1;
            }
            while x < mw {
                if self.sc[y][x] == b'>' && self.sc[y][x + 1] == b'.' {
                    c += 1;
                    self.sc[y][x + 1] = b'>';
                    self.sc[y][x] = b'.';
                    x += 1;
                }
                x += 1;
            }
        }
        c
    }
}

impl fmt::Display for Trench {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for y in 0..self.h {
            for x in 0..self.w {
                write!(f, "{}", self.sc[y][x] as char)?;
            }
            write!(f, "\n")?;
        }
        Ok(())
    }
}

fn main() {
    aoc::benchme(|bench: bool| {
        let mut inp = std::fs::read(aoc::input_file()).expect("read error");
        let mut trench = Trench::new(&mut inp);
        let p1 = trench.part();
        if !bench {
            println!("Part 1: {}", p1);
        }
    })
}

#[test]
fn part_works() {
    let mut inp = std::fs::read("../2021/25/test1.txt").expect("read error");
    let mut t = Trench::new(&mut inp);
    assert_eq!(t.part(), 58);
}

#[test]
fn step_works() {
    // During a single step, the east-facing herd moves first, then the south-facing herd moves. So, given this situation:
    let inp = &mut b"......\n.>v.v.\n....>.\n......\n".to_owned();
    let mut test0 = Trench::new(inp);
    assert_eq!(test0.step(), 3);
    assert_eq!(format!("{}", test0), "......\n.>....\n..v.v>\n......\n");

    // strong currents
    let inp = &mut r#"...>...
.......
......>
v.....>
......>
.......
..vvv..
"#
    .as_bytes()
    .to_owned();
    let mut test1 = Trench::new(inp);
    assert_eq!(test1.step(), 5);
    assert_eq!(
        format!("{}", test1),
        r#"..vv>..
.......
>......
v.....>
>......
.......
....v..
"#
    );
    assert_eq!(test1.step(), 7);
    assert_eq!(
        format!("{}", test1),
        r#"....v>.
..vv...
.>.....
......>
v>.....
.......
.......
"#
    );
    assert_eq!(test1.step(), 7);
    assert_eq!(
        format!("{}", test1),
        r#"......>
..v.v..
..>v...
>......
..>....
v......
.......
"#
    );
    assert_eq!(test1.step(), 6);
    assert_eq!(
        format!("{}", test1),
        r#">......
..v....
..>.v..
.>.v...
...>...
.......
v......
"#
    );
}

#[test]
fn east_works() {
    // So, in a situation like this:
    let inp = &mut b"...>>>>>...\n".to_owned();
    let mut test0 = Trench::new(inp);
    assert_eq!(format!("{}", test0), "...>>>>>...\n");

    // After one step, only the rightmost sea cucumber would have moved:

    assert_eq!(test0.east(), 1);
    assert_eq!(format!("{}", test0), "...>>>>.>..\n");

    // After the next step, two sea cucumbers move:
    assert_eq!(test0.east(), 2);
    assert_eq!(format!("{}", test0), "...>>>.>.>.\n");
    assert_eq!(test0.east(), 3);
    assert_eq!(format!("{}", test0), "...>>.>.>.>\n");
    assert_eq!(test0.east(), 4);
    assert_eq!(format!("{}", test0), ">..>.>.>.>.\n");
}
