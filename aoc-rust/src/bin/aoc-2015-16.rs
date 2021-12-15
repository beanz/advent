use std::collections::HashMap;

struct Sue {
    props: HashMap<String, usize>,
}

impl Sue {
    fn new(s: &str) -> Sue {
        let mut props: HashMap<String, usize> = HashMap::new();
        let mut nums = aoc::uints::<usize>(s);
        props.insert("num".to_string(), nums.next().unwrap());
        let sp = s.split(' ');
        for name in sp.step_by(2).skip(1) {
            props.insert(
                name.trim_matches(':').to_string(),
                nums.next().unwrap(),
            );
        }
        Sue { props }
    }
    fn prop(&self, k: &str) -> Option<&usize> {
        self.props.get(k)
    }
}

fn find_sue1(sues: &[Sue], tape: &[(&str, usize)]) -> usize {
    *sues
        .iter()
        .find(|s| {
            tape.iter().all(|(k, v)| {
                let val = s.prop(k);
                match val {
                    Some(x) => x == v,
                    _ => true,
                }
            })
        })
        .unwrap()
        .prop("num")
        .unwrap()
}

fn find_sue2(sues: &[Sue], tape: &[(&str, usize)]) -> usize {
    *sues
        .iter()
        .find(|s| {
            tape.iter().all(|(k, v)| {
                let val = s.prop(k);
                match val {
                    Some(x) => match *k {
                        "cats" | "trees" => x > v,
                        "pomeranians" | "goldfish" => x < v,
                        _ => x == v,
                    },
                    _ => true,
                }
            })
        })
        .unwrap()
        .prop("num")
        .unwrap()
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let sues: Vec<Sue> = inp.iter().map(|l| Sue::new(l)).collect();
        let tape = [
            ("children", 3usize),
            ("cats", 7),
            ("samoyeds", 2),
            ("pomeranians", 3),
            ("akitas", 0),
            ("vizslas", 0),
            ("goldfish", 5),
            ("trees", 3),
            ("cars", 2),
            ("perfumes", 1),
        ];
        let p1 = find_sue1(&sues, &tape);
        let p2 = find_sue2(&sues, &tape);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn find_sue1_works() {
    let sue1 = Sue::new("Sue 1: cats: 5, children: 1, cars: 2");
    assert_eq!(*sue1.prop("num").unwrap(), 1usize, "sue 1: num");
    assert_eq!(*sue1.prop("cats").unwrap(), 5usize, "sue 1: cats");
    assert_eq!(*sue1.prop("children").unwrap(), 1usize, "sue 1: children");
    assert_eq!(*sue1.prop("cars").unwrap(), 2usize, "sue 1: cars");
    let sue10 = Sue::new("Sue 10: cats: 4, cars: 3");
    assert_eq!(*sue10.prop("num").unwrap(), 10usize, "sue 10: num");
    assert_eq!(*sue10.prop("cats").unwrap(), 4usize, "sue 10: cats");
    assert_eq!(*sue10.prop("cars").unwrap(), 3usize, "sue 10: cars");
    assert_eq!(
        find_sue1(&[sue1, sue10], &[("cats", 4usize), ("goldfish", 5)]),
        10,
        "find sue part 1"
    );
}

#[test]
fn find_sue2_works() {
    let sue1 = Sue::new("Sue 1: cats: 5, children: 1, cars: 2");
    let sue10 = Sue::new("Sue 10: cats: 4, cars: 3");
    assert_eq!(
        find_sue2(&[sue1, sue10], &[("cats", 4usize), ("goldfish", 5)]),
        1,
        "find sue part 2"
    );
}
