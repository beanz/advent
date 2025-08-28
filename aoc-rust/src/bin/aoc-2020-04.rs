#[derive(Debug, PartialEq)]
enum Fsm {
    Start,
    End,
    BirthYear,
    IssueYear,
    ExpYear,
    Height,
    HairColor,
    EyeColor,
    PassportID,
    CountryID,
}

fn validate_range(min: usize, max: usize, value: &[u8]) -> bool {
    let mut n = 0;
    for ch in value {
        match ch {
            b'0'..=b'9' => n = 10 * n + (ch - b'0') as usize,
            _ => {
                return false;
            }
        }
    }
    min <= n && n <= max
}

fn validate(state: &Fsm, value: &[u8]) -> bool {
    match state {
        Fsm::BirthYear => validate_range(1920, 2002, value),
        Fsm::IssueYear => validate_range(2010, 2020, value),
        Fsm::ExpYear => validate_range(2020, 2030, value),
        Fsm::Height => {
            let l = value.len();
            match (value[l - 2], value[l - 1]) {
                (b'c', b'm') => validate_range(150, 193, &value[0..(l - 2)]),
                (b'i', b'n') => validate_range(59, 76, &value[0..(l - 2)]),
                _ => false,
            }
        }
        Fsm::HairColor => {
            value.len() == 7 // #[0-9a-f]{6} no test actually required
        }
        Fsm::EyeColor => {
            if value.len() == 3 {
                matches!(
                    (value[0], value[1], value[2]),
                    (b'a', b'm', b'b')
                        | (b'b', b'l', b'u')
                        | (b'b', b'r', b'n')
                        | (b'g', b'r', b'y')
                        | (b'g', b'r', b'n')
                        | (b'h', b'z', b'l')
                        | (b'o', b't', b'h')
                )
            } else {
                false
            }
        }
        Fsm::PassportID => value.len() == 9 && validate_range(1, 999999999, value),
        _ => false,
    }
}

fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut state = Fsm::Start;
    let mut vp1 = 0;
    let mut vp2 = 0;
    let mut j = 0;
    for i in 0..inp.len() {
        match inp[i] {
            b'\n' | b' ' => {
                if state == Fsm::End {
                    if vp1 == 7 {
                        p1 += 1;
                    }
                    if vp2 == 7 {
                        p2 += 1;
                    }
                    vp1 = 0;
                    vp2 = 0;
                    state = Fsm::Start;
                } else {
                    if validate(&state, &inp[j..i]) {
                        vp2 += 1;
                    }
                    if state != Fsm::CountryID {
                        vp1 += 1;
                    }
                    state = Fsm::End;
                }
            }
            b':' => {
                j = i + 1;
                match (inp[i - 3], inp[i - 2], inp[i - 1]) {
                    (b'b', b'y', b'r') => {
                        state = Fsm::BirthYear;
                    }
                    (b'i', b'y', b'r') => {
                        state = Fsm::IssueYear;
                    }
                    (b'e', b'y', b'r') => {
                        state = Fsm::ExpYear;
                    }
                    (b'h', b'g', b't') => {
                        state = Fsm::Height;
                    }
                    (b'h', b'c', b'l') => {
                        state = Fsm::HairColor;
                    }
                    (b'e', b'c', b'l') => {
                        state = Fsm::EyeColor;
                    }
                    (b'p', b'i', b'd') => {
                        state = Fsm::PassportID;
                    }
                    (_, _, _) => {
                        state = Fsm::CountryID;
                    }
                }
            }
            _ => {}
        }
    }
    if state == Fsm::End {
        if vp1 == 7 {
            p1 += 1;
        }
        if vp2 == 7 {
            p2 += 1;
        }
    }
    (p1, p2)
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
        let inp = std::fs::read("../2020/04/test1.txt").expect("read error");
        let (p1, p2) = parts(&inp);
        assert_eq!(p1, 2, "part 1 test1");
        assert_eq!(p2, 2, "part 2 test1");
        let inp = std::fs::read("../2020/04/test2.txt").expect("read error");
        let (p1, p2) = parts(&inp);
        assert_eq!(p1, 4, "part 1 test2");
        assert_eq!(p2, 0, "part 2 test2");
        let inp = std::fs::read("../2020/04/test3.txt").expect("read error");
        let (p1, p2) = parts(&inp);
        assert_eq!(p1, 4, "part 1 test3");
        assert_eq!(p2, 4, "part 2 test3");
        let inp = std::fs::read("../2020/04/input.txt").expect("read error");
        let (p1, p2) = parts(&inp);
        assert_eq!(p1, 213, "part 1 input");
        assert_eq!(p2, 147, "part 2 input");
    }
}
