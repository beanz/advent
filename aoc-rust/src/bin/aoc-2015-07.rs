use std::collections::HashMap;

pub fn calc(
    m: &HashMap<String, String>,
    cache: &mut HashMap<String, u16>,
    s: &str,
) -> u16 {
    if cache.contains_key(&s.to_string()) {
        return *cache.get(&s.to_string()).unwrap();
    }
    let res: u16;
    let try_u16 = s.parse::<u16>();
    if let Ok(n) = try_u16 {
        res = n;
    } else {
        let v = m.get(&s.to_string()).unwrap();
        if v.contains("AND") {
            let mut lhs = v.split(' ');
            let op1 = lhs.next().unwrap();
            lhs.next();
            let op2 = lhs.next().unwrap();
            res = calc(m, cache, op1) & calc(m, cache, op2);
        } else if v.contains("OR") {
            let mut lhs = v.split(' ');
            let op1 = lhs.next().unwrap();
            lhs.next();
            let op2 = lhs.next().unwrap();
            res = calc(m, cache, op1) | calc(m, cache, op2);
        } else if v.contains("LSHIFT") {
            let mut lhs = v.split(' ');
            let op1 = lhs.next().unwrap();
            lhs.next();
            let op2 = lhs.next().unwrap().parse::<u16>().unwrap();
            res = calc(m, cache, op1) << op2;
        } else if v.contains("RSHIFT") {
            let mut lhs = v.split(' ');
            let op1 = lhs.next().unwrap();
            lhs.next();
            let op2 = lhs.next().unwrap().parse::<u16>().unwrap();
            res = calc(m, cache, op1) >> op2;
        } else if v.contains("NOT") {
            let mut lhs = v.split(' ');
            lhs.next();
            let op = lhs.next().unwrap();
            res = !calc(m, cache, op);
        } else {
            res = calc(m, cache, v);
        }
    }
    cache.insert(s.to_string(), res);
    res
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let mut m = inp.iter().fold(HashMap::new(), |mut m, l| {
            let v = l.split(" -> ").collect::<Vec<&str>>();
            let k = v[1].to_owned();
            m.insert(k, v[0].to_owned());
            m
        });
        let mut cache: HashMap<String, u16> = HashMap::new();
        let p1 = calc(&m, &mut cache, "a");
        if !bench {
            println!("Part 1: {}", p1);
        }
        let mut cache2: HashMap<String, u16> = HashMap::new();
        m.insert("b".to_string(), format!("{}", p1));
        let p2 = calc(&m, &mut cache2, "a");
        if !bench {
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn calc_works() {
    let mut cache = HashMap::new();
    let mut m: HashMap<String, String> = HashMap::new();
    m.insert("x".to_string(), "123".to_string());
    m.insert("y".to_string(), "456".to_string());
    m.insert("d".to_string(), "x AND y".to_string());
    m.insert("e".to_string(), "x OR y".to_string());
    m.insert("f".to_string(), "x LSHIFT 2".to_string());
    m.insert("g".to_string(), "y RSHIFT 2".to_string());
    m.insert("h".to_string(), "NOT x".to_string());
    m.insert("i".to_string(), "NOT y".to_string());
    for &(inp, exp) in [
        ("d", 72),
        ("e", 507),
        ("f", 492),
        ("g", 114),
        ("h", 65412),
        ("i", 65079),
        ("x", 123),
        ("y", 456),
    ]
    .iter()
    {
        assert_eq!(calc(&m, &mut cache, inp), exp, "{}", inp);
    }
}
