use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut seeds = SmallVec::<[usize; 32]>::new();
    let mut seed_ranges = SmallVec::<[(usize, usize); 128]>::new();
    let mut i = 0;
    let mut start: Option<usize> = None;
    aoc::read::visit_uint_until::<usize>(inp, &mut i, b'\n', |x: usize| {
        seeds.push(x);
        if let Some(s) = start {
            seed_ranges.push((s, s + x));
            start = None;
        } else {
            start = Some(x);
        }
    });
    i += 2;

    while i < inp.len() {
        while inp[i] != b'\n' {
            i += 1
        }
        i += 1;
        let mut map = SmallVec::<[usize; 1024]>::new();
        while i < inp.len() {
            aoc::read::visit_uint_until::<usize>(inp, &mut i, b'\n', |x: usize| {
                map.push(x);
            });
            i += 1;
            if i >= inp.len() || inp[i] == b'\n' {
                break;
            }
        }
        i += 1;
        for s in &mut seeds {
            for me in map.chunks(3) {
                let (dst, src, len) = (me[0], me[1], me[2]);
                if src <= *s && *s < src + len {
                    *s = dst + *s - src;
                    break;
                }
            }
        }
        let mut mapped = SmallVec::<[(usize, usize); 128]>::new();
        'outer: while let Some((start, end)) = seed_ranges.pop() {
            for s in map.chunks(3) {
                let (dst, src, src_end) = (s[0], s[1], s[1] + s[2]);
                let before_start = start;
                let before_end = if end < src { end } else { src };
                let overlap_start = if start > src { start } else { src };
                let overlap_end = if src_end < end { src_end } else { end };
                let after_start = if src_end > start { src_end } else { start };
                let after_end = end;
                if overlap_end > overlap_start {
                    mapped.push((overlap_start + dst - src, overlap_end + dst - src));
                } else {
                    continue;
                }
                if before_end > before_start {
                    seed_ranges.push((before_start, before_end));
                }
                if after_end > after_start {
                    seed_ranges.push((after_start, after_end));
                }
                continue 'outer;
            }
            mapped.push((start, end));
        }
        std::mem::swap(&mut mapped, &mut seed_ranges);
    }

    seeds.select_nth_unstable(0);
    seed_ranges.select_nth_unstable(0);

    (*seeds.first().unwrap(), seed_ranges.first().unwrap().0)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2023/05/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (35, 46));
        let inp = std::fs::read("../2023/05/input.txt").expect("read error");
        assert_eq!(parts(&inp), (535088217, 51399228));
    }
}
