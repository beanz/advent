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
}
trait RunningDeer {
    fn dist(&self, t: usize) -> usize;
}

impl RunningDeer for Deer {
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

fn max_dist<I: RunningDeer, T: Iterator<Item = I>>(deers: T, t: usize) -> usize {
    deers.map(|d| d.dist(t)).max().unwrap()
}

fn max_dist_vec(deers: &Vec<Deer>, t: usize) -> usize {
    deers.iter().map(|d| d.dist(t)).max().unwrap()
}

fn main() {
    let deers = aoc::read_input_lines().map(|l| Deer::new(&l.unwrap()));
    let race_time = {
        if aoc::is_test() {
            2503
        } else {
            1000
        }
    };
    println!("Part 1: {}", max_dist(deers, race_time));
    let deers2: Vec<Deer> = aoc::read_input_lines()
        .map(|l| Deer::new(&l.unwrap()))
        .collect();
    println!(
        "Part 2: {}",
        deers2
            .iter()
            .map(|d| {
                (1..=race_time)
                    .map(|rt| {
                        if d.dist(rt) == max_dist_vec(&deers2, rt) {
                            1
                        } else {
                            0
                        }
                    })
                    .sum::<usize>()
            })
            .max()
            .unwrap()
    );
}
