use heapless::{FnvIndexMap, FnvIndexSet, Vec};

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut g = FnvIndexMap::<u16, FnvIndexSet<u16, 32>, 2048>::new();
    let mut names = FnvIndexMap::<u16, u16, 2048>::new();
    let mut id: u16 = 0;
    let node_id = |g: &mut FnvIndexMap<u16, FnvIndexSet<u16, 32>, 2048>,
                   names: &mut FnvIndexMap<u16, u16, 2048>,
                   id: &mut u16,
                   nb: &[u8]|
     -> u16 {
        let n =
            (((nb[0] - b'a') as u16) * 26 + ((nb[1] - b'a') as u16)) * 26 + ((nb[2] - b'a') as u16);
        if let Some(nid) = names.get(&n) {
            return *nid;
        }
        names.insert(n, *id).expect("insert");
        g.insert(*id, FnvIndexSet::<u16, 32>::new())
            .expect("insert");
        let nid = *id;
        *id += 1;
        nid
    };
    let mut i = 0;
    while i < inp.len() {
        let fid = node_id(&mut g, &mut names, &mut id, &inp[i..i + 3]);
        i += 4;
        while inp[i] == b' ' {
            let tid = node_id(&mut g, &mut names, &mut id, &inp[i + 1..i + 4]);
            g.get_mut(&fid).unwrap().insert(tid).expect("insert");
            g.get_mut(&tid).unwrap().insert(fid).expect("insert");
            i += 4;
        }
        i += 1;
    }
    let mut start = 0;
    let mut end = id - 1;

    while end > start {
        let p1 = find_cuts(&mut g, start, end);
        if p1 != 0 {
            return (p1 * (id as usize - p1), 1);
        }
        start += 1;
        end -= 1;
    }
    (1, 2)
}

fn find_cuts(g: &mut FnvIndexMap<u16, FnvIndexSet<u16, 32>, 2048>, start: u16, end: u16) -> usize {
    let mut cuts = Vec::<u32, 512>::new();
    let mut path = Vec::<u16, 512>::new();
    for _k in 0..3 {
        find_path(g, start, end, &cuts, &mut path);
        if path.is_empty() {
            return 0;
        }
        for i in 0..path.len() - 1 {
            cuts.push(edge(path[i], path[i + 1])).expect("insert");
        }
    }
    find_path(g, start, end, &cuts, &mut path);
    if !path.is_empty() {
        // still connected so start and end are in same partition; try again
        return 0;
    }
    let mut k = 0;
    while cuts.len() > 3 {
        let rm = cuts.pop().unwrap();
        find_path(g, start, end, &cuts, &mut path);
        if !path.is_empty() {
            let tmp = cuts[k];
            cuts[k] = rm;
            k += 1;
            cuts.push(tmp).expect("insert");
        }
    }
    let mut todo = aoc::deque::Deque::<u16, 1536>::default();
    todo.push(start);
    let mut e = [false; 1536];
    let mut p1 = 0;
    while let Some(cur) = todo.pop() {
        if e[cur as usize] {
            continue;
        }
        e[cur as usize] = true;
        p1 += 1;
        for nxt in g.get(&cur).unwrap() {
            if is_cut(&cuts, cur, *nxt) {
                continue;
            }
            todo.push(*nxt);
        }
    }

    p1
}

fn find_path(
    g: &mut FnvIndexMap<u16, FnvIndexSet<u16, 32>, 2048>,
    start: u16,
    end: u16,
    cuts: &Vec<u32, 512>,
    path: &mut Vec<u16, 512>,
) {
    path.clear();
    let mut todo = aoc::deque::Deque::<Vec<u16, 16>, 4096>::default();
    let mut s = Vec::<u16, 16>::new();
    s.push(start).expect("insert");
    todo.push(s);
    let mut visit: [bool; 1536] = [false; 1536];
    while let Some(cur) = todo.pop() {
        let node = cur[cur.len() - 1];
        if node == end {
            for e in cur {
                path.push(e).expect("insert");
            }
            return;
        }
        visit[node as usize] = true;
        for nxt in g.get(&node).unwrap() {
            if visit[*nxt as usize] {
                continue;
            }
            if is_cut(cuts, node, *nxt) {
                continue;
            }
            let mut npath = Vec::<u16, 16>::new();
            for e in cur.clone() {
                npath.push(e).expect("insert");
            }
            npath.push(*nxt).expect("insert");
            todo.push(npath);
        }
    }
    return;
}

fn is_cut(cuts: &Vec<u32, 512>, from: u16, to: u16) -> bool {
    let ne = edge(from, to);
    for e in cuts {
        if *e == ne {
            return true;
        }
    }
    false
}

fn edge(a: u16, b: u16) -> u32 {
    let a = a as u32;
    let b = b as u32;
    if a > b {
        1536 * a + b
    } else {
        1536 * b + a
    }
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
        let inp = std::fs::read("../2023/25/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (54, 1));
        let inp = std::fs::read("../2023/25/input.txt").expect("read error");
        assert_eq!(parts(&inp), (506202, 1));
    }
}
