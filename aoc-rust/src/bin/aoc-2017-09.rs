fn run(inp: &str) -> (usize, usize) {
    let mut score = 0;
    let mut garbage = 0;
    let mut level = 1;
    let ch = inp.chars().collect::<Vec<char>>();
    let mut i = 0;
    while i < ch.len() {
        match ch[i] {
            '<' => {
                i += 1;
                while ch[i] != '>' {
                    if ch[i] == '!' {
                        i += 1;
                    } else {
                        garbage += 1;
                    }
                    i += 1;
                }
            }
            '{' => {
                score += level;
                level += 1;
            }
            '}' => {
                level -= 1;
            }
            _ => {}
        }
        i += 1;
    }
    (score, garbage)
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let (p1, p2) = run(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn part1_works() {
        for tc in &[
            ("{}", 1),
            ("{{{}}}", 6),
            ("{{},{}}", 5),
            ("{{{},{},{{}}}}", 16),
            ("{<a>,<a>,<a>,<a>}", 1),
            ("{{<ab>},{<ab>},{<ab>},{<ab>}}", 9),
            ("{{<!!>},{<!!>},{<!!>},{<!!>}}", 9),
            ("{{<a!>},{<a!>},{<a!>},{<ab>}}", 3),
        ] {
            let (p1, _) = run(&tc.0);
            assert_eq!(p1, tc.1, "{}", tc.0);
        }
    }

    #[test]
    fn part2_works() {
        for tc in &[
            ("<>", 0),
            ("<random characters>", 17),
            ("<<<<>", 3),
            ("<{!>}>", 2),
            ("<!!>", 0),
            ("<!!!>>", 0),
            ("<{o\"i!a,<{i<a>", 10),
        ] {
            let (_, p2) = run(&tc.0);
            assert_eq!(p2, tc.1, "{}", tc.0);
        }
    }
}
