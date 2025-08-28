use heapless::Deque;
use std::collections::VecDeque;

fn parts(inp: &[u8]) -> (u32, u32) {
    let (j, players) = aoc::read::uint::<u32>(inp, 0);
    let (_, score) = aoc::read::uint::<u32>(inp, j + 31);
    (play_heapless(players, score), play(players, score * 100))
}

fn play(players: u32, marbles: u32) -> u32 {
    let mut scores = vec![0u32; 8000000];
    let mut circle: VecDeque<u32> = VecDeque::with_capacity(8000000);
    circle.push_front(0);
    for m in 1..=marbles {
        if m % 23 == 0 {
            for _j in 0..7 {
                let t = circle.pop_back().expect("circle has marble");
                circle.push_front(t);
            }
            scores[((m - 1) % players) as usize] +=
                m + circle.pop_front().expect("circle has marble");
        } else {
            for _j in 0..2 {
                let t = circle.pop_front().expect("circle has marble");
                circle.push_back(t);
            }
            circle.push_front(m);
        }
    }
    *scores.iter().max().expect("max has score")
}

fn play_heapless(players: u32, marbles: u32) -> u32 {
    let mut scores = [0u32; 80000];
    let mut circle = Deque::<u32, 80000>::new();
    circle.push_front(0).expect("circle has space");
    for m in 1..=marbles {
        if m % 23 == 0 {
            for _j in 0..7 {
                let t = circle.pop_back().expect("circle has marble");
                circle.push_front(t).expect("circle has space");
            }
            scores[((m - 1) % players) as usize] +=
                m + circle.pop_front().expect("circle has marble");
        } else {
            for _j in 0..2 {
                let t = circle.pop_front().expect("circle has marble");
                circle.push_back(t).expect("circle has space");
            }
            circle.push_front(m).expect("circle has space");
        }
    }
    *scores.iter().max().expect("max has score")
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let (p1, p2) = parts(&inp);
        if !bench {
            println!("Part 1: {p1}");
            println!("Part 2: {p2}");
        }
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2018/09/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (32, 22563));
        let inp = std::fs::read("../2018/09/input.txt").expect("read error");
        assert_eq!(parts(&inp), (385820, 3156297594));
        let inp = std::fs::read("../2018/09/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (373597, 2954067253));
    }
}
