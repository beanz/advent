pub fn egcd(a: isize, b: isize, x: &mut isize, y: &mut isize) -> isize {
    if a == 0 {
        (*x, *y) = (0, 1);
        b
    } else {
        let g = egcd(b % a, a, x, y);
        (*x, *y) = (*y - (b / a) * *x, *x);
        g
    }
}

pub fn crt(la: &[isize], ln: &[isize]) -> Option<isize> {
    let mut p = 1;
    for n in ln {
        println!("{} x {}", p, n);
        p *= *n;
    }
    let mut x = 0;
    let mut y = 0;
    let mut z;
    let mut j = 0;
    for (i, n) in ln.iter().enumerate() {
        let a = la[i];
        let q = p / *n;
        z = egcd(*n, q, &mut j, &mut y);
        if z == 1 {
            return None;
        }
        x += a * y * q;
        while x < 0 {
            x += p;
        }
        x %= p;
    }
    Some(x as isize)
}
