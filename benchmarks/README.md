This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## C++
 &nbsp;  | 2019
 ---:  | ---: 
Day 01 | 2.48µs
Day 02 | 1.18ms
Day 03 | 50.1ms
Day 04 | 4.02ms
Day 05 | 60µs
Day 06 | 5.53µs
Day 07 | 8.88ms
Day 08 | 42.5µs
Day 09 | 106ms
Day 10 | 39ms
Day 11 | 26.8ms
Day 12 | 531ms
Day 13 | 205ms
Day 14 | 8.97ms
Day 15 | 46.4ms
Day 16 | 284ms
Day 17 | 32ms
Day 18 | **🔴 2.71s**
Day 19 | 696ms
Day 20 | 501ms
Day 21 | 162ms
Day 22 | 4.55µs
Day 23 | 97ms
Day 24 | 64.3ms
Day 25 | **🔴 1.54s**
*Total* | *7.12s*


## Crystal
 &nbsp;  | 2019 | 2020
 ---:  | ---:  | ---: 
Day 01 | 23.5µs | 469µs
Day 02 | 11.4ms | 879µs
Day 03 | 45ms | 637µs
Day 04 | 72.6ms | 1.53ms
Day 05 | 123µs | 1.49ms
Day 06 | 8.66ms | 3.65ms
Day 07 | 16.2ms | 1.62ms
Day 08 | 485µs | 1.15ms
Day 09 | 119ms | 388µs
Day 10 | 19.5ms | 23.7µs
Day 11 | 30.1ms | 90.9ms
Day 12 | 308ms | 133µs
Day 13 | 267ms | 162µs
Day 14 | 16ms | 6.47ms
Day 15 | 59.5ms | 731ms
Day 16 | 694ms | 1.32ms
Day 17 | 25.2ms | 298ms
Day 18 | **🔴 21.1s** | 1.27ms
Day 19 | 553ms | 8.46ms
Day 20 | 425ms | 13.6ms
Day 21 | 132ms | 1.85ms
Day 22 | 190µs | 238ms
Day 23 | 81.3ms | 1.51s
Day 24 | 97.5ms | **🔴 12.5s**
Day 25 | 2.52s | 48.1ms
*Total* | *26.6s* | *15.5s*


## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 26.4µs | 195µs | 52.4µs | 25.2ms | 11.1µs | 33.3ms | 47µs
Day 02 | 954µs | 16.3µs | 39µs | 13.2ms | 5.14ms | 1.27ms | 1.96µs
Day 03 | 862µs | 120µs | 42.7µs | 225ms | 22.2ms | 63.4µs | 52.6µs
Day 04 | 1.42s | 2.79ms | 3.36ms | 7.35ms | 3.09ms | 824µs | 114µs
Day 05 | 624µs | **🔴 5.92s** | 167ms | 469ms | 58.9µs | 154µs | 1.6ms
Day 06 | 149ms | 240µs | 34.2ms | 65.7ms | 38.2ms | 2.91ms | 2.1µs
Day 07 | 442µs | 1.8ms | 4.35ms | 390µs | 4.65ms | 3.12ms | 109µs
Day 08 | 44.5µs | 8.25µs | 916µs | 357ms | 361µs | 3.78ms | 336µs
Day 09 | 21.1ms | 25.5µs | 197µs | 620ms | 15.6ms | 15.6ms | 1.1ms
Day 10 | 141ms | 7.94ms | 1.87ms | 2.14ms | 35.3ms | 125µs | 60.7µs
Day 11 | 66.7ms | 53ms | 276µs | 91.7ms | 8.19ms | 98.3ms | 837µs
Day 12 | 117ms | 7.43µs | 6.04ms | 2.65ms | 19.5ms | 244µs | 848µs
Day 13 | 193ms | 176µs | 123ms | 6.87ms | 41.5ms | 15.4µs | 413µs
Day 14 | 472µs | **🔴 12.5s** | 114ms | 545ms | 14.1ms | 22ms | 430µs
Day 15 | 127ms | 59.8ms | **🔴 1.25s** | 809ms | 22.6ms | **🔴 1.25s** | 60.4ms
Day 16 | 843µs | 436ms | 482ms | 20.1ms | **🔴 680ms** | 3.6ms | 30.6µs
Day 17 | 96.9ms | 117ms | 659ms | 95.4ms | 5.97ms | **🔴 1.23s** | 2.5ms
Day 18 | 5.74ms | 265ms | 11.5ms | 178ms | **🔴 865ms** | 27.9ms | 61.6ms
Day 19 | 1.66ms | 735ms | 723µs | 268ms | 180ms | 33.4ms | **🔴 1.24s**
Day 20 | **🔴 7.07s** | 462µs | 513ms | 34.9ms | 77.1ms | 18.6ms | 32ms
Day 21 | 960µs | 352ms | 149ms | 974ms | 25.7ms | 4.84ms | 2.73ms
Day 22 | **🔴 3.11s** | 36.2ms | 100ms | **🔴 4.57s** | 474µs | 145ms | 14.3ms
Day 23 | 56.1µs | 18.7µs | 4.26ms | 385ms | 18.6ms | **🔴 1.4s** | **🔴 581ms**
Day 24 | 313ms | 94.5ms | 266ms | 219ms | 489ms | 244ms | 5.31µs
Day 25 | 13.6µs | 179ms | 66.2ms | 21ms | 293ms | 46.1ms | 56.8ms
*Total* | *12.8s* | *20.7s* | *3.96s* | *10s* | *2.87s* | *4.58s* | *2.05s*


