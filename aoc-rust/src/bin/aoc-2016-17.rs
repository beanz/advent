use std::collections::VecDeque;

fn open(p: &str) -> Box<[bool; 4]> {
    let md5 = aoc::md5sum(p.as_bytes());
    Box::new([
        (md5[0] & 0xf0) > 0xa0,
        (md5[0] & 0xf) > 0xa,
        (md5[1] & 0xf0) > 0xa0,
        (md5[1] & 0xf) > 0xa,
    ])
}

#[test]
fn open_works() {
    for tc in &[
        ("hijkl", [true, true, true, false]),
        ("hijklD", [true, false, true, true]),
        ("hijklDR", [false; 4]),
        ("hijklDU", [false, false, false, true]),
        ("hijklDUR", [false; 4]),
    ] {
        assert_eq!(open(&tc.0.to_string()), Box::new(tc.1), "open {}", tc.0)
    }
}

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct SearchState {
    pos: (usize, usize),
    path: String,
}

fn search(inp: &str) -> (String, usize) {
    let mut todo: VecDeque<SearchState> = VecDeque::new();
    todo.push_front(SearchState {
        pos: (0, 0),
        path: "".to_string(),
    });
    let mut p1: Option<String> = None;
    let mut p2 = 0;
    while !todo.is_empty() {
        let cur = todo.pop_front().unwrap();
        //dbg!(&cur);
        if cur.pos == (3, 3) {
            if p1.is_none() {
                //println!("Reached end: {}", &cur.path);
                p1 = Some(cur.path.to_owned());
            }
            if cur.path.len() > p2 {
                p2 = cur.path.len();
            }
            continue;
        }
        let dirs = *open(&(inp.to_owned() + &cur.path));
        //dbg!(dirs);
        for (dir, allowed) in dirs.iter().enumerate() {
            //dbg!((dir, allowed));
            if !allowed {
                continue;
            }
            let next = match dir {
                0 => {
                    if cur.pos.1 == 0 {
                        continue;
                    }
                    SearchState {
                        pos: (cur.pos.0, cur.pos.1 - 1),
                        path: cur.path.to_owned() + "U",
                    }
                }
                1 => {
                    if cur.pos.1 == 3 {
                        continue;
                    }
                    SearchState {
                        pos: (cur.pos.0, cur.pos.1 + 1),
                        path: cur.path.to_owned() + "D",
                    }
                }
                2 => {
                    if cur.pos.0 == 0 {
                        continue;
                    }
                    SearchState {
                        pos: (cur.pos.0 - 1, cur.pos.1),
                        path: cur.path.to_owned() + "L",
                    }
                }
                3 => {
                    if cur.pos.0 == 3 {
                        continue;
                    }
                    SearchState {
                        pos: (cur.pos.0 + 1, cur.pos.1),
                        path: cur.path.to_owned() + "R",
                    }
                }
                _ => panic!("invalid direction?"),
            };
            todo.push_back(next);
        }
    }
    (p1.unwrap(), p2)
}

#[test]
fn search_works() {
    for tc in &[
        ("ihgpwlah", ("DDRRRD", 370usize)),
        ("kglvqrro", ("DDUDRLRRUDRD", 492)),
        ("ulqzkmiv", ("DRURDRUDDLLDLUURRDULRLDUUDDDRR", 830)),
        ("mmsxrhfx", ("RLDUDRDDRR", 590)),
    ] {
        assert_eq!(
            search(&tc.0.to_string()),
            (tc.1 .0.to_string(), tc.1 .1),
            "search {}",
            tc.0
        );
    }
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let (p1, p2) = search(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
