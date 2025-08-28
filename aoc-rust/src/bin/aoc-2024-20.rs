fn parts(inp: &[u8]) -> (usize, usize) {
    const DX: [i32; 4] = [0, 1, 0, -1];
    const DY: [i32; 4] = [-1, 0, 1, 0];
    let w = inp.iter().position(|&ch| ch == b'\n').expect("no EOL");
    let h = inp.len() / (w + 1);
    let w1 = w + 1;
    let w = w as i32;
    let h = h as i32;
    let limit = if w < 20 { 20 } else { 100 };
    let in_bound = |x, y| -> bool { 0 <= x && x < w && 0 <= y && y < h };
    let get = |x, y| -> u8 {
        if in_bound(x, y) {
            inp[(x as usize) + (y as usize) * w1]
        } else {
            128
        }
    };
    let s = inp.iter().position(|&ch| ch == b'S').expect("no S");
    let (sx, sy) = ((s % w1) as i32, (s / w1) as i32);
    let (mut cx, mut cy, mut st) = (sx, sy, 0);
    let mut seen: [Option<usize>; 20000] = [None; 20000];
    'outer: loop {
        seen[(cx + cy * w) as usize] = Some(st);
        for dir in 0..4 {
            let (nx, ny) = (cx + DX[dir], cy + DY[dir]);
            if seen[(nx + ny * w) as usize].is_none() && get(nx, ny) != b'#' {
                (cx, cy, st) = (nx, ny, st + 1);
                continue 'outer;
            }
        }
        break;
    }
    let solve = |cheat_neighbours: &[Rec]| -> usize {
        let mut res = 0;
        for y in 0..h {
            for x in 0..w {
                if let Some(st) = seen[(x + y * w) as usize] {
                    for ch in cheat_neighbours {
                        let (nx, ny, md) = (x + ch.x, y + ch.y, ch.st);
                        if !in_bound(nx, ny) {
                            continue;
                        }
                        if let Some(cst) = seen[(nx + ny * w) as usize] {
                            if cst > st && cst - st - md >= limit {
                                res += 1;
                            }
                        }
                    }
                }
            }
        }
        res
    };
    (
        solve(&CHEAT_NEIGHBOURS2[..]),
        solve(&CHEAT_NEIGHBOURS20[..]),
    )
}

struct Rec {
    x: i32,
    y: i32,
    st: usize,
}

const CHEAT_NEIGHBOURS2: [Rec; 4] = [
    // the [abs(1),abs(1)] don't matter
    Rec { x: 0, y: -2, st: 2 },
    Rec { x: -2, y: 0, st: 2 },
    Rec { x: 2, y: 0, st: 2 },
    Rec { x: 0, y: 2, st: 2 },
];

