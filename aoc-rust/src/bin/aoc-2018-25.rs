use heapless::Vec;

fn parts(inp: &[u8]) -> usize {
    let mut points = Vec::<(i16, i16, i16, i16), 1536>::new();
    let mut constellations = [0usize; 2048];
    let mut i = 0;
    while i < inp.len() {
        let (j, x) = aoc::read::int::<i16>(inp, i);
        let (j, y) = aoc::read::int::<i16>(inp, j + 1);
        let (j, z) = aoc::read::int::<i16>(inp, j + 1);
        let (j, q) = aoc::read::int::<i16>(inp, j + 1);
        points.push((x, y, z, q)).expect("points full");
        i = j + 1;
    }
    let mut l = 1;
    let mut m = 0;
    for i in 0..points.len() {
        for j in 0..i {
            if manhattan(points[i], points[j]) <= 3 {
                if constellations[i] != 0 && constellations[i] != constellations[j] {
                    //eprint!(" merging {} with {},", constellations[i], constellations[j]);
                    for n in 0..i {
                        if constellations[n] == constellations[i] {
                            constellations[n] = constellations[j];
                        }
                    }
                    m += 1;
                }
                constellations[i] = constellations[j];
            }
        }
        if constellations[i] == 0 {
            //eprintln!(" new {}", l);
            constellations[i] = l;
            l += 1;
        }
    }
    l - 1 - m
}

fn manhattan(a: (i16, i16, i16, i16), b: (i16, i16, i16, i16)) -> usize {
    let (ax, ay, az, aq) = a;
    let (bx, by, bz, bq) = b;
    (ax.abs_diff(bx) + ay.abs_diff(by) + az.abs_diff(bz) + aq.abs_diff(bq)) as usize
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let p1 = parts(&inp);
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
        let inp = std::fs::read("../2018/25/test0.txt").expect("read error");
        assert_eq!(parts(&inp), 2);
        let inp = std::fs::read("../2018/25/test1.txt").expect("read error");
        assert_eq!(parts(&inp), 4);
        let inp = std::fs::read("../2018/25/test2.txt").expect("read error");
        assert_eq!(parts(&inp), 3);
        let inp = std::fs::read("../2018/25/test3.txt").expect("read error");
        assert_eq!(parts(&inp), 8);
        let inp = std::fs::read("../2018/25/input.txt").expect("read error");
        assert_eq!(parts(&inp), 331);
        let inp = std::fs::read("../2018/25/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), 377);
    }
}
