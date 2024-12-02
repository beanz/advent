use smallvec::SmallVec;

fn safe(nums: &SmallVec<[i32; 16]>, skip: Option<usize>) -> bool {
    let v = |i| {
        if let Some(o) = skip {
            if i >= o {
                nums[i + 1]
            } else {
                nums[i]
            }
        } else {
            nums[i]
        }
    };
    let end = if let Some(_) = skip {
        nums.len() - 2
    } else {
        nums.len() - 1
    };
    let dir = v(0) - v(1);
    for i in 0..end {
        let d = v(i) - v(i + 1);
        if d * dir <= 0 || d.unsigned_abs() > 3 {
            return false;
        }
    }
    true
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut nums = SmallVec::<[i32; 16]>::new();
    let mut i = 0;
    let mut p1 = 0;
    let mut p2 = 0;
    while i < inp.len() {
        loop {
            let (j, n) = aoc::read::uint::<i32>(inp, i);
            i = j;
            nums.push(n);
            if inp[i] == b'\n' {
                break;
            }
            i += 1;
        }
        if safe(&nums, None) {
            p1 += 1;
            p2 += 1;
        } else {
            for i in 0..nums.len() {
                if safe(&nums, Some(i)) {
                    p2 += 1;
                    break;
                }
            }
        }
        nums.clear();
        i += 1;
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
        aoc::test::auto("../2024/02/", parts);
    }
}
