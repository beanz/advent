use std::fmt;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum SFToken {
    Open,
    Comma,
    Close,
    Num(usize),
}

#[derive(Debug, Clone, PartialEq, Eq)]
struct SnailFish {
    sf: Vec<SFToken>,
}

impl SnailFish {
    fn new(inp: &[u8]) -> SnailFish {
        let mut sf: Vec<SFToken> = vec![];
        let mut n: usize = 0;
        let mut is_num = false;
        for ch in inp {
            match (ch, is_num) {
                (48..=57, true) => n = n * 10 + (ch - 48) as usize,
                (48..=57, false) => {
                    n = n * 10 + (ch - 48) as usize;
                    is_num = true;
                }
                (93, true) => {
                    sf.push(SFToken::Num(n));
                    sf.push(SFToken::Close);
                    n = 0;
                    is_num = false;
                }
                (93, false) => {
                    sf.push(SFToken::Close);
                }
                (91, false) => sf.push(SFToken::Open),
                (44, true) => {
                    sf.push(SFToken::Num(n));
                    sf.push(SFToken::Comma);
                    n = 0;
                    is_num = false;
                }
                (44, false) => {
                    sf.push(SFToken::Comma);
                }
                _ => {
                    panic!("unexpected token {}", ch);
                }
            }
        }
        SnailFish { sf }
    }
    fn new_vec(inp: &[u8]) -> Vec<SnailFish> {
        let mut sfs: Vec<SnailFish> = vec![];
        let mut start: usize = 0;
        for i in 0..inp.len() {
            if inp[i] == 10 {
                sfs.push(SnailFish::new(&inp[start..i]));
                start = i + 1;
            }
        }
        sfs
    }
    fn len(&self) -> usize {
        self.sf.len()
    }
    fn maghelper(&self, s: usize, e: usize) -> usize {
        if let SFToken::Num(n) = self.sf[s] {
            return n;
        }
        let mut level = 0;
        for i in s + 1..e {
            match (&self.sf[i], level) {
                (SFToken::Open, _) => level += 1,
                (SFToken::Close, _) => level -= 1,
                (SFToken::Comma, 0) => {
                    return 3 * self.maghelper(s + 1, i)
                        + 2 * self.maghelper(i + 1, e - 1);
                }
                _ => {}
            }
        }
        panic!("unreachable")
    }

    fn magnitude(&self) -> usize {
        self.maghelper(0, self.len())
    }

    fn explode(&mut self) -> bool {
        let mut bc = 0;
        for i in 0..self.sf.len() {
            match self.sf[i] {
                SFToken::Open => {
                    bc += 1;
                    if bc == 5 {
                        let mut lb = i;
                        let mut j = i;
                        while self.sf[j] != SFToken::Close {
                            if self.sf[j] == SFToken::Open {
                                lb = i
                            }
                            j += 1;
                        }
                        //println!("exploding {} , {}", self.sf[j - 3], self.sf[j - 1]);
                        match (self.sf[j - 3], self.sf[j - 1]) {
                            (SFToken::Num(a), SFToken::Num(b)) => {
                                j += 1;
                                while j < self.sf.len() {
                                    if let SFToken::Num(n) = self.sf[j] {
                                        self.sf[j] = SFToken::Num(b + n);
                                        break;
                                    }
                                    j += 1;
                                }
                                j = lb;
                                while j > 0 {
                                    if let SFToken::Num(n) = self.sf[j] {
                                        self.sf[j] = SFToken::Num(n + a);
                                        break;
                                    }
                                    j -= 1;
                                }
                                self.sf[lb] = SFToken::Num(0);
                                self.sf.remove(lb + 1); // num
                                self.sf.remove(lb + 1); // comma
                                self.sf.remove(lb + 1); // num
                                self.sf.remove(lb + 1); // ]
                                return true;
                            }
                            _ => panic!("unreachable"),
                        }
                    }
                }
                SFToken::Close => bc -= 1,
                _ => {}
            }
        }
        false
    }

