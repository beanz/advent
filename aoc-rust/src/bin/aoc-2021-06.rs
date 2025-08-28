use std::mem;

struct Fish {
    init: Vec<u8>,
}

impl Fish {
    fn new(inp: &[u8]) -> Fish {
        let init = read_u8s(inp);
        Fish { init }
    }
    fn count(&mut self) -> (usize, usize) {
        let mut fish: [usize; 9] = [0; 9];
        for f in &self.init {
            fish[*f as usize] += 1;
        }
        let mut next: [usize; 9] = [0; 9];
        for _ in 1..=80 {
            next[6] = fish[0];
            next[8] = fish[0];
            for i in 0..8 {
                next[i] += fish[i + 1];
            }
            mem::swap(&mut fish, &mut next);
            next = [0; 9];
        }
        let mut p1 = 0;
        for n in fish {
            p1 += n;
        }

        for _ in 81..=256 {
            next[6] = fish[0];
            next[8] = fish[0];
            for i in 0..8 {
                next[i] += fish[i + 1];
            }
            mem::swap(&mut fish, &mut next);
            next = [0; 9];
        }
        let mut p2 = 0;
        for n in fish {
            p2 += n;
        }

        (p1, p2)
    }
}

fn read_u8s(inp: &[u8]) -> Vec<u8> {
    let mut u8s: Vec<u8> = vec![];
    let mut n: u8 = 0;
    let mut is_num = false;
    for ch in inp {
        match (ch, is_num) {
            (b'0'..=b'9', true) => n = n * 10 + (ch - b'0'),
            (b'0'..=b'9', false) => {
                n = ch - b'0';
                is_num = true;
            }
            (_, true) => {
                u8s.push(n);
                is_num = false;
            }
            _ => {}
        }
    }
    u8s
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let mut fish = Fish::new(&inp);
        let (p1, p2) = fish.count();
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}
