use smallvec::SmallVec;

fn is_valid(nums: &SmallVec<[usize; 16]>, i: usize, sub: usize, total: usize, p2: bool) -> bool {
    if i == nums.len() {
        return sub == total;
    }
    if is_valid(nums, i + 1, sub + nums[i], total, p2) {
        return true;
    }
    if is_valid(nums, i + 1, sub * nums[i], total, p2) {
        return true;
    }
    if !p2 {
        return false;
    }
    let mut sub = sub;
    let mut t = nums[i];
    while t > 0 {
        sub *= 10;
        t /= 10;
    }
    sub += nums[i];
    is_valid(nums, i + 1, sub, total, p2)
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut i = 0;
    let mut p1 = 0;
    let mut p2 = 0;
    let mut nums = SmallVec::<[usize; 16]>::new();
    while i < inp.len() {
        let (j, total) = aoc::read::uint::<usize>(inp, i);
        i = j + 2;
        loop {
            let (j, n) = aoc::read::uint::<usize>(inp, i);
            i = j + 1;
            nums.push(n);
            if inp[i - 1] == b'\n' {
                break;
            }
        }
        if is_valid(&nums, 1, nums[0], total, false) {
            p1 += total;
            p2 += total;
            nums.clear();
            continue;
        }
        if is_valid(&nums, 1, nums[0], total, true) {
            p2 += total;
        }
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
        aoc::test::auto("../2024/07/", parts);
    }
}
