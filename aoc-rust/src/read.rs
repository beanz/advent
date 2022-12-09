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
    while i < inp.len() && b'0' <= inp[i] && inp[i] <= b'9' {
        n = n * 10.into() + (inp[i] & 0xf).into();
        i += 1;
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
    let mut m: T = 1.into();
    if i < inp.len() && inp[i] == b'-' {
        m = -m;
        i += 1;
    }
    debug_assert!(
        i < inp.len() && b'0' <= inp[i] && inp[i] <= b'9',
        "{} < {}",
        i,
        inp.len()
    );
    while i < inp.len() && b'0' <= inp[i] && inp[i] <= b'9' {
        n = n * 10.into() + (inp[i] - b'0').into();
        i += 1;
    }
    (i, m * n)
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
