fn decompress(s: &str, rec: bool) -> usize {
    let mut i: usize = 0;
    let ch: Vec<char> = s.chars().collect();
    let mut res = 0;
    while i < s.len() {
        match ch[i] {
            '(' => {
                let mut j = i + 1;
                while j < s.len() {
                    if ch[j] == ')' {
                        break;
                    }
                    j += 1;
                }
                let uints =
                    aoc::uints::<usize>(&s[i + 1..=j]).collect::<Vec<usize>>();
                let data_len = {
                    if rec {
                        decompress(&s[j + 1..=j + uints[0]], true)
                    } else {
                        uints[0]
                    }
                };
                res += uints[1] * data_len;
                i = j + uints[0];
            }
            _ => res += 1,
        }
        i += 1;
    }
    res
}

#[test]
fn decompress_works() {
    for tc in vec![
        ("ADVENT", "ADVENT"),
        ("A(1x5)BC", "ABBBBBC"),
        ("(3x3)XYZ", "XYZXYZXYZ"),
        ("A(2x2)BCD(2x2)EFG", "ABCBCDEFEFG"),
        ("(6x1)(1x3)A", "(1x3)A"),
        ("X(8x2)(3x3)ABCY", "X(3x3)ABC(3x3)ABCY"),
    ] {
        assert_eq!(
            decompress(tc.0, false),
            tc.1.len(),
            "decompress non-recursive: {}",
            tc.0
        );
    }
    for tc in vec![
        ("(3x3)XYZ", 9),
        ("X(8x2)(3x3)ABCY", 20),
        ("(27x12)(20x12)(13x14)(7x10)(1x12)A", 241920),
        (
            "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN",
            445,
        ),
    ] {
        assert_eq!(
            decompress(tc.0, true),
            tc.1,
            "decompress recursive: {}",
            tc.0
        );
    }
}

fn main() {
    let inp = aoc::read_input_line();
    println!("Part 1: {}", decompress(&inp, false));
    println!("Part 2: {}", decompress(&inp, true));
}
