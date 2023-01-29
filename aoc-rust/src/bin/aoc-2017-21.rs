#[allow(dead_code)]
fn pretty2(a: u16) {
    eprintln!(
        "{}{}\n{}{}\n",
        if a & 0b1000 != 0 { "#" } else { "." },
        if a & 0b0100 != 0 { "#" } else { "." },
        if a & 0b0010 != 0 { "#" } else { "." },
        if a & 0b0001 != 0 { "#" } else { "." },
    );
}

fn flip2(a: u16) -> u16 {
    ((a & 0b1100) >> 2) | ((a << 2) & 0b1100)
}

fn transpose2(a: u16) -> u16 {
    (a & 0b1001) | ((a & 0b0100) >> 1) | ((a & 0b0010) << 1)
}

fn read2(inp: &[u8], i: usize) -> u16 {
    (u16::from(inp[i] == b'#') << 3)
        + (u16::from(inp[i + 1] == b'#') << 2)
        + (u16::from(inp[i + 3] == b'#') << 1)
        + u16::from(inp[i + 4] == b'#')
}

#[allow(dead_code)]
fn pretty3(a: u16) {
    eprintln!(
        "{}{}{}\n{}{}{}\n{}{}{}\n",
        if a & 0b100000000 != 0 { "#" } else { "." },
        if a & 0b010000000 != 0 { "#" } else { "." },
        if a & 0b001000000 != 0 { "#" } else { "." },
        if a & 0b000100000 != 0 { "#" } else { "." },
        if a & 0b000010000 != 0 { "#" } else { "." },
        if a & 0b000001000 != 0 { "#" } else { "." },
        if a & 0b000000100 != 0 { "#" } else { "." },
        if a & 0b000000010 != 0 { "#" } else { "." },
        if a & 0b000000001 != 0 { "#" } else { "." },
    );
}

fn flip3(a: u16) -> u16 {
    ((a & 0b111000000) >> 6) | (a & 0b111000) | ((a & 0b111) << 6)
}

fn transpose3(a: u16) -> u16 {
    (a & 0b100010001)
        | ((a & 0b010000000) >> 2)
        | ((a & 0b001000000) >> 4)
        | ((a & 0b000100000) << 2)
        | ((a & 0b000001000) >> 2)
        | ((a & 0b000000100) << 4)
        | ((a & 0b000000010) << 2)
}

fn read3(inp: &[u8], i: usize) -> u16 {
    (u16::from(inp[i] == b'#') << 8)
        + (u16::from(inp[i + 1] == b'#') << 7)
        + (u16::from(inp[i + 2] == b'#') << 6)
        + (u16::from(inp[i + 4] == b'#') << 5)
        + (u16::from(inp[i + 5] == b'#') << 4)
        + (u16::from(inp[i + 6] == b'#') << 3)
        + (u16::from(inp[i + 8] == b'#') << 2)
        + (u16::from(inp[i + 9] == b'#') << 1)
        + u16::from(inp[i + 10] == b'#')
}

fn read22(inp: &[u8], i: usize) -> u64 {
    (((u64::from(inp[i] == b'#') << 3)
        + (u64::from(inp[i + 1] == b'#') << 2)
        + (u64::from(inp[i + 5] == b'#') << 1)
        + u64::from(inp[i + 6] == b'#'))
        << 16)
        + ((u64::from(inp[i + 2] == b'#') << 3)
            + (u64::from(inp[i + 3] == b'#') << 2)
            + (u64::from(inp[i + 7] == b'#') << 1)
            + u64::from(inp[i + 8] == b'#'))
}

fn read2x2(inp: &[u8], i: usize) -> u64 {
    (read22(inp, i) << 32) + read22(inp, i + 10)
}

