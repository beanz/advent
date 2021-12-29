This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 26.4µs | 195µs | 52.4µs | 25.2ms | 11.1µs | 33.3ms | 46.8µs
Day 02 | 954µs | 16.3µs | 39µs | 13.2ms | 5.14ms | 1.27ms | 694µs
Day 03 | 862µs | 120µs | 42.7µs | 225ms | 22.2ms | 63.4µs | 139µs
Day 04 | 1.42s | 2.79ms | 3.36ms | 7.35ms | 3.09ms | 824µs | 396µs
Day 05 | 624µs | 5.92s | 167ms | 469ms | 58.9µs | 154µs | 1.6ms
Day 06 | 149ms | 240µs | 34.2ms | 65.7ms | 38.2ms | 2.62ms | 190µs
Day 07 | 442µs | 1.8ms | 4.35ms | 390µs | 4.65ms | 3.01ms | 109µs
Day 08 | 44.5µs | 8.25µs | 916µs | 357ms | 361µs | 3.78ms | 821µs
Day 09 | 21.1ms | 25.5µs | 197µs | 620ms | 15.6ms | 15.6ms | 1.09ms
Day 10 | 141ms | 7.94ms | 1.87ms | 2.14ms | 35.3ms | 125µs | 60.7µs
Day 11 | 66.7ms | 67.8ms | 276µs | 90.6ms | 8.19ms | 98.3ms | 848µs
Day 12 | 117ms | 144ms | 6.04ms | 2.65ms | 32.6ms | 244µs | 848µs
Day 13 | 193ms | 176µs | 2.02s | 6.87ms | 41.5ms | 15.4µs | 440µs
Day 14 | 472µs | **🔴 12.5s** | 114ms | 545ms | 14.1ms | 22ms | 466µs
Day 15 | 127ms | 59.8ms | 1.25s | 809ms | 22.6ms | **🔴 1.25s** | 365ms
Day 16 | 843µs | 436ms | 482ms | 20.1ms | **🔴 680ms** | 3.6ms | 28.1µs
Day 17 | 96.9ms | 117ms | 659ms | 95.4ms | 5.97ms | **🔴 1.23s** | 2.6ms
Day 18 | 5.74ms | 265ms | 1.02s | 178ms | **🔴 881ms** | 27.9ms | 61.9ms
Day 19 | 1.66ms | 735ms | 723µs | 268ms | 180ms | 33.4ms | **🔴 1.24s**
Day 20 | **🔴 7.07s** | 462µs | 513ms | 34.9ms | 77.1ms | 18.6ms | 33.2ms
Day 21 | 960µs | 352ms | 149ms | 974ms | 25.7ms | 4.84ms | 2.73ms
Day 22 | **🔴 3.11s** | 36.2ms | 1.06s | **🔴 4.57s** | 474µs | 145ms | 14.5ms
Day 23 | 56.1µs | **🔴 16s** | 4.26ms | 385ms | 18.6ms | **🔴 1.4s** | **🔴 1.85s**
Day 24 | 313ms | 94.5ms | **🔴 5s** | 219ms | 489ms | 244ms | 5.61µs
Day 25 | 13.6µs | 179ms | 1.38s | 21ms | 293ms | 46.1ms | 491ms
*Total* | *12.8s* | *36.9s* | *13.9s* | *10s* | *2.89s* | *4.58s* | *4.07s*


## rust
 &nbsp;  | 2015 | 2016 | 2017 | 2021
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 10.9µs | 85.2µs | 18.7µs | 40.6µs
Day 02 | 119µs | 140µs | 21.3µs | 3.84µs
Day 03 | 943µs | 611µs | 20.6µs | 43.8µs
Day 04 | 140ms | 3.01ms | 3.71ms | 128µs
Day 05 | 304µs | 605ms | 5.37ms | 1.05ms
Day 06 | 13.4ms | 1.95ms | 2.12ms | 1.41µs
Day 07 | 411µs | 4.39ms | 1.03ms | -
Day 08 | 63.5µs | 30.2µs | 454µs | -
Day 09 | 9.32ms | 336µs | 82.9µs | -
Day 10 | 73.1ms | 314µs | 250µs | -
Day 11 | 10.5ms | 222ms | 161µs | -
Day 12 | 495µs | 85.1ms | 1.88ms | -
Day 13 | 18.6ms | 195µs | **🔴 82.4ms** | 29.8µs
Day 14 | 1.21ms | **🔴 6.26s** | 30.9ms | -
Day 15 | 5.51ms | 14.3ms | **🔴 155ms** | -
Day 16 | 516µs | 14.1ms | 39ms | 11.7µs
Day 17 | 48ms | 35.8ms | 41.2ms | -
Day 18 | 26.7ms | 51.3ms | 1.52ms | **🔴 46.7ms**
Day 19 | 1.76ms | 77ns | - | **🔴 23.3ms**
Day 20 | **🔴 359ms** | 201µs | - | -
Day 21 | 48.6µs | 7.62ms | - | -
Day 22 | 46.5ms | 2.57ms | - | -
Day 23 | 13.7µs | **🔴 2.21s** | - | -
Day 24 | 8.35ms | 5.58ms | - | -
Day 25 | 650ns | 14.8ms | - | -
*Total* | *765ms* | *9.54s* | *366ms* | *71.3ms*

