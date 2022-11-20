This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## C++
 &nbsp;  | 2019
 ---:  | ---: 
Day 01 | 2.48µs
Day 02 | 1.18ms
Day 03 | 49.5ms
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
Day 14 | 6.69ms
Day 15 | 46.4ms
Day 16 | 284ms
Day 17 | 32ms
Day 18 | **🔴 2.41s**
Day 19 | 696ms
Day 20 | 501ms
Day 21 | 162ms
Day 22 | 4.55µs
Day 23 | 97ms
Day 24 | 64.3ms
Day 25 | **🔴 1.54s**
*Total* | *6.82s*


## Crystal
 &nbsp;  | 2015 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 61.9µs** | 20µs | 415µs | **🔴 385µs**
Day 02 | - | 11.4ms | 755µs | 110µs
Day 03 | - | 45ms | 637µs | **🔴 239µs**
Day 04 | - | 72.6ms | 1.29ms | -
Day 05 | - | 123µs | 1.06ms | -
Day 06 | - | 8.66ms | 3.28ms | -
Day 07 | - | 16.2ms | 1.62ms | -
Day 08 | - | 485µs | 1.15ms | -
Day 09 | - | 119ms | 293µs | -
Day 10 | - | 19.5ms | 23.7µs | -
Day 11 | - | 30.1ms | 80.2ms | -
Day 12 | - | 308ms | 110µs | -
Day 13 | - | 267ms | 162µs | -
Day 14 | - | 16ms | 6.47ms | -
Day 15 | - | 34ms | 731ms | -
Day 16 | - | 694ms | 1.32ms | -
Day 17 | - | 25.2ms | 298ms | -
Day 18 | - | **🔴 21.1s** | 1.27ms | -
Day 19 | - | 553ms | 7.69ms | -
Day 20 | - | 482ms | 13.6ms | -
Day 21 | - | 132ms | 1.85ms | -
Day 22 | - | 190µs | 238ms | -
Day 23 | - | 81.3ms | 1.51s | -
Day 24 | - | 97.5ms | **🔴 13.9s** | -
Day 25 | - | 2.52s | 48.1ms | -
*Total* | *61.9µs* | *26.7s* | *16.8s* | *734µs*


## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 29.1µs | 130µs | 39.5µs | 19.5ms | 6.72µs | 21.9ms | 29.1µs
Day 02 | 769µs | 17.9µs | 31.6µs | 9.68ms | 2.57ms | 836µs | 1.4µs
Day 03 | 754µs | 73.7µs | 32µs | 198ms | 19.8ms | 43.8µs | 49.9µs
Day 04 | 1.39s | 2.18ms | 2.63ms | 6.53ms | 2.34ms | 602µs | 74.9µs
Day 05 | 533µs | **🔴 5.83s** | 152ms | 448ms | 33µs | 123µs | 1.1ms
Day 06 | 133ms | 248µs | 24.6ms | 57.8ms | 30.5ms | 1.82ms | 2.2µs
Day 07 | 320µs | 1.47ms | 3.19ms | 300µs | 2.75ms | 2.03ms | 97.6µs
Day 08 | 32.3µs | 6.43µs | 688µs | 236ms | 278µs | 2.53ms | 237µs
Day 09 | 14.8ms | 21.8µs | 182µs | 436ms | 14.2ms | 11.3ms | 903µs
Day 10 | 120ms | 5.31ms | 1.75ms | 1.35ms | 30.5ms | 78.2µs | 61.3µs
Day 11 | 51.1ms | 46.1ms | 253µs | 71ms | 6.9ms | 79.3ms | 730µs
Day 12 | 79.6ms | 4.46µs | 4.26ms | 1.52ms | 15.8ms | 184µs | 975µs
Day 13 | 150ms | 123µs | 117ms | 4.3ms | 34.8ms | 10.6µs | 350µs
Day 14 | 310µs | **🔴 12.8s** | 99.8ms | 483ms | 11.6ms | 16.7ms | 346µs
Day 15 | 103ms | 53.5ms | **🔴 1.15s** | 641ms | 12.7ms | 738ms | 54.1ms
Day 16 | 537µs | 412ms | 349ms | 13.9ms | **🔴 607ms** | 2.22ms | 25.5µs
Day 17 | 90.5ms | 71ms | **🔴 700ms** | 82.1ms | 5.13ms | **🔴 849ms** | 2.5ms
Day 18 | 6.12ms | 252ms | 12.8ms | 117ms | **🔴 864ms** | 20.8ms | 50.9ms
Day 19 | - | 558ms | 545µs | 250ms | 105ms | 28.6ms | **🔴 973ms**
Day 20 | **🔴 6.41s** | 343µs | 371ms | 25.6ms | 50.2ms | - | 28ms
Day 21 | 637µs | 265ms | 113ms | 628ms | 23ms | 3.8ms | 2.02ms
Day 22 | **🔴 2.64s** | 32.3ms | 99.8ms | **🔴 6.74s** | 337µs | 94.2ms | 9.54ms
Day 23 | 47.9µs | 10.6µs | 3.62ms | 333ms | 15.2ms | **🔴 1.67s** | **🔴 505ms**
Day 24 | 237ms | 65.6ms | 236ms | 180ms | 297ms | 207ms | 3.85µs
Day 25 | 7.88µs | 149ms | 55.7ms | 15.4ms | 214ms | 48.5ms | 52.1ms
*Total* | *11.4s* | *20.5s* | *3.49s* | *11s* | *2.37s* | *3.8s* | *1.68s*


