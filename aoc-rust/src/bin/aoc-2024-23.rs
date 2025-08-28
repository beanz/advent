use heapless::Vec;

fn parts(inp: &[u8]) -> (usize, [u8; 38]) {
    let mut i = 0;
    let mut g: [bool; 456976] = [false; 456976];
    let mut nodes = Vec::<usize, 1024>::new();
    let mut dedup = [false; 676];
    while i < inp.len() {
        let a = num(inp[i], inp[i + 1]);
        let b = num(inp[i + 3], inp[i + 4]);
        g[(a * 676) + b] = true;
        g[(b * 676) + a] = true;
        if !dedup[a] {
            nodes.push(a).expect("overflow");
            dedup[a] = true;
        }
        if !dedup[b] {
            nodes.push(b).expect("overflow");
            dedup[b] = true;
        }
        i += 6;
    }
    let mut p1 = 0;
    for i in 0..nodes.len() {
        let a = nodes[i];
        for j in i + 1..nodes.len() {
            let b = nodes[j];
            if !g[(a * 676) + b] {
                continue;
            }
            for k in j + 1..nodes.len() {
                let c = nodes[k];
                if g[(a * 676) + c] && g[(b * 676) + c] && (has_t(a) || has_t(b) || has_t(c)) {
                    p1 += 1;
                }
            }
        }
    }
    let mut dedup = [false; 676];
    let mut p2 = Vec::<usize, 32>::new();
    let mut set = Vec::<usize, 32>::new();
    for i in 0..nodes.len() {
        let a = nodes[i];
        if dedup[a] {
            continue;
        }
        dedup[a] = true;
        set.push(a).expect("overflow");
        for j in 0..nodes.len() {
            if i == j {
                continue;
            }
            let b = nodes[j];
            if !g[(a * 676) + b] {
                continue;
            }
            let mut l = 0;
            for c in &set {
                if g[(b * 676) + *c] {
                    l += 1;
                }
            }
            if l == set.len() {
                dedup[b] = true;
                set.push(b).expect("overflow");
            }
        }
        if set.len() > p2.len() {
            (p2, set) = (set, p2);
        }
        set.clear();
    }
    p2.sort_unstable();
    let p2 = p2.as_slice();
    let mut p2r = [32; 38];
    let n = name(p2[0]);
    p2r[0] = n.0;
    p2r[1] = n.1;
    for i in 1..p2.len() {
        let j = 2 + (i - 1) * 3;
        let n = name(p2[i]);
        p2r[j] = b',';
        p2r[j + 1] = n.0;
        p2r[j + 2] = n.1;
    }

    (p1, p2r)
}

fn num(a: u8, b: u8) -> usize {
    (((a - b'a') as usize) * 26) + ((b - b'a') as usize)
}

#[allow(dead_code)]
fn name(a: usize) -> (u8, u8) {
    ((a / 26) as u8 + b'a', (a % 26) as u8 + b'a')
}

fn has_t(a: usize) -> bool {
    (a / 26) as u8 + b'a' == b't'
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {}", std::str::from_utf8(&p2[0..]).expect("ascii"));
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        aoc::test::auto("../2024/23/", parts);
    }
}
