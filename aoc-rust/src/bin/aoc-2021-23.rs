use rustc_hash::FxHashSet;

#[derive(Debug, Clone, Copy, Hash, PartialEq)]
enum Pod {
    Empty,
    A,
    B,
    C,
    D,
}

impl std::fmt::Display for Pod {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            match self {
                Pod::Empty => ".",
                Pod::A => "A",
                Pod::B => "B",
                Pod::C => "C",
                Pod::D => "D",
            }
        )
    }
}

impl Pod {
    fn cost(&self) -> usize {
        [0, 1, 10, 100, 1000][*self as usize]
    }
    fn doorway(&self) -> usize {
        (*self as usize) * 2
    }
}

#[derive(Debug, Clone, Copy, PartialEq)]
enum RoomState {
    Complete,
    Invaded,
    Incomplete,
}

#[derive(Debug, Clone, Hash, PartialEq)]
struct Board {
    state: Vec<Pod>,
    cost: usize,
}
impl Eq for Board {}

use std::cmp::Ordering;
impl PartialOrd for Board {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}
impl Ord for Board {
    fn cmp(&self, other: &Self) -> Ordering {
        self.cost.cmp(&other.cost)
    }
}

impl Board {
    fn from_input(inp: &[u8]) -> Board {
        let mut state = vec![];
        for ch in inp {
            state.push(match ch {
                b'.' => Pod::Empty,
                b'A' => Pod::A,
                b'B' => Pod::B,
                b'C' => Pod::C,
                b'D' => Pod::D,
                _ => continue,
            })
        }
        Board { state, cost: 0 }
    }
    fn expand(&self) -> Board {
        let mut b = Board::from_input(b"...........\n....\nDCBA\nDBAC\n....");
        for i in 11..=14 {
            b.state[i] = self.state[i];
        }
        for i in 15..=18 {
            b.state[i + 8] = self.state[i];
        }
        b
    }
    fn is_win(&self) -> bool {
        for i in 0..11 {
            if self.state[i] != Pod::Empty {
                return false;
            }
            for i in 11..self.state.len() {
                let expect = match (i - 11) % 4 {
                    0 => Pod::A,
                    1 => Pod::B,
                    2 => Pod::C,
                    3 => Pod::D,
                    _ => unreachable!(),
                };
                if self.state[i] != expect {
                    return false;
                }
            }
        }
        true
    }
    fn room_state(&self, pos: usize) -> RoomState {
        let mut i = if pos > 10 {
            11 + (pos - 11) % 4
        } else {
            self.down(pos).expect("doorway?")
        };
        let expect = match pos {
            2 => Pod::A,
            4 => Pod::B,
            6 => Pod::C,
            8 => Pod::D,
            0 | 1 | 3 | 5 | 7 | 9 | 10 => unreachable!("invalid room"),
            _ => match (pos - 11) % 4 {
                0 => Pod::A,
                1 => Pod::B,
                2 => Pod::C,
                3 => Pod::D,
                _ => unreachable!("impossible"),
            },
        };
        let mut rs = RoomState::Complete;
        while i < self.state.len() {
            if self.state[i] == Pod::Empty {
                rs = RoomState::Incomplete;
            } else if self.state[i] != expect {
                return RoomState::Invaded;
            }
            i += 4;
        }
        rs
    }
    fn up(&self, i: usize) -> Option<usize> {
        match i {
            0..=10 => None,
            11 => Some(2),
            12 => Some(4),
            13 => Some(6),
            14 => Some(8),
            _ => Some(i - 4),
        }
    }
    fn down(&self, i: usize) -> Option<usize> {
        match i {
            0 | 1 | 3 | 5 | 7 | 9 | 10 => None,
            2 => Some(11),
            4 => Some(12),
            6 => Some(13),
            8 => Some(14),
            _ => {
                if i + 4 < self.state.len() {
                    Some(i + 4)
                } else {
                    None
                }
            }
        }
    }
    fn moves<F>(&self, mut add: F)
    where
        F: FnMut(Board),
    {
        for i in 0..self.state.len() {
            if self.state[i] == Pod::Empty {
                continue;
            }
            self.moves_from(i, &mut add);
        }
    }
    fn moves_from<F>(&self, pos: usize, mut add: F)
    where
        F: FnMut(Board),
    {
        let cost = self.state[pos].cost();
        if pos > 10 {
            let rs = self.room_state(pos);
            if rs != RoomState::Invaded {
                // don't move out of completed room
                return;
            }
            let mut steps = 0;
            let mut ni = pos;
            while let Some(j) = self.up(ni) {
                //eprintln!("  going up {}", j);
                steps += 1;
                ni = j;
                if self.state[j] != Pod::Empty {
                    return;
                }
            }
            for j in &[7, 5, 3, 1, 0] {
                //eprintln!("  going right {}", j);
                if *j > ni {
                    continue;
                }
                if self.state[*j] != Pod::Empty {
                    break;
                }
                let mut n = Board {
                    state: self.state.clone(),
                    cost: self.cost + (steps + ni - j) * cost,
                };
                n.state[*j] = self.state[pos];
                n.state[pos] = Pod::Empty;
                //eprintln!("  calling add {}", n);
                add(n);
            }
            for j in &[3, 5, 7, 9, 10] {
                //eprintln!("  going left {}", j);
                if *j < ni {
                    continue;
                }
                if self.state[*j] != Pod::Empty {
                    break;
                }
                let mut n = Board {
                    state: self.state.clone(),
                    cost: self.cost + (steps + j - ni) * cost,
                };
                n.state[*j] = self.state[pos];
                n.state[pos] = Pod::Empty;
                add(n);
            }
        } else {
            let rs = self.room_state(self.state[pos].doorway());
            if rs != RoomState::Incomplete {
                // can only move into incomplete room
                return;
            }
            let dw = self.state[pos].doorway();
            let mut steps = 0;
            let mut j = pos;
            //eprintln!("trying to move to doorway {} from {}", dw, j);
            while j != dw {
                if j < dw {
                    j += 1
                } else {
                    j -= 1
                }
                //eprintln!("{}: {}", j, self.state[j]);
                if self.state[j] != Pod::Empty {
                    return;
                }
                steps += 1;
            }
            let mut ni = self.down(j).expect("not doorway?");
            let mut j = ni;
            while j < self.state.len() {
                if self.state[j] == Pod::Empty {
                    steps += 1;
                    ni = j;
                } else if self.state[j] != self.state[pos] {
                    return;
                }
                j += 4;
            }
            let mut n = Board {
                state: self.state.clone(),
                cost: self.cost + steps * cost,
            };
            n.state[ni] = self.state[pos];
            n.state[pos] = Pod::Empty;
            add(n);
        }
    }
    fn solve(&self) -> usize {
        let mut todo = Queue::new();
        let mut seen = FxHashSet::default();
        todo.insert(self.clone());

        while let Some(b) = todo.next() {
            //eprintln!("checking:\n{}", b);
            if seen.contains(&b) {
                continue;
            }
            //eprint!("{}     \r", b.cost);
            if b.is_win() {
                return b.cost;
            }
            b.moves(|x| {
                //eprintln!("inserting:\n{}", x);
                todo.insert(x);
            });
            seen.insert(b);
        }
        0
    }
    fn parts(&self) -> (usize, usize) {
        (self.solve(), self.expand().solve())
    }
}

