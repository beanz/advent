use smallvec::SmallVec;

fn solve(s: &[u8], nums: &[usize]) -> usize {
    let mut mat: [u8; 256] = [0; 256];
    mat[0] = b'.';
    let mut l = 1;
    for n in nums {
        for _ in 0..*n {
            mat[l] = b'#';
            l += 1;
        }
        mat[l] = b'.';
        l += 1;
    }
    let mat = &mat[0..l];
    let mut state_count: [usize; 256] = [0; 256];
    state_count[0] = 1;
    let mut next_state_count: [usize; 256] = [0; 256];
    for ch in s {
        for state in 0..256 {
            let count = state_count[state];
            if count == 0 {
                continue;
            }
            state_count[state] = 0;
            if *ch == b'#' {
                if state + 1 < mat.len() && mat[state + 1] == b'#' {
                    next_state_count[state + 1] += count;
                }
            } else if *ch == b'.' {
                if state + 1 < mat.len() && mat[state + 1] == b'.' {
                    next_state_count[state + 1] += count;
                }
                if mat[state] == b'.' {
                    next_state_count[state] += count;
                }
            } else {
                if state + 1 < mat.len() {
                    next_state_count[state + 1] += count;
                }
                if mat[state] == b'.' {
                    next_state_count[state] += count;
                }
            }
        }
        std::mem::swap(&mut next_state_count, &mut state_count)
    }
    state_count[mat.len() - 1] + state_count[mat.len() - 2]
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let (mut p1, mut p2) = (0, 0);
    let mul = 5;
    let mut i = 0;
    let mut nums = SmallVec::<[usize; 128]>::new();
    while i < inp.len() {
        let start = i;
        let end = inp[i..].iter().position(|&ch| ch == b' ').unwrap();
        i += end + 1;
        aoc::read::visit_uint_until(inp, &mut i, b'\n', |x: usize| {
            nums.push(x);
        });
        let ns = nums.as_slice();
        p1 += solve(&inp[start..start + end], ns);
        let mut nums2 = SmallVec::<[usize; 128]>::new();
        for _ in 0..mul {
            for n in ns {
                nums2.push(*n);
            }
        }
        let ns = nums2.as_slice();
        let mut in2: [u8; 256] = [0; 256];
        let mut l2 = 0;
        for ch in &inp[start..start + end] {
            in2[l2] = *ch;
            l2 += 1;
        }
        for _ in 1..mul {
            in2[l2] = b'?';
            l2 += 1;
            for ch in &inp[start..start + end] {
                in2[l2] = *ch;
                l2 += 1;
            }
        }
        p2 += solve(&in2[0..l2], ns);
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
        let inp = std::fs::read("../2023/12/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (21, 525152));
        let inp = std::fs::read("../2023/12/input.txt").expect("read error");
        assert_eq!(parts(&inp), (6488, 815364548481));
    }
}
