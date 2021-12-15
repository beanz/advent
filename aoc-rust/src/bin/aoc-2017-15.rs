struct Generator {
    prev: usize,
    factor: usize,
    modulus: usize,
}

impl Generator {
    fn new(prev: usize, factor: usize, modulus: usize) -> Generator {
        Generator {
            prev,
            factor,
            modulus,
        }
    }
}

impl Iterator for Generator {
    type Item = usize;

    fn next(&mut self) -> Option<Self::Item> {
        self.prev = (self.prev * self.factor) % self.modulus;
        Some(self.prev)
    }
}

#[test]
fn generator_works() {
    let mut gen_a = Generator::new(65, 16807, 2147483647);
    assert_eq!(gen_a.next(), Some(1092455), "gen a 0th");
    assert_eq!(gen_a.next(), Some(1181022009), "gen a 1st");
    assert_eq!(gen_a.next(), Some(245556042), "gen a 2st");
    assert_eq!(gen_a.next(), Some(1744312007), "gen a 3st");
    assert_eq!(gen_a.next(), Some(1352636452), "gen a 4st");
    let mut gen_b = Generator::new(8921, 48271, 2147483647);
    assert_eq!(gen_b.next(), Some(430625591), "gen b 0th");
    assert_eq!(gen_b.next(), Some(1233683848), "gen b 1st");
    assert_eq!(gen_b.next(), Some(1431495498), "gen b 2st");
    assert_eq!(gen_b.next(), Some(137874439), "gen b 3st");
    assert_eq!(gen_b.next(), Some(285222916), "gen b 4st");
}

fn part1(init_a: usize, init_b: usize) -> usize {
    Generator::new(init_a, 16807, 2147483647)
        .zip(Generator::new(init_b, 48271, 2147483647))
        .take(40_000_000)
        .filter(|(a, b)| (a & 0xffff) == (b & 0xffff))
        .count()
}

#[test]
fn part1_works() {
    assert_eq!(part1(65, 8921), 588, "part 1 example");
}

fn generator2(
    gen: &mut Generator, div: usize,
) -> impl Iterator<Item = usize> + '_ {
    gen.filter(move |a| (a % div) == 0)
}

#[test]
fn generator2_works() {
    let mut gen_a = Generator::new(65, 16807, 2147483647);
    let mut gen_a2 = generator2(&mut gen_a, 4);
    assert_eq!(gen_a2.next(), Some(1352636452), "gen a%4 0th");
    assert_eq!(gen_a2.next(), Some(1992081072), "gen a%4 1st");
    assert_eq!(gen_a2.next(), Some(530830436), "gen a%4 2st");
    assert_eq!(gen_a2.next(), Some(1980017072), "gen a%4 3st");
    assert_eq!(gen_a2.next(), Some(740335192), "gen a%4 4st");
    let mut gen_b = Generator::new(8921, 48271, 2147483647);
    let mut gen_b2 = generator2(&mut gen_b, 8);
    assert_eq!(gen_b2.next(), Some(1233683848), "gen b%8 0th");
    assert_eq!(gen_b2.next(), Some(862516352), "gen b%8 1st");
    assert_eq!(gen_b2.next(), Some(1159784568), "gen b%8 2st");
    assert_eq!(gen_b2.next(), Some(1616057672), "gen b%8 3st");
    assert_eq!(gen_b2.next(), Some(412269392), "gen b%8 4st");
}

fn part2(init_a: usize, init_b: usize) -> usize {
    generator2(&mut Generator::new(init_a, 16807, 2147483647), 4)
        .zip(generator2(
            &mut Generator::new(init_b, 48271, 2147483647),
            8,
        ))
        .take(5_000_000)
        .filter(|(a, b)| (a & 0xffff) == (b & 0xffff))
        .count()
}

#[test]
fn part2_works() {
    assert_eq!(part2(65, 8921), 309, "part 2 example");
}

fn main() {
    let inp = aoc::read_input_line();
    aoc::benchme(|bench: bool| {
        let init = aoc::uints::<usize>(&inp).collect::<Vec<usize>>();
        let p1 = part1(init[0], init[1]);
        let p2 = part2(init[0], init[1]);
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}
