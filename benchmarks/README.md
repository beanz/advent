This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 1 | - | - | 52.8µs | 24.5ms | 10µs | 36.5ms | 16.2ms
Day 2 | - | - | 42.2µs | 15.2ms | 4.5ms | 1.17ms | 688µs
Day 3 | - | - | 43.6µs | 229ms | 77.3ms | 62.9µs | 143µs
Day 4 | - | - | 3.31ms | 7.57ms | 168ms | 847µs | 1.6ms
Day 5 | - | 24.7s | 166ms | 526ms | 2.9ms | 164µs | **🔴 77.1ms**
Day 6 | - | - | 33.4ms | 73.4ms | 36.8ms | 2.66ms | 180µs
Day 7 | - | - | 4.29ms | 418µs | 8.59ms | 2.9ms | 3.67ms
Day 8 | - | - | 937µs | 382ms | 373µs | 3.7ms | 840µs
Day 9 | - | - | 202µs | 659ms | 101ms | 15.2ms | 2.04ms
Day 10 | - | 8.01ms | 26.1ms | 2.26ms | 35.1ms | 122µs | 59.6µs
Day 11 | - | 26.2s | 1.19s | **🔴 28.2s** | 30.8ms | 99.6ms | 1.17ms
Day 12 | - | 908ms | 6.22ms | 2.63ms | 925ms | 241µs | -
Day 13 | - | 178µs | 2.08s | 6.79ms | 221ms | 15.7µs | -
Day 14 | - | 25.9s | 1.03s | 4.56s | 13.5ms | 21.8ms | -
Day 15 | - | 61.4ms | 1.29s | 761ms | 51.4ms | 526ms | -
Day 16 | - | 1.05s | 515ms | 20.1ms | 1.27s | 3.68ms | -
Day 17 | - | 118ms | 668ms | 91.6ms | 36ms | **🔴 1.26s** | -
Day 18 | - | 3.98s | 1.02s | 190ms | **🔴 42.5s** | 26.8ms | -
Day 19 | - | 737ms | 758µs | 275ms | 731ms | 36.7ms | -
Day 20 | - | 454µs | 1.57s | 33.8ms | 951ms | 18.8ms | -
Day 21 | - | 45.9s | 166ms | 953ms | 155ms | 4.82ms | -
Day 22 | - | 36.6ms | 1.08s | 4.67s | 453µs | 127ms | -
Day 23 | - | **🔴 2m18s** | 4.53ms | 378ms | - | **🔴 1.46s** | -
Day 24 | - | 97ms | **🔴 4.98s** | 223ms | 455ms | 241ms | -
Day 25 | - | 181ms | 1.52s | 19.1ms | - | 45.8ms | -
*Total* | *0s* | *4m28s* | *17.4s* | *42.3s* | *47.8s* | *3.93s* | *104ms*