    fn split(&mut self) -> bool {
        for i in 0..self.sf.len() {
            if let SFToken::Num(n) = self.sf[i] {
                if n > 9 {
                    self.sf[i] = SFToken::Open;
                    self.sf.insert(i + 1, SFToken::Num(n / 2));
                    self.sf.insert(i + 2, SFToken::Comma);
                    self.sf.insert(i + 3, SFToken::Num((1 + n) / 2));
                    self.sf.insert(i + 4, SFToken::Close);
                    return true;
                }
            }
        }
        false
    }

    fn reduce(&mut self) {
        loop {
            if self.explode() {
                continue;
            }
            if self.split() {
                continue;
            }
            return;
        }
    }
    fn add(&self, other: &SnailFish) -> SnailFish {
        let mut new = SnailFish { sf: vec![] };
        new.sf.insert(0, SFToken::Open);
        for sft in &self.sf {
            new.sf.push(sft.clone());
        }
        new.sf.push(SFToken::Comma);
        for sft in &other.sf {
            new.sf.push(sft.clone());
        }
        new.sf.push(SFToken::Close);
        new.reduce();
        new
    }
}

impl fmt::Display for SFToken {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}",
            match self {
                SFToken::Open => "[".to_string(),
                SFToken::Comma => ",".to_string(),
                SFToken::Close => "]".to_string(),
                SFToken::Num(n) => format!("{}", n),
            }
        )
    }
}

impl fmt::Display for SnailFish {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}",
            self.sf
                .iter()
                .map(|t| match t {
                    SFToken::Open => "[".to_string(),
                    SFToken::Comma => ",".to_string(),
                    SFToken::Close => "]".to_string(),
                    SFToken::Num(n) => format!("{}", n),
                })
                .collect::<String>()
        )
    }
}

fn part1(sfs: &mut Vec<SnailFish>) -> usize {
    let mut sum = sfs.remove(0);
    for i in 1..sfs.len() {
        sum = sum.add(&sfs[i]);
    }
    sum.magnitude()
}

fn part2(sfs: &mut Vec<SnailFish>) -> usize {
    let mut max = 0;
    for i in 0..sfs.len() {
        for j in i..sfs.len() {
            let mag = sfs[i].add(&sfs[j]).magnitude();
            if mag > max {
                max = mag;
            }
            let mag2 = sfs[j].add(&sfs[i]).magnitude();
            if mag2 > max {
                max = mag2;
            }
        }
    }
    max
}

fn main() {
    let bytes = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let mut sfs = SnailFish::new_vec(&bytes);
        let p1 = part1(&mut sfs);
        let p2 = part2(&mut sfs);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    })
}

#[test]
fn snailfish_magnitude_works() {
    let tests: Vec<(&str, usize)> = vec![
        ("[9,1]", 29),
        ("[1,9]", 21),
        ("[[9,1],[1,9]]", 129),
        ("[[1,2],[[3,4],5]]", 143),
        ("[[[[0,7],4],[[7,8],[6,0]]],[8,1]]", 1384),
        ("[[[[1,1],[2,2]],[3,3]],[4,4]]", 445),
        ("[[[[3,0],[5,3]],[4,4]],[5,5]]", 791),
        ("[[[[5,0],[7,4]],[5,5]],[6,6]]", 1137),
        (
            "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]",
            3488,
        ),
        (
            "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]",
            4140,
        ),
    ];
    for tc in tests {
        let sf = SnailFish::new(&tc.0.to_string().into_bytes());
        assert_eq!(sf.magnitude(), tc.1, "{}", tc.0);
    }
}

