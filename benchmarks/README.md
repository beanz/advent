This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 1 | 26.6µs | 218µs | 53.4µs | 24.6ms | 10.2µs | 34.1ms | 46.7µs
Day 2 | 922µs | 16.7µs | 38.9µs | 13.9ms | 4.73ms | 1.18ms | 678µs
Day 3 | 893µs | 117µs | 43.1µs | 224ms | 74.2ms | 61.7µs | 133µs
Day 4 | 1.41s | 2.75ms | 3.1ms | 7.3ms | 163ms | 842µs | 410µs
Day 5 | 624µs | 6.07s | 163ms | 470ms | 2.88ms | 159µs | **🔴 1.74ms**
Day 6 | 148ms | 247µs | 33.3ms | 65.6ms | 35.6ms | 2.57ms | 178µs
Day 7 | 442µs | - | 4.39ms | 406µs | 8.95ms | 2.89ms | 111µs
Day 8 | 45µs | - | 868µs | 352ms | 371µs | 3.84ms | 824µs
Day 9 | 21.7ms | - | 200µs | 570ms | 104ms | 14.9ms | 1.1ms
Day 10 | 143ms | 8.22ms | 1.85ms | 2.15ms | 36.9ms | 124µs | 59.4µs
Day 11 | 68.3ms | 27.5s | 277µs | **🔴 1m9.3s** | 30.5ms | 98.2ms | 816µs
Day 12 | 117ms | 831ms | 5.78ms | 2.49ms | 908ms | 250µs | 851µs
Day 13 | 199ms | 185µs | 2.01s | 6.82ms | 208ms | 15.6µs | 450µs
Day 14 | 410µs | 25.5s | 109ms | 4.57s | 13.6ms | 20.8ms | -
Day 15 | 126ms | 60ms | 1.25s | 799ms | 45.9ms | **🔴 3.81s** | -
Day 16 | 811µs | 19.2s | 631ms | 20.4ms | 1.25s | 3.22ms | -
Day 17 | 96.2ms | 114ms | 655ms | 109ms | 36.1ms | 1.2s | -
Day 18 | 5.72ms | 3.96s | 1.02s | 196ms | **🔴 42.1s** | 28ms | -
Day 19 | 1.73ms | 700ms | 734µs | 268ms | 676ms | 33.6ms | -
Day 20 | **🔴 7.17s** | 484µs | 523ms | 34.2ms | 921ms | 17.3ms | -
Day 21 | 948µs | 350ms | 146ms | 938ms | 155ms | 4.73ms | -
Day 22 | **🔴 3.11s** | 35.8ms | 1.04s | 4.38s | 447µs | 133ms | -
Day 23 | 56.2µs | **🔴 2m7s** | 4.18ms | 370ms | - | 1.41s | -
Day 24 | 312ms | 103ms | **🔴 4.88s** | 205ms | 459ms | 243ms | -
Day 25 | 13.8µs | 176ms | 1.36s | 18.3ms | - | 45.7ms | -
*Total* | *12.9s* | *3m32s* | *13.8s* | *1m22.9s* | *47.3s* | *7.11s* | *7.39ms*
