#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Constraint {
    i: usize,
    j: usize,
}

struct Prog {
    add_x: Vec<i64>,
    add_y: Vec<i64>,
    constraint: Vec<Constraint>,
}

impl Prog {
    pub fn new(input: &str) -> Prog {
        let mut add_x: Vec<i64> = vec![];
        let mut add_y: Vec<i64> = vec![];
        let mut div_z: Vec<i64> = vec![];
        let mut y_count = 0;
        for line in input.trim().split('\n') {
            let mut parts = line.split(' ');
            let instruction = parts.next().unwrap();
            let reg: char = parts.next().unwrap().parse().unwrap();
            let value = if let Some(s) = parts.next() {
                match s.parse::<i64>() {
                    Ok(v) => Some(v),
                    _ => None,
                }
            } else {
                None
            };
            match (instruction, reg, value) {
                ("add", 'x', Some(v)) => add_x.push(v),
                ("add", 'y', Some(v)) => {
                    if y_count % 3 == 2 {
                        add_y.push(v)
                    }
                    y_count += 1;
                }
                ("div", 'z', Some(v)) => div_z.push(v),
                _ => {}
            }
        }
        if add_x.len() != 14 {
            panic!(
                "wrong number of add x found; got {} expected 14",
                add_x.len()
            )
        }
        if add_y.len() != 14 {
            panic!(
                "wrong number of add y found; got {} expected 14",
                add_y.len()
            )
        }
        if div_z.len() != 14 {
            panic!(
                "wrong number of div z found; got {} expected 14",
                div_z.len()
            )
        }
        let mut stack: Vec<usize> = vec![];
        let mut constraint: Vec<Constraint> = vec![];
        for (i, dz) in div_z.iter().enumerate() {
            if *dz != 1 {
                let j = stack.pop().unwrap();
                constraint.push(Constraint { i, j });
            } else {
                stack.push(i);
            }
        }
        if !stack.is_empty() {
            panic!("stack not empty; got length {}", stack.len());
        }
        if constraint.len() != 7 {
            panic!("constraint length not 7; got {}", constraint.len());
        }
        Prog {
            add_x,
            add_y,
            constraint,
        }
    }
    fn solve(&self, smallest: bool) -> i64 {
        let mut ans: [i64; 14] = if smallest { [1; 14] } else { [9; 14] };
        let inc = if smallest { 1 } else { -1 };
        for c in &self.constraint {
            loop {
                ans[c.i] = ans[c.j] + self.add_y[c.j] + self.add_x[c.i];
                if 0 < ans[c.i] && ans[c.i] <= 9 {
                    break;
                }
                ans[c.j] += inc;
                if 9 < ans[c.j] || ans[c.j] < 0 {
                    panic!("constraint failed {c:?}")
                }
            }
        }
        let mut n: i64 = 0;
        for a in &ans {
            n = n * 10 + a;
        }
        n
    }
}

fn main() {
    let inp = aoc::slurp_input_file();
    aoc::benchme(|bench: bool| {
        let prog = Prog::new(&inp);
        let p1 = prog.solve(false);
        let p2 = prog.solve(true);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}
