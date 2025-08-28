struct Lava<'a> {
    m: &'a mut [u8],
    w: usize,
    h: usize,
}

impl Lava<'_> {
    fn new(inp: &mut [u8]) -> Lava {
        let mut w = 0;
        while w < inp.len() && inp[w] != b'\n' {
            w += 1
        }
        w += 1;
        let h = inp.len() / w;
        Lava { m: inp, w, h }
    }

    fn parts(&mut self) -> (usize, usize) {
        let mut risk = 0;
        let mut sizes: Vec<usize> = Vec::with_capacity(512);
        let mut todo: Vec<usize> = Vec::with_capacity(512);
        for ch in b'0'..=b'8' {
            for i in 0..self.m.len() {
                if self.m[i] != ch {
                    continue;
                }
                risk += (self.m[i] - b'0') as usize + 1;
                let mut size = 0;
                todo.push(i);
                while let Some(ti) = todo.pop() {
                    if self.m[ti] == b'9' {
                        continue;
                    }
                    self.m[ti] = b'9';
                    size += 1;
                    let x = ti % self.w;
                    let y = ti / self.w;
                    if x > 0 {
                        todo.push(ti - 1);
                    }
                    if x < self.w - 2 {
                        todo.push(ti + 1);
                    }
                    if y > 0 {
                        todo.push(ti - self.w);
                    }
                    if y < self.h - 1 {
                        todo.push(ti + self.w)
                    }
                }
                todo.clear();
                sizes.push(size);
            }
        }
        sizes.sort();
        (
            risk,
            sizes[sizes.len() - 3] * sizes[sizes.len() - 2] * sizes[sizes.len() - 1],
        )
    }
}

fn main() {
    aoc::benchme(|bench: bool| {
        let mut inp = std::fs::read(aoc::input_file()).expect("read error");
        let mut lava = Lava::new(&mut inp);
        let (p1, p2) = lava.parts();
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
    fn parts_works() {
        let mut inp: Vec<u8> = vec![];
        for ch in b"2199943210\n3987894921\n9856789892\n8767896789\n9899965678\n" {
            inp.push(*ch);
        }
        let mut n = Lava::new(&mut inp);
        let (p1, p2) = n.parts();
        assert_eq!(p1, 15, "part 1 test1");
        assert_eq!(p2, 1134, "part 2 test1");
    }
}
