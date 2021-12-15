#[derive(Debug, Clone, Copy, PartialEq, Eq, PartialOrd, Ord, Hash, Default)]
struct Deer {
    speed: usize,
    run_time: usize,
    rest_time: usize,
}

impl Deer {
    fn new(s: &str) -> Deer {
        let mut v = aoc::uints::<usize>(s);
        Deer {
            speed: v.next().unwrap(),
            run_time: v.next().unwrap(),
            rest_time: v.next().unwrap(),
        }
    }
    fn dist(&self, t: usize) -> usize {
        let combined_time = self.run_time + self.rest_time;
        let iterations = t / combined_time;
        let mut remaining_run_time = t % combined_time;
        if remaining_run_time > self.run_time {
            remaining_run_time = self.run_time
        }
        self.speed * (iterations * self.run_time + remaining_run_time)
    }
}

fn max_dist(deers: &[Deer], t: usize) -> usize {
    deers.iter().map(|d| d.dist(t)).max().unwrap()
}

fn max_score(deers: &[Deer], t: usize) -> usize {
    deers
        .iter()
        .map(|d| {
            (1..=t)
                .map(|rt| {
                    if d.dist(rt) == max_dist(deers, rt) {
                        1
                    } else {
                        0
                    }
                })
                .sum::<usize>()
        })
        .max()
        .unwrap()
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let deers: Vec<Deer> = inp.iter().map(|l| Deer::new(l)).collect();
        let race_time = {
            if aoc::is_test() {
                1000
            } else {
                2503
            }
        };
        let p1 = max_dist(&deers, race_time);
        let p2 = max_score(&deers, race_time);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn works() {
    let comet =
        Deer::new("Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.");
    let dancer =
        Deer::new("Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.");
    let deers: Vec<Deer> = vec![comet, dancer];
    assert_eq!(max_dist(&deers, 1000), 1120, "part 1 test");
    assert_eq!(max_score(&deers, 1000), 689, "part 2 test");
}