## Nim
 &nbsp;  | 2019 | 2020
 ---:  | ---:  | ---: 
Day 01 | 15.7µs | 522µs
Day 02 | 9.3ms | 730µs
Day 03 | 31.9ms | 122µs
Day 04 | 86.2ms | 15.8ms
Day 05 | 87.5µs | 316µs
Day 06 | 91.4ms | 1.76ms
Day 07 | 7.67ms | 2.46ms
Day 08 | 29.1µs | 1.19ms
Day 09 | 13.8ms | 1.59ms
Day 10 | 29.7ms | 28.4µs
Day 11 | 5.01ms | 36.5ms
Day 12 | 435ms | 113µs
Day 13 | 30.6ms | 24.9µs
Day 14 | 7.99ms | 12.1ms
Day 15 | 30.2ms | **🔴 837ms**
Day 16 | 689ms | 1.57ms
Day 17 | 4.1ms | 113ms
Day 18 | **🔴 1m8s** | 1.2ms
Day 19 | 115ms | 212ms
Day 20 | 867ms | 5.44ms
Day 21 | 20.8ms | 2.3ms
Day 22 | 48.1µs | 324ms
Day 23 | 15.7ms | **🔴 1.1s**
Day 24 | 51.7ms | 181ms
Day 25 | 202ms | 48.7ms
*Total* | *1m10.8s* | *2.9s*


## Rust
 &nbsp;  | 2015 | 2016 | 2017 | 2021
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 10.9µs | 85.2µs | 18.7µs | 40.6µs
Day 02 | 119µs | 140µs | 21.3µs | 3.84µs
Day 03 | 943µs | 611µs | 20.6µs | 43.8µs
Day 04 | **🔴 1.4s** | 3.01ms | 3.71ms | 125µs
Day 05 | 304µs | 6.05s | 53.7ms | 1.05ms
Day 06 | 134ms | 1.95ms | 2.12ms | 1.41µs
Day 07 | 411µs | 4.39ms | 1.03ms | 34.1µs
Day 08 | 63.5µs | 30.2µs | 454µs | 174µs
Day 09 | 9.32ms | 336µs | 82.9µs | 287µs
Day 10 | 731ms | 314µs | 250µs | 50µs
Day 11 | 105ms | 2.22s | 161µs | -
Day 12 | 495µs | 3.39µs | 1.88ms | -
Day 13 | 186ms | 195µs | **🔴 824ms** | 508µs
Day 14 | 1.21ms | **🔴 1m2.6s** | 30.9ms | -
Day 15 | 55.1ms | 14.3ms | **🔴 1.55s** | -
Day 16 | 516µs | 141ms | 39ms | 11.7µs
Day 17 | 48ms | 35.8ms | 412ms | -
Day 18 | 26.7ms | 513ms | 1.52ms | 46.7ms
Day 19 | 1.76ms | 77ns | - | 23.3ms
Day 20 | **🔴 3.59s** | 201µs | - | -
Day 21 | 48.6µs | 76.2ms | - | 2.04µs
Day 22 | 465ms | 25.7ms | - | -
Day 23 | 13.7µs | 8.58µs | - | -
Day 24 | 8.35ms | 5.58ms | - | **🔴 31.3s**
Day 25 | 650ns | 15.4ms | - | -
*Total* | *6.76s* | *1m11.7s* | *2.92s* | *31.3s*


