use nom::{
    bytes::complete::{tag, take_until},
    character::complete::*,
    multi::{many1, separated_list1},
    sequence::{terminated, tuple},
    IResult,
};

#[derive(Debug, PartialEq, Clone)]
struct Rule<'a> {
    name: &'a [u8],
    r1: (u16, u16),
    r2: (u16, u16),
}

fn rule_line(input: &[u8]) -> IResult<&[u8], Rule> {
    let (input, name) = terminated(take_until(": "), tag(": "))(input)?;
    let (input, (l1, h1, l2, h2)) = tuple((
        terminated(digit1, tag("-")),
        terminated(digit1, tag(" or ")),
        terminated(digit1, tag("-")),
        digit1,
    ))(input)?;
    let l1 = std::str::from_utf8(l1)
        .expect("ascii")
        .parse::<u16>()
        .expect("number");
    let h1 = std::str::from_utf8(h1)
        .expect("ascii")
        .parse::<u16>()
        .expect("number");
    let l2 = std::str::from_utf8(l2)
        .expect("ascii")
        .parse::<u16>()
        .expect("number");
    let h2 = std::str::from_utf8(h2)
        .expect("ascii")
        .parse::<u16>()
        .expect("number");
    let (input, _) = tag("\n")(input)?;
    Ok((
        input,
        Rule {
            name,
            r1: (l1, h1),
            r2: (l2, h2),
        },
    ))
}

#[test]
fn rule_works() {
    let input = b"class: 1-3 or 5-7\n";
    let (rest, r) = rule_line(input).unwrap();
    assert_eq!(r.name, b"class");
    assert_eq!(r.r1, (1, 3));
    assert_eq!(r.r2, (5, 7));
    assert_eq!(rest, b"");
}

fn rule_list(input: &[u8]) -> IResult<&[u8], Vec<Rule>> {
    terminated(many1(rule_line), tag("\n"))(input)
}

#[test]
fn rule_list_works() {
    let input = b"class: 1-3 or 5-7\nrow: 6-11 or 33-44\nseat: 13-40 or 45-50\n\n";
    let (input, r) = rule_list(input).unwrap();
    assert_eq!(r[0].name, b"class");
    assert_eq!(r[0].r1, (1, 3));
    assert_eq!(r[0].r2, (5, 7));
    assert_eq!(r[1].name, b"row");
    assert_eq!(r[1].r1, (6, 11));
    assert_eq!(r[1].r2, (33, 44));
    assert_eq!(r[2].name, b"seat");
    assert_eq!(r[2].r1, (13, 40));
    assert_eq!(r[2].r2, (45, 50));
}

#[derive(Debug, PartialEq, Eq)]
struct Ticket {
    n: Vec<u16>,
}

fn ticket(input: &[u8]) -> IResult<&[u8], Ticket> {
    let (input, n) = terminated(separated_list1(tag(","), digit1), tag("\n"))(input)?;
    let n = n
        .iter()
        .map(|n| {
            std::str::from_utf8(n)
                .expect("ascii")
                .parse::<u16>()
                .expect("number")
        })
        .collect();
    Ok((input, Ticket { n }))
}

#[test]
fn ticket_works() {
    let input = b"7,1,14\n";
    let (input, tkt) = ticket(input).unwrap();
    assert_eq!(input, b"");
    let exp: Vec<u16> = vec![7, 1, 14];
    assert_eq!(tkt.n, exp);
}

struct Scan<'a> {
    rules: Vec<Rule<'a>>,
    ticket: Ticket,
    tickets: Vec<Ticket>,
    err: usize,
}

fn scan(input: &[u8]) -> IResult<&[u8], Scan> {
    let (input, (rules, ticket, tickets)) = tuple((
        terminated(rule_list, tag("your ticket:\n")),
        terminated(ticket, tag("\nnearby tickets:\n")),
        many1(ticket),
    ))(input)?;
    let mut err = 0;
    let tickets = tickets
        .into_iter()
        .filter_map(|t| {
            for n in &t.n {
                let mut valid = false;
                for r in &rules {
                    if r.r1.0 <= *n && *n <= r.r1.1 || r.r2.0 <= *n && *n <= r.r2.1 {
                        valid = true;
                        break;
                    }
                }
                if !valid {
                    err += (*n) as usize;
                    return None;
                }
            }
            Some(t)
        })
        .collect();
    Ok((
        input,
        Scan {
            rules,
            ticket,
            tickets,
            err,
        },
    ))
}

#[test]
fn scan_works() {
    let inp = std::fs::read("../2020/16/test1.txt").expect("read error");
    let (input, scan) = scan(&inp).unwrap();
    assert_eq!(input, b"");
    assert_eq!(
        scan.rules,
        vec![
            Rule {
                name: b"class",
                r1: (1, 3),
                r2: (5, 7)
            },
            Rule {
                name: b"row",
                r1: (6, 11),
                r2: (33, 44),
            },
            Rule {
                name: b"seat",
                r1: (13, 40),
                r2: (45, 50),
            }
        ]
    );
    assert_eq!(scan.ticket.n, vec![7, 1, 14]);
    assert_eq!(scan.tickets, vec![Ticket { n: vec![7, 3, 47] },]);
    assert_eq!(scan.err, 71);
}

use ahash::RandomState;
use std::collections::HashMap;
use std::collections::HashSet;

fn parts(inp: &[u8]) -> (usize, usize) {
    let (_, scan) = scan(inp).expect("invalid input");
    if scan.tickets.len() < scan.rules.len() {
        return (scan.err, 0);
    }
    let mut possible: Vec<Vec<usize>> = vec![];
    for (i, rule) in scan.rules.iter().enumerate() {
        possible.push(vec![]);
        for col in 0..scan.ticket.n.len() {
            let mut valid = true;
            for t in &scan.tickets {
                let v = t.n[col];
                if !(rule.r1.0 <= v && v <= rule.r1.1 || rule.r2.0 <= v && v <= rule.r2.1) {
                    valid = false;
                    break;
                }
            }
            if valid {
                possible[i].push(col);
            }
        }
    }
    let mut p2 = 1;
    let mut c = 0;
    let is_test = scan.rules.len() < 6;
    loop {
        for i in 0..possible.len() {
            if possible[i].len() != 1 {
                continue;
            }
            let col = possible[i][0];
            possible[i].clear();
            if i < 6 || is_test {
                p2 *= scan.ticket.n[col] as usize;
                c += 1;
                if c == 6 || (is_test && c == scan.rules.len()) {
                    return (scan.err, p2);
                }
            }
            for j in 0..possible.len() {
                for k in 0..possible[j].len() {
                    if possible[j][k] == col {
                        possible[j].swap_remove(k);
                        break;
                    }
                }
            }
        }
    }
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

#[test]
fn parts_works() {
    let inp = std::fs::read("../2020/16/test1.txt").expect("read error");
    assert_eq!(parts(&inp), (71, 0));
    let inp = std::fs::read("../2020/16/test2.txt").expect("read error");
    assert_eq!(parts(&inp), (0, 1716));
    let inp = std::fs::read("../2020/16/input.txt").expect("read error");
    assert_eq!(parts(&inp), (21980, 1439429522627));
}
