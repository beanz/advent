pub fn calc(lines: &[String]) -> (usize, usize) {
    let mut p1 = [false; 1000000];
    let mut p2: [i32; 1000000] = [0; 1000000];
    for l in lines.iter() {
        let mut ss = l.rsplit(' ');
        let max = ss
            .next()
            .unwrap()
            .split(',')
            .map(|x| x.parse::<usize>().unwrap())
            .collect::<Vec<usize>>();
        ss.next();
        let min = ss
            .next()
            .unwrap()
            .split(',')
            .map(|x| x.parse::<usize>().unwrap())
            .collect::<Vec<usize>>();
        let mut sw = "toggle";
        if l.starts_with("turn on") {
            sw = "on"
        } else if l.starts_with("turn off") {
            sw = "off"
        }
        for x in min[0]..=max[0] {
            for y in min[1]..=max[1] {
                let i = x + y * 1000;
                match sw {
                    "off" => {
                        p1[i] = false;
                        p2[i] -= 1;
                        if p2[i] < 0 {
                            p2[i] = 0
                        }
                    }
                    "on" => {
                        p1[i] = true;
                        p2[i] += 1;
                    }
                    _ => {
                        p1[i] = !p1[i];
                        p2[i] += 2;
                    }
                }
            }
        }
    }
    (
        p1.iter().filter(|&&i| i).count(),
        p2.iter().map(|x| x.unsigned_abs() as usize).sum(),
    )
}

fn main() {
    let inp = aoc::input_lines();
    aoc::benchme(|bench: bool| {
        let (p1, p2) = calc(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    });
}