## Zig
 &nbsp;  | 2020 | 2021
 ---:  | ---:  | ---: 
Day 01 | 546µs | 10.5µs
Day 02 | 161µs | 1.32µs
Day 03 | 29.2µs | 162µs
Day 04 | 2.36ms | 54µs
Day 05 | 234µs | 1.02ms
Day 06 | 11.4ms | 1.06µs
Day 07 | 941µs | 47.5µs
Day 08 | 5.87ms | 1.9ms
Day 09 | 329µs | 360µs
Day 10 | 46.5µs | 46.6µs
Day 11 | 40.2ms | 206µs
Day 12 | 2.07ms | 204µs
Day 13 | 16.4µs | 354µs
Day 14 | 8.4ms | 146µs
Day 15 | 805ms | **🔴 139ms**
Day 16 | 1.59ms | -
Day 17 | 11.9ms | -
Day 18 | 10.6ms | -
Day 19 | 17.9ms | -
Day 20 | 13.5ms | -
Day 21 | 3.69ms | 628µs
Day 22 | 148ms | -
Day 23 | **🔴 6.43s** | -
Day 24 | 107ms | -
Day 25 | 41.6ms | -
*Total* | *7.67s* | *144ms*


## 2015
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 26.4µs | 10.9µs
Day 02 | 954µs | 119µs
Day 03 | 862µs | 943µs
Day 04 | 1.42s | **🔴 1.4s**
Day 05 | 624µs | 304µs
Day 06 | 149ms | 134ms
Day 07 | 442µs | 411µs
Day 08 | 44.5µs | 63.5µs
Day 09 | 21.1ms | 9.32ms
Day 10 | 141ms | 731ms
Day 11 | 66.7ms | 105ms
Day 12 | 117ms | 495µs
Day 13 | 193ms | 186ms
Day 14 | 472µs | 1.21ms
Day 15 | 127ms | 55.1ms
Day 16 | 843µs | 516µs
Day 17 | 96.9ms | 48ms
Day 18 | 5.74ms | 26.7ms
Day 19 | 1.66ms | 1.76ms
Day 20 | **🔴 7.07s** | **🔴 3.59s**
Day 21 | 960µs | 48.6µs
Day 22 | **🔴 3.11s** | 465ms
Day 23 | 56.1µs | 13.7µs
Day 24 | 313ms | 8.35ms
Day 25 | 13.6µs | 650ns
*Total* | *12.8s* | *6.76s*

![Graph for year 2015](y2015.svg)

## 2016
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 195µs | 85.2µs
Day 02 | 16.3µs | 140µs
Day 03 | 120µs | 611µs
Day 04 | 2.79ms | 3.01ms
Day 05 | **🔴 5.92s** | 6.05s
Day 06 | 240µs | 1.95ms
Day 07 | 1.8ms | 4.39ms
Day 08 | 8.25µs | 30.2µs
Day 09 | 25.5µs | 336µs
Day 10 | 7.94ms | 314µs
Day 11 | 53ms | 2.22s
Day 12 | 7.43µs | 3.39µs
Day 13 | 176µs | 195µs
Day 14 | **🔴 12.5s** | **🔴 1m2.6s**
Day 15 | 59.8ms | 14.3ms
Day 16 | 436ms | 141ms
Day 17 | 117ms | 35.8ms
Day 18 | 265ms | 513ms
Day 19 | 735ms | 77ns
Day 20 | 462µs | 201µs
Day 21 | 352ms | 76.2ms
Day 22 | 36.2ms | 25.7ms
Day 23 | 18.7µs | 8.58µs
Day 24 | 94.5ms | 5.58ms
Day 25 | 179ms | 15.4ms
*Total* | *20.7s* | *1m11.7s*

