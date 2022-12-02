use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::*,
    combinator::{recognize, value},
    multi::{many1, separated_list1},
    sequence::{terminated, tuple},
    IResult,
};
use std::fmt;

#[derive(Debug, PartialEq, Clone)]
struct BagQuantity<'a> {
    name: &'a [u8],
    num: usize,
}
impl fmt::Display for BagQuantity<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{} x {}",
            self.num,
            std::str::from_utf8(self.name).expect("ascii"),
        )
    }
}

#[derive(Debug)]
struct Rule<'a> {
    bag: &'a [u8],
    bags: Vec<BagQuantity<'a>>,
}
impl fmt::Display for Rule<'_> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{}: ", std::str::from_utf8(self.bag).expect("ascii"),)?;
        for b in &self.bags {
            write!(f, "{}, ", b)?;
        }
        Ok(())
    }
}

fn bag_name(input: &[u8]) -> IResult<&[u8], &[u8]> {
    terminated(
        recognize(tuple((alpha1, space1, alpha1))),
        alt((tag(" bags"), tag(" bag"))),
    )(input)
}

fn bag_quantity(input: &[u8]) -> IResult<&[u8], BagQuantity> {
    let (input, q) = terminated(digit1, tag(" "))(input)?;
    let num = std::str::from_utf8(q)
        .expect("ascii")
        .parse::<usize>()
        .expect("number");
    let (input, name) = bag_name(input)?;
    Ok((input, BagQuantity { num, name }))
}

fn bag_list(input: &[u8]) -> IResult<&[u8], Vec<BagQuantity>> {
    terminated(separated_list1(tag(", "), bag_quantity), tag(".\n"))(input)
}

fn rule_line(input: &[u8]) -> IResult<&[u8], Rule> {
    let (input, bag) = terminated(bag_name, tag(" contain "))(input)?;
    let (input, bags): (&[u8], Vec<BagQuantity>) =
        alt((value(vec![], tag("no other bags.\n")), bag_list))(input)?;
    Ok((input, Rule { bag, bags }))
}

use ahash::RandomState;
use std::collections::HashMap;
use std::collections::HashSet;

fn parts(inp: &[u8]) -> (usize, usize) {
    let res = many1(rule_line)(inp).expect("parse error");
    let (_, rules) = res;
    let mut graph1: HashMap<&[u8], Vec<&[u8]>, RandomState> = HashMap::default();
    let mut graph2: HashMap<&[u8], Vec<&BagQuantity>, RandomState> = HashMap::default();
    for e in &rules {
        for bq in &e.bags {
            graph1
                .entry(bq.name)
                .and_modify(|v| v.push(e.bag))
                .or_insert_with(|| vec![e.bag]);
            graph2
                .entry(e.bag)
                .and_modify(|v| v.push(bq))
                .or_insert_with(|| vec![bq]);
        }
    }
    let mut uniq: HashSet<&[u8], RandomState> = HashSet::default();
    part1(&graph1, b"shiny gold", &mut uniq);
    (uniq.len() - 1, part2(&graph2, b"shiny gold") - 1)
}

fn part1<'a>(
    graph1: &'a HashMap<&[u8], Vec<&[u8]>, RandomState>,
    bag: &'a [u8],
    uniq: &mut HashSet<&'a [u8], RandomState>,
) {
    if uniq.contains(bag) {
        return;
    }
    uniq.insert(bag);
    if let Some(bags) = graph1.get(bag) {
        for b in bags {
            part1(graph1, b, uniq);
        }
    }
}

fn part2<'a>(graph2: &'a HashMap<&[u8], Vec<&BagQuantity>, RandomState>, bag: &'a [u8]) -> usize {
    let mut c = 1;
    if let Some(bags) = graph2.get(bag) {
        for b in bags {
            c += b.num * part2(graph2, b.name);
        }
    }
    c
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
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
    fn bag_name_works() {
        let input = b"bright white bag";
        let (rest, name) = bag_name(input).unwrap();
        assert_eq!(name, b"bright white");
        assert_eq!(rest, b"");
        let input = b"light red bags";
        let (rest, name) = bag_name(input).unwrap();
        assert_eq!(name, b"light red");
        assert_eq!(rest, b"");
    }
    #[test]
    fn bag_quantity_works() {
        let input = b"1 bright white bag";
        let (rest, bq) = bag_quantity(input).unwrap();
        assert_eq!(rest, b"");
        assert_eq!(
            bq,
            BagQuantity {
                name: b"bright white",
                num: 1
            }
        );
    }
    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2020/07/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (4, 32));
        let inp = std::fs::read("../2020/07/test2.txt").expect("read error");
        assert_eq!(parts(&inp), (0, 126));
        let inp = std::fs::read("../2020/07/input.txt").expect("read error");
        assert_eq!(parts(&inp), (112, 6260));
    }
}