## Haskell
 &nbsp;  | 2021
 ---:  | ---: 
Day 01 | **🔴 2.58ms**
Day 02 | **🔴 2.78ms**
Day 03 | **🔴 3.73ms**
Day 04 | 160µs
Day 05 | -
Day 06 | -
Day 07 | -
Day 08 | -
Day 09 | -
Day 10 | -
Day 11 | -
Day 12 | -
Day 13 | -
Day 14 | -
Day 15 | -
Day 16 | -
Day 17 | -
Day 18 | -
Day 19 | -
Day 20 | -
Day 21 | -
Day 22 | -
Day 23 | -
Day 24 | -
Day 25 | -
*Total* | *9.25ms*


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
Day 01 | 4.66µs | 79.3µs | 2.87µs | 30.3µs
Day 02 | 101µs | 143µs | 17µs | 4.07µs
Day 03 | 917µs | 382µs | 20.6µs | 42.4µs
Day 04 | **🔴 1.55s** | 2.88ms | 3.35ms | 124µs
Day 05 | 392µs | 6.57s | 55.3ms | 1.01ms
Day 06 | 56.1ms | 1.45ms | 2.22ms | 1.42µs
Day 07 | 359µs | 4.41ms | 1.03ms | 34.3µs
Day 08 | 66.6µs | 21.1µs | 352µs | 172µs
Day 09 | 8.63ms | 266µs | 102µs | 254µs
Day 10 | 777ms | 267µs | 198µs | 80µs
Day 11 | 76.2ms | 1.95s | 169µs | 363µs
Day 12 | 544µs | 3.45µs | 1.6ms | -
Day 13 | 175ms | 182µs | **🔴 732ms** | 513µs
Day 14 | 830µs | **🔴 56.1s** | 28.6ms | -
Day 15 | 52.9ms | 9.46ms | **🔴 1.62s** | -
Day 16 | 483µs | 159ms | 29.5ms | 12.2µs
Day 17 | 49.4ms | 37.7ms | 485ms | -
Day 18 | 26.7ms | 503ms | 927µs | 44.4ms
Day 19 | 1.73ms | 68ns | - | 23.7ms
Day 20 | **🔴 2.99s** | 158µs | - | -
Day 21 | 42.3µs | 51.9ms | - | 1.67µs
Day 22 | 733ms | 23.9ms | - | -
Day 23 | 9.52µs | 7.71µs | - | -
Day 24 | 8.18ms | 5.89ms | - | **🔴 22.6s**
Day 25 | 510ns | 11.8ms | - | -
*Total* | *6.51s* | *1m5.4s* | *2.96s* | *22.7s*


## Zig
 &nbsp;  | 2020 | 2021
 ---:  | ---:  | ---: 
