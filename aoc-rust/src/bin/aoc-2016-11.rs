use std::collections::HashMap;
use std::collections::HashSet;
use std::collections::VecDeque;
use std::fmt;

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Element {
    chip_floor: u8,
    gen_floor: u8,
}

#[derive(Debug, Clone, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct State {
    lift: u8,
    elements: Vec<Element>,
    moves: usize,
}

impl fmt::Display for State {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        let mut res = "".to_string();
        res.push_str(&format!("moves: {}\n", self.moves));
        for floor in (1..=4).rev() {
            let l = if floor == self.lift { "L" } else { "_" };
            res.push_str(&format!("{floor}: {l}"));
            for (i, el) in self.elements.iter().enumerate() {
                let g = if el.gen_floor == floor {
                    i.to_string() + "G"
                } else {
                    "__".to_string()
                };
                let m = if el.chip_floor == floor {
                    i.to_string() + "M"
                } else {
                    "__".to_string()
                };
                res.push_str(&format!(" {g} {m}"));
            }
            res.push('\n');
        }
        write!(f, "{res}")
    }
}

impl State {
    fn possible_floors(&self) -> Vec<u8> {
        match self.lift {
            1 => vec![2],
            2 => vec![1, 3],
            3 => vec![2, 4],
            4 => vec![3],
            _ => unreachable!(),
        }
    }
}

impl State {
    fn done(&self) -> bool {
        for el in &self.elements {
            if el.chip_floor != 4 || el.gen_floor != 4 {
                return false;
            }
        }
        true
    }
}

impl State {
    fn safe(&self) -> bool {
        let mut floor_gen_count = [0; 4];
        for el in &self.elements {
            floor_gen_count[(el.gen_floor - 1) as usize] += 1;
        }
        for el in &self.elements {
            if el.chip_floor != el.gen_floor && floor_gen_count[(el.chip_floor - 1) as usize] > 0 {
                return false;
            }
        }
        true
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash)]
enum Move {
    Gen(usize),
    Chip(usize),
}

impl State {
    fn item_picks(&self) -> Vec<Vec<Move>> {
        let mut res: Vec<Vec<Move>> = vec![];
        for (i, el) in self.elements.iter().enumerate() {
            if el.chip_floor == self.lift {
                res.push(vec![Move::Chip(i)]);
                if el.gen_floor == self.lift {
                    res.push(vec![Move::Chip(i), Move::Gen(i)]);
                }
                let mut j = i + 1;
                while j < self.elements.len() {
                    if self.elements[j].chip_floor == self.lift {
                        res.push(vec![Move::Chip(i), Move::Chip(j)]);
                    }
                    if self.elements[j].gen_floor == self.lift {
                        // invalid?
                        // res.push(vec![Move::Chip(i),Move::Gen(j)]);
                    }
                    j += 1;
                }
            }
            if el.gen_floor == self.lift {
                res.push(vec![Move::Gen(i)]);
                let mut j = i + 1;
                while j < self.elements.len() {
                    if self.elements[j].gen_floor == self.lift {
                        res.push(vec![Move::Gen(i), Move::Gen(j)]);
                    }
                    if self.elements[j].chip_floor == self.lift {
                        // invalid?
                        //res.push(vec![Move::Gen(i),Move::Chip(j)]);
                    }
                    j += 1;
                }
            }
        }
        res
    }
}

impl State {
    fn next_state(&self, lift: u8, moves: Vec<Move>) -> State {
        let mut elements: Vec<Element> = vec![];
        for el in &self.elements {
            elements.push(Element {
                chip_floor: el.chip_floor,
                gen_floor: el.gen_floor,
            });
        }
        for m in moves {
            match m {
                Move::Chip(n) => elements[n].chip_floor = lift,
                Move::Gen(n) => elements[n].gen_floor = lift,
            }
        }
        State {
            lift,
            elements,
            moves: self.moves + 1,
        }
    }
}

impl State {
    fn visit_key(&self) -> String {
        let mut todo: Vec<char> = vec![(self.lift + b'0') as char, '!'];
        let mut done: Vec<char> = vec![];
        for el in &self.elements {
            if el.chip_floor == el.gen_floor {
                done.push((el.chip_floor + b'0') as char);
            } else {
                todo.push((el.gen_floor + b'0') as char);
                todo.push(',');
                todo.push((el.chip_floor + b'0') as char);
                todo.push(',');
            }
        }
        done.sort_unstable();
        let l = todo.len() - 1;
        todo[l] = '!';
        todo.extend_from_slice(&done);
        todo.into_iter().collect::<String>()
    }
}

struct Solver {
    init: State,
    names: Vec<String>,
}