![Graph for year 2016](y2016.svg)

## 2017
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 52.4µs | 18.7µs
Day 02 | 39µs | 21.3µs
Day 03 | 42.7µs | 20.6µs
Day 04 | 3.36ms | 3.71ms
Day 05 | 167ms | 53.7ms
Day 06 | 34.2ms | 2.12ms
Day 07 | 4.35ms | 1.03ms
Day 08 | 916µs | 454µs
Day 09 | 197µs | 82.9µs
Day 10 | 1.87ms | 250µs
Day 11 | 276µs | 161µs
Day 12 | 6.04ms | 1.88ms
Day 13 | 123ms | **🔴 824ms**
Day 14 | 114ms | 30.9ms
Day 15 | **🔴 1.25s** | **🔴 1.55s**
Day 16 | 482ms | 39ms
Day 17 | 659ms | 412ms
Day 18 | 11.5ms | 1.52ms
Day 19 | 723µs | -
Day 20 | 513ms | -
Day 21 | 149ms | -
Day 22 | 100ms | -
Day 23 | 4.26ms | -
Day 24 | 266ms | -
Day 25 | 66.2ms | -
*Total* | *3.96s* | *2.92s*

![Graph for year 2017](y2017.svg)

## 2018
 &nbsp;  | Golang
 ---:  | ---: 
Day 01 | 25.2ms
Day 02 | 13.2ms
Day 03 | 225ms
Day 04 | 7.35ms
Day 05 | 469ms
Day 06 | 65.7ms
Day 07 | 390µs
Day 08 | 357ms
Day 09 | 620ms
Day 10 | 2.14ms
Day 11 | 91.7ms
Day 12 | 2.65ms
Day 13 | 6.87ms
Day 14 | 545ms
Day 15 | 809ms
Day 16 | 20.1ms
Day 17 | 95.4ms
Day 18 | 178ms
Day 19 | 268ms
Day 20 | 34.9ms
Day 21 | 974ms
Day 22 | **🔴 4.57s**
Day 23 | 385ms
Day 24 | 219ms
Day 25 | 21ms
*Total* | *10s*

![Graph for year 2018](y2018.svg)

## 2019
 &nbsp;  | C++ | Crystal | Golang | Nim
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 2.48µs | 23.5µs | 11.1µs | 15.7µs
Day 02 | 1.18ms | 11.4ms | 5.14ms | 9.3ms
Day 03 | 50.1ms | 45ms | 22.2ms | 31.9ms
Day 04 | 4.02ms | 72.6ms | 3.09ms | 86.2ms
Day 05 | 60µs | 123µs | 58.9µs | 87.5µs
Day 06 | 5.53µs | 8.66ms | 38.2ms | 91.4ms
Day 07 | 8.88ms | 16.2ms | 4.65ms | 7.67ms
Day 08 | 42.5µs | 485µs | 361µs | 29.1µs
Day 09 | 106ms | 119ms | 15.6ms | 13.8ms
Day 10 | 39ms | 19.5ms | 35.3ms | 29.7ms
Day 11 | 26.8ms | 30.1ms | 8.19ms | 5.01ms
Day 12 | 531ms | 308ms | 19.5ms | 435ms
Day 13 | 205ms | 267ms | 41.5ms | 30.6ms
Day 14 | 8.97ms | 16ms | 14.1ms | 7.99ms
Day 15 | 46.4ms | 59.5ms | 22.6ms | 30.2ms
Day 16 | 284ms | 694ms | **🔴 680ms** | 689ms
Day 17 | 32ms | 25.2ms | 5.97ms | 4.1ms
Day 18 | **🔴 2.71s** | **🔴 21.1s** | **🔴 865ms** | **🔴 1m8s**
Day 19 | 696ms | 553ms | 180ms | 115ms
Day 20 | 501ms | 425ms | 77.1ms | 867ms
Day 21 | 162ms | 132ms | 25.7ms | 20.8ms
Day 22 | 4.55µs | 190µs | 474µs | 48.1µs
Day 23 | 97ms | 81.3ms | 18.6ms | 15.7ms
Day 24 | 64.3ms | 97.5ms | 489ms | 51.7ms
Day 25 | **🔴 1.54s** | 2.52s | 293ms | 202ms
*Total* | *7.12s* | *26.6s* | *2.87s* | *1m10.8s*

