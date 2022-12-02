struct Rogue {
    rows: Vec<Vec<bool>>,
    width: usize,
    count: usize,
}

impl Rogue {
    fn new(row: &str) -> Rogue {
        let width = row.len();
        let mut count = 0;
        let rows = vec![row
            .as_bytes()
            .iter()
            .map(|ch| {
                let res = *ch == b'^';
                if !res {
                    count += 1
                };
                res
            })
            .collect::<Vec<bool>>()];
        Rogue { rows, width, count }
    }
    fn add(&mut self) {
        // add a row
        let l = self.rows.len();
        self.rows.push(vec![]);
        for x in 0..self.width {
            let left_trap = x > 0 && self.rows[l - 1][x - 1];
            let right_trap = x < self.width - 1 && self.rows[l - 1][x + 1];
            let new = (left_trap && !right_trap) || (right_trap && !left_trap);
            if !new {
                self.count += 1;
            }
            self.rows[l].push(new);
        }
    }
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let mut r = Rogue::new(&inp);
        while r.rows.len() < 40 {
            r.add();
        }
        let p1 = r.count;
        while r.rows.len() < 400000 {
            r.add();
        }
        let p2 = r.count;
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rogue_new_works() {
        let r = Rogue::new(&"..^^.".to_string());
        assert_eq!(r.width, 5, "rogue new - width");
        assert_eq!(r.count, 3, "rogue new - count");
        assert_eq!(
            r.rows,
            vec![vec![false, false, true, true, false]],
            "rogue new - rows",
        );
    }

    #[test]
    fn rogue_add_works() {
        let mut r = Rogue::new(&"..^^.".to_string());
        r.add();
        assert_eq!(
            r.rows,
            vec![
                vec![false, false, true, true, false],
                vec![false, true, true, true, true],
            ],
            "rogue add example 1, row 2",
        );
        assert_eq!(r.count, 4, "rogue add example 1, row 2, new count");
        r.add();
        assert_eq!(
            r.rows,
            vec![
                vec![false, false, true, true, false],
                vec![false, true, true, true, true],
                vec![true, true, false, false, true],
            ],
            "rogue add example 1, row 3",
        );
        assert_eq!(r.count, 6, "rogue add example 1, row 3, new count");
        let mut r_ex2 = Rogue::new(&".^^.^.^^^^".to_string());
        for _n in 0..9 {
            r_ex2.add();
        }
        assert_eq!(r_ex2.count, 38, "rogue add example 2, count");
    }
}
