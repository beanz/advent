use std::fmt;

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Rect {
    w: usize,
    h: usize,
    disp: Vec<Vec<bool>>,
}

impl Rect {
    fn new(w: usize, h: usize) -> Rect {
        let disp = vec![vec![false; w]; h];
        Rect { w, h, disp }
    }
    fn count(&self) -> usize {
        self.disp
            .iter()
            .map(|r| r.iter().filter(|e| **e).count())
            .sum()
    }
    fn rect(&mut self, w: usize, h: usize) {
        for x in 0..w {
            for y in 0..h {
                self.disp[y][x] = true;
            }
        }
    }
    fn rotate_column(&mut self, col: usize, by: usize) {
        for _ in 0..by {
            let tmp = self.disp[self.h - 1][col];
            for y in (1..self.h).rev() {
                self.disp[y][col] = self.disp[y - 1][col];
            }
            self.disp[0][col] = tmp;
        }
    }
    fn rotate_row(&mut self, row: usize, by: usize) {
        self.disp[row].rotate_right(by);
    }
    fn apply(&mut self, s: &String) {
        let uints: Vec<usize> = aoc::uints::<usize>(&s).collect();
        if s.starts_with("rect") {
            self.rect(uints[0], uints[1]);
        } else if s.starts_with("rotate col") {
            self.rotate_column(uints[0], uints[1]);
        } else if s.starts_with("rotate row") {
            self.rotate_row(uints[0], uints[1]);
        } else {
            panic!("not supported yet")
        }
    }
}

impl fmt::Display for Rect {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}",
            self.disp
                .iter()
                .map(|r| r
                    .iter()
                    .map(|p| if *p { '#' } else { '.' })
                    .collect::<String>())
                .collect::<Vec<String>>()
                .join("\n")
        )
    }
}

#[test]
fn rect_works() {
    let mut r = Rect::new(7, 3);
    r.rect(3, 2);
    assert_eq!(format!("{}", r), "###....\n###....\n.......", "rect 3x2");
}

#[test]
fn rotate_column_works() {
    let mut r = Rect::new(7, 3);
    r.rect(3, 2);
    r.rotate_column(1, 2);
    assert_eq!(
        format!("{}", r),
        "###....\n#.#....\n.#.....",
        "rotate column 1 by 2"
    );
}

#[test]
fn rotate_row_works() {
    let mut r = Rect::new(7, 3);
    r.rect(3, 2);
    r.rotate_row(0, 5);
    assert_eq!(
        format!("{}", r),
        "#....##\n###....\n.......",
        "rotate row 0 by 5"
    );
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let (w, h) = if aoc::is_test() { (7, 3) } else { (50, 6) };
        let mut r = Rect::new(w, h);
        for l in &inp {
            r.apply(l);
        }
        let p1 = r.count();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2:\n{}", r);
        }
    });
}
