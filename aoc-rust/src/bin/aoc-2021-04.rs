use ahash::RandomState;
use std::collections::HashMap;

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Board {
    score: usize,
    won: bool,
    row_remaining: Vec<u8>,
    col_remaining: Vec<u8>,
}

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Location {
    board: usize,
    row: usize,
    col: usize,
}

struct Bingo {
    calls: Vec<u8>,
    boards: Vec<Board>,
    remaining: u8,
    lookup: HashMap<u8, Vec<Location>, RandomState>,
}

impl Bingo {
    fn new(inp: &[u8]) -> Bingo {
        let mut calls: Vec<u8> = vec![];
        let mut n: u8 = 0;
        let mut j = 0;
        for (i, ch) in inp.iter().enumerate() {
            match ch {
                b'0'..=b'9' => {
                    n = (n * 10) + (ch - 48);
                }
                b',' => {
                    calls.push(n);
                    n = 0;
                }
                b'\n' => {
                    j = i;
                    break;
                }
                _ => panic!("unexpected input reading calls"),
            }
        }
        let u8s = read_u8s(&inp[j..inp.len()]);
        let mut remaining: u8 = 0;
        let mut boards: Vec<Board> = vec![];
        let mut lookup: HashMap<u8, Vec<Location>, RandomState> = HashMap::default();

        for (bnum, chunk) in u8s.chunks(25).enumerate() {
            remaining += 1;
            let mut board = Board {
                score: 0,
                won: false,
                row_remaining: vec![5, 5, 5, 5, 5],
                col_remaining: vec![5, 5, 5, 5, 5],
            };
            for (i, num) in chunk.iter().enumerate() {
                let r = i / 5;
                let c = i % 5;
                board.score += *num as usize;
                let le = lookup.entry(*num).or_insert_with(Vec::new);
                le.push(Location {
                    board: bnum,
                    row: r,
                    col: c,
                });
            }
            boards.push(board);
        }

        Bingo {
            calls,
            boards,
            remaining,
            lookup,
        }
    }
    fn play(&mut self) -> (usize, usize) {
        let mut p1 = 0;
        let mut p2 = 0;
        let mut first = true;
        for call in &self.calls {
            for nl in self.lookup.get(call).unwrap() {
                let mut board = &mut self.boards[nl.board];
                if board.won {
                    continue;
                }
                board.score -= *call as usize;
                board.row_remaining[nl.row] -= 1;
                board.col_remaining[nl.col] -= 1;
                if board.row_remaining[nl.row] != 0 && board.col_remaining[nl.col] != 0 {
                    continue;
                }
                board.won = true;
                if first {
                    first = false;
                    p1 = (*call as usize) * board.score;
                }
                self.remaining -= 1;
                if self.remaining == 0 {
                    p2 = (*call as usize) * board.score;
                    return (p1, p2);
                }
            }
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
            (48..=57, true) => n = n * 10 + (ch - 48),
            (48..=57, false) => {
                n = ch - 48;
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
        let mut bingo = Bingo::new(&inp);
        let (p1, p2) = bingo.play();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}