Day 01 | 588µs | 15.4µs
Day 02 | 181µs | 1.09µs
Day 03 | 26.6µs | 79.6µs
Day 04 | 3.01ms | 55.7µs
Day 05 | 263µs | 1.13ms
Day 06 | 13.8ms | 1.11µs
Day 07 | 1.32ms | 57.1µs
Day 08 | 7.49ms | 2ms
Day 09 | 259µs | 287µs
Day 10 | 52.1µs | 54.8µs
Day 11 | 38.7ms | 220µs
Day 12 | 2.4ms | 252µs
Day 13 | 18µs | 406µs
Day 14 | 9.51ms | 134µs
Day 15 | 909ms | **🔴 23ms**
Day 16 | 1.94ms | 534µs
Day 17 | **🔴 2m39s** | 1.77ms
Day 18 | 12.1ms | **🔴 17.4ms**
Day 19 | - | -
Day 20 | 17.7ms | -
Day 21 | 4.29ms | 430µs
Day 22 | 200ms | -
Day 23 | 7.59s | -
Day 24 | 127ms | -
Day 25 | 43.6ms | -
*Total* | *2m48s* | *47.8ms*


## 2015
 &nbsp;  | Crystal | Golang | Rust
 ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 61.9µs** | 29.1µs | 4.66µs
Day 02 | - | 769µs | 101µs
Day 03 | - | 754µs | 917µs
Day 04 | - | 1.39s | **🔴 1.55s**
Day 05 | - | 533µs | 392µs
Day 06 | - | 133ms | 56.1ms
Day 07 | - | 320µs | 359µs
Day 08 | - | 32.3µs | 66.6µs
Day 09 | - | 14.8ms | 8.63ms
Day 10 | - | 120ms | 777ms
Day 11 | - | 51.1ms | 76.2ms
Day 12 | - | 79.6ms | 544µs
Day 13 | - | 150ms | 175ms
Day 14 | - | 310µs | 830µs
Day 15 | - | 103ms | 52.9ms
Day 16 | - | 537µs | 483µs
Day 17 | - | 90.5ms | 49.4ms
Day 18 | - | 6.12ms | 26.7ms
Day 19 | - | - | 1.73ms
Day 20 | - | **🔴 6.41s** | **🔴 2.99s**
Day 21 | - | 637µs | 42.3µs
Day 22 | - | **🔴 2.64s** | 733ms
Day 23 | - | 47.9µs | 9.52µs
Day 24 | - | 237ms | 8.18ms
Day 25 | - | 7.88µs | 510ns
*Total* | *61.9µs* | *11.4s* | *6.51s*

![Graph for year 2015](y2015.svg)

## 2016
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 130µs | 79.3µs
Day 02 | 17.9µs | 143µs
Day 03 | 73.7µs | 382µs
Day 04 | 2.18ms | 2.88ms
Day 05 | **🔴 5.83s** | 6.57s
Day 06 | 248µs | 1.45ms
Day 07 | 1.47ms | 4.41ms
Day 08 | 6.43µs | 21.1µs
Day 09 | 21.8µs | 266µs
Day 10 | 5.31ms | 267µs
Day 11 | 46.1ms | 1.95s
Day 12 | 4.46µs | 3.45µs
Day 13 | 123µs | 182µs
Day 14 | **🔴 12.8s** | **🔴 56.1s**
Day 15 | 53.5ms | 9.46ms
Day 16 | 412ms | 159ms
Day 17 | 71ms | 37.7ms
Day 18 | 252ms | 503ms
Day 19 | 558ms | 68ns
Day 20 | 343µs | 158µs
Day 21 | 265ms | 51.9ms
Day 22 | 32.3ms | 23.9ms
Day 23 | 10.6µs | 7.71µs
Day 24 | 65.6ms | 5.89ms
Day 25 | 149ms | 11.8ms
*Total* | *20.5s* | *1m5.4s*

![Graph for year 2016](y2016.svg)

