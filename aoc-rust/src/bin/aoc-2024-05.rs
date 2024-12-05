use smallvec::SmallVec;
use std::cmp::Ordering;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut rules: [bool; 16384] = [false; 16384];
    let mut i = 0;
    while i < inp.len() {
        let (j, a) = aoc::read::uint::<usize>(inp, i);
        let (j, b) = aoc::read::uint::<usize>(inp, j + 1);
        rules[(a << 7) + b] = true;
        i = j + 1;
        if inp[i] == b'\n' {
            i += 1;
            break;
        }
    }
    let mut p1 = 0;
    let mut p2 = 0;
    let mut nums = SmallVec::<[usize; 128]>::new();
    while i < inp.len() {
        while i < inp.len() {
            let (j, a) = aoc::read::uint::<usize>(inp, i);
            i = j + 1;
            nums.push(a);
            if inp[j] == b'\n' {
                break;
            }
        }

        if nums.windows(2).all(|w| rules[(w[0] << 7) + w[1]]) {
            p1 += nums[nums.len() / 2];
            nums.clear();
            continue;
        }
        nums.sort_by(|a, b| {
            if rules[(a << 7) + b] {
                Ordering::Less
            } else {
                Ordering::Greater
            }
        });
        p2 += nums[nums.len() / 2];
        nums.clear();
    }

    (p1, p2)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/05/", parts);
    }
}
