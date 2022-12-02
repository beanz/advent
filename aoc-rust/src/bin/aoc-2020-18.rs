use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete,
    combinator::map,
    multi::fold_many0,
    sequence::{delimited, pair, preceded, terminated},
    IResult,
};

fn num(input: &[u8]) -> IResult<&[u8], usize> {
    map(complete::u8, |x| x as usize)(input)
}

fn part1_num_or_brackets(input: &[u8]) -> IResult<&[u8], usize> {
    alt((num, delimited(tag("("), part1_op, tag(")"))))(input)
}

fn part1_op(input: &[u8]) -> IResult<&[u8], usize> {
    let (input, first) = part1_num_or_brackets(input)?;
    let (input, res) = fold_many0(
        pair(
            delimited(tag(" "), complete::one_of("+*"), tag(" ")),
            part1_num_or_brackets,
        ),
        || first,
        |acc, (op, v)| match op {
            '+' => acc + v,
            '*' => acc * v,
            _ => unreachable!("invalid op"),
        },
    )(input)?;
    Ok((input, res))
}

fn part2_num_or_brackets(input: &[u8]) -> IResult<&[u8], usize> {
    alt((num, delimited(tag("("), part2_op, tag(")"))))(input)
}

fn part2_plus(input: &[u8]) -> IResult<&[u8], usize> {
    let (input, first) = part2_num_or_brackets(input)?;
    let (input, res) = fold_many0(
        preceded(tag(" + "), part2_num_or_brackets),
        || first,
        |acc, v| acc + v,
    )(input)?;
    Ok((input, res))
}

fn part2_op(input: &[u8]) -> IResult<&[u8], usize> {
    let (input, first) = part2_plus(input)?;
    let (input, res) =
        fold_many0(preceded(tag(" * "), part2_plus), || first, |acc, v| acc * v)(input)?;
    Ok((input, res))
}

fn part1(input: &[u8]) -> IResult<&[u8], usize> {
    let (input, first) = terminated(part1_op, tag("\n"))(input)?;
    let (input, res) =
        fold_many0(terminated(part1_op, tag("\n")), || first, |acc, v| acc + v)(input)?;
    Ok((input, res))
}

fn part2(input: &[u8]) -> IResult<&[u8], usize> {
    let (input, first) = terminated(part2_op, tag("\n"))(input)?;
    let (input, res) =
        fold_many0(terminated(part2_op, tag("\n")), || first, |acc, v| acc + v)(input)?;
    Ok((input, res))
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (_, p1) = part1(&inp).expect("parse error");
        let (_, p2) = part2(&inp).expect("parse error");
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
    fn num_works() {
        let input = b"8";
        let (input, n) = num(input).expect("parse error");
        assert_eq!(input, b"");
        assert_eq!(n, 8);
    }
    #[test]
    fn part1_op_works() {
        let tests: Vec<(&[u8], usize)> = vec![
            (b"8", 8),
            (b"1 + 4", 5),
            (b"2 * 3", 6),
            (b"1 + 2 * 3 + 4 * 5 + 6", 71),
            (b"1 + (2 * 3) + (4 * (5 + 6))", 51),
            (b"2 * 3 + (4 * 5)", 26),
            (b"5 + (8 * 3 + 9 + 3 * 4 * 3)", 437),
            (b"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 12240),
            (b"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 13632),
        ];
        for (inp, exp) in tests {
            let (input, n) = part1_op(inp).expect("parse error");
            assert_eq!(input, b"", "{}", std::str::from_utf8(inp).expect("ascii"));
            assert_eq!(n, exp, "{}", std::str::from_utf8(inp).expect("ascii"));
        }
    }
    #[test]
    fn part2_op_works() {
        let tests: Vec<(&[u8], usize)> = vec![
            (b"8", 8),
            (b"1 + 4", 5),
            (b"2 * 3", 6),
            (b"1 + 2 * 3 + 4 * 5 + 6", 231),
            (b"1 + (2 * 3) + (4 * (5 + 6))", 51),
            (b"2 * 3 + (4 * 5)", 46),
            (b"5 + (8 * 3 + 9 + 3 * 4 * 3)", 1445),
            (b"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))", 669060),
            (b"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2", 23340),
        ];
        for (inp, exp) in tests {
            let (input, n) = part2_op(inp).expect("parse error");
            assert_eq!(input, b"", "{}", std::str::from_utf8(inp).expect("ascii"));
            assert_eq!(n, exp, "{}", std::str::from_utf8(inp).expect("ascii"));
        }
    }
}
