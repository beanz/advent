use heapless::{FnvIndexMap, Vec};

fn parts(inp: &[u8]) -> ((i32, i32), (i32, i32)) {
    let w1 = aoc::read::skip_next_line(inp, 0);
    let h = inp.len() / w1;
    let w = w1 - 1;
    //eprintln!("{}x{}", w, h);
    let mut carts = FnvIndexMap::<(i32, i32), Cart, 32>::new();
    let turn = Turn::Ccw; // left to start
    for y in 0..h {
        for x in 0..w {
            let dir = match inp[x + y * w1] {
                b'^' => (0, -1),
                b'v' => (0, 1),
                b'<' => (-1, 0),
                b'>' => (1, 0),
                _ => continue,
            };
            carts
                .insert((x as i32, y as i32), Cart { dir, turn })
                .expect("carts full");
        }
    }
    //eprintln!("{:?}", carts);
    //pretty(inp, &carts, w, h);
    let last: (i32, i32);
    let mut p1: Option<(i32, i32)> = None;
    loop {
        let mut pos: Vec<(i32, i32), 150> = Vec::new();
        for k in carts.keys() {
            pos.push((k.0, k.1)).expect("pos overflow");
        }
        pos.sort_by(|(ax, ay), (bx, by)| (ay, ax).cmp(&(by, bx)));
        for k in pos {
            let (x, y) = k;
            let cart = carts.remove(&k);
            if cart.is_none() {
                continue;
            }
            let cart = cart.expect("missing cart?");
            //eprintln!("{},{} {:?}", x, y, cart);
            let (nx, ny) = (x + cart.dir.0, y + cart.dir.1);
            if carts.remove(&(nx, ny)).is_some() {
                //eprintln!("crash {},{}", nx, ny);
                if p1.is_none() {
                    p1 = Some((nx, ny));
                }
                continue;
            }
            let (dir, turn) = match track(inp, nx as usize, ny as usize, w1) {
                Track::StraightV | Track::StraightH => (cart.dir, cart.turn),
                Track::Intersection => match cart.turn {
                    Turn::Ccw => (ccw(cart.dir), Turn::Fwd),
                    Turn::Fwd => (cart.dir, Turn::Cw),
                    Turn::Cw => (cw(cart.dir), Turn::Ccw),
                },
                Track::TopDown => match cart.dir {
                    (0, -1) => ((-1, 0), cart.turn),
                    (0, 1) => ((1, 0), cart.turn),
                    (-1, 0) => ((0, -1), cart.turn),
                    (1, 0) => ((0, 1), cart.turn),
                    _ => unreachable!(),
                },
                Track::BottomUp => match cart.dir {
                    (0, -1) => ((1, 0), cart.turn),
                    (0, 1) => ((-1, 0), cart.turn),
                    (-1, 0) => ((0, 1), cart.turn),
                    (1, 0) => ((0, -1), cart.turn),
                    _ => unreachable!(),
                },
                Track::Derailed => unreachable!(),
            };
            //eprintln!("moved {},{} => {},{} {:?}", x, y, nx, ny, cart);
            carts
                .insert((nx, ny), Cart { dir, turn })
                .expect("carts overflowed");
        }
        //pretty(inp, &carts, w, h);
        match carts.len() {
            0 => unreachable!("no more carts?"),
            1 => {
                last = *carts.keys().next().expect("must be one");
                break;
            }
            _ => {}
        }
    }
    let p1 = p1.expect("no first crash?");
    ((p1.0, p1.1), (last.0, last.1))
}

#[allow(dead_code)]
fn pretty(inp: &[u8], carts: &FnvIndexMap<(i32, i32), Cart, 32>, w: usize, h: usize) {
    for y in 0..h {
        for x in 0..w {
            if let Some(cart) = carts.get(&(x as i32, y as i32)) {
                eprint!(
                    "{}",
                    match cart.dir {
                        (0, -1) => '^',
                        (0, 1) => 'v',
                        (-1, 0) => '<',
                        (1, 0) => '>',
                        _ => unreachable!("invalid direction"),
                    }
                );
                continue;
            }
            eprint!(
                "{}",
                match track(inp, x, y, w + 1) {
                    Track::Derailed => ' ',
                    Track::TopDown => '\\',
                    Track::BottomUp => '/',
                    Track::StraightV => '|',
                    Track::StraightH => '-',
                    Track::Intersection => '+',
                }
            );
        }
        eprintln!();
    }
    eprintln!();
}

#[derive(Debug, Copy, Clone)]
enum Turn {
    Ccw,
    Fwd,
    Cw,
}

fn cw(d: (i32, i32)) -> (i32, i32) {
    (-d.1, d.0)
}

fn ccw(d: (i32, i32)) -> (i32, i32) {
    (d.1, -d.0)
}

#[derive(Debug)]
struct Cart {
    dir: (i32, i32),
    turn: Turn,
}

enum Track {
    StraightV,
    StraightH,
    TopDown,
    BottomUp,
    Intersection,
    Derailed,
}

fn track(inp: &[u8], x: usize, y: usize, w1: usize) -> Track {
    match inp[x + y * w1] {
        b'^' | b'v' | b'|' => Track::StraightV,
        b'<' | b'>' | b'-' => Track::StraightH,
        b'\\' => Track::TopDown,
        b'/' => Track::BottomUp,
        b'+' => Track::Intersection,
        _ => Track::Derailed,
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {},{}", p1.0, p1.1);
            println!("Part 2: {},{}", p2.0, p2.1);
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/13/test0.txt").expect("read error");
        assert_eq!(parts(&inp), ((0, 3), (0, 6)));
        let inp = std::fs::read("../2018/13/test2.txt").expect("read error");
        assert_eq!(parts(&inp), ((2, 0), (6, 4)));
        let inp = std::fs::read("../2018/13/input.txt").expect("read error");
        assert_eq!(parts(&inp), ((116, 91), (8, 23)));
        let inp = std::fs::read("../2018/13/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), ((74, 87), (29, 74)));
    }
}
