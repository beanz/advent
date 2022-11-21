use std::collections::HashSet;

fn parts(inp: &str) -> (usize, String) {
    let mut chunks = inp.split("\n\n");
    let mut points: HashSet<[usize; 2]> = HashSet::new();
    let point_line = chunks.next().unwrap();
    let ints = aoc::ints(point_line).collect::<Vec<usize>>();
    for p in ints.chunks(2) {
        points.insert([p[0], p[1]]);
    }
    let mut max = vec![0, 0];
    let mut p1: Option<usize> = None;
    for l in chunks.next().unwrap().lines() {
        let mut s = l.split('=');
        let fold: &[u8] = s.next().unwrap().as_bytes();
        let n = s.next().unwrap().parse::<usize>().unwrap();
        let axis = (fold[fold.len() - 1] - b'x') as usize;
        let mut npoints: HashSet<[usize; 2]> = HashSet::new();
        for p in &points {
            let mut np = [p[0], p[1]];
            if np[axis] > n {
                np[axis] =
                    (n as isize - (np[axis] as isize - n as isize)) as usize;
            }
            npoints.insert(np);
        }
        points = npoints;
        max[axis] = n;
        if p1.is_none() {
            p1 = Some(points.len());
        }
    }
    let mut s: Vec<u8> = vec![];
    for y in 0..max[1] {
        for x in 0..max[0] {
            if points.contains(&[x, y]) {
                s.push(b'#');
            } else {
                s.push(b' ');
            }
        }
        s.push(b'\n');
    }
    let p2 = String::from_utf8(s).expect("invalid utf-8");
    (p1.expect("no folds?"), p2)
}

fn main() {
    let inp = aoc::slurp_input_file();
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2:\n{}", p2);
        }
    })
}
