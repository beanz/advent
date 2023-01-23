use arrayvec::ArrayVec;
use heapless::FnvIndexMap;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut graph = FnvIndexMap::<(i32, i32), usize, 16384>::new();
    let mut stack: ArrayVec<(i32, i32, usize), 256> = ArrayVec::default();
    let (mut x, mut y, mut d) = (0, 0, 0);
    for i in 1..inp.len() - 1 {
        match inp[i] {
            b'(' => stack.push((x, y, d)),
            b')' => (x, y, d) = stack.pop().expect("stack empty"),
            b'|' => (x, y, d) = stack[stack.len() - 1],
            _ => {
                x += i32::from(inp[i] == b'E') - i32::from(inp[i] == b'W');
                y += i32::from(inp[i] == b'S') - i32::from(inp[i] == b'N');
                d += 1;
                if let Some(pd) = graph.get(&(x, y)) {
                    if d >= *pd {
                        continue;
                    }
                }
                graph.insert((x, y), d).expect("graph full");
            }
        }
    }
    let mut p1 = usize::MIN;
    let mut p2 = 0;
    for dist in graph.values() {
        p1 = p1.max(*dist);
        if *dist >= 1000 {
            p2 += 1;
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
        let inp = std::fs::read("../2018/20/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (5, 0));
        let inp = std::fs::read("../2018/20/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (10, 0));
        let inp = std::fs::read("../2018/20/test3.txt").expect("read error");
        assert_eq!(parts(&inp), (18, 0));
        let inp = std::fs::read("../2018/20/test4.txt").expect("read error");
        assert_eq!(parts(&inp), (23, 0));
        let inp = std::fs::read("../2018/20/test5.txt").expect("read error");
        assert_eq!(parts(&inp), (31, 0));
        let inp = std::fs::read("../2018/20/input.txt").expect("read error");
        assert_eq!(parts(&inp), (3560, 8688));
        let inp = std::fs::read("../2018/20/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (4214, 8492));
    }
}
