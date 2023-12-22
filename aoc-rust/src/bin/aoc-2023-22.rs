use smallvec::SmallVec;

const SIZE: usize = 1210;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut bricks = SmallVec::<[[u16; 6]; 2048]>::new();
    let mut k: usize = 0;
    let mut cur: [u16; 6] = [0; 6];
    aoc::read::visit_uints(inp, |n| {
        cur[k] = n;
        if k >= 3 {
            cur[k] += 1;
        }
        k += 1;
        if k == 6 {
            k = 0;
            let b: [u16; 6] = [cur[0], cur[1], cur[2], cur[3], cur[4], cur[5]];
            bricks.push(b);
        }
    });
    bricks.sort_by(|a, b| a[2].cmp(&b[2]));
    let intersected = |a: &[u16; 6], b: &[u16; 6]| {
        if a[2] >= b[5] || b[2] >= a[5] {
            return false;
        }
        if a[1] >= b[4] || b[1] >= a[4] {
            return false;
        }
        if a[0] >= b[3] || b[0] >= a[3] {
            return false;
        }
        true
    };
    let mut height: [u16; 121] = [0; 121];
    let stop_z = |xmin: u16, xmax: u16, ymin: u16, ymax: u16, h: &mut [u16; 121]| {
        let mut z = 0;
        for y in ymin..ymax {
            for x in xmin..xmax {
                let h = h[(x + 11 * y) as usize];
                if h > z {
                    z = h;
                }
            }
        }
        z
    };
    let mut s: [usize; SIZE * 8] = [0; SIZE * 8];
    let mut sc: [usize; SIZE] = [0; SIZE];
    for i in 0..bricks.len() {
        let z = 1 + stop_z(
            bricks[i][0],
            bricks[i][3],
            bricks[i][1],
            bricks[i][4],
            &mut height,
        );
        let drop = bricks[i][2] - z;
        bricks[i][2] = z;
        bricks[i][5] -= drop;
        let t: [u16; 6] = [
            bricks[i][0],
            bricks[i][1],
            bricks[i][2] - 1,
            bricks[i][3],
            bricks[i][4],
            bricks[i][5] - 1,
        ];
        for y in bricks[i][1]..bricks[i][4] {
            for x in bricks[i][0]..bricks[i][3] {
                height[(x + y * 11) as usize] = bricks[i][5] - 1;
            }
        }
        let mut c = 0;
        for j in 0..bricks.len() {
            if i == j {
                continue;
            }
            if intersected(&bricks[j], &t) {
                c += 1;
                let mut inserted = false;
                for k in 0..8 {
                    if s[j * 8 + k] != 0 {
                        continue;
                    }
                    s[j * 8 + k] = i + 1;
                    inserted = true;
                    break;
                }
                debug_assert!(inserted);
            }
        }
        sc[i] = c;
    }

    let (mut p1, mut p2): (usize, usize) = (0, 0);
    for i in 0..bricks.len() {
        let mut dis: usize = 0;
        let mut rem: [usize; SIZE] = [0; SIZE];
        let mut todo = aoc::deque::Deque::<usize, SIZE>::default();
        for k in 0..8 {
            if s[i * 8 + k] == 0 {
                break;
            }
            todo.push(s[i * 8 + k] - 1);
        }
        while let Some(cur) = todo.pop() {
            rem[cur] += 1;
            if sc[cur] == rem[cur] {
                for k in 0..8 {
                    if s[cur * 8 + k] == 0 {
                        break;
                    }
                    todo.push(s[cur * 8 + k] - 1);
                }
                dis += 1;
            }
        }
        if dis == 0 {
            p1 += 1;
        }
        p2 += dis;
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
        let inp = std::fs::read("../2023/22/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (5, 7));
        let inp = std::fs::read("../2023/22/input.txt").expect("read error");
        assert_eq!(parts(&inp), (409, 61097));
    }
}
