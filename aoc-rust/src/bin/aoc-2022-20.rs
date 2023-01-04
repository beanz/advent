fn mix(nums: &[isize], rounds: usize, key: isize) -> isize {
    let len = nums.len();
    let mut idx: [usize; 5000] = [0; 5000];
    for (i, e) in idx.iter_mut().enumerate().take(len) {
        *e = i;
    }
    //pretty(&nums, &idx[0..len], key);
    for _ in 0..rounds {
        for (i, n) in nums.iter().enumerate().take(len) {
            let num = n * key;
            //eprintln!("moving {}", num);
            let mut j = 0;
            while idx[j] != i {
                j += 1
            }
            let ni = (j as isize + num).rem_euclid((len - 1) as isize) as usize;
            match ni.cmp(&j) {
                std::cmp::Ordering::Greater => idx.copy_within(j + 1..ni + 1, j),
                std::cmp::Ordering::Less => idx.copy_within(ni..j, ni + 1),
                _ => {}
            }
            idx[ni] = i;
            //pretty(&nums, &idx[0..len], key);
        }
    }
    let mut zero = 0;
    while nums[zero] != 0 {
        zero += 1
    }
    let mut n_zero = 0;
    while idx[n_zero] != zero {
        n_zero += 1;
    }
    nums[idx[(n_zero + 1000) % len]] * key
        + nums[idx[(n_zero + 2000) % len]] * key
        + nums[idx[(n_zero + 3000) % len]] * key
}

#[allow(dead_code)]
fn pretty(nums: &[isize], idx: &[usize], key: isize) {
    for i in idx {
        eprint!("{}, ", nums[*i] * key);
    }
    eprintln!();
}

fn parts(inp: &[u8]) -> (isize, isize) {
    let mut nums: [isize; 5000] = [0; 5000];
    let mut i = 0;
    let mut l = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<isize>(inp, i);
        nums[l] = n;
        l += 1;
        i = j + 1;
    }
    (mix(&nums[0..l], 1, 1), mix(&nums[0..l], 10, 811589153))
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
        let inp = std::fs::read("../2022/20/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (3, 1623178306));
        let inp = std::fs::read("../2022/20/input.txt").expect("read error");
        assert_eq!(parts(&inp), (17490, 1632917375836));
    }
}