![Graph for year 2019](y2019.svg)

## 2020
 &nbsp;  | Crystal | Golang | Nim | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 469µs | 33.3ms | 522µs | 546µs
Day 02 | 879µs | 1.27ms | 730µs | 161µs
Day 03 | 637µs | 63.4µs | 122µs | 29.2µs
Day 04 | 1.53ms | 824µs | 15.8ms | 2.36ms
Day 05 | 1.49ms | 154µs | 316µs | 234µs
Day 06 | 3.65ms | 2.91ms | 1.76ms | 11.4ms
Day 07 | 1.62ms | 3.12ms | 2.46ms | 941µs
Day 08 | 1.15ms | 3.78ms | 1.19ms | 5.87ms
Day 09 | 388µs | 15.6ms | 1.59ms | 329µs
Day 10 | 23.7µs | 125µs | 28.4µs | 46.5µs
Day 11 | 90.9ms | 98.3ms | 36.5ms | 40.2ms
Day 12 | 133µs | 244µs | 113µs | 2.07ms
Day 13 | 162µs | 15.4µs | 24.9µs | 16.4µs
Day 14 | 6.47ms | 22ms | 12.1ms | 8.4ms
Day 15 | 731ms | **🔴 1.25s** | **🔴 837ms** | 805ms
Day 16 | 1.32ms | 3.6ms | 1.57ms | 1.59ms
Day 17 | 298ms | **🔴 1.23s** | 113ms | 11.9ms
Day 18 | 1.27ms | 27.9ms | 1.2ms | 10.6ms
Day 19 | 8.46ms | 33.4ms | 212ms | 17.9ms
Day 20 | 13.6ms | 18.6ms | 5.44ms | 13.5ms
Day 21 | 1.85ms | 4.84ms | 2.3ms | 3.69ms
Day 22 | 238ms | 145ms | 324ms | 148ms
Day 23 | 1.51s | **🔴 1.4s** | **🔴 1.1s** | **🔴 6.43s**
Day 24 | **🔴 12.5s** | 244ms | 181ms | 107ms
Day 25 | 48.1ms | 46.1ms | 48.7ms | 41.6ms
*Total* | *15.5s* | *4.58s* | *2.9s* | *7.67s*

![Graph for year 2020](y2020.svg)

## 2021
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 47µs | 40.6µs | 10.5µs
Day 02 | 1.96µs | 3.84µs | 1.32µs
Day 03 | 52.6µs | 43.8µs | 162µs
Day 04 | 114µs | 125µs | 54µs
Day 05 | 1.6ms | 1.05ms | 1.02ms
Day 06 | 2.1µs | 1.41µs | 1.06µs
Day 07 | 109µs | 34.1µs | 47.5µs
Day 08 | 336µs | 174µs | 1.9ms
Day 09 | 1.1ms | 287µs | 360µs
Day 10 | 60.7µs | 50µs | 46.6µs
Day 11 | 837µs | - | 206µs
Day 12 | 848µs | - | 204µs
Day 13 | 413µs | 508µs | 354µs
Day 14 | 430µs | - | 146µs
Day 15 | 60.4ms | - | **🔴 139ms**
Day 16 | 30.6µs | 11.7µs | -
Day 17 | 2.5ms | - | -
Day 18 | 61.6ms | 46.7ms | -
Day 19 | **🔴 1.24s** | 23.3ms | -
Day 20 | 32ms | - | -
Day 21 | 2.73ms | 2.04µs | 628µs
Day 22 | 14.3ms | - | -
Day 23 | **🔴 581ms** | - | -
Day 24 | 5.31µs | **🔴 31.3s** | -
Day 25 | 56.8ms | - | -
*Total* | *2.05s* | *31.3s* | *144ms*

![Graph for year 2021](y2021.svg)
