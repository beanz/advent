use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (i32, i32) {
    let mut p1 = 0;
    let mut i = 0;
    let mut acc = SmallVec::<[i32; 1024]>::new();
    while i < inp.len() {
        let (j, n) = aoc::read::int::<i32>(inp, i);
        p1 += n;
        acc.push(p1);
        i = j + 1;
    }
    let mut ri: usize = 0;
    let mut rq: i32 = i32::MAX;
    for i in 0..acc.len() {
        for j in i + 1..acc.len() {
            let d = acc[i].abs_diff(acc[j]) as i32;
            if d % p1 == 0 {
                let q = d / p1;
                if q < rq {
                    (ri, rq) = (i.max(j), q)
                }
            }
        }
    }
    (p1, acc[ri])
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
        let inp = std::fs::read("../2018/01/test.txt").expect("read error");
        assert_eq!(parts(&inp), (3, 2));
        let inp = std::fs::read("../2018/01/input.txt").expect("read error");
        assert_eq!(parts(&inp), (505, 72330));
        let inp = std::fs::read("../2018/01/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (490, 70357));
    }
}
