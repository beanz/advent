pub fn auto<T, F>(path: &str, func: F)
where
    F: Fn(&[u8]) -> (T, T),
    T: std::cmp::Eq + std::str::FromStr + std::fmt::Debug,
    <T as std::str::FromStr>::Err: std::fmt::Debug,
{
    let casefile = path.to_owned() + "TC.txt";
    let tests = std::fs::read_to_string(casefile).expect("read error");
    let mut lines = tests.split('\n');
    loop {
        let line = lines.next();
        if line.is_none() {
            break;
        }
        let file = path.to_owned() + line.unwrap();
        println!("file {}", file);
        let inp = std::fs::read(file).expect("input read error");
        let p1 = lines.next().unwrap().parse::<T>().expect("read p1 answer");
        let p2 = lines.next().unwrap().parse::<T>().expect("read p2 answer");
        assert_eq!(func(&inp), (p1, p2));
        if lines.next().is_none() {
            break;
        }
        println!("next");
    }
}
