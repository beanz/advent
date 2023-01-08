const REP: [isize; 4] = [0, 1, 0, -1];

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut cur_back: [u8; 650] = [0; 650];
    for i in 0..650 {
        cur_back[i] = inp[i] - b'0'
    }
    let mut out_back: [u8; 650] = [0; 650];
    let mut cur = &mut cur_back;
    let mut out = &mut out_back;
    for _ph in 1..=100 {
        for i in 1..=650 {
            let mut n = 0;
            for j in 0..650 {
                let di = (1 + j) / i;
                let m = REP[di % 4];
                let d = cur[j] as isize * m;
                n += d;
            }
            if n < 0 {
                n *= -1;
            }
            n %= 10;
            out[i - 1] = n as u8;
        }
        (cur, out) = (out, cur);
    }
    let mut p1 = 0;
    for i in 0..8 {
        p1 = p1 * 10 + (cur[i] as usize);
    }
    let (_, offset) = aoc::read::uint::<usize>(&inp[0..7], 0);
    let mut inp10000 = vec![];
    let mut o = 0;
    for _i in 0..10000 {
        for j in 0..650 {
            if o >= offset {
                inp10000.push(inp[j]);
            }
            o += 1;
        }
    }
    //eprintln!("{}", std::str::from_utf8(&inp10000[0..10]).expect("ascii"));
    //eprintln!("{}", inp10000.len());
    let l = inp10000.len();
    let cur = &mut inp10000;
    for _ph in 1..=100 {
        let mut sum = 0;
        for i in 0..l {
            sum += cur[i] as isize;
        }
        for i in 0..l {
            let n = ((if sum < 0 { -1 * sum } else { sum }) % 10) as u8;
            sum -= cur[i] as isize;
            cur[i] = n;
        }
    }
    let mut p2 = 0;
    for i in 0..8 {
        p2 = p2 * 10 + (cur[i] as usize);
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
        let inp = std::fs::read("../2019/16/input.txt").expect("read error");
        assert_eq!(parts(&inp), (23135243, 21130597));
        let inp = std::fs::read("../2019/16/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (29795507, 89568529));
    }
}
