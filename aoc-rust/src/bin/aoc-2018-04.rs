use heapless::FnvIndexMap;

#[derive(Debug, Default, Clone, Copy)]
enum Ev {
    #[default]
    None,
    Wake(u8),
    Sleep(u8),
}

const DAYS: usize = 31 * 12;
const SIZE: usize = 10;
const LEN: usize = DAYS * SIZE;
const MAX_GUARDS: usize = 32;
fn parts(inp: &[u8]) -> (usize, usize) {
    let mut events: [Ev; LEN] = [Ev::None; LEN];
    let mut guards: [u16; DAYS] = [0; DAYS];
    let mut id_to_idx = FnvIndexMap::<u16, usize, MAX_GUARDS>::new();
    let mut idx_to_id = [0u16; MAX_GUARDS];
    let mut i = 0;
    while i < inp.len() {
        let mut day = (((inp[i + 6] - b'0') * 10 + inp[i + 7] - b'0') - 1) as usize * 31;
        day += ((inp[i + 9] - b'0') * 10 + inp[i + 10] - b'0') as usize - 1;
        let min = (inp[i + 15] - b'0') * 10 + inp[i + 16] - b'0';
        let mut ev = match inp[i + 19] {
            b'G' => {
                if inp[i + 12] == b'2' {
                    day += 1;
                }
                let (j, guard) = aoc::read::uint::<u16>(inp, i + 26);
                guards[day] = guard;
                if !id_to_idx.contains_key(&guard) {
                    let idx = id_to_idx.len();
                    id_to_idx.insert(guard, idx).expect("id_to_idx full");
                    idx_to_id[idx] = guard;
                }
                i = j + 14;
                continue;
            }
            b'f' => {
                i += 32;
                Ev::Sleep(min)
            }
            b'w' => {
                i += 28;
                Ev::Wake(min)
            }
            _ => unreachable!("unsupported input line"),
        };
        let mut inserted = false;
        for j in 0..SIZE {
            let k = day * SIZE + j;
            match events[k] {
                Ev::None => {
                    events[k] = ev;
                    inserted = true;
                    break;
                }
                Ev::Wake(m) | Ev::Sleep(m) => {
                    if m > min {
                        (events[k], ev) = (ev, events[k]);
                    }
                }
            }
        }
        assert!(inserted, "failed to insert {:?} for day {}", ev, day);
    }
    let mut minutes = [0u32; MAX_GUARDS];
    let mut guard_minutes = [0u32; MAX_GUARDS * 60];
    for d in 0..DAYS {
        let guard = guards[d];
        if guard == 0 {
            continue;
        }
        let guard_idx = id_to_idx.get(&guard).expect("guard idx found");
        let gm_idx = guard_idx * 60;
        for j in 0..SIZE / 2 {
            let k = d * SIZE + j * 2;
            match events[k] {
                Ev::None => continue,
                Ev::Wake(_) => {
                    unreachable!("unexpected wake?");
                }
                Ev::Sleep(sm) => {
                    if let Ev::Wake(wm) = events[k + 1] {
                        minutes[*guard_idx] += (wm - sm) as u32;
                        for min in sm..wm {
                            guard_minutes[gm_idx + min as usize] += 1;
                        }
                    }
                }
            }
        }
    }
    let mut max = 0u32;
    let mut max_guard = 0u16;
    let mut max_guard_idx = 0;
    for (guard, guard_idx) in &id_to_idx {
        if minutes[*guard_idx] > max {
            max = minutes[*guard_idx];
            max_guard = *guard;
            max_guard_idx = *guard_idx;
        }
    }
    let mut max = 0;
    let mut max_min = 0;
    for min in 0..60 {
        let times = guard_minutes[max_guard_idx * 60 + min];
        if times > max {
            max = times;
            max_min = min;
        }
    }
    let p1 = max_guard as usize * max_min;
    let mut max = 0;
    let mut max_guard = 0;
    let mut max_min = 0;
    for (guard, guard_idx) in &id_to_idx {
        for min in 0..60 {
            let times = guard_minutes[guard_idx * 60 + min];
            if times > max {
                max = times;
                max_guard = *guard;
                max_min = min;
            }
        }
    }
    (p1, max_min * max_guard as usize)
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
        let inp = std::fs::read("../2018/04/test.txt").expect("read error");
        assert_eq!(parts(&inp), (240, 4455));
        let inp = std::fs::read("../2018/04/input.txt").expect("read error");
        assert_eq!(parts(&inp), (71748, 106850));
        let inp = std::fs::read("../2018/04/input-amf.txt").expect("read error");
        assert_eq!(parts(&inp), (143415, 49944));
    }
}
