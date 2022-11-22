fn parts(inp: &[u8]) -> (i32, usize) {
    let mut ints: [i32; 4] = [0; 4];
    signed_ints(inp, &mut ints);
    let mut p2 = 0;
    let (x_min, x_max, y_min, y_max) = (ints[0], ints[1], ints[2], ints[3]);
    let mut vx = {
        let mut x = 1;
        loop {
            if x * (x + 1) >= x_min * 2 {
                break;
            }
            x += 1;
        }
        x
    };
    while vx <= x_max {
        for vy in -y_min.abs()..=y_min.abs() {
            if hits(vx, vy, x_min, x_max, y_min, y_max) {
                p2 += 1;
            }
        }
        vx += 1;
    }
    (y_min * (y_min + 1) / 2, p2)
}
fn hits(svx: i32, svy: i32, x_min: i32, x_max: i32, y_min: i32, y_max: i32) -> bool {
    let (mut x, mut y) = (0, 0);
    let (mut vx, mut vy) = (svx, svy);
    loop {
        x += vx;
        y += vy;
        if vx > 0 {
            vx -= 1;
        }
        vy -= 1;
        if y < y_min {
            return false;
        }
        if x_min <= x && x <= x_max {
            if y <= y_max {
                return true;
            }
        } else if vx == 0 {
            return false;
        }
    }
}

fn signed_ints(inp: &[u8], res: &mut [i32]) {
    let mut n = 0;
    let mut m = 1;
    let mut i = 0;
    let mut num = false;
    for ch in inp {
        match ch {
            b'-' => {
                m = -1;
            }
            b'0'..=b'9' => {
                num = true;
                n = n * 10 + (ch - b'0') as i32;
            }
            _ => {
                if num {
                    res[i] = n * m;
                    i += 1;
                    n = 0;
                    m = 1;
                    num = false;
                }
            }
        }
    }
    if num {
        res[i] = n * m;
    }
}

#[test]
fn parts_works() {
    let (tp1, tp2) = parts(b"target area: x=20..30, y=-10..-5\n");
    assert_eq!(tp1, 45);
    assert_eq!(tp2, 112);
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
