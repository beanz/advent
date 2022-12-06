const MAX_CRATES: usize = 60;
const MAX_STACKS: usize = 9;
type Dock = [u8; MAX_STACKS * MAX_CRATES * 2];

#[allow(dead_code)]
fn len(d: &Dock, i: usize) -> u8 {
    d[i * MAX_CRATES]
}
#[allow(dead_code)]
fn unshift(d: &mut Dock, i: usize, v: u8) {
    let o = i * MAX_CRATES;
    let l = d[o] as usize + 1 + o;
    d.copy_within(o + 1..l, o + 2);
    d[o + 1] = v;
    d[o] += 1;
}
fn top(d: &Dock, i: usize) -> u8 {
    let o = i * MAX_CRATES;
    if d[o] == 0 {
        32
    } else {
        d[o + d[o] as usize]
    }
}
#[allow(dead_code)]
fn reverse(d: &mut Dock, i: usize) {
    let o = i * MAX_CRATES;
    let l = d[o] as usize;
    d[(o + 1)..(l + o + 1)].reverse();
}
#[allow(dead_code)]
fn pop(d: &mut Dock, i: usize) -> u8 {
    let o = i * MAX_CRATES;
    d[o] -= 1;
    d[(1 + d[o]) as usize]
}
#[allow(dead_code)]
fn push(d: &mut Dock, i: usize, v: u8) {
    let o = i * MAX_CRATES;
    d[o] += 1;
    d[o + d[o] as usize] = v;
}
fn mov(d: &mut Dock, f: usize, t: usize, n: usize) {
    let fr = f * MAX_CRATES;
    assert!(d[fr] as usize >= n);
    let to = t * MAX_CRATES;
    let fe = d[fr] as usize + fr;
    let te = d[to] as usize + 1 + to;
    for i in 0..n {
        d[te + i] = d[fe - i];
    }
    d[fr] -= n as u8;
    d[to] += n as u8;
}

fn mov2(d: &mut Dock, f: usize, t: usize, n: usize) {
    let fr = f * MAX_CRATES;
    assert!(d[fr] as usize >= n);
    let to = t * MAX_CRATES;
    let fe = fr + 1 + (d[fr] as usize);
    let te = to + 1 + (d[to] as usize);
    d.copy_within(fe - n..fe, te);
    d[fr] -= n as u8;
    d[to] += n as u8;
}
#[allow(dead_code)]
fn debug(d: &Dock) {
    for i in 0..MAX_STACKS * 2 {
        let o = i * MAX_CRATES;
        if d[o] == 0 {
            continue;
        }
        eprintln!(
            "{}: {} {}",
            i,
            d[o],
            std::str::from_utf8(&d[o + 1..o + (d[o] as usize + 1)]).expect("ascii")
        );
    }
}

fn parts(inp: &[u8]) -> ([u8; 9], [u8; 9]) {
    let mut dock = [0; MAX_STACKS * MAX_CRATES * 2];
    let mut i = 0;
    let mut l = 0;
    while i < inp.len() {
        if inp[i] == b'\n' {
            l += 1;
            if inp[i + 1] == b'\n' {
                break;
            }
        }
        i += 1;
    }
    i += 1;
    let ll = i / l;
    let mut j = i - ll;
    while j > 0 {
        j -= ll;
        for k in 0..ll / 4 {
            let ch = inp[j + 1 + k * 4];
            if b'A' <= ch && ch <= b'Z' {
                push(&mut dock, k, ch);
                push(&mut dock, k + 9, ch);
            }
        }
    }
    i += 1;
    while i < inp.len() {
        let (j, n) = aoc::read::uint::<usize>(inp, i + 5);
        let f = (inp[j + 6] - b'1') as usize;
        let t = (inp[j + 11] - b'1') as usize;
        mov(&mut dock, f, t, n);
        mov2(&mut dock, 9 + f, 9 + t, n);
        i = j + 13;
    }
    let mut p1 = [32; 9];
    let mut p2 = [32; 9];
    for i in 0..9 {
        p1[i] = top(&dock, i);
        p2[i] = top(&dock, 9 + i);
    }
    (p1, p2)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {}", std::str::from_utf8(&p1[0..]).expect("ascii"));
            println!("Part 2: {}", std::str::from_utf8(&p2[0..]).expect("ascii"));
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn stack_works() {
        let mut d = [0; MAX_STACKS * MAX_CRATES * 2];
        assert_eq!(len(&d, 0), 0);
        unshift(&mut d, 0, b'A');
        assert_eq!(len(&d, 0), 1);
        assert_eq!(top(&d, 0), b'A');
        unshift(&mut d, 0, b'B');
        assert_eq!(len(&d, 0), 2);
        assert_eq!(top(&d, 0), b'A');
        push(&mut d, 0, b'C');
        assert_eq!(len(&d, 0), 3);
        assert_eq!(top(&d, 0), b'C');
        assert_eq!(pop(&mut d, 0), b'C');
        assert_eq!(len(&d, 0), 2);
        assert_eq!(top(&d, 0), b'A');
        mov(&mut d, 0, 1, 2);
        assert_eq!(len(&d, 0), 0);
        assert_eq!(len(&d, 1), 2);
        assert_eq!(top(&d, 1), b'B');
        mov2(&mut d, 1, 0, 2);
        assert_eq!(len(&d, 1), 0);
        assert_eq!(len(&d, 0), 2);
        assert_eq!(top(&d, 0), b'B');
        unshift(&mut d, 9, b'D');
        assert_eq!(len(&d, 9), 1);
        assert_eq!(top(&d, 9), b'D');
        unshift(&mut d, 9, b'C');
        assert_eq!(len(&d, 9), 2);
        assert_eq!(top(&d, 9), b'D');
        unshift(&mut d, 9, b'M');
        assert_eq!(len(&d, 9), 3);
        assert_eq!(top(&d, 9), b'D');
        reverse(&mut d, 9);
        assert_eq!(len(&d, 9), 3);
        assert_eq!(top(&d, 9), b'M');
    }
    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/05/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (*b"CMZ      ", *b"MCD      "));
        let inp = std::fs::read("../2022/05/input.txt").expect("read error");
        assert_eq!(parts(&inp), (*b"PTWLTDSJV", *b"WZMFVGGZP"));
    }
}
