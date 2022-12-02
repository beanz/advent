use itertools::*;
use std::collections::HashMap;

pub struct Routes {
    places: HashMap<String, u16>,
    dist: HashMap<(u16, u16), i32>,
}

impl Routes {
    fn new() -> Routes {
        Routes {
            places: HashMap::new(),
            dist: HashMap::new(),
        }
    }
    fn city_id(&mut self, city: &str) -> u16 {
        let next = self.places.len() as u16;
        *self.places.entry(city.to_string()).or_insert(next)
    }
    fn add(&mut self, s: &str) {
        let words: Vec<&str> = s.split(' ').collect();
        let dist = words[4].parse::<i32>().unwrap();
        let src = self.city_id(words[0]);
        let dest = self.city_id(words[2]);
        if src < dest {
            self.dist.insert((src, dest), dist);
        } else {
            self.dist.insert((dest, src), dist);
        }
    }
    fn dist(&self, a: u16, b: u16) -> i32 {
        if a < b {
            return *self.dist.get(&(a, b)).unwrap();
        }
        *self.dist.get(&(b, a)).unwrap()
    }
    fn minmax(&mut self) -> (i32, i32) {
        if let MinMaxResult::MinMax(x, y) = (0..self.places.len() as u16)
            .permutations(self.places.len())
            .map(|x| {
                x.windows(2)
                    .map(|cities| self.dist(cities[0], cities[1]))
                    .sum()
            })
            .minmax()
        {
            (x, y)
        } else {
            (-1, -1)
        }
    }
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let mut routes = Routes::new();
        for l in &inp {
            routes.add(l);
        }
        let (p1, p2) = routes.minmax();
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
    fn routes_works() {
        let mut routes = Routes::new();
        routes.add("London to Dublin = 464");
        routes.add("London to Belfast = 518");
        routes.add("Dublin to Belfast = 141");
        assert_eq!(routes.dist(0, 1), 464, "distance between first two");
        assert_eq!(routes.dist(1, 0), 464, "distance back again is the same");
        let (p1, p2) = routes.minmax();
        assert_eq!(p1, 605, "shortest");
        assert_eq!(p2, 982, "longest");
    }
}