fn iter(v3: u16, r2: &[u16; 16], r3: &[u64; 512]) -> ([u16; 9], usize, usize, usize) {
    let s4x4 = r3[v3 as usize];
    let c0 = s4x4.count_ones() as usize;
    //eprintln!("c={}", c0);
    let a2x2 = ((s4x4 >> 48) & 0x1ff) as usize;
    let b2x2 = ((s4x4 >> 32) & 0x1ff) as usize;
    let c2x2 = ((s4x4 >> 16) & 0x1ff) as usize;
    let d2x2 = (s4x4 & 0x1ff) as usize;
    let a3x3 = r2[a2x2];
    let b3x3 = r2[b2x2];
    let c3x3 = r2[c2x2];
    let d3x3 = r2[d2x2];
    let c1 =
        (a3x3.count_ones() + b3x3.count_ones() + c3x3.count_ones() + d3x3.count_ones()) as usize;
    //eprintln!("c={}", c1);
    let mut r = [0u16; 9];
    r[0] = r2[(((a3x3 & 0b110000000) >> 5) + ((a3x3 & 0b000110000) >> 4)) as usize];
    r[1] = r2[(((a3x3 & 0b001000000) >> 3)
        + ((a3x3 & 0b000001000) >> 2)
        + ((b3x3 & 0b100000000) >> 6)
        + ((b3x3 & 0b000100000) >> 5)) as usize];
    r[2] = r2[(((b3x3 & 0b011000000) >> 4) + ((b3x3 & 0b000011000) >> 3)) as usize];
    r[3] = r2[(((a3x3 & 0b000000110) << 1) + ((c3x3 & 0b110000000) >> 7)) as usize];
    r[4] = r2[(((a3x3 & 0b000000001) << 3)
        + (b3x3 & 0b000000100)
        + ((c3x3 & 0b001000000) >> 5)
        + ((d3x3 & 0b100000000) >> 8)) as usize];
    r[5] = r2[(((b3x3 & 0b000000011) << 2) + ((d3x3 & 0b011000000) >> 6)) as usize];
    r[6] = r2[(((c3x3 & 0b000110000) >> 2) + ((c3x3 & 0b000000110) >> 1)) as usize];
    r[7] = r2[((c3x3 & 0b000001000)
        + ((d3x3 & 0b000100000) >> 3)
        + ((c3x3 & 0b000000001) << 1)
        + ((d3x3 & 0b000000100) >> 2)) as usize];
    r[8] = r2[(((d3x3 & 0b000011000) >> 1) + (d3x3 & 0b000000011)) as usize];
    let mut c2 = 0;
    for i in 0..9 {
        c2 += r[i].count_ones() as usize;
    }
    //eprintln!("c={}", c2);
    (r, c0, c1, c2)
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut r2 = [0u16; 16];
    let mut r3 = [0u64; 512];
    let mut i = 0;
    while i < inp.len() {
        if inp[i + 6] == b'=' {
            // 2x2 rule
            let mut lhs = read2(inp, i);
            let orig = lhs;
            let rhs = read3(inp, i + 9);
            //pretty2(lhs);
            //pretty3(rhs);
            r2[lhs as usize] = rhs;
            lhs = transpose2(lhs);
            r2[lhs as usize] = rhs;
            lhs = flip2(lhs);
            r2[lhs as usize] = rhs;
            lhs = transpose2(lhs);
            r2[lhs as usize] = rhs;
            lhs = flip2(lhs);
            r2[lhs as usize] = rhs;
            lhs = transpose2(lhs);
            r2[lhs as usize] = rhs;
            lhs = flip2(lhs);
            r2[lhs as usize] = rhs;
            lhs = transpose2(lhs);
            r2[lhs as usize] = rhs;
            debug_assert!(orig == flip2(lhs));
            i += 21;
        } else {
            // 3x3 rule
            let mut lhs = read3(inp, i);
            let orig = lhs;
            let rhs = read2x2(inp, i + 15);
            r3[lhs as usize] = rhs;
            lhs = transpose3(lhs);
            r3[lhs as usize] = rhs;
            lhs = flip3(lhs);
            r3[lhs as usize] = rhs;
            lhs = transpose3(lhs);
            r3[lhs as usize] = rhs;
            lhs = flip3(lhs);
            r3[lhs as usize] = rhs;
            lhs = transpose3(lhs);
            r3[lhs as usize] = rhs;
            lhs = flip3(lhs);
            r3[lhs as usize] = rhs;
            lhs = transpose3(lhs);
            r3[lhs as usize] = rhs;
            debug_assert!(orig == flip3(lhs));
            i += 35;
        }
    }
    //eprintln!("{:?}", r2);
    //eprintln!("{:?}", r3);
    let mut i3 = [0usize; 512];
    let mut ni3 = [0usize; 512];
    let start = read3(&b".#./..#/###"[..], 0);
    i3[start as usize] = 1;
    let mut cur = &mut i3;
    let mut next = &mut ni3;
    let mut p1 = 0;
    let mut p2 = 0;
    for n in 0..6 {
        let mut _tc0 = 0;
        let mut tc1 = 0;
        let mut tc2 = 0;
        for v3 in 0..512 {
            let c = cur[v3];
            if c == 0 {
                continue;
            }
            let (nv, c0, c1, c2) = iter(v3 as u16, &r2, &r3);
            _tc0 += c0 * c;
            tc1 += c1 * c;
            tc2 += c2 * c;
            for n3 in nv {
                next[n3 as usize] += c;
            }
            cur[v3] = 0;
        }
        (cur, next) = (next, cur);
        p2 = tc2;
        if n == 1 {
            p1 = tc1;
        }
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
        let inp = std::fs::read("../2017/21/input.txt").expect("read error");
        assert_eq!(parts(&inp), (125, 1782917));
        let inp = std::fs::read("../2017/21/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (120, 2204099));
    }
}
