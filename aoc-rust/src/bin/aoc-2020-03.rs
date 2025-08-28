struct Forest<'a> {
    m: &'a [u8],
    w: usize,
    h: usize,
}

impl Forest<'_> {
    fn new(inp: &[u8]) -> Forest {
        let mut w = 0;
        while w < inp.len() && inp[w] != b'\n' {
            w += 1
        }
        let h = inp.len() / (w + 1);
        Forest { m: inp, w, h }
    }
    fn is_tree(&self, x: usize, y: usize) -> bool {
        let i = y * (self.w + 1) + (x % self.w);
        self.m[i] == b'#'
    }
    fn traverse(&self, sx: usize, sy: usize) -> usize {
        let mut c = 0;
        let (mut x, mut y) = (0, 0);
        while y < self.h {
            if self.is_tree(x, y) {
                c += 1;
            }
            x += sx;
            y += sy;
        }
        c
    }
    fn parts(&self) -> (usize, usize) {
        (
            self.traverse(3, 1),
            [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
                .iter()
                .map(|(sx, sy)| self.traverse(*sx, *sy))
                .product(),
        )
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let f = Forest::new(&inp);
        let (p1, p2) = f.parts();
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn is_tree_works() {
        let inp = std::fs::read("../2020/03/test1.txt").expect("read error");
        let f = Forest::new(&inp);
        assert!(!f.is_tree(0, 0));
        assert!(f.is_tree(0, 1));
    }

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/03/test1.txt").expect("read error");
        let f = Forest::new(&inp);
        let (p1, p2) = f.parts();
        assert_eq!(p1, 7, "part 1 test1");
        assert_eq!(p2, 336, "part 2 test1");
    }
}
