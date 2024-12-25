use heapless::Vec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut keys = Vec::<[u8; 5], 512>::new();
    let mut locks = Vec::<[u8; 5], 512>::new();
    let mut i = 0;
    while i < inp.len() {
        let mut c: [u8; 5] = [0; 5];
        for j in 0..5 {
            for k in 1..6 {
                c[j] += u8::from(inp[i + j + k * 6] == b'#');
            }
        }
        if inp[i] == b'#' {
            locks.push(c).expect("overflow");
        } else {
            keys.push(c).expect("overflow");
        }
        i += 43;
    }
    let mut p1 = 0;
    for lock in &locks {
        for key in &keys {
            p1 += usize::from(
                lock[0] + key[0] < 6
                    && lock[1] + key[1] < 6
                    && lock[2] + key[2] < 6
                    && lock[3] + key[3] < 6
                    && lock[4] + key[4] < 6,
            );
        }
    }
    (p1, 0)
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
        aoc::test::auto("../2024/25/", parts);
    }
}
