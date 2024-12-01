use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut a = SmallVec::<[u32; 1024]>::new();
    let mut b = SmallVec::<[u32; 1024]>::new();
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::uint::<u32>(inp, i);
        i = j;
        a.push(n);
        while inp[i] == b' ' {
            i += 1;
        }
        let (j, n) = aoc::read::uint::<u32>(inp, i);
        i = j + 1;
        b.push(n);
    }
    a.sort_by(|a, b| a.cmp(&b));
    b.sort_by(|a, b| a.cmp(&b));
    let mut p1 = 0;
    for i in 0..a.len() {
        p1 += (a[i] as i32 - b[i] as i32).abs() as usize;
    }
    let mut p2 = 0;
    let (mut ai, mut bi) = (0, 0);
    while ai < a.len() && bi < b.len() {
        if a[ai] < b[bi] {
            ai += 1;
            continue;
        }
        if a[ai] > b[bi] {
            bi += 1;
            continue;
        }
        let mut ac = 0;
        let v = a[ai];
        while ai < a.len() && a[ai] == v {
            ai += 1;
            ac += 1;
        }
        let mut bc = 0;
        while bi < b.len() && b[bi] == v {
            bi += 1;
            bc += 1;
        }
        p2 += (v * ac * bc) as usize;
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
        aoc::test::auto("../2024/01/", parts);
    }
}
