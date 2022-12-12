fn parts(inp: &[u8]) -> (usize, usize) {
    let mut p1 = 0;
    let mut p2 = 0;
    let mut w = 0;
    while inp[w] != b'\n' {
        w += 1;
    }
    let w1 = w + 1;
    let mut todo1 = Deque::<Search, 100>::default();
    let mut todo2 = Deque::<Search, 3200>::default();
    let mut e = 0;
    for i in 0..inp.len() {
        match inp[i] {
            b'S' => {
                todo1.push(Search {
                    pos: i,
                    ch: b'a',
                    steps: 0,
                });
                todo2.push(Search {
                    pos: i,
                    ch: b'a',
                    steps: 0,
                });
            }
            b'a' => {
                todo2.push(Search {
                    pos: i,
                    ch: b'a',
                    steps: 0,
                });
            }
            b'E' => {
                e = i;
            }
            _ => {}
        }
    }
    let mut v = [false; 10240];
    while let Some(cur) = todo1.pop() {
        if v[cur.pos] {
            continue;
        }
        v[cur.pos] = true;
        if cur.pos == e {
            p1 = cur.steps;
            break;
        }
        let steps = cur.steps + 1;
        if cur.pos > 0 && (cur.pos - 1) % w1 != w {
            let pos = cur.pos - 1;
            let ch = if inp[pos] == b'E' { b'z' } else { inp[pos] };
            if ch <= cur.ch + 1 && !v[pos] {
                todo1.push(Search { pos, steps, ch })
            }
        }
        if cur.pos < inp.len() - 1 && (cur.pos + 1) % w1 != w {
            let pos = cur.pos + 1;
            let ch = if inp[pos] == b'E' { b'z' } else { inp[pos] };
            if ch <= cur.ch + 1 && !v[pos] {
                todo1.push(Search { pos, steps, ch })
            }
        }
        if cur.pos >= w1 {
            let pos = cur.pos - w1;
            let ch = if inp[pos] == b'E' { b'z' } else { inp[pos] };
            if ch <= cur.ch + 1 && !v[pos] {
                todo1.push(Search { pos, steps, ch })
            }
        }
        if cur.pos < inp.len() - w1 {
            let pos = cur.pos + w1;
            let ch = if inp[pos] == b'E' { b'z' } else { inp[pos] };
            if ch <= cur.ch + 1 && !v[pos] {
                todo1.push(Search { pos, steps, ch })
            }
        }
    }
    let mut v = [false; 10240];
    while let Some(cur) = todo2.pop() {
        if v[cur.pos] {
            continue;
        }
        v[cur.pos] = true;
        if cur.pos == e {
            p2 = cur.steps;
            break;
        }
        let steps = cur.steps + 1;
        if cur.pos > 0 && (cur.pos - 1) % w1 != w {
            let pos = cur.pos - 1;
            let ch = if inp[pos] == b'E' { b'z' } else { inp[pos] };
            if ch <= cur.ch + 1 && !v[pos] {
                todo2.push(Search { pos, steps, ch })
            }
        }
        if cur.pos < inp.len() - 1 && (cur.pos + 1) % w1 != w {
            let pos = cur.pos + 1;
            let ch = if inp[pos] == b'E' { b'z' } else { inp[pos] };
            if ch <= cur.ch + 1 && !v[pos] {
                todo2.push(Search { pos, steps, ch })
            }
        }
        if cur.pos >= w1 {
            let pos = cur.pos - w1;
            let ch = if inp[pos] == b'E' { b'z' } else { inp[pos] };
            if ch <= cur.ch + 1 && !v[pos] {
                todo2.push(Search { pos, steps, ch })
            }
        }
        if cur.pos < inp.len() - w1 {
            let pos = cur.pos + w1;
            let ch = if inp[pos] == b'E' { b'z' } else { inp[pos] };
            if ch <= cur.ch + 1 && !v[pos] {
                todo2.push(Search { pos, steps, ch })
            }
        }
    }
    (p1, p2)
}

#[derive(Clone, Copy, Debug, Default)]
struct Search {
    pos: usize,
    ch: u8,
    steps: usize,
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

use std::mem::MaybeUninit;

struct Deque<T, const N: usize>
where
    T: Clone + std::fmt::Debug + Default,
{
    array: [T; N],
    head: usize,
    tail: usize,
    len: usize,
}

impl<T, const N: usize> Default for Deque<T, N>
where
    T: Clone + std::fmt::Debug + Default,
{
    /// Return an empty array
    fn default() -> Deque<T, N> {
        unsafe {
            Deque {
                array: MaybeUninit::uninit().assume_init(),
                head: 0,
                tail: 0,
                len: 0,
            }
        }
    }
}

impl<T, const N: usize> Deque<T, N>
where
    T: Clone + std::fmt::Debug + Default,
{
    fn len(&self) -> usize {
        self.len
    }
    fn push(&mut self, i: T) {
        if self.len == N {
            eprintln!("{}", self.len());
            panic!("deque full!")
        }
        self.array[self.tail] = i;
        self.tail += 1;
        if self.tail == N {
            self.tail = 0;
        }
        self.len += 1;
    }
    fn pop(&mut self) -> Option<T> {
        if self.len == 0 {
            return None;
        }
        let r = self.array[self.head].to_owned();
        self.head += 1;
        if self.head == N {
            self.head = 0;
        }
        self.len -= 1;
        Some(r)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parts_works() {
        let inp = std::fs::read("../2022/12/test1.txt").expect("read error");
        assert_eq!(parts(&inp), (31, 29));
        let inp = std::fs::read("../2022/12/input.txt").expect("read error");
        assert_eq!(parts(&inp), (481, 480));
    }
    #[test]
    fn deque_works() {
        let mut dq = Deque::<usize, 4>::default();
        dq.push(1);
        assert_eq!(dq.len(), 1);
        assert_eq!(dq.pop(), Some(1));
        assert_eq!(dq.len(), 0);
        assert_eq!(dq.pop(), None);
        dq.push(2);
        dq.push(4);
        dq.push(8);
        dq.push(16);
        assert_eq!(dq.len(), 4);
        assert_eq!(dq.pop(), Some(2));
        assert_eq!(dq.len(), 3);
        assert_eq!(dq.pop(), Some(4));
        assert_eq!(dq.len(), 2);
        assert_eq!(dq.pop(), Some(8));
        assert_eq!(dq.len(), 1);
        assert_eq!(dq.pop(), Some(16));
    }
}
