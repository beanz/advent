use std::mem::MaybeUninit;

pub struct Deque<T, const N: usize>
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
    #[allow(clippy::uninit_assumed_init)]
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
    pub fn len(&self) -> usize {
        self.len
    }
    pub fn push(&mut self, i: T) {
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
    pub fn pop(&mut self) -> Option<T> {
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
