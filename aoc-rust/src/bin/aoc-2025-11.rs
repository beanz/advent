use heapless::index_map::FnvIndexMap;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut g = FnvIndexMap::<u16, Vec<u16>, 1024>::new();
    let mut i: usize = 0;
    while i < inp.len() {
        let id = chomp_id(&inp[i..i + 3]);
        i += 4;
        let mut kv = Vec::<u16>::new();
        while i + 3 < inp.len() && inp[i] != b'\n' {
            i += 1;
            let o = chomp_id(&inp[i..i + 3]);
            kv.push(o);
            i += 3;
        }
        g.insert(id, kv).expect("overflow");
        i += 1;
    }
    let you = chomp_id(b"you");
    let out = chomp_id(b"out");
    let svr = chomp_id(b"svr");
    let dac = chomp_id(b"dac");
    let fft = chomp_id(b"fft");
    let mut cache = FnvIndexMap::<u16, usize, 1024>::new();
    let p1 = search(&g, you, out, &mut cache);
    cache.clear();
    let svr_to_fft = search(&g, svr, fft, &mut cache);
    cache.clear();
    let fft_to_dac = search(&g, fft, dac, &mut cache);
    cache.clear();
    let dac_to_out = search(&g, dac, out, &mut cache);

    (p1, svr_to_fft * fft_to_dac * dac_to_out)
}

fn search(
    g: &FnvIndexMap<u16, Vec<u16>, 1024>,
    cur: u16,
    end: u16,
    cache: &mut FnvIndexMap<u16, usize, 1024>,
) -> usize {
    if let Some(v) = cache.get(&cur) {
        return *v;
    }
    if cur == end {
        return 1;
    }
    if let Some(next) = g.get(&cur) {
        let mut r: usize = 0;
        for n in next {
            r += search(g, *n, end, cache);
        }
        cache.insert(cur, r).expect("overflow");
        return r;
    }
    0
}

fn chomp_id(inp: &[u8]) -> u16 {
    let mut id: u16 = 0;
    for ch in inp {
        let ord = (ch - b'a') as u16;
        id = (id * 26) + ord;
    }
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
        aoc::test::auto("../2025/11/", parts);
    }
}
