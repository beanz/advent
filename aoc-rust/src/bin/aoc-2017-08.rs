use std::collections::HashMap;

fn run(inp: &[String]) -> (isize, isize) {
    let mut p2 = std::isize::MIN;
    let mut reg: HashMap<String, isize> = HashMap::new();
    for l in inp {
        let ints = aoc::ints::<isize>(&l).collect::<Vec<isize>>();
        let mut words = l.split(' ');
        let r1n = words.next().unwrap();
        let op = words.next().unwrap();
        let r2n = words.nth(2).unwrap();
        let cmp = words.next().unwrap();
        let r2 = reg.entry(r2n.to_string()).or_insert(0);
        let test = match cmp {
            ">" => *r2 > ints[1],
            "<" => *r2 < ints[1],
            "==" => *r2 == ints[1],
            ">=" => *r2 >= ints[1],
            "<=" => *r2 <= ints[1],
            "!=" => *r2 != ints[1],
            _ => panic!("parse error; invalid cmp, {}, in: {}", cmp, l),
        };
        if !test {
            continue;
        }
        let r1 = reg.entry(r1n.to_string()).or_insert(0);
        match op {
            "inc" => *r1 += ints[0],
            "dec" => *r1 -= ints[0],
            _ => panic!("parse error; invalid op, {}, in: {}", op, l),
        }
        if *r1 > p2 {
            p2 = *r1;
        }
    }
    (*reg.values().max().unwrap(), p2)
}

fn main() {
    let inp = aoc::input_lines();
    let (p1, p2) = run(&inp);
    println!("Part 1: {}", p1);
    println!("Part 2: {}", p2);
}

#[allow(dead_code)]
const EX: [&str; 4] = [
    "b inc 5 if a > 1",
    "a inc 1 if b < 5",
    "c dec -10 if a >= 1",
    "c inc -20 if c == 10",
];

#[test]
fn run_works() {
    let ex: Vec<String> =
        EX.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    let (p1, p2) = run(&ex);
    assert_eq!(p1, 1, "part 1 example");
    assert_eq!(p2, 10, "part 2 example");
}
