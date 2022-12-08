fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut w = 0;
    while inp[w] != b'\n' {
        w += 1;
    }
    let w1 = w + 1;
    let h = inp.len() / w1;
    let inc: [usize; 4] = [w1 - 1, w1 + 1, 0, 2 * w1]; // -1,1,-w1,w1
    for i in 0..inp.len() {
        let t = inp[i];
        if t == b'\n' {
            continue; // not a tree
        }
        let mut p1_done = false;
        let mut score = 1;
        for di in inc {
            let mut ni = i;
            (ni, _) = (ni + di).overflowing_sub(w1);
            let mut view = 0;
            let mut visible = true;
            while ni % w1 != w && ni < w1 * h {
                view += 1;
                if inp[ni] >= t {
                    visible = false;
                    break;
                }
                (ni, _) = (ni + di).overflowing_sub(w1);
            }
            score *= view;
            if visible && !p1_done {
                p1 += 1;
                p1_done = true;
            }
            if score == 0 && p1_done {
                break;
            }
        }
        if score > p2 {
            p2 = score
        }
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
        let inp = std::fs::read("../2022/08/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (21, 8));
        let inp = std::fs::read("../2022/08/input.txt").expect("read error");
        assert_eq!(parts(&inp), (1681, 201684));
    }
}
