use num::rational::Ratio;
use std::collections::HashMap;

#[derive(Debug)]
enum Op {
    Add,
    Sub,
    Mul,
    Div,
}

#[derive(Debug)]
enum Node {
    Value(isize),
    Op(usize, Op, usize),
}

fn parts(inp: &[u8]) -> (isize, isize) {
    let root = char_id(b"root", 26, b'a');
    let humn = char_id(b"humn", 26, b'a');
    let mut i = 0;
    let mut nodes: HashMap<usize, Node> = HashMap::default();
    while i < inp.len() {
        let id = char_id(&inp[i..i + 4], 26, b'a');
        i += 6;
        if inp[i].is_ascii_digit() {
            let (j, n) = aoc::read::uint::<isize>(inp, i);
            nodes.insert(id, Node::Value(n));
            i = j + 1;
            continue;
        }
        let left = char_id(&inp[i..i + 4], 26, b'a');
        let right = char_id(&inp[i + 7..i + 11], 26, b'a');
        let op = match inp[i + 5] {
            b'+' => Op::Add,
            b'-' => Op::Sub,
            b'*' => Op::Mul,
            b'/' => Op::Div,
            _ => unreachable!("invalid op"),
        };
        nodes.insert(id, Node::Op(left, op, right));
        i += 12;
    }
    let p1 = part1(&nodes, root);
    nodes.entry(root).and_modify(|e| {
        *e = match e {
            Node::Op(left, _op, right) => Node::Op(*left, Op::Sub, *right),
            _ => unreachable!("root should be op"),
        }
    });
    nodes.entry(humn).and_modify(|e| *e = Node::Value(0));
    let zero = part2(&nodes, root);
    nodes.entry(humn).and_modify(|e| *e = Node::Value(1));
    let one = part2(&nodes, root);
    let ans = zero / (zero - one);
    if !ans.is_integer() {
        unreachable!("expected part 2 to be integer");
    }
    (p1, ans.to_integer())
}

fn part1(nodes: &HashMap<usize, Node>, id: usize) -> isize {
    let node = nodes.get(&id).expect("missing node");
    match node {
        Node::Value(val) => *val,
        Node::Op(id_l, op, id_r) => {
            let left = part1(nodes, *id_l);
            let right = part1(nodes, *id_r);
            match op {
                Op::Add => left + right,
                Op::Sub => left - right,
                Op::Mul => left * right,
                Op::Div => left / right,
            }
        }
    }
}

fn part2(nodes: &HashMap<usize, Node>, id: usize) -> Ratio<isize> {
    let node = nodes.get(&id).expect("missing node");
    match node {
        Node::Value(val) => Ratio::from_integer(*val),
        Node::Op(id_l, op, id_r) => {
            let left = part2(nodes, *id_l);
            let right = part2(nodes, *id_r);
            match op {
                Op::Add => left + right,
                Op::Sub => left - right,
                Op::Mul => left * right,
                Op::Div => left / right,
            }
        }
    }
}

fn char_id(chs: &[u8], mul: usize, off: u8) -> usize {
    let mut id = 0;
    for ch in chs {
        id = mul * id + (*ch - off) as usize
    }
    id
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
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
    fn parts_works() {
        let inp = std::fs::read("../2022/21/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (10, 20));
        let inp = std::fs::read("../2022/21/input.txt").expect("read error");
        assert_eq!(parts(&inp), (100, 200));
    }
}
