use heapless::{FnvIndexMap, Vec};

#[derive(Debug, Clone, Default)]
struct Rec {
    i: usize,
    si: usize,
    steps: usize,
    prev: usize,
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let w = inp.iter().position(|&ch| ch == b'\n').unwrap();
    (graph(inp, w, true), graph(inp, w, false))
}

fn graph(inp: &[u8], w: usize, part1: bool) -> usize {
    let w1 = w + 1;
    let start = 1 + w1;
    let end = inp.len() - 3 - w1;
    let offsets: [isize; 4] = [-1, 1, -(w1 as isize), w1 as isize];
    let chars: [u8; 4] = [b'<', b'>', b'^', b'v'];
    let char_at = |pos: usize| {
        if pos == 1 || pos == inp.len() - 3 {
            b'#'
        } else {
            inp[pos]
        }
    };
    let mut g = FnvIndexMap::<usize, FnvIndexMap<usize, usize, 32>, 2048>::new();
    let mut todo = aoc::deque::Deque::<Rec, 128>::default();
    todo.push(Rec {
        i: start,
        si: start,
        steps: 0,
        prev: start,
    });
    let mut visit = [false; 32000];
    while let Some(cur) = todo.pop() {
        let mut n = Vec::<usize, 4>::new();
        let ch = char_at(cur.i);
        for k in 0..4 {
            let o = offsets[k];
            let dir = chars[k];
            let np = (cur.i as isize + o) as usize;
            if char_at(np) == b'#' {
                continue;
            }
            if part1 && ch != b'.' && ch != dir {
                continue;
            }
            if !part1 && ch == b'#' {
                continue;
            }
            n.push(np).expect("insert");
        }
        if n.len() > 2 || cur.i == end {
            if !g.contains_key(&cur.si) {
                g.insert(cur.si, FnvIndexMap::<usize, usize, 32>::new())
                    .expect("insert");
            }
            g.get_mut(&cur.si)
                .unwrap()
                .insert(cur.i, cur.steps)
                .expect("insert");
            if !part1 {
                if !g.contains_key(&cur.i) {
                    g.insert(cur.i, FnvIndexMap::<usize, usize, 32>::new())
                        .expect("insert");
                }
                g.get_mut(&cur.i)
                    .unwrap()
                    .insert(cur.si, cur.steps)
                    .expect("insert");
            }
            if visit[cur.i] {
                continue;
            }
            visit[cur.i] = true;
            for ni in n {
                if cur.prev == ni {
                    continue;
                }
                todo.push(Rec {
                    i: ni,
                    si: cur.i,
                    steps: 1,
                    prev: cur.i,
                });
            }
            continue;
        }
        for ni in n {
            if cur.prev == ni {
                continue;
            }
            todo.push(Rec {
                i: ni,
                si: cur.si,
                steps: cur.steps + 1,
                prev: cur.i,
            });
        }
    }

    let mut todo = Vec::<(usize, Option<usize>), 128>::new();
    todo.push((start, Some(0))).expect("insert");
    let mut visit = [false; 32000];
    let mut res = 0;
    while let Some((i, steps)) = todo.pop() {
        if steps.is_none() {
            visit[i] = false;
            continue;
        }
        let steps = steps.unwrap();
        if i == end {
            if res < steps {
                res = steps;
            }
            continue;
        }
        if visit[i] {
            continue;
        }
        visit[i] = true;
        todo.push((i, None)).expect("insert");
        for (ni, nsteps) in g.get(&i).unwrap() {
            if !visit[*ni] {
                todo.push((*ni, Some(steps + nsteps))).expect("insert");
            }
        }
    }

    res + 2
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
        let inp = std::fs::read("../2023/23/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (94, 154));
        let inp = std::fs::read("../2023/23/input.txt").expect("read error");
        assert_eq!(parts(&inp), (2402, 6450));
    }
}