#[test]
fn snailfish_explode_works() {
    let tests: Vec<(&str, &str)> = vec![
        ( "[[[[[9,8],1],2],3],4]", "[[[[0,9],2],3],4]" ),
	( "[7,[6,[5,[4,[3,2]]]]]", "[7,[6,[5,[7,0]]]]" ),
	( "[[6,[5,[4,[3,2]]]],1]", "[[6,[5,[7,0]]],3]" ),
	( "[[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]" ),
	( "[[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]", "[[3,[2,[8,0]]],[9,[5,[7,0]]]]" ),
	( "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]", "[[[[0,7],4],[7,[[8,4],9]]],[1,1]]" ),
	( "[[[[0,7],4],[7,[[8,4],9]]],[1,1]]", "[[[[0,7],4],[15,[0,13]]],[1,1]]" ),
	( "[[[[14,14],[14,15]],[[15,14],[14,5]]],[[[0,7],[11,0]],[[12,[7,5]],[4,4]]]]",
	       "[[[[14,14],[14,15]],[[15,14],[14,5]]],[[[0,7],[11,0]],[[19,0],[9,4]]]]" ),
    ];
    for tc in tests {
        let mut sf = SnailFish::new(&tc.0.to_string().into_bytes());
        let changed = sf.explode();
        assert_eq!(format!("{}", sf), tc.1, "{}", tc.0);
        assert_eq!(changed, true, "{}", tc.0);
    }
}

#[test]
fn snailfish_split_works() {
    let tests: Vec<(&str, &str)> = vec![
        (
            "[[[[0,7],4],[15,[0,13]]],[1,1]]",
            "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]",
        ),
        (
            "[[[[0,7],4],[[7,8],[0,13]]],[1,1]]",
            "[[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]",
        ),
    ];
    for tc in tests {
        let mut sf = SnailFish::new(&tc.0.to_string().into_bytes());
        let changed = sf.split();
        assert_eq!(format!("{}", sf), tc.1, "{}", tc.0);
        assert_eq!(changed, true, "{}", tc.0);
    }
}

#[test]
fn snailfish_reduce_works() {
    let tests: Vec<(&str, &str)> = vec![(
        "[[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]",
        "[[[[0,7],4],[[7,8],[6,0]]],[8,1]]",
    )];
    for tc in tests {
        let mut sf = SnailFish::new(&tc.0.to_string().into_bytes());
        sf.reduce();
        assert_eq!(format!("{}", sf), tc.1, "{}", tc.0);
    }
}

