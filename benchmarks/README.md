This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 26.4µs | 195µs | 52.4µs | 25.2ms | 10.2µs | 33.3ms | 46.8µs
Day 02 | 954µs | 16.3µs | 39µs | 13.2ms | 4.85ms | 1.27ms | 694µs
Day 03 | 862µs | 120µs | 42.7µs | 225ms | 75ms | 63.4µs | 139µs
Day 04 | 1.42s | 2.79ms | 3.36ms | 7.35ms | 160ms | 824µs | 396µs
Day 05 | 624µs | 5.92s | 167ms | 469ms | 2.93ms | 154µs | 1.6ms
Day 06 | 149ms | 240µs | 34.2ms | 65.7ms | 35.3ms | 2.62ms | 190µs
Day 07 | 442µs | 1.8ms | 4.35ms | 390µs | 8.61ms | 3.01ms | 109µs
Day 08 | 44.5µs | - | 916µs | 357ms | 366µs | 3.78ms | 821µs
Day 09 | 21.1ms | - | 197µs | 620ms | 102ms | 15.6ms | 1.09ms
Day 10 | 141ms | 7.94ms | 1.87ms | 2.14ms | 34.3ms | 125µs | 60.7µs
Day 11 | 66.7ms | 25.5s | 276µs | **🔴 19.5s** | 31.6ms | 98.3ms | 848µs
Day 12 | 117ms | 833ms | 6.04ms | 2.65ms | 935ms | 244µs | 848µs
Day 13 | 193ms | 176µs | 2.02s | 6.87ms | 210ms | 15.4µs | 440µs
Day 14 | 472µs | 26.5s | 114ms | 4.51s | 13.6ms | 22ms | 466µs
Day 15 | 127ms | 59.8ms | 1.25s | 809ms | 48.2ms | **🔴 1.25s** | **🔴 365ms**
Day 16 | 843µs | 35.3s | 482ms | 20.1ms | 1.24s | 3.6ms | 28.1µs
Day 17 | 96.9ms | 117ms | 659ms | 95.4ms | 36.5ms | **🔴 1.23s** | 2.52ms
Day 18 | 5.74ms | 4.07s | 1.02s | 178ms | **🔴 43.8s** | 27.9ms | -
Day 19 | 1.66ms | 735ms | 723µs | 268ms | 695ms | 33.4ms | -
Day 20 | **🔴 7.07s** | 462µs | 513ms | 34.9ms | 1.08s | 18.6ms | -
Day 21 | 960µs | 352ms | 149ms | 974ms | 168ms | 4.84ms | -
Day 22 | **🔴 3.11s** | 36.2ms | 1.06s | 4.57s | 556µs | 145ms | -
Day 23 | 56.1µs | **🔴 2m8s** | 4.26ms | 385ms | - | **🔴 1.4s** | -
Day 24 | 313ms | 94.5ms | **🔴 5s** | 219ms | 456ms | 244ms | -
Day 25 | 13.6µs | 179ms | 1.38s | 21ms | - | 46.1ms | -
*Total* | *12.8s* | *3m48s* | *13.9s* | *33.4s* | *49.2s* | *4.58s* | *375ms*


## rust
 &nbsp;  | 2015 | 2016 | 2017 | 2021
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 10.9µs | 85.2µs | 18.7µs | **🔴 40.6µs**
Day 02 | 119µs | 140µs | 21.3µs | 3.84µs
Day 03 | 943µs | 611µs | 20.6µs | -
Day 04 | 140ms | 3.01ms | 3.71ms | -
Day 05 | 304µs | 605ms | 5.37ms | -
Day 06 | 13.4ms | 1.95ms | 2.12ms | -
Day 07 | 411µs | 4.39ms | 1.03ms | -
Day 08 | 63.5µs | 30.2µs | 454µs | -
Day 09 | 9.32ms | 336µs | 82.9µs | -
Day 10 | 73.1ms | 314µs | 250µs | -
Day 11 | 10.5ms | 222ms | 161µs | -
Day 12 | 495µs | 85.1ms | 1.88ms | -
Day 13 | 18.6ms | 195µs | **🔴 82.4ms** | **🔴 29.8µs**
Day 14 | 1.21ms | **🔴 6.26s** | 30.9ms | -
Day 15 | 5.51ms | 14.3ms | **🔴 155ms** | -
Day 16 | 516µs | 14.1ms | 39ms | 11.7µs
Day 17 | 48ms | 35.8ms | 41.2ms | -
Day 18 | 26.7ms | 51.3ms | 15.9µs | -
Day 19 | 1.76ms | 77ns | - | -
Day 20 | **🔴 359ms** | 201µs | - | -
Day 21 | 48.6µs | 7.62ms | - | -
Day 22 | 46.5ms | 2.57ms | - | -
Day 23 | 13.7µs | **🔴 2.21s** | - | -
Day 24 | 8.35ms | 5.58ms | - | -
Day 25 | 650ns | 14.8ms | - | -
*Total* | *765ms* | *9.54s* | *364ms* | *86µs*

