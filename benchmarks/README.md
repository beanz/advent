This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 26.4µs | 195µs | 52.4µs | 25.2ms | 10.7µs | 33.3ms | 46.8µs
Day 02 | 954µs | 16.3µs | 39µs | 13.2ms | 4.67ms | 1.27ms | 694µs
Day 03 | 862µs | 120µs | 42.7µs | 225ms | 78.5ms | 63.4µs | 139µs
Day 04 | 1.42s | 2.79ms | 3.36ms | 7.35ms | 163ms | 824µs | 396µs
Day 05 | 624µs | 5.92s | 167ms | 469ms | 3.14ms | 154µs | 1.6ms
Day 06 | 149ms | 240µs | 34.2ms | 65.7ms | 36.1ms | 2.62ms | 190µs
Day 07 | 442µs | 1.8ms | 4.35ms | 390µs | 8.87ms | 3.01ms | 109µs
Day 08 | 44.5µs | - | 916µs | 357ms | 361µs | 3.78ms | 821µs
Day 09 | 21.1ms | - | 197µs | 620ms | 102ms | 15.6ms | 1.09ms
Day 10 | 141ms | 7.94ms | 1.87ms | 2.14ms | 34.9ms | 125µs | 60.7µs
Day 11 | 66.7ms | 25.5s | 276µs | **🔴 19.5s** | 32.1ms | 98.3ms | 848µs
Day 12 | 117ms | 833ms | 6.04ms | 2.65ms | 937ms | 244µs | 848µs
Day 13 | 193ms | 176µs | 2.02s | 6.87ms | 212ms | 15.4µs | 440µs
Day 14 | 472µs | 26.5s | 114ms | 4.51s | 16.8ms | 22ms | 466µs
Day 15 | 127ms | 59.8ms | 1.25s | 809ms | 50.5ms | **🔴 1.25s** | **🔴 365ms**
Day 16 | 843µs | 35.3s | 482ms | 20.1ms | 1.24s | 3.6ms | -
Day 17 | 96.9ms | 117ms | 659ms | 95.4ms | 37.2ms | **🔴 1.23s** | -
Day 18 | 5.74ms | 4.07s | 1.02s | 178ms | **🔴 43.3s** | 27.9ms | -
Day 19 | 1.66ms | 735ms | 723µs | 268ms | 688ms | 33.4ms | -
Day 20 | **🔴 7.07s** | 462µs | 513ms | 34.9ms | 1.16s | 18.6ms | -
Day 21 | 960µs | 352ms | 149ms | 974ms | 225ms | 4.84ms | -
Day 22 | **🔴 3.11s** | 36.2ms | 1.06s | 4.57s | 484µs | 145ms | -
Day 23 | 56.1µs | **🔴 2m8s** | 4.26ms | 385ms | - | **🔴 1.4s** | -
Day 24 | 313ms | 94.5ms | **🔴 5s** | 219ms | 467ms | 244ms | -
Day 25 | 13.6µs | 179ms | 1.38s | 21ms | - | 46.1ms | -
*Total* | *12.8s* | *3m48s* | *13.9s* | *33.4s* | *48.8s* | *4.58s* | *373ms*


## rust
 &nbsp;  | 2015 | 2016 | 2017 | 2021
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 18µs | - | - | **🔴 42µs**
Day 02 | 122µs | - | - | 3µs
Day 03 | 908µs | - | - | -
Day 04 | **🔴 1.42s** | - | - | -
Day 05 | 309µs | - | - | -
Day 06 | 134ms | - | - | -
Day 07 | 417µs | - | - | -
Day 08 | 64µs | - | - | -
Day 09 | 9.18ms | - | - | -
Day 10 | 732ms | - | - | -
Day 11 | 98.6ms | - | - | -
Day 12 | 504µs | - | - | -
Day 13 | 187ms | - | - | **🔴 37µs**
Day 14 | 1.21ms | - | - | -
Day 15 | 54.6ms | - | - | -
Day 16 | 498µs | - | - | -
Day 17 | 46.7ms | - | - | -
Day 18 | 26.8ms | - | - | -
Day 19 | 1.91ms | - | - | -
Day 20 | **🔴 3.48s** | - | - | -
Day 21 | 52µs | - | - | -
Day 22 | 461ms | - | - | -
Day 23 | 13µs | - | - | -
Day 24 | 8.57ms | - | - | -
Day 25 | 0s | - | - | -
*Total* | *6.66s* | *0s* | *0s* | *82µs*