## 2017
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 39.5µs | 2.87µs
Day 02 | 31.6µs | 17µs
Day 03 | 32µs | 20.6µs
Day 04 | 2.63ms | 3.35ms
Day 05 | 152ms | 55.3ms
Day 06 | 24.6ms | 2.22ms
Day 07 | 3.19ms | 1.03ms
Day 08 | 688µs | 352µs
Day 09 | 182µs | 102µs
Day 10 | 1.75ms | 198µs
Day 11 | 253µs | 169µs
Day 12 | 4.26ms | 1.6ms
Day 13 | 117ms | **🔴 732ms**
Day 14 | 99.8ms | 28.6ms
Day 15 | **🔴 1.15s** | **🔴 1.62s**
Day 16 | 349ms | 29.5ms
Day 17 | **🔴 700ms** | 485ms
Day 18 | 12.8ms | 927µs
Day 19 | 545µs | -
Day 20 | 371ms | -
Day 21 | 113ms | -
Day 22 | 99.8ms | -
Day 23 | 3.62ms | -
Day 24 | 236ms | -
Day 25 | 55.7ms | -
*Total* | *3.49s* | *2.96s*

![Graph for year 2017](y2017.svg)

## 2018
 &nbsp;  | Golang
 ---:  | ---: 
Day 01 | 19.5ms
Day 02 | 9.68ms
Day 03 | 198ms
Day 04 | 6.53ms
Day 05 | 448ms
Day 06 | 57.8ms
Day 07 | 300µs
Day 08 | 236ms
Day 09 | 436ms
Day 10 | 1.35ms
Day 11 | 71ms
Day 12 | 1.52ms
Day 13 | 4.3ms
Day 14 | 483ms
Day 15 | 641ms
Day 16 | 13.9ms
Day 17 | 82.1ms
Day 18 | 117ms
Day 19 | 250ms
Day 20 | 25.6ms
Day 21 | 628ms
Day 22 | **🔴 6.74s**
Day 23 | 333ms
Day 24 | 180ms
Day 25 | 15.4ms
*Total* | *11s*

![Graph for year 2018](y2018.svg)

## 2019
 &nbsp;  | C++ | Crystal | Golang | Nim
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 2.48µs | 20µs | 6.72µs | 15.7µs
Day 02 | 1.18ms | 11.4ms | 2.57ms | 9.3ms
Day 03 | 49.5ms | 45ms | 19.8ms | 31.9ms
Day 04 | 4.02ms | 72.6ms | 2.34ms | 86.2ms
Day 05 | 60µs | 123µs | 33µs | 87.5µs
Day 06 | 5.53µs | 8.66ms | 30.5ms | 91.4ms
Day 07 | 8.88ms | 16.2ms | 2.75ms | 7.67ms
Day 08 | 42.5µs | 485µs | 278µs | 29.1µs
Day 09 | 106ms | 119ms | 14.2ms | 13.8ms
Day 10 | 39ms | 19.5ms | 30.5ms | 29.7ms
Day 11 | 26.8ms | 30.1ms | 6.9ms | 5.01ms
Day 12 | 531ms | 308ms | 15.8ms | 435ms
Day 13 | 205ms | 267ms | 34.8ms | 30.6ms
Day 14 | 6.69ms | 16ms | 11.6ms | 7.99ms
Day 15 | 46.4ms | 34ms | 12.7ms | 30.2ms
Day 16 | 284ms | 694ms | **🔴 607ms** | 689ms
Day 17 | 32ms | 25.2ms | 5.13ms | 4.1ms
Day 18 | **🔴 2.41s** | **🔴 21.1s** | **🔴 864ms** | **🔴 1m8s**
Day 19 | 696ms | 553ms | 105ms | 115ms
Day 20 | 501ms | 482ms | 50.2ms | 867ms
Day 21 | 162ms | 132ms | 23ms | 20.8ms
Day 22 | 4.55µs | 190µs | 337µs | 48.1µs
Day 23 | 97ms | 81.3ms | 15.2ms | 15.7ms
Day 24 | 64.3ms | 97.5ms | 297ms | 51.7ms
Day 25 | **🔴 1.54s** | 2.52s | 214ms | 202ms
*Total* | *6.82s* | *26.7s* | *2.37s* | *1m10.8s*

![Graph for year 2019](y2019.svg)

## 2020
 &nbsp;  | Crystal | Golang | Nim | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 415µs | 21.9ms | 522µs | 588µs
