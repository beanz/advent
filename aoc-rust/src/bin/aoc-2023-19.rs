use smallvec::SmallVec;

#[derive(Clone, Copy)]

struct Check {
    key: u8,
    op: u8,
    val: usize,
    nxt: usize,
}

struct Search {
    state: usize,
    min: [usize; 4],
    max: [usize; 4],
}

const SIZE: usize = 26 * 26 * 26 * 2 * 4;
const IN: usize = 442;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut i = 0;
    let mut rules: [Option<Check>; SIZE] = [None; SIZE];
    while i < inp.len() {
        let id = chomp_id(inp, &mut i);
        let mut k: usize = 0;
        while inp[i] != b'}' {
            i += 1;
            if inp[i + 1] != b'<' && inp[i + 1] != b'>' {
                let nxt = chomp_id(inp, &mut i);
                rules[id * 4 + k] = Some(Check {
                    key: 0,
                    op: b':',
                    val: 0,
                    nxt,
                });
                break;
            }
            let key = key_ch(inp[i]);
            let op = inp[i + 1];
            i += 2;
            let (j, val): (usize, usize) = aoc::read::uint(inp, i);
            i = j + 1;
            let nxt = chomp_id(inp, &mut i);
            rules[id * 4 + k] = Some(Check { key, op, val, nxt });
            k += 1;
        }
        i += 1;
        if i + 1 < inp.len() && inp[i + 1] == b'\n' {
            break;
        }
        i += 1;
    }
    i += 2;
    let mut p1: usize = 0;
    while i < inp.len() {
        let mut p: [usize; 4] = [0, 0, 0, 0];
        while inp[i] != b'}' {
            i += 1;
            let k = key_ch(inp[i]);
            i += 2;
            let (j, n) = aoc::read::uint(inp, i);
            i = j;
            p[k as usize] = n;
        }
        let mut state: usize = IN;
        loop {
            if state == 0 {
                break;
            }
            if state == 1 {
                p1 += p[0] + p[1] + p[2] + p[3];
                break;
            }
            for k in 0..4 {
                if let Some(chk) = rules[state * 4 + k] {
                    if chk.op == b':' {
                        state = chk.nxt;
                        break;
                    }
                    if chk.op == b'<' {
                        if p[chk.key as usize] < chk.val {
                            state = chk.nxt;
                            break;
                        }
                        continue;
                    }
                    if p[chk.key as usize] > chk.val {
                        state = chk.nxt;
                        break;
                    }
                } else {
                    break;
                }
            }
        }
        i += 2;
    }
    let mut p2: usize = 0;
    let mut todo = SmallVec::<[Search; 512]>::new();
    todo.push(Search {
        state: IN,
        min: [1, 1, 1, 1],
        max: [4000, 4000, 4000, 4000],
    });
    while let Some(cur) = todo.pop() {
        let mut cur = cur;
        if cur.state == 0 {
            continue;
        }
        if cur.state == 1 {
            p2 += (cur.max[0] - cur.min[0] + 1)
                * (cur.max[1] - cur.min[1] + 1)
                * (cur.max[2] - cur.min[2] + 1)
                * (cur.max[3] - cur.min[3] + 1);
            continue;
        }
        for k in 0..4 {
            if let Some(chk) = rules[cur.state * 4 + k] {
                let mut ntrue = Search {
                    state: chk.nxt,
                    min: [cur.min[0], cur.min[1], cur.min[2], cur.min[3]],
                    max: [cur.max[0], cur.max[1], cur.max[2], cur.max[3]],
                };
                if chk.op == b':' {
                    todo.push(ntrue);
                    continue;
                }
                let ki = chk.key as usize;
                if chk.op == b'>' {
                    ntrue.min[ki] = if cur.min[ki] > chk.val + 1 {
                        cur.min[ki]
                    } else {
                        chk.val + 1
                    };
                    cur.max[ki] = if cur.max[ki] < chk.val {
                        cur.max[ki]
                    } else {
                        chk.val
                    };
                } else {
                    ntrue.max[ki] = if cur.max[ki] < chk.val - 1 {
                        cur.max[ki]
                    } else {
                        chk.val - 1
                    };
                    cur.min[ki] = if cur.min[ki] > chk.val {
                        cur.min[ki]
                    } else {
                        chk.val
                    };
                }
                todo.push(ntrue);
            } else {
                break;
            }
        }
    }
    (p1, p2)
}

fn key_ch(ch: u8) -> u8 {
    match ch {
        b'x' => 0,
        b'm' => 1,
        b'a' => 2,
        _ => 3,
    }
}

fn chomp_id(inp: &[u8], i: &mut usize) -> usize {
    let mut id: usize = 0;
    while *i < inp.len() {
        match inp[*i] {
            b'R' => {
                *i += 1;
                return 0;
            }
            b'A' => {
                *i += 1;
                return 1;
            }
            b'a'..=b'z' => {
                id = 26 * id + (inp[*i] - b'a') as usize;
                *i += 1;
                continue;
            }
            _ => break,
        }
    }
    id << 1
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
        let inp = std::fs::read("../2023/19/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (19114, 167409079868000));
        let inp = std::fs::read("../2023/19/input.txt").expect("read error");
        assert_eq!(parts(&inp), (353046, 125355665599537));
    }
}