const CHEAT_NEIGHBOURS20: [Rec; 836] = [
    Rec {
        x: 0,
        y: -20,
        st: 20,
    },
    Rec {
        x: -1,
        y: -19,
        st: 20,
    },
    Rec {
        x: 0,
        y: -19,
        st: 19,
    },
    Rec {
        x: 1,
        y: -19,
        st: 20,
    },
    Rec {
        x: -2,
        y: -18,
        st: 20,
    },
    Rec {
        x: -1,
        y: -18,
        st: 19,
    },
    Rec {
        x: 0,
        y: -18,
        st: 18,
    },
    Rec {
        x: 1,
        y: -18,
        st: 19,
    },
    Rec {
        x: 2,
        y: -18,
        st: 20,
    },
    Rec {
        x: -3,
        y: -17,
        st: 20,
    },
    Rec {
        x: -2,
        y: -17,
        st: 19,
    },
    Rec {
        x: -1,
        y: -17,
        st: 18,
    },
    Rec {
        x: 0,
        y: -17,
        st: 17,
    },
    Rec {
        x: 1,
        y: -17,
        st: 18,
    },
    Rec {
        x: 2,
        y: -17,
        st: 19,
    },
    Rec {
        x: 3,
        y: -17,
        st: 20,
    },
    Rec {
        x: -4,
        y: -16,
        st: 20,
    },
    Rec {
        x: -3,
        y: -16,
        st: 19,
    },
    Rec {
        x: -2,
        y: -16,
        st: 18,
    },
    Rec {
        x: -1,
        y: -16,
        st: 17,
    },
    Rec {
        x: 0,
        y: -16,
        st: 16,
    },
    Rec {
        x: 1,
        y: -16,
        st: 17,
    },
    Rec {
        x: 2,
        y: -16,
        st: 18,
    },
    Rec {
        x: 3,
        y: -16,
        st: 19,
    },
    Rec {
        x: 4,
        y: -16,
        st: 20,
    },
    Rec {
        x: -5,
        y: -15,
        st: 20,
    },
    Rec {
        x: -4,
        y: -15,
        st: 19,
    },
    Rec {
        x: -3,
        y: -15,
        st: 18,
    },
    Rec {
        x: -2,
        y: -15,
        st: 17,
    },
    Rec {
        x: -1,
        y: -15,
        st: 16,
    },
    Rec {
        x: 0,
        y: -15,
        st: 15,
    },
    Rec {
        x: 1,
        y: -15,
        st: 16,
    },
    Rec {
        x: 2,
        y: -15,
        st: 17,
    },
    Rec {
        x: 3,
        y: -15,
        st: 18,
    },
    Rec {
        x: 4,
        y: -15,
        st: 19,
    },
    Rec {
        x: 5,
        y: -15,
        st: 20,
    },
    Rec {
        x: -6,
        y: -14,
        st: 20,
    },
    Rec {
        x: -5,
        y: -14,
        st: 19,
    },
    Rec {
        x: -4,
        y: -14,
        st: 18,
    },
    Rec {
        x: -3,
        y: -14,
        st: 17,
    },
    Rec {
        x: -2,
        y: -14,
        st: 16,
    },
    Rec {
        x: -1,
        y: -14,
        st: 15,
    },
    Rec {
        x: 0,
        y: -14,
        st: 14,
    },
    Rec {
        x: 1,
        y: -14,
        st: 15,
    },
    Rec {
        x: 2,
        y: -14,
        st: 16,
    },
    Rec {
        x: 3,
        y: -14,
        st: 17,
    },
    Rec {
        x: 4,
        y: -14,
        st: 18,
    },
    Rec {
        x: 5,
        y: -14,
        st: 19,
    },
    Rec {
        x: 6,
        y: -14,
        st: 20,
    },
    Rec {
        x: -7,
        y: -13,
        st: 20,
    },
    Rec {
        x: -6,
        y: -13,
        st: 19,
    },
    Rec {
        x: -5,
        y: -13,
        st: 18,
    },
    Rec {
        x: -4,
        y: -13,
        st: 17,
    },
    Rec {
        x: -3,
        y: -13,
        st: 16,
    },
    Rec {
        x: -2,
        y: -13,
        st: 15,
    },
    Rec {
        x: -1,
        y: -13,
        st: 14,
    },
    Rec {
        x: 0,
        y: -13,
        st: 13,
    },
    Rec {
        x: 1,
        y: -13,
        st: 14,
    },
    Rec {
        x: 2,
        y: -13,
        st: 15,
    },
    Rec {
        x: 3,
        y: -13,
        st: 16,
    },
    Rec {
        x: 4,
        y: -13,
        st: 17,
    },
    Rec {
        x: 5,
        y: -13,
        st: 18,
    },
    Rec {
        x: 6,
        y: -13,
        st: 19,
    },
    Rec {
        x: 7,
        y: -13,
        st: 20,
    },
    Rec {
        x: -8,
        y: -12,
        st: 20,
    },
    Rec {
        x: -7,
        y: -12,
        st: 19,
    },
    Rec {
        x: -6,
        y: -12,
        st: 18,
    },
    Rec {
        x: -5,
        y: -12,
        st: 17,
    },
    Rec {
        x: -4,
        y: -12,
        st: 16,
    },
    Rec {
        x: -3,
        y: -12,
        st: 15,
    },
    Rec {
        x: -2,
        y: -12,
        st: 14,
    },
    Rec {
        x: -1,
        y: -12,
        st: 13,
    },
    Rec {
        x: 0,
        y: -12,
        st: 12,
    },
    Rec {
        x: 1,
        y: -12,
        st: 13,
    },
    Rec {
        x: 2,
        y: -12,
        st: 14,
    },
    Rec {
        x: 3,
        y: -12,
        st: 15,
    },
    Rec {
        x: 4,
        y: -12,
        st: 16,
    },
    Rec {
        x: 5,
        y: -12,
        st: 17,
    },
    Rec {
        x: 6,
        y: -12,
        st: 18,
    },
    Rec {
        x: 7,
        y: -12,
        st: 19,
    },
    Rec {
        x: 8,
        y: -12,
        st: 20,
    },
    Rec {
        x: -9,
        y: -11,
        st: 20,
    },
    Rec {
        x: -8,
        y: -11,
        st: 19,
    },
    Rec {
        x: -7,
        y: -11,
        st: 18,
    },
    Rec {
        x: -6,
        y: -11,
        st: 17,
    },
    Rec {
        x: -5,
        y: -11,
        st: 16,
    },
    Rec {
        x: -4,
        y: -11,
        st: 15,
    },
    Rec {
        x: -3,
        y: -11,
        st: 14,
    },
    Rec {
        x: -2,
        y: -11,
        st: 13,
    },
    Rec {
        x: -1,
        y: -11,
        st: 12,
    },
    Rec {
        x: 0,
        y: -11,
        st: 11,
    },
    Rec {
        x: 1,
        y: -11,
        st: 12,
    },
    Rec {
        x: 2,
        y: -11,
        st: 13,
    },
    Rec {
        x: 3,
        y: -11,
        st: 14,
    },
    Rec {
        x: 4,
        y: -11,
        st: 15,
    },
    Rec {
        x: 5,
        y: -11,
        st: 16,
    },
    Rec {
        x: 6,
        y: -11,
        st: 17,
    },
    Rec {
        x: 7,
        y: -11,
        st: 18,
    },
    Rec {
        x: 8,
        y: -11,
        st: 19,
    },
    Rec {
        x: 9,
        y: -11,
        st: 20,
    },
    Rec {
        x: -10,
        y: -10,
        st: 20,
    },
    Rec {
        x: -9,
        y: -10,
        st: 19,
    },
    Rec {
        x: -8,
        y: -10,
        st: 18,
    },
    Rec {
        x: -7,
        y: -10,
        st: 17,
    },
    Rec {
        x: -6,
        y: -10,
        st: 16,
    },
    Rec {
        x: -5,
        y: -10,
        st: 15,
    },
    Rec {
        x: -4,
        y: -10,
        st: 14,
    },
    Rec {
        x: -3,
        y: -10,
        st: 13,
    },
    Rec {
        x: -2,
        y: -10,
        st: 12,
    },
    Rec {
        x: -1,
        y: -10,
        st: 11,
    },
    Rec {
        x: 0,
        y: -10,
        st: 10,
    },
    Rec {
        x: 1,
        y: -10,
        st: 11,
    },
    Rec {
        x: 2,
        y: -10,
        st: 12,
    },
    Rec {
        x: 3,
        y: -10,
        st: 13,
    },
    Rec {
        x: 4,
        y: -10,
        st: 14,
    },
    Rec {
        x: 5,
        y: -10,
        st: 15,
    },
    Rec {
        x: 6,
        y: -10,
        st: 16,
    },
    Rec {
        x: 7,
        y: -10,
        st: 17,
    },
    Rec {
        x: 8,
        y: -10,
        st: 18,
    },
    Rec {
        x: 9,
        y: -10,
        st: 19,
    },
    Rec {
        x: 10,
        y: -10,
        st: 20,
    },
    Rec {
        x: -11,
        y: -9,
        st: 20,
    },
    Rec {
        x: -10,
        y: -9,
        st: 19,
    },
    Rec {
        x: -9,
        y: -9,
        st: 18,
    },
    Rec {
        x: -8,
        y: -9,
        st: 17,
    },
    Rec {
        x: -7,
        y: -9,
        st: 16,
    },
    Rec {
        x: -6,
        y: -9,
        st: 15,
    },
    Rec {
        x: -5,
        y: -9,
        st: 14,
    },
    Rec {
        x: -4,
        y: -9,
        st: 13,
    },
    Rec {
        x: -3,
        y: -9,
        st: 12,
    },
    Rec {
        x: -2,
        y: -9,
        st: 11,
    },
    Rec {
        x: -1,
        y: -9,
        st: 10,
    },
    Rec { x: 0, y: -9, st: 9 },
    Rec {
        x: 1,
        y: -9,
        st: 10,
    },
    Rec {
        x: 2,
        y: -9,
        st: 11,
    },
    Rec {
        x: 3,
        y: -9,
        st: 12,
    },
    Rec {
        x: 4,
        y: -9,
        st: 13,
    },
    Rec {
        x: 5,
        y: -9,
        st: 14,
    },
    Rec {
        x: 6,
        y: -9,
        st: 15,
    },
    Rec {
        x: 7,
        y: -9,
        st: 16,
    },
    Rec {
        x: 8,
        y: -9,
        st: 17,
    },
    Rec {
        x: 9,
        y: -9,
        st: 18,
    },
    Rec {
        x: 10,
        y: -9,
        st: 19,
    },
    Rec {
        x: 11,
        y: -9,
        st: 20,
    },
    Rec {
        x: -12,
        y: -8,
        st: 20,
    },
    Rec {
        x: -11,
        y: -8,
        st: 19,
    },
    Rec {
        x: -10,
        y: -8,
        st: 18,
    },
    Rec {
        x: -9,
        y: -8,
        st: 17,
    },
    Rec {
        x: -8,
        y: -8,
        st: 16,
    },
    Rec {
        x: -7,
        y: -8,
        st: 15,
    },
    Rec {
        x: -6,
        y: -8,
        st: 14,
    },
    Rec {
        x: -5,
        y: -8,
        st: 13,
    },
    Rec {
        x: -4,
        y: -8,
        st: 12,
    },
    Rec {
        x: -3,
        y: -8,
        st: 11,
    },
    Rec {
        x: -2,
        y: -8,
        st: 10,
    },
    Rec {
        x: -1,
        y: -8,
        st: 9,
    },
    Rec { x: 0, y: -8, st: 8 },
    Rec { x: 1, y: -8, st: 9 },
    Rec {
        x: 2,
        y: -8,
        st: 10,
    },
    Rec {
        x: 3,
        y: -8,
        st: 11,
    },
    Rec {
        x: 4,
        y: -8,
        st: 12,
    },
    Rec {
        x: 5,
        y: -8,
        st: 13,
    },
    Rec {
        x: 6,
        y: -8,
        st: 14,
    },
    Rec {
        x: 7,
        y: -8,
        st: 15,
    },
    Rec {
        x: 8,
        y: -8,
        st: 16,
    },
    Rec {
        x: 9,
        y: -8,
        st: 17,
    },
    Rec {
        x: 10,
        y: -8,
        st: 18,
    },
    Rec {
        x: 11,
        y: -8,
        st: 19,
    },
    Rec {
        x: 12,
        y: -8,
        st: 20,
    },
    Rec {
        x: -13,
        y: -7,
        st: 20,
    },
    Rec {
        x: -12,
        y: -7,
        st: 19,
    },
    Rec {
        x: -11,
        y: -7,
        st: 18,
    },
    Rec {
        x: -10,
        y: -7,
        st: 17,
    },
    Rec {
        x: -9,
        y: -7,
        st: 16,
    },
    Rec {
        x: -8,
        y: -7,
        st: 15,
    },
    Rec {
        x: -7,
        y: -7,
        st: 14,
    },
    Rec {
        x: -6,
        y: -7,
        st: 13,
    },
    Rec {
        x: -5,
        y: -7,
        st: 12,
    },
    Rec {
        x: -4,
        y: -7,
        st: 11,
    },
    Rec {
        x: -3,
        y: -7,
        st: 10,
    },
    Rec {
        x: -2,
        y: -7,
        st: 9,
    },
    Rec {
        x: -1,
        y: -7,
        st: 8,
    },
    Rec { x: 0, y: -7, st: 7 },
    Rec { x: 1, y: -7, st: 8 },
    Rec { x: 2, y: -7, st: 9 },
    Rec {
        x: 3,
        y: -7,
        st: 10,
    },
    Rec {
        x: 4,
        y: -7,
        st: 11,
    },
    Rec {
        x: 5,
        y: -7,
        st: 12,
    },
    Rec {
        x: 6,
        y: -7,
        st: 13,
    },
    Rec {
        x: 7,
        y: -7,
        st: 14,
    },
    Rec {
        x: 8,
        y: -7,
        st: 15,
    },
    Rec {
        x: 9,
        y: -7,
        st: 16,
    },
    Rec {
        x: 10,
        y: -7,
        st: 17,
    },
    Rec {
        x: 11,
        y: -7,
        st: 18,
    },
    Rec {
        x: 12,
        y: -7,
        st: 19,
    },
    Rec {
        x: 13,
        y: -7,
        st: 20,
    },
    Rec {
        x: -14,
        y: -6,
        st: 20,
    },
    Rec {
        x: -13,
        y: -6,
        st: 19,
    },
    Rec {
        x: -12,
        y: -6,
        st: 18,
    },
    Rec {
        x: -11,
        y: -6,
        st: 17,
    },
    Rec {
        x: -10,
        y: -6,
        st: 16,
    },
    Rec {
        x: -9,
        y: -6,
        st: 15,
    },
    Rec {
        x: -8,
        y: -6,
        st: 14,
    },
    Rec {
        x: -7,
        y: -6,
        st: 13,
    },
    Rec {
        x: -6,
        y: -6,
        st: 12,
    },
    Rec {
        x: -5,
        y: -6,
        st: 11,
    },
    Rec {
        x: -4,
        y: -6,
        st: 10,
    },
    Rec {
        x: -3,
        y: -6,
        st: 9,
    },
    Rec {
        x: -2,
        y: -6,
        st: 8,
    },
    Rec {
        x: -1,
        y: -6,
        st: 7,
    },
    Rec { x: 0, y: -6, st: 6 },
    Rec { x: 1, y: -6, st: 7 },
    Rec { x: 2, y: -6, st: 8 },
    Rec { x: 3, y: -6, st: 9 },
    Rec {
        x: 4,
        y: -6,
        st: 10,
    },
    Rec {
        x: 5,
        y: -6,
        st: 11,
    },
    Rec {
        x: 6,
        y: -6,
        st: 12,
    },
    Rec {
        x: 7,
        y: -6,
        st: 13,
    },
    Rec {
        x: 8,
        y: -6,
        st: 14,
    },
    Rec {
        x: 9,
        y: -6,
        st: 15,
    },
    Rec {
        x: 10,
        y: -6,
        st: 16,
    },
    Rec {
        x: 11,
        y: -6,
        st: 17,
    },
    Rec {
        x: 12,
        y: -6,
        st: 18,
    },
    Rec {
        x: 13,
        y: -6,
        st: 19,
    },
    Rec {
        x: 14,
        y: -6,
        st: 20,
    },
    Rec {
        x: -15,
        y: -5,
        st: 20,
    },
    Rec {
        x: -14,
        y: -5,
        st: 19,
    },
    Rec {
        x: -13,
        y: -5,
        st: 18,
    },
    Rec {
        x: -12,
        y: -5,
        st: 17,
    },
    Rec {
        x: -11,
        y: -5,
        st: 16,
    },
    Rec {
        x: -10,
        y: -5,
        st: 15,
    },
    Rec {
        x: -9,
        y: -5,
        st: 14,
    },
    Rec {
        x: -8,
        y: -5,
        st: 13,
    },
    Rec {
        x: -7,
        y: -5,
        st: 12,
    },
    Rec {
        x: -6,
        y: -5,
        st: 11,
    },
    Rec {
        x: -5,
        y: -5,
        st: 10,
    },
    Rec {
        x: -4,
        y: -5,
        st: 9,
    },
    Rec {
        x: -3,
        y: -5,
        st: 8,
    },
    Rec {
        x: -2,
        y: -5,
        st: 7,
    },
    Rec {
        x: -1,
        y: -5,
        st: 6,
    },
    Rec { x: 0, y: -5, st: 5 },
    Rec { x: 1, y: -5, st: 6 },
    Rec { x: 2, y: -5, st: 7 },
    Rec { x: 3, y: -5, st: 8 },
    Rec { x: 4, y: -5, st: 9 },
    Rec {
        x: 5,
        y: -5,
        st: 10,
    },
    Rec {
        x: 6,
        y: -5,
        st: 11,
    },
    Rec {
        x: 7,
        y: -5,
        st: 12,
    },
    Rec {
        x: 8,
        y: -5,
        st: 13,
    },
    Rec {
        x: 9,
        y: -5,
        st: 14,
    },
    Rec {
        x: 10,
        y: -5,
        st: 15,
    },
    Rec {
        x: 11,
        y: -5,
        st: 16,
    },
    Rec {
        x: 12,
        y: -5,
        st: 17,
    },
    Rec {
        x: 13,
        y: -5,
        st: 18,
    },
    Rec {
        x: 14,
        y: -5,
        st: 19,
    },
    Rec {
        x: 15,
        y: -5,
        st: 20,
    },
    Rec {
        x: -16,
        y: -4,
        st: 20,
    },
    Rec {
        x: -15,
        y: -4,
        st: 19,
    },
    Rec {
        x: -14,
        y: -4,
        st: 18,
    },
    Rec {
        x: -13,
        y: -4,
        st: 17,
    },
    Rec {
        x: -12,
        y: -4,
        st: 16,
    },
    Rec {
        x: -11,
        y: -4,
        st: 15,
    },
    Rec {
        x: -10,
        y: -4,
        st: 14,
    },
    Rec {
        x: -9,
        y: -4,
        st: 13,
    },
    Rec {
        x: -8,
        y: -4,
        st: 12,
    },
    Rec {
        x: -7,
        y: -4,
        st: 11,
    },
    Rec {
        x: -6,
        y: -4,
        st: 10,
    },
    Rec {
        x: -5,
        y: -4,
        st: 9,
    },
    Rec {
        x: -4,
        y: -4,
        st: 8,
    },
    Rec {
        x: -3,
        y: -4,
        st: 7,
    },
    Rec {
        x: -2,
        y: -4,
        st: 6,
    },
    Rec {
        x: -1,
        y: -4,
        st: 5,
    },
    Rec { x: 0, y: -4, st: 4 },
    Rec { x: 1, y: -4, st: 5 },
    Rec { x: 2, y: -4, st: 6 },
    Rec { x: 3, y: -4, st: 7 },
    Rec { x: 4, y: -4, st: 8 },
    Rec { x: 5, y: -4, st: 9 },
    Rec {
        x: 6,
        y: -4,
        st: 10,
    },
    Rec {
        x: 7,
        y: -4,
        st: 11,
    },
    Rec {
        x: 8,
        y: -4,
        st: 12,
    },
    Rec {
        x: 9,
        y: -4,
        st: 13,
    },
    Rec {
        x: 10,
        y: -4,
        st: 14,
    },
    Rec {
        x: 11,
        y: -4,
        st: 15,
    },
    Rec {
        x: 12,
        y: -4,
        st: 16,
    },
    Rec {
        x: 13,
        y: -4,
        st: 17,
    },
    Rec {
        x: 14,
        y: -4,
        st: 18,
    },
    Rec {
        x: 15,
        y: -4,
        st: 19,
    },
    Rec {
        x: 16,
        y: -4,
        st: 20,
    },
    Rec {
        x: -17,
        y: -3,
        st: 20,
    },
    Rec {
        x: -16,
        y: -3,
        st: 19,
    },
    Rec {
        x: -15,
        y: -3,
        st: 18,
    },
    Rec {
        x: -14,
        y: -3,
        st: 17,
    },
    Rec {
        x: -13,
        y: -3,
        st: 16,
    },
    Rec {
        x: -12,
        y: -3,
        st: 15,
    },
    Rec {
        x: -11,
        y: -3,
        st: 14,
    },
    Rec {
        x: -10,
        y: -3,
        st: 13,
    },
    Rec {
        x: -9,
        y: -3,
        st: 12,
    },
    Rec {
        x: -8,
        y: -3,
        st: 11,
    },
    Rec {
        x: -7,
        y: -3,
        st: 10,
    },
    Rec {
        x: -6,
        y: -3,
        st: 9,
    },
    Rec {
        x: -5,
        y: -3,
        st: 8,
    },
    Rec {
        x: -4,
        y: -3,
        st: 7,
    },
    Rec {
        x: -3,
        y: -3,
        st: 6,
    },
    Rec {
        x: -2,
        y: -3,
        st: 5,
    },
    Rec {
        x: -1,
        y: -3,
        st: 4,
    },
    Rec { x: 0, y: -3, st: 3 },
    Rec { x: 1, y: -3, st: 4 },
    Rec { x: 2, y: -3, st: 5 },
    Rec { x: 3, y: -3, st: 6 },
    Rec { x: 4, y: -3, st: 7 },
    Rec { x: 5, y: -3, st: 8 },
    Rec { x: 6, y: -3, st: 9 },
    Rec {
        x: 7,
        y: -3,
        st: 10,
    },
    Rec {
        x: 8,
        y: -3,
        st: 11,
    },
    Rec {
        x: 9,
        y: -3,
        st: 12,
    },
    Rec {
        x: 10,
        y: -3,
        st: 13,
    },
    Rec {
        x: 11,
        y: -3,
        st: 14,
    },
    Rec {
        x: 12,
        y: -3,
        st: 15,
    },
    Rec {
        x: 13,
        y: -3,
        st: 16,
    },
    Rec {
        x: 14,
        y: -3,
        st: 17,
    },
    Rec {
        x: 15,
        y: -3,
        st: 18,
    },
    Rec {
        x: 16,
        y: -3,
        st: 19,
    },
    Rec {
        x: 17,
        y: -3,
        st: 20,
    },
    Rec {
        x: -18,
        y: -2,
        st: 20,
    },
    Rec {
        x: -17,
        y: -2,
        st: 19,
    },
    Rec {
        x: -16,
        y: -2,
        st: 18,
    },
    Rec {
        x: -15,
        y: -2,
        st: 17,
    },
    Rec {
        x: -14,
        y: -2,
        st: 16,
    },
    Rec {
        x: -13,
        y: -2,
        st: 15,
    },
    Rec {
        x: -12,
        y: -2,
        st: 14,
    },
    Rec {
        x: -11,
        y: -2,
        st: 13,
    },
    Rec {
        x: -10,
        y: -2,
        st: 12,
    },
    Rec {
        x: -9,
        y: -2,
        st: 11,
    },
    Rec {
        x: -8,
        y: -2,
        st: 10,
    },
    Rec {
        x: -7,
        y: -2,
        st: 9,
    },
    Rec {
        x: -6,
        y: -2,
        st: 8,
    },
    Rec {
        x: -5,
        y: -2,
        st: 7,
    },
    Rec {
        x: -4,
        y: -2,
        st: 6,
    },
    Rec {
        x: -3,
        y: -2,
        st: 5,
    },
    Rec {
        x: -2,
        y: -2,
        st: 4,
    },
    Rec {
        x: -1,
        y: -2,
        st: 3,
    },
    Rec { x: 0, y: -2, st: 2 },
    Rec { x: 1, y: -2, st: 3 },
    Rec { x: 2, y: -2, st: 4 },
    Rec { x: 3, y: -2, st: 5 },
    Rec { x: 4, y: -2, st: 6 },
    Rec { x: 5, y: -2, st: 7 },
    Rec { x: 6, y: -2, st: 8 },
    Rec { x: 7, y: -2, st: 9 },
    Rec {
        x: 8,
        y: -2,
        st: 10,
    },
    Rec {
        x: 9,
        y: -2,
        st: 11,
    },
    Rec {
        x: 10,
        y: -2,
        st: 12,
    },
    Rec {
        x: 11,
        y: -2,
        st: 13,
    },
    Rec {
        x: 12,
        y: -2,
        st: 14,
    },
    Rec {
        x: 13,
        y: -2,
        st: 15,
    },
    Rec {
        x: 14,
        y: -2,
        st: 16,
    },
    Rec {
        x: 15,
        y: -2,
        st: 17,
    },
    Rec {
        x: 16,
        y: -2,
        st: 18,
    },
    Rec {
        x: 17,
        y: -2,
        st: 19,
    },
    Rec {
        x: 18,
        y: -2,
        st: 20,
    },
    Rec {
        x: -19,
        y: -1,
        st: 20,
    },
    Rec {
        x: -18,
        y: -1,
        st: 19,
    },
    Rec {
        x: -17,
        y: -1,
        st: 18,
    },
    Rec {
        x: -16,
        y: -1,
        st: 17,
    },
    Rec {
        x: -15,
        y: -1,
        st: 16,
    },
    Rec {
        x: -14,
        y: -1,
        st: 15,
    },
    Rec {
        x: -13,
        y: -1,
        st: 14,
    },
    Rec {
        x: -12,
        y: -1,
        st: 13,
    },
    Rec {
        x: -11,
        y: -1,
        st: 12,
    },
    Rec {
        x: -10,
        y: -1,
        st: 11,
    },
    Rec {
        x: -9,
        y: -1,
        st: 10,
    },
    Rec {
        x: -8,
        y: -1,
        st: 9,
    },
    Rec {
        x: -7,
        y: -1,
        st: 8,
    },
    Rec {
        x: -6,
        y: -1,
        st: 7,
    },
    Rec {
        x: -5,
        y: -1,
        st: 6,
    },
    Rec {
        x: -4,
        y: -1,
        st: 5,
    },
    Rec {
        x: -3,
        y: -1,
        st: 4,
    },
    Rec {
        x: -2,
        y: -1,
        st: 3,
    },
    Rec {
        x: -1,
        y: -1,
        st: 2,
    },
    Rec { x: 1, y: -1, st: 2 },
    Rec { x: 2, y: -1, st: 3 },
    Rec { x: 3, y: -1, st: 4 },
    Rec { x: 4, y: -1, st: 5 },
    Rec { x: 5, y: -1, st: 6 },
    Rec { x: 6, y: -1, st: 7 },
    Rec { x: 7, y: -1, st: 8 },
    Rec { x: 8, y: -1, st: 9 },
    Rec {
        x: 9,
        y: -1,
        st: 10,
    },
    Rec {
        x: 10,
        y: -1,
        st: 11,
    },
    Rec {
        x: 11,
        y: -1,
        st: 12,
    },
    Rec {
        x: 12,
        y: -1,
        st: 13,
    },
    Rec {
        x: 13,
        y: -1,
        st: 14,
    },
    Rec {
        x: 14,
        y: -1,
        st: 15,
    },
    Rec {
        x: 15,
        y: -1,
        st: 16,
    },
    Rec {
        x: 16,
        y: -1,
        st: 17,
    },
    Rec {
        x: 17,
        y: -1,
        st: 18,
    },
    Rec {
        x: 18,
        y: -1,
        st: 19,
    },
    Rec {
        x: 19,
        y: -1,
        st: 20,
    },
    Rec {
        x: -20,
        y: 0,
        st: 20,
    },
    Rec {
        x: -19,
        y: 0,
        st: 19,
    },
    Rec {
        x: -18,
        y: 0,
        st: 18,
    },
    Rec {
        x: -17,
        y: 0,
        st: 17,
    },
    Rec {
        x: -16,
        y: 0,
        st: 16,
    },
    Rec {
        x: -15,
        y: 0,
        st: 15,
    },
    Rec {
        x: -14,
        y: 0,
        st: 14,
    },
    Rec {
        x: -13,
        y: 0,
        st: 13,
    },
    Rec {
        x: -12,
        y: 0,
        st: 12,
    },
    Rec {
        x: -11,
        y: 0,
        st: 11,
    },
    Rec {
        x: -10,
        y: 0,
        st: 10,
    },
    Rec { x: -9, y: 0, st: 9 },
    Rec { x: -8, y: 0, st: 8 },
    Rec { x: -7, y: 0, st: 7 },
    Rec { x: -6, y: 0, st: 6 },
    Rec { x: -5, y: 0, st: 5 },
    Rec { x: -4, y: 0, st: 4 },
    Rec { x: -3, y: 0, st: 3 },
    Rec { x: -2, y: 0, st: 2 },
    Rec { x: 2, y: 0, st: 2 },
    Rec { x: 3, y: 0, st: 3 },
    Rec { x: 4, y: 0, st: 4 },
    Rec { x: 5, y: 0, st: 5 },
    Rec { x: 6, y: 0, st: 6 },
    Rec { x: 7, y: 0, st: 7 },
    Rec { x: 8, y: 0, st: 8 },
    Rec { x: 9, y: 0, st: 9 },
    Rec {
        x: 10,
        y: 0,
        st: 10,
    },
    Rec {
        x: 11,
        y: 0,
        st: 11,
    },
    Rec {
        x: 12,
        y: 0,
        st: 12,
    },
    Rec {
        x: 13,
        y: 0,
        st: 13,
    },
    Rec {
        x: 14,
        y: 0,
        st: 14,
    },
    Rec {
        x: 15,
        y: 0,
        st: 15,
    },
    Rec {
        x: 16,
        y: 0,
        st: 16,
    },
    Rec {
        x: 17,
        y: 0,
        st: 17,
    },
    Rec {
        x: 18,
        y: 0,
        st: 18,
    },
    Rec {
        x: 19,
        y: 0,
        st: 19,
    },
    Rec {
        x: 20,
        y: 0,
        st: 20,
    },
    Rec {
        x: -19,
        y: 1,
        st: 20,
    },
    Rec {
        x: -18,
        y: 1,
        st: 19,
    },
    Rec {
        x: -17,
        y: 1,
        st: 18,
    },
    Rec {
        x: -16,
        y: 1,
        st: 17,
    },
    Rec {
        x: -15,
        y: 1,
        st: 16,
    },
    Rec {
        x: -14,
        y: 1,
        st: 15,
    },
    Rec {
        x: -13,
        y: 1,
        st: 14,
    },
    Rec {
        x: -12,
        y: 1,
        st: 13,
    },
    Rec {
        x: -11,
        y: 1,
        st: 12,
    },
    Rec {
        x: -10,
        y: 1,
        st: 11,
    },
    Rec {
        x: -9,
        y: 1,
        st: 10,
    },
    Rec { x: -8, y: 1, st: 9 },
    Rec { x: -7, y: 1, st: 8 },
    Rec { x: -6, y: 1, st: 7 },
    Rec { x: -5, y: 1, st: 6 },
    Rec { x: -4, y: 1, st: 5 },
    Rec { x: -3, y: 1, st: 4 },
    Rec { x: -2, y: 1, st: 3 },
    Rec { x: -1, y: 1, st: 2 },
    Rec { x: 1, y: 1, st: 2 },
    Rec { x: 2, y: 1, st: 3 },
    Rec { x: 3, y: 1, st: 4 },
    Rec { x: 4, y: 1, st: 5 },
    Rec { x: 5, y: 1, st: 6 },
    Rec { x: 6, y: 1, st: 7 },
    Rec { x: 7, y: 1, st: 8 },
    Rec { x: 8, y: 1, st: 9 },
    Rec { x: 9, y: 1, st: 10 },
    Rec {
        x: 10,
        y: 1,
        st: 11,
    },
    Rec {
        x: 11,
        y: 1,
        st: 12,
    },
    Rec {
        x: 12,
        y: 1,
        st: 13,
    },
    Rec {
        x: 13,
        y: 1,
        st: 14,
    },
    Rec {
        x: 14,
        y: 1,
        st: 15,
    },
    Rec {
        x: 15,
        y: 1,
        st: 16,
    },
    Rec {
        x: 16,
        y: 1,
        st: 17,
    },
    Rec {
        x: 17,
        y: 1,
        st: 18,
    },
    Rec {
        x: 18,
        y: 1,
        st: 19,
    },
    Rec {
        x: 19,
        y: 1,
        st: 20,
    },
    Rec {
        x: -18,
        y: 2,
        st: 20,
    },
    Rec {
        x: -17,
        y: 2,
        st: 19,
    },
    Rec {
        x: -16,
        y: 2,
        st: 18,
    },
    Rec {
        x: -15,
        y: 2,
        st: 17,
    },
    Rec {
        x: -14,
        y: 2,
        st: 16,
    },
    Rec {
        x: -13,
        y: 2,
        st: 15,
    },
    Rec {
        x: -12,
        y: 2,
        st: 14,
    },
    Rec {
        x: -11,
        y: 2,
        st: 13,
    },
    Rec {
        x: -10,
        y: 2,
        st: 12,
    },
    Rec {
        x: -9,
        y: 2,
        st: 11,
    },
    Rec {
        x: -8,
        y: 2,
        st: 10,
    },
    Rec { x: -7, y: 2, st: 9 },
    Rec { x: -6, y: 2, st: 8 },
    Rec { x: -5, y: 2, st: 7 },
    Rec { x: -4, y: 2, st: 6 },
    Rec { x: -3, y: 2, st: 5 },
    Rec { x: -2, y: 2, st: 4 },
    Rec { x: -1, y: 2, st: 3 },
    Rec { x: 0, y: 2, st: 2 },
    Rec { x: 1, y: 2, st: 3 },
    Rec { x: 2, y: 2, st: 4 },
    Rec { x: 3, y: 2, st: 5 },
    Rec { x: 4, y: 2, st: 6 },
    Rec { x: 5, y: 2, st: 7 },
    Rec { x: 6, y: 2, st: 8 },
    Rec { x: 7, y: 2, st: 9 },
    Rec { x: 8, y: 2, st: 10 },
    Rec { x: 9, y: 2, st: 11 },
    Rec {
        x: 10,
        y: 2,
        st: 12,
    },
    Rec {
        x: 11,
        y: 2,
        st: 13,
    },
    Rec {
        x: 12,
        y: 2,
        st: 14,
    },
    Rec {
        x: 13,
        y: 2,
        st: 15,
    },
    Rec {
        x: 14,
        y: 2,
        st: 16,
    },
    Rec {
        x: 15,
        y: 2,
        st: 17,
    },
    Rec {
        x: 16,
        y: 2,
        st: 18,
    },
    Rec {
        x: 17,
        y: 2,
        st: 19,
    },
    Rec {
        x: 18,
        y: 2,
        st: 20,
    },
    Rec {
        x: -17,
        y: 3,
        st: 20,
    },
    Rec {
        x: -16,
        y: 3,
        st: 19,
    },
    Rec {
        x: -15,
        y: 3,
        st: 18,
    },
    Rec {
        x: -14,
        y: 3,
        st: 17,
    },
    Rec {
        x: -13,
        y: 3,
        st: 16,
    },
    Rec {
        x: -12,
        y: 3,
        st: 15,
    },
    Rec {
        x: -11,
        y: 3,
        st: 14,
    },
    Rec {
        x: -10,
        y: 3,
        st: 13,
    },
    Rec {
        x: -9,
        y: 3,
        st: 12,
    },
    Rec {
        x: -8,
        y: 3,
        st: 11,
    },
    Rec {
        x: -7,
        y: 3,
        st: 10,
    },
    Rec { x: -6, y: 3, st: 9 },
    Rec { x: -5, y: 3, st: 8 },
    Rec { x: -4, y: 3, st: 7 },
    Rec { x: -3, y: 3, st: 6 },
    Rec { x: -2, y: 3, st: 5 },
    Rec { x: -1, y: 3, st: 4 },
    Rec { x: 0, y: 3, st: 3 },
    Rec { x: 1, y: 3, st: 4 },
    Rec { x: 2, y: 3, st: 5 },
    Rec { x: 3, y: 3, st: 6 },
    Rec { x: 4, y: 3, st: 7 },
    Rec { x: 5, y: 3, st: 8 },
    Rec { x: 6, y: 3, st: 9 },
    Rec { x: 7, y: 3, st: 10 },
    Rec { x: 8, y: 3, st: 11 },
    Rec { x: 9, y: 3, st: 12 },
    Rec {
        x: 10,
        y: 3,
        st: 13,
    },
    Rec {
        x: 11,
        y: 3,
        st: 14,
    },
    Rec {
        x: 12,
        y: 3,
        st: 15,
    },
    Rec {
        x: 13,
        y: 3,
        st: 16,
    },
    Rec {
        x: 14,
        y: 3,
        st: 17,
    },
    Rec {
        x: 15,
        y: 3,
        st: 18,
    },
    Rec {
        x: 16,
        y: 3,
        st: 19,
    },
    Rec {
        x: 17,
        y: 3,
        st: 20,
    },
    Rec {
        x: -16,
        y: 4,
        st: 20,
    },
    Rec {
        x: -15,
        y: 4,
        st: 19,
    },
    Rec {
        x: -14,
        y: 4,
        st: 18,
    },
    Rec {
        x: -13,
        y: 4,
        st: 17,
    },
    Rec {
        x: -12,
        y: 4,
        st: 16,
    },
    Rec {
        x: -11,
        y: 4,
        st: 15,
    },
    Rec {
        x: -10,
        y: 4,
        st: 14,
    },
    Rec {
        x: -9,
        y: 4,
        st: 13,
    },
    Rec {
        x: -8,
        y: 4,
        st: 12,
    },
    Rec {
        x: -7,
        y: 4,
        st: 11,
    },
    Rec {
        x: -6,
        y: 4,
        st: 10,
    },
    Rec { x: -5, y: 4, st: 9 },
    Rec { x: -4, y: 4, st: 8 },
    Rec { x: -3, y: 4, st: 7 },
    Rec { x: -2, y: 4, st: 6 },
    Rec { x: -1, y: 4, st: 5 },
    Rec { x: 0, y: 4, st: 4 },
    Rec { x: 1, y: 4, st: 5 },
    Rec { x: 2, y: 4, st: 6 },
    Rec { x: 3, y: 4, st: 7 },
    Rec { x: 4, y: 4, st: 8 },
    Rec { x: 5, y: 4, st: 9 },
    Rec { x: 6, y: 4, st: 10 },
    Rec { x: 7, y: 4, st: 11 },
    Rec { x: 8, y: 4, st: 12 },
    Rec { x: 9, y: 4, st: 13 },
    Rec {
        x: 10,
        y: 4,
        st: 14,
    },
    Rec {
        x: 11,
        y: 4,
        st: 15,
    },
    Rec {
        x: 12,
        y: 4,
        st: 16,
    },
    Rec {
        x: 13,
        y: 4,
        st: 17,
    },
    Rec {
        x: 14,
        y: 4,
        st: 18,
    },
    Rec {
        x: 15,
        y: 4,
        st: 19,
    },
    Rec {
        x: 16,
        y: 4,
        st: 20,
    },
    Rec {
        x: -15,
        y: 5,
        st: 20,
    },
    Rec {
        x: -14,
        y: 5,
        st: 19,
    },
    Rec {
        x: -13,
        y: 5,
        st: 18,
    },
    Rec {
        x: -12,
        y: 5,
        st: 17,
    },
    Rec {
        x: -11,
        y: 5,
        st: 16,
    },
    Rec {
        x: -10,
        y: 5,
        st: 15,
    },
    Rec {
        x: -9,
        y: 5,
        st: 14,
    },
    Rec {
        x: -8,
        y: 5,
        st: 13,
    },
    Rec {
        x: -7,
        y: 5,
        st: 12,
    },
    Rec {
        x: -6,
        y: 5,
        st: 11,
    },
    Rec {
        x: -5,
        y: 5,
        st: 10,
    },
    Rec { x: -4, y: 5, st: 9 },
    Rec { x: -3, y: 5, st: 8 },
    Rec { x: -2, y: 5, st: 7 },
    Rec { x: -1, y: 5, st: 6 },
    Rec { x: 0, y: 5, st: 5 },
    Rec { x: 1, y: 5, st: 6 },
    Rec { x: 2, y: 5, st: 7 },
    Rec { x: 3, y: 5, st: 8 },
    Rec { x: 4, y: 5, st: 9 },
    Rec { x: 5, y: 5, st: 10 },
    Rec { x: 6, y: 5, st: 11 },
    Rec { x: 7, y: 5, st: 12 },
    Rec { x: 8, y: 5, st: 13 },
    Rec { x: 9, y: 5, st: 14 },
    Rec {
        x: 10,
        y: 5,
        st: 15,
    },
    Rec {
        x: 11,
        y: 5,
        st: 16,
    },
    Rec {
        x: 12,
        y: 5,
        st: 17,
    },
    Rec {
        x: 13,
        y: 5,
        st: 18,
    },
    Rec {
        x: 14,
        y: 5,
        st: 19,
    },
    Rec {
        x: 15,
        y: 5,
        st: 20,
    },
    Rec {
        x: -14,
        y: 6,
        st: 20,
    },
    Rec {
        x: -13,
        y: 6,
        st: 19,
    },
    Rec {
        x: -12,
        y: 6,
        st: 18,
    },
    Rec {
        x: -11,
        y: 6,
        st: 17,
    },
    Rec {
        x: -10,
        y: 6,
        st: 16,
    },
    Rec {
        x: -9,
        y: 6,
        st: 15,
    },
    Rec {
        x: -8,
        y: 6,
        st: 14,
    },
    Rec {
        x: -7,
        y: 6,
        st: 13,
    },
    Rec {
        x: -6,
        y: 6,
        st: 12,
    },
    Rec {
        x: -5,
        y: 6,
        st: 11,
    },
    Rec {
        x: -4,
        y: 6,
        st: 10,
    },
    Rec { x: -3, y: 6, st: 9 },
    Rec { x: -2, y: 6, st: 8 },
    Rec { x: -1, y: 6, st: 7 },
    Rec { x: 0, y: 6, st: 6 },
    Rec { x: 1, y: 6, st: 7 },
    Rec { x: 2, y: 6, st: 8 },
    Rec { x: 3, y: 6, st: 9 },
    Rec { x: 4, y: 6, st: 10 },
    Rec { x: 5, y: 6, st: 11 },
    Rec { x: 6, y: 6, st: 12 },
    Rec { x: 7, y: 6, st: 13 },
    Rec { x: 8, y: 6, st: 14 },
    Rec { x: 9, y: 6, st: 15 },
    Rec {
        x: 10,
        y: 6,
        st: 16,
    },
    Rec {
        x: 11,
        y: 6,
        st: 17,
    },
    Rec {
        x: 12,
        y: 6,
        st: 18,
    },
    Rec {
        x: 13,
        y: 6,
        st: 19,
    },
    Rec {
        x: 14,
        y: 6,
        st: 20,
    },
    Rec {
        x: -13,
        y: 7,
        st: 20,
    },
    Rec {
        x: -12,
        y: 7,
        st: 19,
    },
    Rec {
        x: -11,
        y: 7,
        st: 18,
    },
    Rec {
        x: -10,
        y: 7,
        st: 17,
    },
    Rec {
        x: -9,
        y: 7,
        st: 16,
    },
    Rec {
        x: -8,
        y: 7,
        st: 15,
    },
    Rec {
        x: -7,
        y: 7,
        st: 14,
    },
    Rec {
        x: -6,
        y: 7,
        st: 13,
    },
    Rec {
        x: -5,
        y: 7,
        st: 12,
    },
    Rec {
        x: -4,
        y: 7,
        st: 11,
    },
    Rec {
        x: -3,
        y: 7,
        st: 10,
    },
    Rec { x: -2, y: 7, st: 9 },
    Rec { x: -1, y: 7, st: 8 },
    Rec { x: 0, y: 7, st: 7 },
    Rec { x: 1, y: 7, st: 8 },
    Rec { x: 2, y: 7, st: 9 },
    Rec { x: 3, y: 7, st: 10 },
    Rec { x: 4, y: 7, st: 11 },
    Rec { x: 5, y: 7, st: 12 },
    Rec { x: 6, y: 7, st: 13 },
    Rec { x: 7, y: 7, st: 14 },
    Rec { x: 8, y: 7, st: 15 },
    Rec { x: 9, y: 7, st: 16 },
    Rec {
        x: 10,
        y: 7,
        st: 17,
    },
    Rec {
        x: 11,
        y: 7,
        st: 18,
    },
    Rec {
        x: 12,
        y: 7,
        st: 19,
    },
    Rec {
        x: 13,
        y: 7,
        st: 20,
    },
    Rec {
        x: -12,
        y: 8,
        st: 20,
    },
    Rec {
        x: -11,
        y: 8,
        st: 19,
    },
    Rec {
        x: -10,
        y: 8,
        st: 18,
    },
    Rec {
        x: -9,
        y: 8,
        st: 17,
    },
    Rec {
        x: -8,
        y: 8,
        st: 16,
    },
    Rec {
        x: -7,
        y: 8,
        st: 15,
    },
    Rec {
        x: -6,
        y: 8,
        st: 14,
    },
    Rec {
        x: -5,
        y: 8,
        st: 13,
    },
    Rec {
        x: -4,
        y: 8,
        st: 12,
    },
    Rec {
        x: -3,
        y: 8,
        st: 11,
    },
    Rec {
        x: -2,
        y: 8,
        st: 10,
    },
    Rec { x: -1, y: 8, st: 9 },
    Rec { x: 0, y: 8, st: 8 },
    Rec { x: 1, y: 8, st: 9 },
    Rec { x: 2, y: 8, st: 10 },
    Rec { x: 3, y: 8, st: 11 },
    Rec { x: 4, y: 8, st: 12 },
    Rec { x: 5, y: 8, st: 13 },
    Rec { x: 6, y: 8, st: 14 },
    Rec { x: 7, y: 8, st: 15 },
    Rec { x: 8, y: 8, st: 16 },
    Rec { x: 9, y: 8, st: 17 },
    Rec {
        x: 10,
        y: 8,
        st: 18,
    },
    Rec {
        x: 11,
        y: 8,
        st: 19,
    },
    Rec {
        x: 12,
        y: 8,
        st: 20,
    },
    Rec {
        x: -11,
        y: 9,
        st: 20,
    },
    Rec {
        x: -10,
        y: 9,
        st: 19,
    },
    Rec {
        x: -9,
        y: 9,
        st: 18,
    },
    Rec {
        x: -8,
        y: 9,
        st: 17,
    },
    Rec {
        x: -7,
        y: 9,
        st: 16,
    },
    Rec {
        x: -6,
        y: 9,
        st: 15,
    },
    Rec {
        x: -5,
        y: 9,
        st: 14,
    },
    Rec {
        x: -4,
        y: 9,
        st: 13,
    },
    Rec {
        x: -3,
        y: 9,
        st: 12,
    },
    Rec {
        x: -2,
        y: 9,
        st: 11,
    },
    Rec {
        x: -1,
        y: 9,
        st: 10,
    },
    Rec { x: 0, y: 9, st: 9 },
    Rec { x: 1, y: 9, st: 10 },
    Rec { x: 2, y: 9, st: 11 },
    Rec { x: 3, y: 9, st: 12 },
    Rec { x: 4, y: 9, st: 13 },
    Rec { x: 5, y: 9, st: 14 },
    Rec { x: 6, y: 9, st: 15 },
    Rec { x: 7, y: 9, st: 16 },
    Rec { x: 8, y: 9, st: 17 },
    Rec { x: 9, y: 9, st: 18 },
    Rec {
        x: 10,
        y: 9,
        st: 19,
    },
    Rec {
        x: 11,
        y: 9,
        st: 20,
    },
    Rec {
        x: -10,
        y: 10,
        st: 20,
    },
    Rec {
        x: -9,
        y: 10,
        st: 19,
    },
    Rec {
        x: -8,
        y: 10,
        st: 18,
    },
    Rec {
        x: -7,
        y: 10,
        st: 17,
    },
    Rec {
        x: -6,
        y: 10,
        st: 16,
    },
    Rec {
        x: -5,
        y: 10,
        st: 15,
    },
    Rec {
        x: -4,
        y: 10,
        st: 14,
    },
    Rec {
        x: -3,
        y: 10,
        st: 13,
    },
    Rec {
        x: -2,
        y: 10,
        st: 12,
    },
    Rec {
        x: -1,
        y: 10,
        st: 11,
    },
    Rec {
        x: 0,
        y: 10,
        st: 10,
    },
    Rec {
        x: 1,
        y: 10,
        st: 11,
    },
    Rec {
        x: 2,
        y: 10,
        st: 12,
    },
    Rec {
        x: 3,
        y: 10,
        st: 13,
    },
    Rec {
        x: 4,
        y: 10,
        st: 14,
    },
    Rec {
        x: 5,
        y: 10,
        st: 15,
    },
    Rec {
        x: 6,
        y: 10,
        st: 16,
    },
    Rec {
        x: 7,
        y: 10,
        st: 17,
    },
    Rec {
        x: 8,
        y: 10,
        st: 18,
    },
    Rec {
        x: 9,
        y: 10,
        st: 19,
    },
    Rec {
        x: 10,
        y: 10,
        st: 20,
    },
    Rec {
        x: -9,
        y: 11,
        st: 20,
    },
    Rec {
        x: -8,
        y: 11,
        st: 19,
    },
    Rec {
        x: -7,
        y: 11,
        st: 18,
    },
    Rec {
        x: -6,
        y: 11,
        st: 17,
    },
    Rec {
        x: -5,
        y: 11,
        st: 16,
    },
    Rec {
        x: -4,
        y: 11,
        st: 15,
    },
    Rec {
        x: -3,
        y: 11,
        st: 14,
    },
    Rec {
        x: -2,
        y: 11,
        st: 13,
    },
    Rec {
        x: -1,
        y: 11,
        st: 12,
    },
    Rec {
        x: 0,
        y: 11,
        st: 11,
    },
    Rec {
        x: 1,
        y: 11,
        st: 12,
    },
    Rec {
        x: 2,
        y: 11,
        st: 13,
    },
    Rec {
        x: 3,
        y: 11,
        st: 14,
    },
    Rec {
        x: 4,
        y: 11,
        st: 15,
    },
    Rec {
        x: 5,
        y: 11,
        st: 16,
    },
    Rec {
        x: 6,
        y: 11,
        st: 17,
    },
    Rec {
        x: 7,
        y: 11,
        st: 18,
    },
    Rec {
        x: 8,
        y: 11,
        st: 19,
    },
    Rec {
        x: 9,
        y: 11,
        st: 20,
    },
    Rec {
        x: -8,
        y: 12,
        st: 20,
    },
    Rec {
        x: -7,
        y: 12,
        st: 19,
    },
    Rec {
        x: -6,
        y: 12,
        st: 18,
    },
    Rec {
        x: -5,
        y: 12,
        st: 17,
    },
    Rec {
        x: -4,
        y: 12,
        st: 16,
    },
    Rec {
        x: -3,
        y: 12,
        st: 15,
    },
    Rec {
        x: -2,
        y: 12,
        st: 14,
    },
    Rec {
        x: -1,
        y: 12,
        st: 13,
    },
    Rec {
        x: 0,
        y: 12,
        st: 12,
    },
    Rec {
        x: 1,
        y: 12,
        st: 13,
    },
    Rec {
        x: 2,
        y: 12,
        st: 14,
    },
    Rec {
        x: 3,
        y: 12,
        st: 15,
    },
    Rec {
        x: 4,
        y: 12,
        st: 16,
    },
    Rec {
        x: 5,
        y: 12,
        st: 17,
    },
    Rec {
        x: 6,
        y: 12,
        st: 18,
    },
    Rec {
        x: 7,
        y: 12,
        st: 19,
    },
    Rec {
        x: 8,
        y: 12,
        st: 20,
    },
    Rec {
        x: -7,
        y: 13,
        st: 20,
    },
    Rec {
        x: -6,
        y: 13,
        st: 19,
    },
    Rec {
        x: -5,
        y: 13,
        st: 18,
    },
    Rec {
        x: -4,
        y: 13,
        st: 17,
    },
    Rec {
        x: -3,
        y: 13,
        st: 16,
    },
    Rec {
        x: -2,
        y: 13,
        st: 15,
    },
    Rec {
        x: -1,
        y: 13,
        st: 14,
    },
    Rec {
        x: 0,
        y: 13,
        st: 13,
    },
    Rec {
        x: 1,
        y: 13,
        st: 14,
    },
    Rec {
        x: 2,
        y: 13,
        st: 15,
    },
    Rec {
        x: 3,
        y: 13,
        st: 16,
    },
    Rec {
        x: 4,
        y: 13,
        st: 17,
    },
    Rec {
        x: 5,
        y: 13,
        st: 18,
    },
    Rec {
        x: 6,
        y: 13,
        st: 19,
    },
    Rec {
        x: 7,
        y: 13,
        st: 20,
    },
    Rec {
        x: -6,
        y: 14,
        st: 20,
    },
    Rec {
        x: -5,
        y: 14,
        st: 19,
    },
    Rec {
        x: -4,
        y: 14,
        st: 18,
    },
    Rec {
        x: -3,
        y: 14,
        st: 17,
    },
    Rec {
        x: -2,
        y: 14,
        st: 16,
    },
    Rec {
        x: -1,
        y: 14,
        st: 15,
    },
    Rec {
        x: 0,
        y: 14,
        st: 14,
    },
    Rec {
        x: 1,
        y: 14,
        st: 15,
    },
    Rec {
        x: 2,
        y: 14,
        st: 16,
    },
    Rec {
        x: 3,
        y: 14,
        st: 17,
    },
    Rec {
        x: 4,
        y: 14,
        st: 18,
    },
    Rec {
        x: 5,
        y: 14,
        st: 19,
    },
    Rec {
        x: 6,
        y: 14,
        st: 20,
    },
    Rec {
        x: -5,
        y: 15,
        st: 20,
    },
    Rec {
        x: -4,
        y: 15,
        st: 19,
    },
    Rec {
        x: -3,
        y: 15,
        st: 18,
    },
    Rec {
        x: -2,
        y: 15,
        st: 17,
    },
    Rec {
        x: -1,
        y: 15,
        st: 16,
    },
    Rec {
        x: 0,
        y: 15,
        st: 15,
    },
    Rec {
        x: 1,
        y: 15,
        st: 16,
    },
    Rec {
        x: 2,
        y: 15,
        st: 17,
    },
    Rec {
        x: 3,
        y: 15,
        st: 18,
    },
    Rec {
        x: 4,
        y: 15,
        st: 19,
    },
    Rec {
        x: 5,
        y: 15,
        st: 20,
    },
    Rec {
        x: -4,
        y: 16,
        st: 20,
    },
    Rec {
        x: -3,
        y: 16,
        st: 19,
    },
    Rec {
        x: -2,
        y: 16,
        st: 18,
    },
    Rec {
        x: -1,
        y: 16,
        st: 17,
    },
    Rec {
        x: 0,
        y: 16,
        st: 16,
    },
    Rec {
        x: 1,
        y: 16,
        st: 17,
    },
    Rec {
        x: 2,
        y: 16,
        st: 18,
    },
    Rec {
        x: 3,
        y: 16,
        st: 19,
    },
    Rec {
        x: 4,
        y: 16,
        st: 20,
    },
    Rec {
        x: -3,
        y: 17,
        st: 20,
    },
    Rec {
        x: -2,
        y: 17,
        st: 19,
    },
    Rec {
        x: -1,
        y: 17,
        st: 18,
    },
    Rec {
        x: 0,
        y: 17,
        st: 17,
    },
    Rec {
        x: 1,
        y: 17,
        st: 18,
    },
    Rec {
        x: 2,
        y: 17,
        st: 19,
    },
    Rec {
        x: 3,
        y: 17,
        st: 20,
    },
    Rec {
        x: -2,
        y: 18,
        st: 20,
    },
    Rec {
        x: -1,
        y: 18,
        st: 19,
    },
    Rec {
        x: 0,
        y: 18,
        st: 18,
    },
    Rec {
        x: 1,
        y: 18,
        st: 19,
    },
    Rec {
        x: 2,
        y: 18,
        st: 20,
    },
    Rec {
        x: -1,
        y: 19,
        st: 20,
    },
    Rec {
        x: 0,
        y: 19,
        st: 19,
    },
    Rec {
        x: 1,
        y: 19,
        st: 20,
    },
    Rec {
        x: 0,
        y: 20,
        st: 20,
    },
];

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
        aoc::test::auto("../2024/20/", parts);
    }
}
