pub fn uint<T>(inp: &[u8], i: usize) -> (usize, T)
where
    T: std::ops::Add<T>
        + std::ops::Mul<Output = T>
        + std::convert::From<u8>
        + std::ops::Add<Output = T>
        + num::Integer,
{
    let mut n: T = 0.into();
    let mut i = i;
    debug_assert!(i < inp.len() && b'0' <= inp[i] && inp[i] <= b'9');
    while i < inp.len() {
        let c = inp[i].wrapping_sub(b'0');
        if c <= 9 {
            n = n * 10.into() + c.into();
            i += 1;
            continue;
        }
        break;
    }
    (i, n)
}

pub fn int<T>(inp: &[u8], i: usize) -> (usize, T)
where
    T: std::ops::Add<T>
        + std::ops::Mul<Output = T>
        + std::convert::From<u8>
        + std::ops::Add<Output = T>
        + std::ops::Neg<Output = T>
        + num::Integer,
{
    let mut n: T = 0.into();
    let mut i = i;
    let mut neg = false;
    debug_assert!(i < inp.len(), "index too large: {} < {}", i, inp.len());
    match inp[i] {
        b'-' => {
            neg = true;
            i += 1;
        }
        b'+' => {
            i += 1;
        }
        _ => {}
    }
    debug_assert!(
        i < inp.len() && b'0' <= inp[i] && inp[i] <= b'9',
        "{} < {}",
        i,
        inp.len()
    );
    while i < inp.len() {
        let c = inp[i].wrapping_sub(b'0');
        if c <= 9 {
            n = n * 10.into() + c.into();
            i += 1;
            continue;
        }
        break;
    }
    (i, if neg { -n } else { n })
}

pub fn skip_next_line(inp: &[u8], i: usize) -> usize {
    let mut i = i;
    while inp[i] != b'\n' {
        i += 1;
    }
    i + 1
}

pub fn visit_uint_until<T>(inp: &[u8], i: &mut usize, exp: u8, mut visit_fn: impl FnMut(T))
where
    T: std::ops::Add<T>
        + std::ops::Mul<Output = T>
        + std::convert::From<u8>
        + std::ops::Add<Output = T>
        + num::Integer,
{
    let mut n: T = 0.into();
    let mut num = false;
    loop {
        match inp[*i] {
            ch if ch == exp => {
                if num {
                    visit_fn(n);
                }
                return;
            }
            b'0'..=b'9' => {
                num = true;
                n = n * 10.into() + (inp[*i].wrapping_sub(b'0')).into();
            }
            _ => {
                if num {
                    visit_fn(n);
                }
                num = false;
                n = 0.into();
            }
        }
        *i += 1;
    }
}

pub fn visit_uints<T>(inp: &[u8], mut visit_fn: impl FnMut(T))
where
    T: std::ops::Add<T>
        + std::ops::Mul<Output = T>
        + std::convert::From<u8>
        + std::ops::Add<Output = T>
        + num::Integer,
{
    let mut n: T = 0.into();
    let mut num = false;
    for ch in inp {
        match ch {
            b'0'..=b'9' => {
                num = true;
                n = n * 10.into() + (ch.wrapping_sub(b'0')).into();
            }
            _ => {
                if num {
                    visit_fn(n);
                }
                num = false;
                n = 0.into();
            }
        }
    }
    if num {
        visit_fn(n);
    }
}

pub fn visit_ints<T>(inp: &[u8], mut visit_fn: impl FnMut(T))
where
    T: std::ops::Add<T>
        + std::ops::Mul<Output = T>
        + std::convert::From<u8>
        + std::ops::Add<Output = T>
        + std::ops::Neg<Output = T>
        + num::Integer,
{
    let mut n: T = 0.into();
    let mut num = false;
    let mut neg = false;
    for ch in inp {
        match ch {
            b'0'..=b'9' => {
                num = true;
                n = n * 10.into() + (ch.wrapping_sub(b'0')).into();
            }
            b'-' => {
                neg = true;
            }
            _ => {
                if num {
                    visit_fn(if neg { -n } else { n });
                }
                num = false;
                neg = false;
                n = 0.into();
            }
        }
    }
    if num {
        visit_fn(if neg { -n } else { n });
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn uint_works() {
        let inp = b"2-6";
        let (i, n) = uint::<usize>(inp, 0);
        assert_eq!(i, 1);
        assert_eq!(n, 2);
        let (i, n) = uint::<usize>(inp, i + 1);
        assert_eq!(i, 3);
        assert_eq!(n, 6);
    }
    #[test]
    fn int_works() {
        let inp = b"-6";
        let (i, n) = int::<isize>(inp, 0);
        assert_eq!(i, 2);
        assert_eq!(n, -6);
        let inp = b"6";
        let (i, n) = int::<isize>(inp, 0);
        assert_eq!(i, 1);
        assert_eq!(n, 6);
        let inp = b"-10..-5";
        let (i, n) = int::<isize>(inp, 0);
        assert_eq!(i, 3);
        assert_eq!(n, -10);
        let (i, n) = int::<isize>(inp, i + 2);
        assert_eq!(i, 7);
        assert_eq!(n, -5);
    }
}
