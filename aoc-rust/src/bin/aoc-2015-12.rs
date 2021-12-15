fn part1(s: &str) -> i32 {
    aoc::ints::<i32>(s).sum()
}

fn traverse(v: &json::JsonValue) -> i32 {
    if v.is_number() {
        return v.as_i32().unwrap();
    }
    let mut s = 0;
    if v.is_array() {
        for e in v.members() {
            s += traverse(e);
        }
    } else if v.is_object() {
        for (_, e) in v.entries() {
            if e.is_string() && e.as_str().unwrap() == "red" {
                return 0;
            }
            s += traverse(e);
        }
    }
    s
}

fn part2(s: &str) -> i32 {
    let v = json::parse(s).unwrap();
    traverse(&v)
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let p1 = part1(&inp);
        let p2 = part2(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn part1_works() {
    assert_eq!(part1("[1,2,3]"), 6);
    assert_eq!(part1("{\"a\":2,\"b\":4}"), 6);
    assert_eq!(part1("[[[3]]]"), 3);
    assert_eq!(part1("{\"a\":{\"b\":4},\"c\":-1}"), 3);
    assert_eq!(part1("{\"a\":[-1,1]}"), 0);
    assert_eq!(part1("[-1,{\"a\":1}]"), 0);
    assert_eq!(part1("[]"), 0);
    assert_eq!(part1("{}"), 0);
}

#[test]
fn part2_works() {
    assert_eq!(part2("[1,2,3]"), 6);
    assert_eq!(part2("[1,{\"c\":\"red\",\"b\":2},3]"), 4);
    assert_eq!(part2("{\"d\":\"red\",\"e\":[1,2,3,4],\"f\":5}"), 0);
    assert_eq!(part2("[1,\"red\",5]"), 6);
}