Day 02 | 755µs | 836µs | 730µs | 181µs
Day 03 | 637µs | 43.8µs | 122µs | 26.6µs
Day 04 | 1.29ms | 602µs | 15.8ms | 3.01ms
Day 05 | 1.06ms | 123µs | 316µs | 263µs
Day 06 | 3.28ms | 1.82ms | 1.76ms | 13.8ms
Day 07 | 1.62ms | 2.03ms | 2.46ms | 1.32ms
Day 08 | 1.15ms | 2.53ms | 1.19ms | 7.49ms
Day 09 | 293µs | 11.3ms | 1.59ms | 259µs
Day 10 | 23.7µs | 78.2µs | 28.4µs | 52.1µs
Day 11 | 80.2ms | 79.3ms | 36.5ms | 38.7ms
Day 12 | 110µs | 184µs | 113µs | 2.4ms
Day 13 | 162µs | 10.6µs | 24.9µs | 18µs
Day 14 | 6.47ms | 16.7ms | 12.1ms | 9.51ms
Day 15 | 731ms | 738ms | **🔴 837ms** | 909ms
Day 16 | 1.32ms | 2.22ms | 1.57ms | 1.94ms
Day 17 | 298ms | **🔴 849ms** | 113ms | **🔴 2m39s**
Day 18 | 1.27ms | 20.8ms | 1.2ms | 12.1ms
Day 19 | 7.69ms | 28.6ms | 212ms | -
Day 20 | 13.6ms | - | 5.44ms | 17.7ms
Day 21 | 1.85ms | 3.8ms | 2.3ms | 4.29ms
Day 22 | 238ms | 94.2ms | 324ms | 200ms
Day 23 | 1.51s | **🔴 1.67s** | **🔴 1.1s** | 7.59s
Day 24 | **🔴 13.9s** | 207ms | 181ms | 127ms
Day 25 | 48.1ms | 48.5ms | 48.7ms | 43.6ms
*Total* | *16.8s* | *3.8s* | *2.9s* | *2m48s*

![Graph for year 2020](y2020.svg)

## 2021
 &nbsp;  | Crystal | Golang | Haskell | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 385µs** | 29.1µs | **🔴 2.58ms** | 30.3µs | 15.4µs
Day 02 | 110µs | 1.4µs | **🔴 2.78ms** | 4.07µs | 1.09µs
Day 03 | **🔴 239µs** | 49.9µs | **🔴 3.73ms** | 42.4µs | 79.6µs
Day 04 | - | 74.9µs | 160µs | 124µs | 55.7µs
Day 05 | - | 1.1ms | - | 1.01ms | 1.13ms
Day 06 | - | 2.2µs | - | 1.42µs | 1.11µs
Day 07 | - | 97.6µs | - | 34.3µs | 57.1µs
Day 08 | - | 237µs | - | 172µs | 2ms
Day 09 | - | 903µs | - | 254µs | 287µs
Day 10 | - | 61.3µs | - | 80µs | 54.8µs
Day 11 | - | 730µs | - | 363µs | 220µs
Day 12 | - | 975µs | - | - | 252µs
Day 13 | - | 350µs | - | 513µs | 406µs
Day 14 | - | 346µs | - | - | 134µs
Day 15 | - | 54.1ms | - | - | **🔴 23ms**
Day 16 | - | 25.5µs | - | 12.2µs | 534µs
Day 17 | - | 2.5ms | - | - | 1.77ms
Day 18 | - | 50.9ms | - | 44.4ms | **🔴 17.4ms**
Day 19 | - | **🔴 973ms** | - | 23.7ms | -
Day 20 | - | 28ms | - | - | -
Day 21 | - | 2.02ms | - | 1.67µs | 430µs
Day 22 | - | 9.54ms | - | - | -
Day 23 | - | **🔴 505ms** | - | - | -
Day 24 | - | 3.85µs | - | **🔴 22.6s** | -
Day 25 | - | 52.1ms | - | - | -
*Total* | *734µs* | *1.68s* | *9.25ms* | *22.7s* | *47.8ms*

![Graph for year 2021](y2021.svg)
