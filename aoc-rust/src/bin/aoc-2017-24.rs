use heapless::Vec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut comp = Vec::<(u8, u8), 64>::new();
    let mut i = 0;
    while i < inp.len() {
        let (j, a) = aoc::read::uint::<u8>(inp, i);
        let (j, b) = aoc::read::uint::<u8>(inp, j + 1);
        comp.push((a, b)).expect("comp full");
        i = j + 1;
    }
    search(&comp)
}

fn search(comp: &[(u8, u8)]) -> (usize, usize) {
    let mut todo = Vec::<(u8, u64, usize, usize), 64>::new();
    todo.push((0, 0, 0, 0)).expect("todo full");
    let mut best_strength = 0;
    let mut best_len = 0;
    let mut best_len_strength = 0;
    while let Some((cur, used, l, sc)) = todo.pop() {
        if sc > best_strength {
            best_strength = sc;
        }
        if l > best_len || (l == best_len && sc > best_len_strength) {
            best_len = l;
            best_len_strength = sc;
        }
        for i in 0..comp.len() {
            let bit = 1 << i;
            if used & bit != 0 {
                continue;
            }
            let nxt = comp[i];
            let nused = used | bit;
            if cur == nxt.0 {
                todo.push((nxt.1, nused, l + 1, sc + (nxt.0 + nxt.1) as usize))
                    .expect("todo full");
            } else if cur == nxt.1 {
                todo.push((nxt.0, nused, l + 1, sc + (nxt.0 + nxt.1) as usize))
                    .expect("todo full");
            }
        }
    }

    (best_strength, best_len_strength)
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
        let inp = std::fs::read("../2017/24/test.txt").expect("read error");
        assert_eq!(parts(&inp), (31, 19));
        let inp = std::fs::read("../2017/24/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1940, 1928));
        let inp = std::fs::read("../2017/24/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (1868, 1841));
    }
}
