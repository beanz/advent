mod elfcomp2016;

fn part1(comp: &mut elfcomp2016::ElfComp2016) -> isize {
    comp.run(&vec![]);
    comp.get_reg(b'a')
}

fn part2(comp: &mut elfcomp2016::ElfComp2016) -> isize {
    comp.run(&vec![0, 0, 1, 0]);
    comp.get_reg(b'a')
}

#[allow(dead_code)]
const EX1: [&str; 6] =
    ["cpy 41 a", "inc a", "inc a", "dec a", "jnz a 2", "dec a"];

#[test]
fn part1_works() {
    let e: Vec<String> =
        EX1.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    let mut comp = elfcomp2016::ElfComp2016::new(&e);
    assert_eq!(part1(&mut comp), 42, "part 1 example");
}

fn main() {
    let lines = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let mut comp = elfcomp2016::ElfComp2016::new(&lines);
        let p1 = part1(&mut comp);
        let p2 = part2(&mut comp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
