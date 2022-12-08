type Int = i32;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut w = 0;
    while inp[w] != b'\n' {
        w += 1;
    }
    let w1 = w + 1;
    let h = inp.len() / w1;
    let w1i = (w + 1) as Int;
    let w1xh = w1i * h as Int;
    let inc: [Int; 4] = [-1, 1, -(w1 as Int), w1 as Int];
    for i in 0..inp.len() {
        let t = inp[i];
        if t == b'\n' {
            continue; // not a tree
        }
        let mut p1_done = false;
        let mut score = 1;
        for di in inc {
            let mut ni = i as Int;
            ni += di;
            let mut view = 0;
            let mut visible = true;
            while ni >= 0 && ni < w1xh && ni % w1i != w as Int {
                view += 1;
                if inp[ni as usize] >= t {
                    visible = false;
                    break;
                }
                ni += di;
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