impl Solver {
    fn new(inp: &[String]) -> Solver {
        let mut name_map: HashMap<String, usize> = HashMap::new();
        let mut names: Vec<String> = vec![];
        let mut elements: Vec<Element> = vec![];
        for (i, l) in inp.iter().enumerate() {
            let floor = (i + 1) as u8;
            let list = l.split(" contains ").nth(1).unwrap();
            if list == "nothing relevant." {
                continue;
            }
            let items = list.split(" and ").flat_map(|p| p.split(", "));
            for item in items {
                let mut words = item.split(' ').skip(1);
                let element = words.next().unwrap().split('-').next().unwrap();
                let next = elements.len();
                let num = *name_map.entry(element.to_string()).or_insert(next);
                if num == next {
                    names.push(element.to_string());
                    elements.push(Element {
                        chip_floor: 0,
                        gen_floor: 0,
                    })
                }
                let kind = words.next().unwrap().chars().next().unwrap();
                //println!("f={} element={}/{} {}",
                //         floor, element, num, &kind);
                match kind {
                    'm' => elements[num].chip_floor = floor,
                    'g' => elements[num].gen_floor = floor,
                    _ => unreachable!(),
                }
            }
        }
        for el in &elements {
            assert_ne!(el.chip_floor, 0, "chip floor not defined by input");
            assert_ne!(el.gen_floor, 0, "gen floor not defined by input");
        }
        Solver {
            init: State {
                moves: 0,
                elements,
                lift: 1,
            },
            names,
        }
    }
}

