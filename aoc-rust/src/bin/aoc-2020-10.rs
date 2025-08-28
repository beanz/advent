#[derive(Debug)]
struct Adapters {
    max: usize,
    set: [bool; 192],
}

impl Adapters {
    fn new(inp: &[u8]) -> Adapters {
        let mut set = [false; 192];
        let mut n: usize = 0;
        let mut is_num = false;
        let mut max = 0;
        for ch in inp {
            match ch {
                b'0'..=b'9' => {
                    n = n * 10 + ((ch - b'0') as usize);
                    is_num = true;
                }
                _ => {
                    if is_num {
                        set[n] = true;
                        if max < n {
                            max = n;
                        }
                        n = 0;
                        is_num = false;
                    }
                }
            }
        }
        if is_num {
            set[n] = true;
            if max < n {
                max = n;
            }
        }
        max += 3;
        set[max] = true;
        Adapters { set, max }
    }

    fn parts(&self) -> (usize, usize) {
        let mut cj = 0;
        let mut c: [usize; 4] = [0; 4];
        for j in 1..=self.max {
            if !self.set[j] {
                continue;
            }
            let d = j - cj;
            c[d] += 1;
            cj = j;
        }
        let mut j = 0;
        let mut trib = [0, 0, 1];
        for k in 1..=self.max {
            let s = trib[0] + trib[1] + trib[2];
            trib[j] = s * usize::from(self.set[k]);
            j += 1;
            j %= 3;
        }
        (c[1] * c[3], trib[(j + 2) % 3])
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let adapters = Adapters::new(&inp);
        let (p1, p2) = adapters.parts();
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/10/test0.txt").expect("read error");
        let adapters = Adapters::new(&inp);
        assert_eq!(adapters.parts(), (8, 4));
        let inp = std::fs::read("../2020/10/test1.txt").expect("read error");
        let adapters = Adapters::new(&inp);
        assert_eq!(adapters.parts(), (35, 8));
        let inp = std::fs::read("../2020/10/test2.txt").expect("read error");
        let adapters = Adapters::new(&inp);
        assert_eq!(adapters.parts(), (220, 19208));
        let inp = std::fs::read("../2020/10/input.txt").expect("read error");
        let adapters = Adapters::new(&inp);
        assert_eq!(adapters.parts(), (1920, 1511207993344));
    }
}
