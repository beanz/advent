use aoc::deque::Deque;
use heapless::FnvIndexMap;
use smallvec::SmallVec;

const HI: bool = true;
const LO: bool = false;

const BUTTON: usize = 0;
const BCASTER: usize = 1;
const OUTPUT: usize = 2;
const NAND: usize = 3;
const NOT: usize = 4;
const SIZE: usize = 26 * 26 + OUTPUT;

#[derive(Clone, Debug, Default)]
struct Pulse {
    sig: bool,
    dst: usize,
}

#[derive(Debug)]
struct Node {
    kind: u8,
    outputs: SmallVec<[usize; 32]>,
    inputs: SmallVec<[usize; 32]>,
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let rx = 468;
    let mut nodes = FnvIndexMap::<usize, Node, 64>::new();
    let mut i = 0;
    let mut ids = SmallVec::<[(usize, usize); 256]>::new();
    while i < inp.len() {
        let (kind, id) = read_kind_id(inp, &mut i);
        let kind = kind as u8;
        let mut node = Node {
            kind,
            outputs: SmallVec::<[usize; 32]>::new(),
            inputs: SmallVec::<[usize; 32]>::new(),
        };
        i += 2;
        while inp[i] != b'\n' {
            i += 2;
            let oid = read_id(inp, &mut i);
            node.outputs.push(oid);
            ids.push((oid, id));
        }
        nodes.insert(id, node).expect("node insert");
        i += 1;
    }
    let mut bo = SmallVec::<[usize; 32]>::new();
    bo.push(BCASTER);
    nodes
        .insert(
            BUTTON,
            Node {
                kind: BUTTON as u8,
                outputs: bo,
                inputs: SmallVec::<[usize; 32]>::new(),
            },
        )
        .expect("insert button");
    for (oid, id) in ids {
        if oid == OUTPUT {
            continue;
        }
        if oid == rx {
            nodes
                .insert(
                    rx,
                    Node {
                        kind: BUTTON as u8,
                        outputs: SmallVec::<[usize; 32]>::new(),
                        inputs: SmallVec::<[usize; 32]>::new(),
                    },
                )
                .expect("rx node");
        }
        let n = nodes.get_mut(&oid).expect("node");
        n.inputs.push(id);
    }

    let (mut c_hi, mut c_lo): (usize, usize) = (0, 0);
    let mut flip: [bool; SIZE] = [false; SIZE];
    let mut nand: [bool; SIZE * 32] = [false; SIZE * 32];
    let mut fired: [usize; SIZE] = [0; SIZE];
    let mut cycle = |c: usize, fired: &mut [usize; SIZE], c_lo: &mut usize, c_hi: &mut usize| {
        let mut todo = Deque::<Pulse, 512>::default();
        todo.push(Pulse {
            sig: LO,
            dst: BUTTON,
        });
        while let Some(cur) = todo.pop() {
            if cur.dst == OUTPUT {
                continue;
            }
            for out in &nodes.get(&cur.dst).expect("node").outputs {
                if cur.sig {
                    *c_hi += 1;
                } else {
                    *c_lo += 1;
                }
                if *out == 2 || *out == 468 {
                    continue;
                }
                let n = nodes.get(out).expect("output node");
                if n.kind == BCASTER as u8 {
                    todo.push(Pulse {
                        sig: cur.sig,
                        dst: *out,
                    });
                    continue;
                }
                if n.kind == NOT as u8 {
                    if cur.sig == LO {
                        flip[*out] = !flip[*out];
                        todo.push(Pulse {
                            sig: flip[*out],
                            dst: *out,
                        });
                    }
                    continue;
                }
                let mut nsig = HI;
                for (k, ip) in (&n.inputs).into_iter().enumerate() {
                    if *ip == cur.dst {
                        nand[*out * 32 + k] = cur.sig;
                    }
                    nsig = nsig && nand[*out * 32 + k];
                }
                if nsig {
                    todo.push(Pulse { sig: LO, dst: *out });
                } else {
                    fired[*out] = c + 1;
                    todo.push(Pulse { sig: HI, dst: *out });
                }
            }
        }
    };
    let mut c: usize = 0;
    while c < 1000 {
        cycle(c, &mut fired, &mut c_lo, &mut c_hi);
        c += 1;
    }
    let p1 = c_lo * c_hi;
    let mut important: [usize; 4] = [0; 4];
    if let Some(n) = nodes.get(&rx) {
        let ip = n.inputs[0];
        let n = nodes.get(&ip).expect("next layer node");
        for (k, id) in (&n.inputs).into_iter().enumerate() {
            important[k] = *id;
        }
    } else {
        return (p1, 0);
    }
    loop {
        cycle(c, &mut fired, &mut c_lo, &mut c_hi);
        c += 1;
        let mut found = true;
        for ip in important {
            if fired[ip] == 0 {
                found = false;
                break;
            }
        }
        if found {
            break;
        }
    }
    let mut p2 = 1;
    for ip in important {
        p2 *= fired[ip];
    }

    (p1, p2)
}

fn read_kind_id(inp: &[u8], i: &mut usize) -> (usize, usize) {
    if inp[*i] == b'b' && inp[*i + 1] == b'r' && inp[*i + 2] == b'o' {
        *i += 11;
        return (BCASTER, BCASTER);
    }
    if inp[*i] == b'%' {
        *i += 1;
        return (NOT, read_id(inp, i));
    } else if inp[*i] == b'&' {
        *i += 1;
        return (NAND, read_id(inp, i));
    }
    unreachable!("invalid kind")
}

fn read_id(inp: &[u8], i: &mut usize) -> usize {
    if *i + 2 < inp.len() && inp[*i + 2] == b't' {
        *i += 6;
        return OUTPUT;
    }
    if inp[*i + 1] < b'a' {
        let id = NAND + ((inp[*i] - b'a') as usize);
        *i += 1;
        return id;
    }
    let id = NAND + ((inp[*i] - b'a') as usize) * 26 + ((inp[*i + 1] - b'a') as usize);
    *i += 2;
    id
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
        let inp = std::fs::read("../2023/20/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (32000000, 0));
        let inp = std::fs::read("../2023/20/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (11687500, 0));
        let inp = std::fs::read("../2023/20/input.txt").expect("read error");
        assert_eq!(parts(&inp), (712543680, 238920142622879));
        let inp = std::fs::read("../2023/20/input2.txt").expect("read error");
        assert_eq!(parts(&inp), (817896682, 250924073918341));
    }
}
