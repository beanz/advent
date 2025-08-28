fn parts(inp: &[u8]) -> (usize, usize) {
    let (_, num) = aoc::read::uint::<usize>(inp, 0);
    let mut recipes: Vec<u8> = vec![3, 7];
    let mut elf = (0, 1);
    //pretty(&recipes, elf);
    let end = &inp[..inp.len() - 1];
    while recipes.len() < num + 10 {
        let v0 = recipes[elf.0];
        let v1 = recipes[elf.1];
        let n = v0 + v1;
        if n >= 10 {
            recipes.push(1);
            recipes.push(n - 10);
        } else {
            recipes.push(n);
        }
        elf.0 += 1 + (v0 as usize);
        elf.0 %= recipes.len();
        elf.1 += 1 + (v1 as usize);
        elf.1 %= recipes.len();
        //pretty(&recipes, elf);
    }
    let mut p1 = 0;
    for i in 0..10 {
        p1 = p1 * 10 + (recipes[num + i] as usize);
    }
    for i in 0..recipes.len() - end.len() {
        let mut found = true;
        for j in 0..end.len() {
            if recipes[i + j] != end[j] - b'0' {
                found = false;
                break;
            }
        }
        if found {
            return (p1, i);
        }
    }
    let mut search_i = recipes.len() - end.len() - 1;
    loop {
        let v0 = recipes[elf.0];
        let v1 = recipes[elf.1];
        let n = v0 + v1;
        if n >= 10 {
            recipes.push(1);
            recipes.push(n - 10);
        } else {
            recipes.push(n);
        }
        elf.0 += 1 + (v0 as usize);
        while elf.0 >= recipes.len() {
            elf.0 -= recipes.len()
        }
        elf.1 += 1 + (v1 as usize);
        while elf.1 >= recipes.len() {
            elf.1 -= recipes.len()
        }
        while search_i < recipes.len() - end.len() {
            let mut found = true;
            for j in 0..end.len() {
                if recipes[search_i + j] != end[j] - b'0' {
                    found = false;
                    break;
                }
            }
            if found {
                return (p1, search_i);
            }
            search_i += 1;
        }
    }
}

#[allow(dead_code)]
fn pretty(recipes: &[u8], e: (usize, usize)) {
    for i in 0..recipes.len() {
        if i == e.0 {
            eprint!("({}) ", recipes[i])
        } else if i == e.1 {
            eprint!("[{}] ", recipes[i])
        } else {
            eprint!("{} ", recipes[i])
        };
    }
    eprintln!();
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1:010}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/14/test1a.txt").expect("read error");
        assert_eq!(parts(&inp), (124515891, 9));
        let inp = std::fs::read("../2018/14/input.txt").expect("read error");
        assert_eq!(parts(&inp), (5371393113, 20286858));
        let inp = std::fs::read("../2018/14/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (1776718175, 20220949));
    }
}
