use arrayvec::ArrayVec;

#[derive(Debug, PartialEq, Eq, Clone, Copy)]
enum Seat {
    Floor,
    Empty,
    Occupied,
}

#[derive(Debug)]
struct Room {
    seats: [Seat; 10000],
    h: usize,
    w: usize,
}

impl Room {
    fn new(inp: &[u8]) -> Room {
        let mut seats = [Seat::Floor; 10000];
        let mut w = 0;
        let mut h = 0;
        let mut j = 0;
        let mut k = 0;
        for ch in inp {
            match ch {
                b'L' => {
                    seats[j] = Seat::Empty;
                    j += 1;
                }
                b'.' => {
                    seats[j] = Seat::Floor;
                    j += 1;
                }
                b'\n' => {
                    h += 1;
                    w = k;
                    k = 0;
                }
                _ => unreachable!("invalid input"),
            }
            k += 1;
        }
        w -= 1;
        Room { seats, w, h }
    }

    fn neighbours(&self, x: isize, y: isize, sight: bool) -> ArrayVec<usize, 8> {
        let w = self.w as isize;
        let h = self.h as isize;
        let mut nb: ArrayVec<usize, 8> = ArrayVec::default();
        for (ox, oy) in &[
            (-1, -1),
            (0, -1),
            (1, -1),
            (-1, 0),
            (1, 0),
            (-1, 1),
            (0, 1),
            (1, 1),
        ] {
            let mut nx = x + ox;
            let mut ny = y + oy;
            let mut s = Seat::Floor;
            while 0 <= nx && nx < w && 0 <= ny && ny < h {
                s = self.seats[nx as usize + (ny as usize) * self.w];
                if s != Seat::Floor || !sight {
                    break;
                }
                nx += ox;
                ny += oy;
            }
            if s != Seat::Floor {
                nb.push(nx as usize + (ny as usize) * self.w);
            }
        }
        nb
    }
    fn solve(&self, sight: bool) -> usize {
        let group = if sight { 5 } else { 4 };
        let mut nb_cache: ArrayVec<ArrayVec<usize, 8>, 10000> = ArrayVec::default();
        for y in 0..self.h {
            for x in 0..self.w {
                nb_cache.push(self.neighbours(x as isize, y as isize, sight));
            }
        }
        let mut cur = self.seats;
        let mut new = [Seat::Floor; 10000];
        loop {
            let mut changed = false;
            for i in 0..self.w * self.h {
                let cur_seat = cur[i];
                if cur_seat == Seat::Floor {
                    continue;
                }
                let mut oc = 0;
                for j in &nb_cache[i] {
                    if cur[*j] == Seat::Occupied {
                        oc += 1;
                    }
                }
                let mut new_seat = cur_seat;
                if cur_seat == Seat::Empty && oc == 0 {
                    changed = true;
                    new_seat = Seat::Occupied;
                } else if cur_seat == Seat::Occupied && oc >= group {
                    changed = true;
                    new_seat = Seat::Empty
                }
                new[i] = new_seat;
            }
            if !changed {
                break;
            }
            (cur, new) = (new, cur);
        }
        let mut c = 0;
        for seat in cur {
            if seat == Seat::Occupied {
                c += 1;
            }
        }
        c
    }

    fn parts(&self) -> (usize, usize) {
        (self.solve(false), self.solve(true))
    }
}

fn main() {
    let inp = std::fs::read(aoc::input_file()).expect("read error");
    aoc::benchme(|bench: bool| {
        let room = Room::new(&inp);
        let (p1, p2) = room.parts();
        if !bench {
            println!("Part 1: {}", p1);
            println!("Part 2: {}", p2);
        }
    });
}

#[test]
fn parts_works() {
    let inp = std::fs::read("../2020/11/test1.txt").expect("read error");
    let room = Room::new(&inp);
    assert_eq!(room.parts(), (37, 26));
    let inp = std::fs::read("../2020/11/test2.txt").expect("read error");
    let room = Room::new(&inp);
    assert_eq!(room.parts(), (14, 13));
    let inp = std::fs::read("../2020/11/input.txt").expect("read error");
    let room = Room::new(&inp);
    assert_eq!(room.parts(), (2481, 2227));
}
