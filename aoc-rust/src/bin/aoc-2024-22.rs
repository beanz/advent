use heapless::FnvIndexMap;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = FnvIndexMap::<usize, u16, 65536>::new();
    let mut i = 0;
    let mut seen = FnvIndexMap::<usize, bool, 2048>::new();
    while i < inp.len() {
        let mut n;
        (i, n) = aoc::read::uint::<usize>(inp, i);
        i += 1;
        let mut prev = (n % 10) as i8;
        let mut k = 0;
        seen.clear();
        for j in 0..2000 {
            n ^= n << 6;
            n &= 0xffffff;
            n ^= n >> 5;
            n &= 0xffffff;
            n ^= n << 11;
            n &= 0xffffff;
            let price = n % 10;
            let diff = (price as i8 - prev) & 0x1f;
            prev = price as i8;
            k = ((k << 5) + diff as usize) & 0xfffff;
            if j < 4 || seen.contains_key(&k) {
                continue;
            }
            seen.insert(k, true).expect("overflow");
            p2.insert(
                k,
                price as u16 + if let Some(v) = p2.get(&k) { *v } else { 0 },
            )
            .expect("overflow");
        }
        p1 += n
    }
    let mut mx = 0;
    for v in p2.values() {
        if *v as usize > mx {
            mx = *v as usize;
        }
    }
    (p1, mx)
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
        aoc::test::auto("../2024/22/", parts);
    }
}
