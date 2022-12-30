use smallvec::{smallvec, SmallVec};

#[derive(Debug, PartialEq, Clone)]
enum Rule {
    Char(u8),
    Alt(Vec<Vec<usize>>),
}

const INIT: Option<Rule> = None;

struct Mess<'a, 'b> {
    rules: &'a mut [Option<Rule>; 135],
    messages: &'b [u8],
}

impl<'a, 'b> Mess<'a, 'b> {
    fn new(inp: &'b [u8], rules: &'a mut [Option<Rule>; 135]) -> Mess<'a, 'b> {
        let mut i = 0;
        while inp[i] != b'\n' {
            let mut rn = 0;
            while inp[i] != b':' {
                rn = 10 * rn + (inp[i] - b'0') as usize;
                i += 1;
            }
            i += 2;
            if inp[i] == b'"' {
                rules[rn] = Some(Rule::Char(inp[i + 1]));
                i += 4;
                continue;
            }
            let mut alt: Vec<Vec<usize>> = vec![];
            loop {
                let mut sub: Vec<usize> = vec![];
                while i < inp.len() && inp[i] != b'|' {
                    let (j, n) = aoc::read::uint(inp, i);
                    sub.push(n);
                    i = j;
                    if inp[i] == b'\n' {
                        break;
                    }
                    i += 1;
                }
                alt.push(sub);
                if inp[i] == b'\n' {
                    break;
                }
                i += 2;
            }
            rules[rn] = Some(Rule::Alt(alt));
            i += 1;
            continue;
        }
        i += 1;
        Mess {
            rules,
            messages: &inp[i..],
        }
    }
    fn valid(&self, i: usize, rn: usize) -> Option<Vec<usize>> {
        let rule = self.rules[rn].as_ref().expect("no such rule");
        match rule {
            Rule::Char(ch) => {
                if self.messages[i] == *ch {
                    return Some(vec![i + 1]);
                } else {
                    return None;
                }
            }
            Rule::Alt(alt) => {
                let mut sol = vec![];
                for a in alt {
                    let mut cur: SmallVec<[usize; 10]> = smallvec![i];
                    for srn in a {
                        let mut next = smallvec![];
                        for j in &cur {
                            let s = self.valid(*j, *srn);
                            if let Some(js) = s {
                                for k in &js {
                                    next.push(*k);
                                }
                            }
                        }
                        cur = next;
                    }
                    for j in &cur {
                        // shortcut
                        if self.messages[*j] == b'\n' {
                            return Some(vec![*j]);
                        }
                        sol.push(*j);
                    }
                }
                if !sol.is_empty() {
                    return Some(sol);
                }
                return None;
            }
        }
    }
    fn matches(&self) -> usize {
        let mut c = 0;
        let mut i = 0;
        while i < self.messages.len() {
            let res = self.valid(i, 0);
            if let Some(js) = res {
                for j in js {
                    if self.messages[j] == b'\n' {
                        c += 1;
                        break;
                    }
                }
            }
            while self.messages[i] != b'\n' {
                i += 1;
            }
            i += 1;
        }
        c
    }
    fn parts(&mut self) -> (usize, usize) {
        let p1 = self.matches();
        let r8 = Rule::Alt(vec![
            vec![42],
            vec![42, 42],
            vec![42, 42, 42],
            vec![42, 42, 42, 42],
            vec![42, 42, 42, 42, 42],
        ]);
        self.rules[8] = Some(r8);
        let r11 = Rule::Alt(vec![
            vec![42, 31],
            vec![42, 42, 31, 31],
            vec![42, 42, 42, 31, 31, 31],
            vec![42, 42, 42, 42, 31, 31, 31, 31],
            vec![42, 42, 42, 42, 42, 31, 31, 31, 31, 31],
        ]);
        self.rules[11] = Some(r11);
        (p1, self.matches())
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let mut rules: [Option<Rule>; 135] = [INIT; 135];
        let mut mess = Mess::new(&inp, &mut rules);
        let (p1, p2) = mess.parts();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let mut rules: [Option<Rule>; 135] = [INIT; 135];
        let inp = std::fs::read("../2020/19/test0.txt").expect("read error");
        assert_eq!(Mess::new(&inp, &mut rules).parts(), (1, 1));
        let inp = std::fs::read("../2020/19/test1.txt").expect("read error");
        assert_eq!(Mess::new(&inp, &mut rules).parts(), (1, 1));
        let inp = std::fs::read("../2020/19/test2.txt").expect("read error");
        assert_eq!(Mess::new(&inp, &mut rules).parts(), (2, 2));
        let inp = std::fs::read("../2020/19/input.txt").expect("read error");
        assert_eq!(Mess::new(&inp, &mut rules).parts(), (285, 412));
    }
}
