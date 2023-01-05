fn parts(inp: &[u8]) -> (usize, [u8; 156], usize) {
    let (w, h) = if inp.len() > 150 { (25, 6) } else { (2, 2) };
    let mut p1 = 0;
    let mut min = usize::MAX;
    let l = w * h;
    let mut i = 0;
    while i < inp.len() - 1 {
        let mut c: [usize; 3] = [0; 3];
        for j in 0..l {
            c[(inp[i + j] - b'0') as usize] += 1;
        }
        if c[0] < min {
            min = c[0];
            p1 = c[1] * c[2];
        }
        i += l;
    }

    let mut p2 = [32; 156];
    for y in 0..h {
        let oi = y * (w + 1);
        p2[oi + w] = b'\n';
        for x in 0..w {
            let mut i = y * w + x;
            let j = oi + x;
            while i < inp.len() - 1 {
                match inp[i] {
                    b'0' => {
                        p2[j] = b' ';
                        break;
                    }
                    b'1' => {
                        p2[j] = b'#';
                        break;
                    }
                    _ => {}
                }
                i += l;
            }
        }
    }
    let p2l = (w + 1) * h;
    (p1, p2, p2l)
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2, p2l) = parts(&inp);
        if !bench {
            println!("Part 1: {}", p1);
            print!(
                "Part 2:\n{}",
                std::str::from_utf8(&p2[0..p2l]).expect("ascii")
            );
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2019/08/test1.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 4);
        assert_eq!(std::str::from_utf8(&p2[0..p2l]).expect("ascii"), " #\n# \n",);

        let inp = std::fs::read("../2019/08/input.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 1441);
        assert_eq!(
            std::str::from_utf8(&p2[0..p2l]).expect("ascii"),
            "###  #  # #### ###  ###  \n#  # #  #    # #  # #  # \n#  # #  #   #  ###  #  # \n###  #  #  #   #  # ###  \n# #  #  # #    #  # #    \n#  #  ##  #### ###  #    \n",
        );
        let inp = std::fs::read("../2019/08/input-amf.txt").expect("read error");
        let (p1, p2, p2l) = parts(&inp);
        assert_eq!(p1, 1572);
        assert_eq!(
            std::str::from_utf8(&p2[0..p2l]).expect("ascii"),
            "#  # #   ##  # #### #### \n# #  #   ##  # #    #    \n##    # # #### ###  ###  \n# #    #  #  # #    #    \n# #    #  #  # #    #    \n#  #   #  #  # #    #### \n",
        );
    }
}
