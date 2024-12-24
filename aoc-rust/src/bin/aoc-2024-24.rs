use hash32::{Hash, Hasher};
use heapless::{FnvIndexMap, FnvIndexSet, Vec};

#[derive(Eq, PartialEq, Debug, Clone)]
enum Op {
    And,
    Or,
    Xor,
}

impl Hash for Op {
    fn hash<H: Hasher>(&self, _: &mut H) {}
}

#[derive(Eq, PartialEq, Debug)]
struct Gate {
    a: [u8; 3],
    b: [u8; 3],
    op: Op,
}

impl Hash for Gate {
    fn hash<H: Hasher>(&self, state: &mut H) {
        self.a.hash(state);
        self.b.hash(state);
        self.op.hash(state);
    }
}

fn parts(inp: &[u8]) -> (usize, [u8; 31]) {
    let mut gates = FnvIndexMap::<[u8; 3], Gate, 256>::new();
    let mut rev = FnvIndexMap::<Gate, [u8; 3], 256>::new();
    let mut rev2 = FnvIndexMap::<[u8; 3], Gate, 512>::new();
    let mut bad = FnvIndexSet::<[u8; 3], 8>::new();
    let mut x: [bool; 45] = [false; 45];
    let mut y: [bool; 45] = [false; 45];
    let mut bit_count = 0;
    let mut i = 0;
    while i < inp.len() {
        if inp[i] == b'\n' {
            i += 1;
            continue;
        }
        if inp[i + 3] == b':' {
            let n = 10 * ((inp[i + 1] - b'0') as usize) + ((inp[i + 2] - b'0') as usize);
            let v = inp[i + 5] == b'1';
            if inp[i] == b'x' {
                x[n] = v;
            } else {
                y[n] = v;
            }
            i += 7;
            continue;
        }
        let (op, off) = match inp[i + 4] {
            b'X' => (Op::Xor, 1),
            b'A' => (Op::And, 1),
            b'O' => (Op::Or, 0),
            _ => unreachable!(),
        };
        let a = [inp[i], inp[i + 1], inp[i + 2]];
        let b = [inp[i + 7 + off], inp[i + 8 + off], inp[i + 9 + off]];
        let r = [inp[i + 14 + off], inp[i + 15 + off], inp[i + 16 + off]];
        if r[0] == b'z' {
            let n = 10 * ((r[1] - b'0') as usize) + ((r[2] - b'0') as usize);
            if n > bit_count {
                bit_count = n;
            }
        }
        rev.insert(
            Gate {
                a,
                b,
                op: op.clone(),
            },
            r,
        )
        .expect("overflow");
        gates
            .insert(
                r,
                Gate {
                    a,
                    b,
                    op: op.clone(),
                },
            )
            .expect("overflow");
        rev2.insert(
            a,
            Gate {
                a,
                b,
                op: op.clone(),
            },
        )
        .expect("overflow");
        rev2.insert(
            b,
            Gate {
                b,
                a,
                op: op.clone(),
            },
        )
        .expect("overflow");
        if op == Op::Xor
            && !((a[0] == b'x' && b[0] == b'y') || (b[0] == b'x' && a[0] == b'y') || r[0] == b'z')
        {
            bad.insert(r).expect("overflow");
        }
        i += 18 + off;
    }
    let mut p1 = 0;
    let mut z = bit_count;
    loop {
        let (t, u) = ((z / 10) as u8 + b'0', (z % 10) as u8 + b'0');
        p1 = (p1 << 1) + usize::from(value(&gates, &x, &y, [b'z', t, u]));

        let gxor = &Gate {
            a: [b'x', t, u],
            b: [b'y', t, u],
            op: Op::Xor,
        };
        let xor = get_rev(&rev, gxor);
        let gand = &Gate {
            a: [b'x', t, u],
            b: [b'y', t, u],
            op: Op::And,
        };
        let and = get_rev(&rev, gand);

        let znn = gates.get(&[b'z', t, u]);

        if xor == None || and == None || znn == None {
            z -= 1;
            continue;
        }
        let and = and.unwrap();
        let xor = xor.unwrap();
        let znn = znn.unwrap();

        if znn.op != Op::Xor {
            bad.insert([b'z', t, u]).expect("overflow");
        }

        let or = rev2.get(and);
        if or == None || or.unwrap().op != Op::Or {
            if z > 0 {
                bad.insert(*and).expect("overflow");
            }
        }
        let not_or = rev2.get(xor);
        if not_or == None || not_or.unwrap().op == Op::Or {
            if z > 0 {
                bad.insert(*xor).expect("overflow");
            }
        }
        if z == 0 {
            break;
        }
        z -= 1;
    }
    let mut p2 = Vec::<[u8; 3], 8>::new();
    for b in bad.iter() {
        p2.push(*b).expect("overflow");
    }
    p2.sort_unstable();
    let p2 = p2.as_slice();
    let mut p2r = [32; 31];
    p2r[0] = p2[0][0];
    p2r[1] = p2[0][1];
    p2r[2] = p2[0][2];
    for i in 1..p2.len() {
        let j = 3 + (i - 1) * 4;
        p2r[j] = b',';
        p2r[j + 1] = p2[i][0];
        p2r[j + 2] = p2[i][1];
        p2r[j + 3] = p2[i][2];
    }
    (p1, p2r)
}

fn get_rev<'a>(rev: &'a FnvIndexMap<Gate, [u8; 3], 256>, g: &'a Gate) -> Option<&'a [u8; 3]> {
    if let Some(v) = rev.get(g) {
        Some(v)
    } else {
        rev.get(&Gate {
            a: g.b,
            b: g.a,
            op: g.op.clone(),
        })
    }
}

fn value(
    gates: &FnvIndexMap<[u8; 3], Gate, 256>,
    x: &[bool; 45],
    y: &[bool; 45],
    k: [u8; 3],
) -> bool {
    if let Some(g) = gates.get(&k) {
        let va = value(gates, x, y, g.a);
        let vb = value(gates, x, y, g.b);
        return match g.op {
            Op::Or => va || vb,
            Op::And => va && vb,
            Op::Xor => va != vb,
        };
    }
    let n = 10 * ((k[1] - b'0') as usize) + ((k[2] - b'0') as usize);
    if k[0] == b'x' {
        x[n]
    } else {
        y[n]
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", std::str::from_utf8(&p2).expect("ascii"));
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/24/", parts);
    }
}
