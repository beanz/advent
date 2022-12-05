type Stack = [u8; 80];

#[allow(dead_code)]
fn len(s: &Stack) -> u8 {
    s[0]
}
fn unshift(s: &mut Stack, v: u8) {
    let mut i = s[0] as usize;
    while i != 0 {
        s[i + 1] = s[i];
        i -= 1;
    }
    s[1] = v;
    s[0] += 1;
}
fn top(s: &Stack) -> u8 {
    if s[0] == 0 {
        32
    } else {
        s[s[0] as usize]
    }
}
#[allow(dead_code)]
fn pop(s: &mut Stack) -> u8 {
    s[0] -= 1;
    s[(1 + s[0]) as usize]
}
#[allow(dead_code)]
fn push(s: &mut Stack, v: u8) {
    s[0] += 1;
    s[s[0] as usize] = v;
}
fn mov(s: &mut Stack, d: &mut Stack, n: usize) {
    assert!(s[0] as usize >= n);
    for i in 0..n {
        let so = s[0] as usize;
        let d_o = d[0] as usize + 1;
        d[d_o + i] = s[so - i];
    }
    s[0] -= n as u8;
    d[0] += n as u8;
}

fn mov2(s: &mut Stack, d: &mut Stack, n: usize) {
    assert!(s[0] as usize >= n);
    let o = d[0] as usize + 1;
    d[o..o + n].copy_from_slice(&s[(s[0] + 1) as usize - n..(s[0] + 1) as usize]);
    s[0] -= n as u8;
    d[0] += n as u8;
}

fn parts(inp: &[u8]) -> ([u8; 9], [u8; 9]) {
    let mut stacks = [[0; 80]; 18];
    let mut i = 0;
    let mut j = 0;
    while i < inp.len() {
        if inp[i] == b'\n' {
            if j == 0 {
                break;
            }
            j = 0;
            i += 1;
            continue;
        }
        j += 1;
        if inp[i] < b'A' || inp[i] > b'Z' {
            i += 1;
            continue;
        }
        let si = (j - 1) / 4;
        unshift(&mut stacks[si], inp[i]);
        unshift(&mut stacks[si + 9], inp[i]);
        i += 1;
    }
    i += 1;
    while i < inp.len() {
        let (j, n) = aoc::read::uint::<usize>(inp, i + 5);
        let f = (inp[j + 6] - b'1') as usize;
        let t = (inp[j + 11] - b'1') as usize;
        {
            let (s, d) = if f < t {
                let (l, r) = stacks.split_at_mut(t);
                (&mut l[f], &mut r[0])
            } else {
                let (l, r) = stacks.split_at_mut(f);
                (&mut r[0], &mut l[t])
            };
            mov(s, d, n);
        }
        {
            let (s, d) = if f < t {
                let (l, r) = stacks.split_at_mut(9 + t);
                (&mut l[9 + f], &mut r[0])
            } else {
                let (l, r) = stacks.split_at_mut(9 + f);
                (&mut r[0], &mut l[9 + t])
            };
            mov2(s, d, n);
        }
        i = j + 13;
    }
    let mut p1 = [32; 9];
    let mut p2 = [32; 9];
    for i in 0..9 {
        p1[i] = top(&stacks[i]);
        p2[i] = top(&stacks[9 + i]);
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
        let mut s = [0; 80];
        assert_eq!(len(&s), 0);
        unshift(&mut s, b'A');
        assert_eq!(len(&s), 1);
        assert_eq!(top(&s), b'A');
        unshift(&mut s, b'B');
        assert_eq!(len(&s), 2);
        assert_eq!(top(&s), b'A');
        push(&mut s, b'C');
        assert_eq!(len(&s), 3);
        assert_eq!(top(&s), b'C');
        assert_eq!(pop(&mut s), b'C');
        assert_eq!(len(&s), 2);
        assert_eq!(top(&s), b'A');
        let mut d = [0; 80];
        mov(&mut s, &mut d, 2);
        assert_eq!(len(&s), 0);
        assert_eq!(len(&d), 2);
        assert_eq!(top(&d), b'B');
        mov2(&mut d, &mut s, 2);
        assert_eq!(len(&d), 0);
        assert_eq!(len(&s), 2);
        assert_eq!(top(&s), b'B');
    }
    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/05/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (*b"CMZ      ", *b"MCD      "));
        let inp = std::fs::read("../2022/05/input.txt").expect("read error");
        assert_eq!(parts(&inp), (*b"PTWLTDSJV", *b"WZMFVGGZP"));
    }
}
