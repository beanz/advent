struct Scanner {
    range: usize,
    depth: usize,
}

struct Firewall {
    slots: Vec<Scanner>,
}

impl Firewall {
    fn new(inp: &[String]) -> Firewall {
        let mut slots: Vec<Scanner> = Vec::new();
        for l in inp {
            let uints: Vec<usize> = aoc::uints::<usize>(l).collect();
            slots.push(Scanner {
                depth: uints[0],
                range: uints[1],
            });
        }
        Firewall { slots }
    }
    fn run(&self, delay: usize) -> (usize, bool) {
        let mut sev = 0;
        let mut caught = false;
        for scanner in &self.slots {
            if ((delay + scanner.depth) % ((scanner.range - 1) * 2)) == 0 {
                //println!("hit at depth {}", scanner.depth);
                sev += scanner.depth * scanner.range;
                caught = true;
            }
        }
        (sev, caught)
    }
    fn part1(&self) -> usize {
        let (sev, _) = self.run(0);
        sev
    }
    fn part2(&self) -> usize {
        for delay in 0.. {
            let (_, caught) = self.run(delay);
            if !caught {
                return delay;
            }
        }
        0
    }
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let fw = Firewall::new(&inp);
        let p1 = fw.part1();
        let p2 = fw.part2();
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
    fn parts_work() {
        let ex: Vec<String> = ["0: 3", "1: 2", "4: 4", "6: 4"]
            .iter()
            .map(|x| x.to_string())
            .collect::<Vec<String>>();
        let fw = Firewall::new(&ex);
        assert_eq!(fw.part1(), 24);
        assert_eq!(fw.part2(), 10);
    }
}
