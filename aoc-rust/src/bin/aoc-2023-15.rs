use arr_macro::arr;
use smallvec::SmallVec;

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut i = 0;
    let mut b: [SmallVec<[Lens; 8]>; 256] = arr![SmallVec::<[Lens; 8]>::new(); 256];
    while i < inp.len() {
        let mut j = i;
        let mut bn = 0;
        let mut lb = 0;
        let mut tlb = 0;
        let mut h: u8 = 0;
        while j < inp.len() && inp[j] != b',' && inp[j] != b'\n' {
            if inp[j] == b'-' || inp[j] == b'=' {
                bn = h as usize;
                lb = tlb;
            }
            h = h.wrapping_add(inp[j]).wrapping_mul(17);
            tlb = (tlb << 8) + (inp[j] as usize);
            j += 1;
        }
        p1 += h as usize;
        let mut found: Option<usize> = None;
        for ii in 0..b[bn].len() {
            if b[bn].get(ii).expect("err").l == lb {
                found = Some(ii);
                break;
            }
        }
        if inp[j - 1] == b'-' {
            if let Some(ii) = found {
                b[bn].remove(ii);
            }
        } else if let Some(ii) = found {
            b[bn].get_mut(ii).expect("err").v = inp[j - 1] - b'0';
        } else {
            b[bn].push(Lens {
                l: lb,
                v: inp[j - 1] - b'0',
            });
        }

        i = j + 1;
    }

    let mut p2 = 0;
    for (bn, be) in b.iter().enumerate() {
        for (sn, s) in be.iter().enumerate() {
            p2 += (bn + 1) * (sn + 1) * (s.v as usize);
        }
    }
    (p1, p2)
}

struct Lens {
    l: usize,
    v: u8,
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
        let inp = std::fs::read("../2023/15/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (1320, 145));
        let inp = std::fs::read("../2023/15/input.txt").expect("read error");
        assert_eq!(parts(&inp), (507666, 233537));
    }
}
