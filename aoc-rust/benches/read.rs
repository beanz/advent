use arrayvec::ArrayVec;
use criterion::{black_box, criterion_group, criterion_main, Criterion};
use smallvec::SmallVec;

fn read_int(inp: &[u8], i: usize) -> (usize, i32) {
    aoc::read::int::<i32>(inp, i)
}

fn read_uint(inp: &[u8], i: usize) -> (usize, i32) {
    aoc::read::uint::<i32>(inp, i)
}

fn read_arrayvec(inp: &[u8]) {
    let mut nums: ArrayVec<i64, 8192> = ArrayVec::default();
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<i64>(inp, i);
        nums.push(n);
        i = j + 1;
    }
}

fn read_heapless_vec(inp: &[u8]) {
    let mut nums = heapless::Vec::<i64, 8192>::new();
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<i64>(inp, i);
        nums.push(n);
        i = j + 1;
    }
}

fn read_smallvec(inp: &[u8]) {
    let mut nums = SmallVec::<[i64; 8192]>::new();
    let mut i = 0;
    while i < inp.len() {
        let (j, n) = aoc::read::int::<i64>(inp, i);
        nums.push(n);
        i = j + 1;
    }
}

fn criterion_benchmark(c: &mut Criterion) {
    c.bench_function("read_int", |b| {
        b.iter(|| read_int(black_box(b"abc: -1234"), 5))
    });
    c.bench_function("read_uint", |b| {
        b.iter(|| read_uint(black_box(b"abc: -1234"), 6))
    });
    let inp = std::fs::read("../2019/25/input.txt").expect("read error");
    c.bench_function("read_arrayvec", |b| {
        b.iter(|| read_arrayvec(black_box(&inp)))
    });
    c.bench_function("read_heapless_vec", |b| {
        b.iter(|| read_heapless_vec(black_box(&inp)))
    });
    c.bench_function("read_smallvec", |b| {
        b.iter(|| read_smallvec(black_box(&inp)))
    });
}

criterion_group!(benches, criterion_benchmark);
criterion_main!(benches);
