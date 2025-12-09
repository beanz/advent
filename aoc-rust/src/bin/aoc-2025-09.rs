use heapless::Vec;

#[derive(Debug)]
struct Point {
    x: i32,
    y: i32,
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut points = Vec::<Point, 512>::new();
    let mut i: usize = 0;
    while i < inp.len() {
        let (j, x) = aoc::read::uint::<i32>(inp, i);
        i = j + 1;
        let (j, y) = aoc::read::uint::<i32>(inp, i);
        i = j + 1;
        points.push(Point { x, y }).expect("overflow");
    }
    let mut p1: usize = 0;
    let mut p2: usize = 0;
    for i in 0..points.len() {
        'outer: for j in i + 1..points.len() {
            let dx: usize = (1 + (points[i].x - points[j].x).unsigned_abs()) as usize;
            let dy: usize = (1 + (points[i].y - points[j].y).unsigned_abs()) as usize;
            let a: usize = dx * dy;
            p1 = p1.max(a);
            if a < p2 {
                continue 'outer;
            }
            let min_x: i32 = points[i].x.min(points[j].x);
            let max_x: i32 = points[i].x.max(points[j].x);
            let min_y: i32 = points[i].y.min(points[j].y);
            let max_y: i32 = points[i].y.max(points[j].y);
            for k in 0..points.len() {
                if k == i || k == j {
                    continue;
                }
                let l: usize = (k + 1) % points.len();
                if l == i || l == j {
                    continue;
                }
                let min_x_l: i32 = points[k].x.min(points[l].x);
                let max_x_l: i32 = points[k].x.max(points[l].x);
                let min_y_l: i32 = points[k].y.min(points[l].y);
                let max_y_l: i32 = points[k].y.max(points[l].y);
                if !(max_x_l <= min_x || max_x <= min_x_l || max_y_l <= min_y || max_y <= min_y_l) {
                    continue 'outer;
                }
            }
            p2 = a;
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
        aoc::test::auto("../2025/09/", parts);
    }
}