#[test]
fn snailfish_add_works() {
    let tests: Vec<(&str, &str, &str)> = vec![
        // first example
        (
            "[[[0,[4,5]],[0,0]],[[[4,5],[2,6]],[9,5]]]",
            "[7,[[[3,7],[4,3]],[[6,3],[8,8]]]]",
            "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]",
        ),
        (
            "[[[[4,0],[5,4]],[[7,7],[6,0]]],[[8,[7,7]],[[7,9],[5,0]]]]",
            "[[2,[[0,8],[3,4]]],[[[6,7],1],[7,[1,6]]]]",
            "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]",
        ),
        (
            "[[[[6,7],[6,7]],[[7,7],[0,7]]],[[[8,7],[7,7]],[[8,8],[8,0]]]]",
            "[[[[2,4],7],[6,[0,5]]],[[[6,8],[2,8]],[[2,1],[4,5]]]]",
            "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]",
        ),
        (
            "[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]",
            "[7,[5,[[3,8],[1,4]]]]",
            "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]",
        ),
        (
            "[[[[7,7],[7,8]],[[9,5],[8,7]]],[[[6,8],[0,8]],[[9,9],[9,0]]]]",
            "[[2,[2,2]],[8,[8,1]]]",
            "[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]",
        ),
        (
            "[[[[6,6],[6,6]],[[6,0],[6,7]]],[[[7,7],[8,9]],[8,[8,1]]]]",
            "[2,9]",
            "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]",
        ),
        (
            "[[[[6,6],[7,7]],[[0,7],[7,7]]],[[[5,5],[5,6]],9]]",
            "[1,[[[9,3],9],[[9,0],[0,7]]]]",
            "[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]",
        ),
        (
            "[[[[7,8],[6,7]],[[6,8],[0,8]]],[[[7,7],[5,0]],[[5,5],[5,6]]]]",
            "[[[5,[7,4]],7],1]",
            "[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]",
        ),
        (
            "[[[[7,7],[7,7]],[[8,7],[8,7]]],[[[7,0],[7,7]],9]]",
            "[[[[4,2],2],6],[8,7]]",
            "[[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]",
        ),
        // second example
        (
            "[[[0,[5,8]],[[1,7],[9,6]]],[[4,[1,2]],[[1,4],2]]]",
            "[[[5,[2,8]],4],[5,[[9,9],0]]]",
            "[[[[7,0],[7,8]],[[7,9],[0,6]]],[[[7,0],[6,6]],[[7,7],[0,9]]]]",
        ),
        (
            "[[[[7,0],[7,8]],[[7,9],[0,6]]],[[[7,0],[6,6]],[[7,7],[0,9]]]]",
            "[6,[[[6,2],[5,6]],[[7,6],[4,7]]]]",
            "[[[[7,7],[7,7]],[[7,0],[7,7]]],[[[7,7],[6,7]],[[7,7],[8,9]]]]",
        ),
        (
            "[[[[7,7],[7,7]],[[7,0],[7,7]]],[[[7,7],[6,7]],[[7,7],[8,9]]]]",
            "[[[6,[0,7]],[0,9]],[4,[9,[9,0]]]]",
            "[[[[6,6],[6,6]],[[7,7],[7,7]]],[[[7,0],[7,7]],[[7,8],[8,8]]]]",
        ),
        (
            "[[[[6,6],[6,6]],[[7,7],[7,7]]],[[[7,0],[7,7]],[[7,8],[8,8]]]]",
            "[[[7,[6,4]],[3,[1,3]]],[[[5,5],1],9]]",
            "[[[[6,6],[7,7]],[[7,7],[8,8]]],[[[8,8],[0,8]],[[8,9],[9,9]]]]",
        ),
        (
            "[[[[6,6],[7,7]],[[7,7],[8,8]]],[[[8,8],[0,8]],[[8,9],[9,9]]]]",
            "[[6,[[7,3],[3,2]]],[[[3,8],[5,7]],4]]",
            "[[[[6,6],[7,7]],[[7,7],[7,0]]],[[[7,7],[8,8]],[[8,8],[8,9]]]]",
        ),
        (
            "[[[[6,6],[7,7]],[[7,7],[7,0]]],[[[7,7],[8,8]],[[8,8],[8,9]]]]",
            "[[[[5,4],[7,7]],8],[[8,3],8]]",
            "[[[[7,7],[7,7]],[[7,7],[7,7]]],[[[0,7],[8,8]],[[8,8],[8,9]]]]",
        ),
        (
            "[[[[7,7],[7,7]],[[7,7],[7,7]]],[[[0,7],[8,8]],[[8,8],[8,9]]]]",
            "[[9,3],[[9,9],[6,[4,9]]]]",
            "[[[[7,7],[7,7]],[[7,7],[8,8]]],[[[8,8],[0,8]],[[8,9],[8,7]]]]",
        ),
        (
            "[[[[7,7],[7,7]],[[7,7],[8,8]]],[[[8,8],[0,8]],[[8,9],[8,7]]]]",
            "[[2,[[7,7],7]],[[5,8],[[9,3],[0,2]]]]",
            "[[[[7,7],[7,7]],[[7,7],[7,7]]],[[[8,7],[8,7]],[[7,9],[5,0]]]]",
        ),
        (
            "[[[[7,7],[7,7]],[[7,7],[7,7]]],[[[8,7],[8,7]],[[7,9],[5,0]]]]",
            "[[[[5,2],5],[8,[3,7]]],[[5,[7,5]],[4,4]]]",
            "[[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]]",
        ),
    ];
    for tc in tests {
        let sf = SnailFish::new(&tc.0.to_string().into_bytes());
        let sf2 = SnailFish::new(&tc.1.to_string().into_bytes());
        let res = sf.add(&sf2);
        assert_eq!(format!("{}", res), tc.2, "{} + {}", tc.0, tc.1);
    }
}
