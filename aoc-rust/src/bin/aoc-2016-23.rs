mod elfcomp2016;

#[allow(dead_code)]
const EX1: [&str; 7] = [
    "cpy 2 a", "tgl a", "tgl a", "tgl a", "cpy 1 a", "dec a", "dec a",
];

fn part1(comp: &mut elfcomp2016::ElfComp2016) -> isize {
    comp.run(&vec![7]);
    comp.get_reg(b'a')
}

fn part2(comp: &mut elfcomp2016::ElfComp2016) -> isize {
    comp.run(&vec![12]);
    comp.get_reg(b'a')
}

#[test]
fn part1_works() {
    let e: Vec<String> =
        EX1.iter().map(|x| x.to_string()).collect::<Vec<String>>();
    let mut comp = elfcomp2016::ElfComp2016::new(&e);
    assert_eq!(part1(&mut comp), 3, "part 1 example");
}

fn main() {
    let lines = aoc::input_lines();
    let lines2 = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let mut comp = elfcomp2016::ElfComp2016::new(&lines);
        let p1 = part1(&mut comp);
        comp = elfcomp2016::ElfComp2016::new(&lines2);
        let p2 = part2(&mut comp);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