impl Solver {
    fn solve(&self) -> usize {
        let mut best = usize::MAX;
        let mut todo: VecDeque<Box<State>> = VecDeque::new();
        let first = self.init.clone();
        todo.push_back(Box::new(first));
        let mut visited: HashSet<String> = HashSet::new();
        let mut next;
        while !todo.is_empty() {
            let cur = todo.pop_front().unwrap();
            //println!("{}", &cur);
            let key = cur.visit_key();
            if !visited.insert(key) {
                // already present
                continue;
            }
            if cur.done() {
                //println!("Found solution in {} moves", cur.moves);
                if cur.moves < best {
                    best = cur.moves;
                }
                continue;
            }
            if cur.moves > best {
                continue;
            }

            for nf in cur.possible_floors() {
                for moves in cur.item_picks() {
                    next = cur.next_state(nf, moves);
                    //println!("next:\n{}", next);
                    if next.safe() {
                        todo.push_back(Box::new(next));
                    }
                }
            }
        }
        best
    }
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let mut solver = Solver::new(&inp);
        let p1 = solver.solve();
        solver.names.push("elerium".to_string());
        solver.init.elements.push(Element {
            // elerium
            gen_floor: 1,
            chip_floor: 1,
        });
        solver.names.push("dilithium".to_string());
        solver.init.elements.push(Element {
            // dilithium
            gen_floor: 1,
            chip_floor: 1,
        });
        let p2 = solver.solve();
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
    fn state_display_works() {
        let ex1 = State {
            moves: 0,
            lift: 1,
            elements: vec![
                Element {
                    chip_floor: 1,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 1,
                    gen_floor: 3,
                },
            ],
        };
        let exp = "moves: 0\n".to_owned()
            + "4: _ __ __ __ __\n"
            + "3: _ __ __ 1G __\n"
            + "2: _ 0G __ __ __\n"
            + "1: L __ 0M __ 1M\n";
        assert_eq!(format!("{ex1}"), exp, "ex1 initial state");
    }
    #[test]
    fn state_possible_floors_works() {
        let mut ex1 = State {
            moves: 0,
            lift: 1,
            elements: vec![
                Element {
                    chip_floor: 1,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 1,
                    gen_floor: 3,
                },
            ],
        };
        assert_eq!(ex1.possible_floors(), vec![2], "possible floors from 1");
        ex1.lift = 2;
        assert_eq!(ex1.possible_floors(), vec![1, 3], "possible floors from 2");
        ex1.lift = 4;
        assert_eq!(ex1.possible_floors(), vec![3], "possible floors from 4");
    }
    #[test]
    fn state_done_works() {
        let ex1 = State {
            moves: 0,
            lift: 1,
            elements: vec![
                Element {
                    chip_floor: 1,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 1,
                    gen_floor: 3,
                },
            ],
        };
        let finished = State {
            moves: 0,
            lift: 4,
            elements: vec![
                Element {
                    chip_floor: 4,
                    gen_floor: 4,
                },
                Element {
                    chip_floor: 4,
                    gen_floor: 4,
                },
            ],
        };
        assert_eq!(ex1.done(), false, "example start is not done");
        assert_eq!(finished.done(), true, "example end state is done");
    }
    #[test]
    fn state_safe_works() {
        let ex1 = State {
            moves: 0,
            lift: 1,
            elements: vec![
                Element {
                    chip_floor: 1,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 1,
                    gen_floor: 3,
                },
            ],
        };
        assert_eq!(ex1.safe(), true, "initial example state is safe");

        let not_safe = State {
            moves: 0,
            lift: 1,
            elements: vec![
                Element {
                    chip_floor: 3,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 1,
                    gen_floor: 3,
                },
            ],
        };
        assert_eq!(
            not_safe.safe(),
            false,
            "first element near second gen is unsafe"
        );
    }
    #[test]
    fn state_item_picks_works() {
        let mut ex1 = State {
            moves: 0,
            lift: 1,
            elements: vec![
                Element {
                    chip_floor: 1,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 1,
                    gen_floor: 3,
                },
            ],
        };
        assert_eq!(
            ex1.item_picks(),
            vec![
                vec![Move::Chip(0)],
                vec![Move::Chip(0), Move::Chip(1)],
                vec![Move::Chip(1)]
            ],
            "example picks floor 1"
        );
        let empty: Vec<Vec<Move>> = vec![];
        ex1.lift = 4;
        assert_eq!(ex1.item_picks(), empty, "example picks floor 4 - empty");
        let ex1move2 = State {
            moves: 1,
            lift: 2,
            elements: vec![
                Element {
                    chip_floor: 2,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 1,
                    gen_floor: 3,
                },
            ],
        };

        assert_eq!(
            ex1move2.item_picks(),
            vec![
                vec![Move::Chip(0)],
                vec![Move::Chip(0), Move::Gen(0)],
                vec![Move::Gen(0)]
            ],
            "example move 2 picks"
        );
    }
    #[test]
    fn next_state_works() {
        let ex1 = State {
            moves: 0,
            lift: 1,
            elements: vec![
                Element {
                    chip_floor: 1,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 1,
                    gen_floor: 3,
                },
            ],
        };
        let exp0 = "moves: 1\n".to_owned()
            + "4: _ __ __ __ __\n"
            + "3: _ __ __ 1G __\n"
            + "2: L 0G 0M __ __\n"
            + "1: _ __ __ __ 1M\n";
        assert_eq!(
            format!("{}", ex1.next_state(2, vec![Move::Chip(0)])),
            exp0,
            "example move chip 0 to floor 2"
        );
        let exp1 = "moves: 1\n".to_owned()
            + "4: _ __ __ __ __\n"
            + "3: _ __ __ 1G __\n"
            + "2: L 0G 0M __ 1M\n"
            + "1: _ __ __ __ __\n";
        assert_eq!(
            format!("{}", ex1.next_state(2, vec![Move::Chip(0), Move::Chip(1)])),
            exp1,
            "example move chip 0&1 to floor 2"
        );
    }
    #[test]
    fn state_visit_key_works() {
        let ex1 = State {
            moves: 0,
            lift: 1,
            elements: vec![
                Element {
                    chip_floor: 1,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 1,
                    gen_floor: 3,
                },
            ],
        };
        let exp = "1!2,1,3,1!".to_owned();
        assert_eq!(ex1.visit_key(), exp, "ex1 visit key");
        let moved = State {
            moves: 1,
            lift: 1,
            elements: vec![
                Element {
                    chip_floor: 1,
                    gen_floor: 2,
                },
                Element {
                    chip_floor: 3,
                    gen_floor: 3,
                },
            ],
        };
        let exp = "1!2,1!3".to_owned();
        assert_eq!(moved.visit_key(), exp, "1 completed visit key");
    }
    #[allow(dead_code)]
    const EX1: [&str; 4] = [
    "The first floor contains a hydrogen-compatible microchip and a lithium-compatible microchip.",
    "The second floor contains a hydrogen generator.",
    "The third floor contains a lithium generator.",
    "The fourth floor contains nothing relevant.",
];
    #[test]
    fn solver_new_works() {
        let e: Vec<String> = EX1.iter().map(|x| x.to_string()).collect::<Vec<String>>();
        let solver = Solver::new(&e);
        assert_eq!(solver.init.elements.len(), 2, "example has two items");
        let exp = "moves: 0\n".to_owned()
            + "4: _ __ __ __ __\n"
            + "3: _ __ __ 1G __\n"
            + "2: _ 0G __ __ __\n"
            + "1: L __ 0M __ 1M\n";
        assert_eq!(format!("{}", solver.init), exp, "example parsed correctly");
    }
    #[test]
    fn solver_works() {
        let e: Vec<String> = EX1.iter().map(|x| x.to_string()).collect::<Vec<String>>();
        let solver = Solver::new(&e);
        assert_eq!(solver.solve(), 11, "solver solves example in 11 moves");
    }
}
