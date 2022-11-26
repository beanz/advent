use std::fmt;

struct Trench<'a> {
    sc: &'a mut [u8],
    w: usize,
    h: usize,
}

impl Trench<'_> {
    fn new(inp: &mut [u8]) -> Trench {
        let mut w = 0;
        while w < inp.len() && inp[w] != b'\n' {
            w += 1;
        }
        let h = inp.len() / (w + 1);
        Trench { sc: inp, w, h }
    }
    fn part(&mut self) -> usize {
        for steps in 1.. {
            if self.step() == 0 {
                return steps;
            }
        }
        0
    }
    #[inline(always)]
    fn sc_index(&self, x: usize, y: usize) -> usize {
        x + y * (self.w + 1)
    }
    fn step(&mut self) -> usize {
        let mut c = self.east();
        for x in 0..self.w {
            let mut mhi = x + (self.w + 1) * (self.h - 1);
            let mut i = x;
            if self.sc[mhi] == b'v' && self.sc[x] == b'.' {
                c += 1;
                self.sc[x] = b'v';
                self.sc[mhi] = b'.';
                mhi -= self.w + 1;
                i += self.w + 1;
            }
            while i < mhi {
                let ni = i + (self.w + 1);
                if self.sc[i] == b'v' && self.sc[ni] == b'.' {
                    c += 1;
                    self.sc[ni] = b'v';
                    self.sc[i] = b'.';
                    i = ni;
                }
                i += self.w + 1;
            }
        }
        c
    }
    fn east(&mut self) -> usize {
        let mut c = 0;
        for y in 0..self.h {
            let mut i = self.sc_index(0, y);
            let mut mw = i + self.w - 1;
            if self.sc[mw] == b'>' && self.sc[i] == b'.' {
                c += 1;
                self.sc[i] = b'>';
                self.sc[mw] = b'.';
                mw -= 1;
                i += 1;
            }
            while i < mw {
                if self.sc[i] == b'>' && self.sc[i + 1] == b'.' {
                    c += 1;
                    self.sc[i + 1] = b'>';
                    self.sc[i] = b'.';
                    i += 1;
                }
                i += 1;
            }
        }
        c
    }
}

impl fmt::Display for Trench<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        for y in 0..self.h {
            for x in 0..self.w {
                write!(f, "{}", self.sc[self.sc_index(x, y)] as char)?;
            }
            writeln!(f)?;
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
