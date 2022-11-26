type Int = usize;

struct Report<'a> {
    expenses: &'a [Int],
}

use ahash::RandomState;
use std::collections::HashMap;
use std::collections::HashSet;

impl<'a> Report<'a> {
    fn new(expenses: &'a [Int]) -> Report {
        Report { expenses }
    }

    fn parts(&mut self) -> (Int, Int) {
        let mut p1 = 0;
        let mut p2 = 0;
        let mut seen: HashSet<Int, RandomState> = HashSet::default();
        let mut sum2prod: HashMap<Int, Int, RandomState> = HashMap::default();
        for ex in self.expenses {
            let rem = 2020 - ex;
            if seen.contains(&rem) {
                p1 = ex * rem;
            }
            for other in &seen {
                sum2prod.insert(ex + other, ex * other);
            }
            seen.insert(*ex);
        }
        for ex in self.expenses {
            let rem = 2020 - ex;
            if let Some(p) = sum2prod.get(&rem) {
                p2 = ex * p;
                break;
            }
        }
        (p1, p2)
    }
}
use arrayvec::ArrayVec;

fn main() {
    let inp = aoc::black_box(aoc::slurp_input_file());
    aoc::benchme(|bench: bool| {
        let expenses = aoc::uints::<Int>(&inp).collect::<ArrayVec<Int, 200>>();
        let mut report = Report::new(&expenses);
        let (p1, p2) = report.parts();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn parts_works() {
    let report: Vec<Int> = vec![1721, 979, 366, 299, 675, 1456];
    assert_eq!(
        Report::new(&report).parts(),
        (514579, 241861950),
        "parts test"
    );
}