impl std::fmt::Display for Board {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "#############\n#")?;
        for i in 0..11 {
            write!(f, "{}", self.state[i])?;
        }
        write!(f, "#\n###")?;
        for i in 11..15 {
            write!(f, "{}#", self.state[i])?;
        }
        writeln!(f, "##")?;
        let mut i = 15;
        while i < self.state.len() {
            write!(f, "  #")?;
            for _ in 0..4 {
                write!(f, "{}#", self.state[i])?;
                i += 1;
            }
            writeln!(f)?;
        }
        write!(f, "  #########\nCost: {}", self.cost)?;
        Ok(())
    }
}

fn main() {
    aoc::benchme(|bench: bool| {
        let inp = std::fs::read(aoc::input_file()).expect("read error");
        let board = Board::from_input(&inp);
        let (p1, p2) = board.parts();
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

use priority_queue::PriorityQueue;
use std::cmp::Reverse;

#[derive(Debug)]
struct Queue {
    pq: PriorityQueue<Board, Reverse<Board>>,
}

impl Queue {
    fn new() -> Queue {
        Queue {
            pq: PriorityQueue::new(),
        }
    }
    fn next(&mut self) -> Option<Board> {
        self.pq.pop().map(|(b, _)| b)
    }
    fn insert(&mut self, b: Board) {
        self.pq.push(b.clone(), Reverse(b));
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn pod_display_works() {
        for (p, exp) in [
            (Pod::Empty, "."),
            (Pod::A, "A"),
            (Pod::B, "B"),
            (Pod::C, "C"),
            (Pod::D, "D"),
        ] {
            assert_eq!(format!("{}", p), exp);
        }
    }

    #[test]
    fn pod_cost_works() {
        for (p, exp) in [
            (Pod::Empty, 0),
            (Pod::A, 1),
            (Pod::B, 10),
            (Pod::C, 100),
            (Pod::D, 1000),
        ] {
            assert_eq!(p.cost(), exp);
        }
    }

    #[test]
    fn pod_doorway_works() {
        for (p, exp) in [(Pod::A, 2), (Pod::B, 4), (Pod::C, 6), (Pod::D, 8)] {
            assert_eq!(p.doorway(), exp);
        }
    }

    #[test]
    fn board_from_input_works() {
        let b = Board::from_input(&std::fs::read("../2021/23/test0.txt").expect("read error"));
        assert_eq!(b.state.len(), 19);
        for i in 0..11 {
            assert_eq!(b.state[i], Pod::Empty, "hallway empty");
        }
        assert_eq!(b.state[11], Pod::D);
        assert_eq!(b.state[12], Pod::B);
        assert_eq!(b.state[13], Pod::C);
        assert_eq!(b.state[14], Pod::A);

        assert_eq!(b.state[15], Pod::A);
        assert_eq!(b.state[16], Pod::B);
        assert_eq!(b.state[17], Pod::C);
        assert_eq!(b.state[18], Pod::D);
    }

    #[test]
    fn board_expand_works() {
        let b = Board::from_input(b"...........\nBCBD\nADCA").expand();
        assert_eq!(
            format!("{}", b),
            r#"#############
#...........#
###B#C#B#D###
  #D#C#B#A#
  #D#B#A#C#
  #A#D#C#A#
  #########
Cost: 0"#
        );
    }

    #[test]
    fn board_is_win_works() {
        let b = Board::from_input(&std::fs::read("../2021/23/test0.txt").expect("read error"));
        assert_eq!(b.is_win(), false);
        let mut w = Board {
            state: b.state,
            cost: 0,
        };
        w.state[11] = Pod::A;
        w.state[14] = Pod::D;
        assert_eq!(w.is_win(), true);
    }

    #[test]
    fn board_up_works() {
        let b = Board::from_input(&std::fs::read("../2021/23/test0.txt").expect("read error"));
        for (i, exp) in [
            (1, None),
            (11, Some(2)),
            (12, Some(4)),
            (13, Some(6)),
            (14, Some(8)),
            (15, Some(11)),
        ] {
            assert_eq!(b.up(i), exp, "{} up", i);
        }
    }

    #[test]
    fn board_down_works() {
        let b = Board::from_input(&std::fs::read("../2021/23/test0.txt").expect("read error"));
        for (i, exp) in [
            (1, None),
            (2, Some(11)),
            (4, Some(12)),
            (6, Some(13)),
            (8, Some(14)),
            (11, Some(15)),
            (19, None),
        ] {
            assert_eq!(b.down(i), exp, "{} down", i);
        }
    }

    #[test]
    fn board_display_works() {
        let mut b = Board {
            state: vec![Pod::Empty; 19],
            cost: 123,
        };
        assert_eq!(
            format!("{}", b),
            r#"#############
#...........#
###.#.#.#.###
  #.#.#.#.#
  #########
Cost: 123"#
        );
        b.state[0] = Pod::A;
        b.state[11] = Pod::B;
        assert_eq!(
            format!("{}", b),
            r#"#############
#A..........#
###B#.#.#.###
  #.#.#.#.#
  #########
Cost: 123"#
        );
    }

    #[test]
    fn board_room_state_works() {
        let b = Board::from_input(b"...........DBCDABCA");
        assert_eq!(b.room_state(Pod::A.doorway()), RoomState::Invaded);
        assert_eq!(b.room_state(Pod::B.doorway()), RoomState::Complete);
        assert_eq!(b.room_state(Pod::C.doorway()), RoomState::Complete);
        assert_eq!(b.room_state(Pod::D.doorway()), RoomState::Invaded);
    }

    #[test]
    fn board_moves_works() {
        let empty_board = Board {
            state: vec![Pod::Empty; 19],
            cost: 123,
        };
        let mut m = vec![];
        empty_board.moves(|nb| m.push(nb));
        assert_eq!(m.len(), 0);
    }

    #[test]
    fn board_moves_from_works() {
        let no_moves: Vec<&str> = vec![];
        for (inp, pos, exp, name) in [
            (
                b"A..........\nB...\n....",
                0,
                no_moves,
                "no moves from hallway if room is blocked",
            ),
            (
                b"A..........\nB...\n....",
                11,
                vec![
                    r#"#############
#AB.........#
###.#.#.#.###
  #.#.#.#.#
  #########
Cost: 20"#,
                    r#"#############
#A..B.......#
###.#.#.#.###
  #.#.#.#.#
  #########
Cost: 20"#,
                    r#"#############
#A....B.....#
###.#.#.#.###
  #.#.#.#.#
  #########
Cost: 40"#,
                    r#"#############
#A......B...#
###.#.#.#.###
  #.#.#.#.#
  #########
Cost: 60"#,
                    r#"#############
#A........B.#
###.#.#.#.###
  #.#.#.#.#
  #########
Cost: 80"#,
                    r#"#############
#A.........B#
###.#.#.#.###
  #.#.#.#.#
  #########
Cost: 90"#,
                ],
                "can move out of room",
            ),
            (
                b"A..B.......\n....\n....",
                0,
                vec![
                    r#"#############
#...B.......#
###.#.#.#.###
  #A#.#.#.#
  #########
Cost: 4"#,
                ],
                "can move into room if empty",
            ),
            (
                b"A..B.......\n....\nA...",
                0,
                vec![
                    r#"#############
#...B.......#
###A#.#.#.###
  #A#.#.#.#
  #########
Cost: 3"#,
                ],
                "can move into room if free space",
            ),
            (
                b"A..B.......\n....\nB...",
                0,
                vec![],
                "no move into room with intruder",
            ),
            (
                b"A..B.......\nA...\nB...",
                11,
                vec![
                    r#"#############
#AA.B.......#
###.#.#.#.###
  #B#.#.#.#
  #########
Cost: 2"#,
                ],
                "will move to free intruder",
            ),
        ] {
            let b = Board::from_input(inp);
            eprintln!("{}\n{}", name, b);
            let mut m = vec![];
            b.moves_from(pos, |nb| m.push(nb));
            assert_eq!(m.len(), exp.len(), "{}", name);
            for (i, st) in exp.iter().enumerate() {
                assert_eq!(format!("{}", m[i]), *st, "{}", name);
            }
        }
    }
    #[test]
    fn queue_works() {
        let mut q = Queue::new();
        assert!(q.next().is_none());
        let b4 = Board {
            state: vec![Pod::A],
            cost: 4,
        };
        q.insert(b4.clone());
        assert_eq!(q.next().expect("item").cost, 4);
        q.insert(b4.clone());
        q.insert(Board {
            state: vec![Pod::B],
            cost: 6,
        });
        assert_eq!(q.next().expect("item").cost, 4);
        q.insert(b4.clone());
        let altb4 = Board {
            state: vec![Pod::C],
            cost: 4,
        };
        q.insert(altb4);
        assert_eq!(q.next().expect("item").cost, 4);
        assert_eq!(q.next().expect("item").cost, 4);
        assert_eq!(q.next().expect("item").cost, 6);
        for i in [1, 2, 4, 8, 16, 17, 9, 5, 3] {
            let mut b = Board {
                state: vec![Pod::Empty; 19],
                cost: i,
            };
            b.state[i] = Pod::A;
            q.insert(b);
        }
        q.insert(Board {
            state: vec![],
            cost: 2,
        });
        for j in [1, 2, 2, 3, 4, 5, 8, 9, 16, 17] {
            assert_eq!(q.next().expect("item").cost, j);
        }
    }
}
