use arrayvec::ArrayVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut points: ArrayVec<(i32, i32), 50> = ArrayVec::default();
    let mut i = 0;
    let (mut minx, mut maxx) = (i32::MAX, i32::MIN);
    let (mut miny, mut maxy) = (i32::MAX, i32::MIN);
    while i < inp.len() {
        let (j, x) = aoc::read::uint::<i32>(inp, i);
        let (j, y) = aoc::read::uint::<i32>(inp, j + 2);
        points.push((x, y));
        if x < minx {
            minx = x;
        }
        if x > maxx {
            maxx = x;
        }
        if y < miny {
            miny = y;
        }
        if y > maxy {
            maxy = y;
        }
        i = j + 1;
    }
    //eprintln!("{:?}", points);
    //eprintln!("{},{} - {},{}", minx, miny, maxx, maxy);
    let mut areas: [Option<i32>; 50] = [Some(0); 50];
    for y in miny..=maxy {
        for x in minx..=maxx {
            if let Some(ci) = closest(&points[0..points.len()], x, y) {
                if x == minx || x == maxx || y == miny || y == maxy {
                    areas[ci] = None;
                    continue;
                }
                match areas[ci] {
                    Some(n) => areas[ci] = Some(n + 1),
                    None => {}
                }
            }
        }
    }
    //eprintln!("areas: {:?}", areas);
    let mut p1 = 0;
    for a in areas {
        if let Some(n) = a {
            if n > p1 {
                p1 = n;
            }
        }
    }
    let d = if points.len() > 10 { 10000 } else { 32 } as u32;

    let mut p2 = 0;
    let (mx, my) = ((maxx - minx) / 2, (maxy - miny) / 2);
    let mut dim = 0;
    loop {
        let mut finished = true;
        for y in my - dim..my + dim + 1 {
            for x in &[mx - dim, mx + dim] {
                let mut mds = 0;
                for (px, py) in &points {
                    mds += px.abs_diff(*x) + py.abs_diff(y);
                }
                if mds < d {
                    p2 += 1;
                    finished = false;
                }
            }
        }
        for x in mx - dim + 1..mx + dim {
            for y in &[my - dim, my + dim] {
                let mut mds = 0;
                for (px, py) in &points {
                    mds += px.abs_diff(x) + py.abs_diff(*y);
                }
                if mds < d {
                    p2 += 1;
                    finished = false;
                }
            }
        }
        if finished {
            break;
        }
        dim += 1;
    }
    (p1 as usize, p2 - 1)
}

fn closest(p: &[(i32, i32)], x: i32, y: i32) -> Option<usize> {
    let mut min = u32::MAX;
    let mut min_index: Option<usize> = None;
    for (i, (px, py)) in p.iter().enumerate() {
        let md = px.abs_diff(x) + py.abs_diff(y);
        if md < min {
            min = md;
            min_index = Some(i);
        } else if md == min {
            min_index = None;
        }
    }
    min_index
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
        let inp = std::fs::read("../2018/06/test.txt").expect("read error");
        assert_eq!(parts(&inp), (17, 16));
        let inp = std::fs::read("../2018/06/input.txt").expect("read error");
        assert_eq!(parts(&inp), (6047, 46320));
        let inp = std::fs::read("../2018/06/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (2342, 43302));
    }
}
