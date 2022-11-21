use std::collections::HashMap;

struct Tower {
    parent: HashMap<String, String>,
    children: HashMap<String, Vec<String>>,
    weights: HashMap<String, usize>,
}

fn odd_one(ws: &[usize]) -> Option<usize> {
    if ws.len() < 3 {
        return None;
    }
    let first = ws[0];
    let second = ws[1];
    if first == second {
        for (i, w) in ws.iter().enumerate().skip(2) {
            if *w != first {
                return Some(i);
            }
        }
        return None;
    }
    if first == ws[2] {
        Some(1)
    } else {
        Some(0)
    }
}

#[test]
fn odd_one_works() {
    assert_eq!(odd_one(&[]), None);
    assert_eq!(odd_one(&[1]), None);
    assert_eq!(odd_one(&[1, 1]), None);
    assert_eq!(odd_one(&[1, 1, 1]), None);
    assert_eq!(odd_one(&[1, 1, 0]), Some(2));
    assert_eq!(odd_one(&[1, 1, 1, 1]), None);
    assert_eq!(odd_one(&[0, 1, 1, 1]), Some(0));
    assert_eq!(odd_one(&[1, 0, 1, 1]), Some(1));
    assert_eq!(odd_one(&[1, 1, 0, 1]), Some(2));
    assert_eq!(odd_one(&[1, 1, 1, 0]), Some(3));
    assert_eq!(odd_one(&[1, 1, 1, 1, 1]), None);
    assert_eq!(odd_one(&[1, 1, 1, 1, 0]), Some(4));
}

impl Tower {
    fn new(inp: &[String]) -> Tower {
        let mut parent: HashMap<String, String> = HashMap::new();
        let mut children: HashMap<String, Vec<String>> = HashMap::new();
        let mut weights: HashMap<String, usize> = HashMap::new();
        for l in inp {
            let mut sp = l.split(" -> ");
            let lhs = sp.next().unwrap();
            let ints = aoc::ints::<usize>(lhs).collect::<Vec<usize>>();
            let mut t = lhs.split(' ');
            let tower = t.next().unwrap();
            let weight = ints[0];
            weights.insert(tower.to_string(), weight);
            if let Some(rhs) = sp.next() {
                let children_str = rhs.split(", ");
                for child in children_str {
                    parent.insert(child.to_string(), tower.to_string());
                    let c = children
                        .entry(tower.to_string())
                        .or_insert_with(Vec::new);
                    c.push(child.to_string());
                }
            }
        }
        Tower {
            parent,
            children,
            weights,
        }
    }

    fn part1(&self) -> String {
        for tower in self.weights.keys() {
            if !self.parent.contains_key(tower) {
                return tower.to_string();
            }
        }
        "not found".to_string()
    }

    fn weight(&self, t: String) -> (usize, Option<usize>) {
        let w = *self.weights.get(&t).unwrap();
        if let Some(children) = self.children.get(&t) {
            let mut ws: Vec<usize> = Vec::new();
            for ct in children {
                let (w, ans) = self.weight(ct.to_string());
                if ans.is_some() {
                    return (0, ans);
                }
                ws.push(w);
            }
            let has_odd = odd_one(&ws);
            match has_odd {
                None => (w + ws.iter().sum::<usize>(), None),
                Some(odd) => {
                    let not_odd = usize::from(odd == 0);
                    (
                        0,
                        Some(
                            *self.weights.get(&children[odd]).unwrap()
                                + ws[not_odd]
                                - ws[odd],
                        ),
                    )
                }
            }
        } else {
            (w, None)
        }
    }

    fn part2(&self, top: String) -> usize {
        let (_, ans) = self.weight(top);
        ans.unwrap()
    }
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let tower = Tower::new(&inp);
        let p1 = tower.part1();
        let p2 = tower.part2(p1.to_string());
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[allow(dead_code)]
const EX: [&str; 13] = [
    "pbga (66)",
    "xhth (57)",
    "ebii (61)",
    "havc (66)",
    "ktlj (57)",
    "fwft (72) -> ktlj, cntj, xhth",
    "qoyq (66)",
    "padx (45) -> pbga, havc, qoyq",
    "tknk (41) -> ugml, padx, fwft",
    "jptl (61)",
    "ugml (68) -> gyxo, ebii, jptl",
    "gyxo (61)",
    "cntj (57)",
];

#[test]
fn parts_work() {
    let ex: Vec<String> =
        EX.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    let tower = Tower::new(&ex);
    let p1 = tower.part1();
    assert_eq!(p1, "tknk", "part 1 example");
    assert_eq!(tower.part2(p1), 60, "part 2 example");
}
