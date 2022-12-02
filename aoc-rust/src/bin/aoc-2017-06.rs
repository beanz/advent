use std::collections::HashMap;

fn calc(banks: &mut [usize]) -> (usize, usize) {
    let mut seen: HashMap<Vec<usize>, usize> = HashMap::new();
    let mut c = 0;
    loop {
        if let Some(prev) = seen.get(&banks.to_vec()) {
            return (c, c - prev);
        }
        seen.insert(banks.to_vec(), c);
        let (maxi, max) =
            banks.iter().enumerate().fold(
                (0, 0),
                |max, (ind, &val)| {
                    if val > max.1 {
                        (ind, val)
                    } else {
                        max
                    }
                },
            );
        banks[maxi] = 0;
        let mut i = (maxi + 1) % banks.len();
        let mut n = max;
        while n > 0 {
            banks[i] += 1;
            n -= 1;
            i += 1;
            i %= banks.len();
        }
        c += 1;
    }
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let mut banks = aoc::ints::<usize>(&inp).collect::<Vec<usize>>();
        let (p1, p2) = calc(&mut banks);
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
    fn calc_works() {
        assert_eq!(calc(&mut [0, 2, 7, 0]), (5, 4), "example");
    }
}
