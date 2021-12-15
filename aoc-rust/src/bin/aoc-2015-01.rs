pub fn p1(inp: &str) -> i32 {
    inp.chars().fold(0, |x, y| {
        x + {
            if y == '(' {
                1
            } else {
                -1
            }
        }
    })
}

pub fn p2(inp: &str) -> i32 {
    inp.char_indices().fold(0, |x: i32, iy| {
        let (i, y) = iy;
        if x > 0 {
            x
        } else if y == '(' {
            x - 1
        } else if x == 0 {
            i as i32 + 1
        } else {
            x + 1
        }
    })
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let p1 = p1(&inp);
        let p2 = p2(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn p1works() {
    for &(inp, exp) in [
        ("(())", 0),
        ("()()", 0),
        ("(((", 3),
        ("(()(()(", 3),
        ("))(((((", 3),
        ("())", -1),
        ("))(", -1),
        (")))", -3),
        (")())())", -3),
    ]
    .iter()
    {
        assert_eq!(p1(&inp.to_string()), exp, "{}", inp);
    }
}

#[test]
fn p2works() {
    for &(inp, exp) in [(")", 1), ("()())", 5)].iter() {
        assert_eq!(p2(&inp.to_string()), exp, "{}", inp);
    }
}
