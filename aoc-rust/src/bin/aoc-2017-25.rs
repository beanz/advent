fn part(inp: &[u8]) -> usize {
    let start = inp[15] - b'A';
    let (j, num) = aoc::read::uint::<usize>(inp, 54);
    let mut i = j + 9;
    let mut states: [(u8, isize, u8); 12] = [(0, 0, 0); 12];
    while i < inp.len() {
        let state = inp[i + 9] - b'A';
        let v0 = inp[i + 63] - b'0';
        let (j, mov0) = match inp[i + 93] {
            b'r' => (i + 100, 1),
            b'l' => (i + 99, -1),
            _ => unreachable!("invalid direction"),
        };
        let nxt0 = inp[j + 26] - b'A';
        i = j + 29;
        let v1 = inp[i + 51] - b'0';
        let (j, mov1) = match inp[i + 81] {
            b'r' => (i + 88, 1),
            b'l' => (i + 87, -1),
            _ => unreachable!("invalid direction"),
        };
        let nxt1 = inp[j + 26] - b'A';
        let k = state as usize * 2;
        states[k] = (v0, mov0, nxt0);
        states[k + 1] = (v1, mov1, nxt1);
        i = j + 30;
    }
    let mut tape = [0u8; 20000];
    let mut cur = 8000;
    let mut state = start;
    for _i in 0..num {
        let v = tape[cur];
        let k = state as usize * 2 + v as usize;
        let (wv, mov, nstate) = states[k];
        tape[cur] = wv;
        cur = (cur as isize + mov) as usize;
        state = nstate;
    }
    let mut c = 0;
    for v in &tape {
        c += *v as usize;
    }
    c
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let p1 = part(&inp);
        if !bench {
            println!("Part 1: {p1}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2017/25/test.txt").expect("read error");
        assert_eq!(part(&inp), 3);
        let inp = std::fs::read("../2017/25/input.txt").expect("read error");
        assert_eq!(part(&inp), 4217);
        let inp = std::fs::read("../2017/25/input-amf.txt").expect("read error");
        assert_eq!(part(&inp), 2846);
    }
}
