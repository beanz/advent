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
Day 01 | **🔴 67.3µs** | 20µs | 415µs | **🔴 412µs**
Day 02 | - | 11.4ms | 755µs | 111µs
Day 03 | - | 45ms | 2.7ms | **🔴 242µs**
Day 04 | - | 72.6ms | 1.29ms | -
Day 05 | - | 123µs | 1.06ms | -
Day 06 | - | 8.66ms | 3.28ms | -
Day 07 | - | 16.2ms | 1.62ms | -
Day 08 | - | 485µs | 9.96ms | -
Day 09 | - | 119ms | 1.66ms | -
Day 10 | - | 19.5ms | 23.7µs | -
Day 11 | - | 30.1ms | 80.2ms | -
Day 12 | - | 308ms | 110µs | -
Day 13 | - | 267ms | 162µs | -
Day 14 | - | 16ms | 6.47ms | -
Day 15 | - | 34ms | 731ms | -
Day 16 | - | 694ms | 5.05ms | -
Day 17 | - | 25.2ms | 298ms | -
Day 18 | - | **🔴 21.1s** | 1.27ms | -
Day 19 | - | 553ms | 7.69ms | -
Day 20 | - | 482ms | 13.6ms | -
Day 21 | - | 132ms | 1.85ms | -
Day 22 | - | 190µs | 238ms | -
Day 23 | - | 81.3ms | 1.51s | -
Day 24 | - | 97.5ms | **🔴 13.9s** | -
Day 25 | - | 2.52s | 48.1ms | -
*Total* | *67.3µs* | *26.7s* | *16.8s* | *764µs*


## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 29.1µs | 130µs | 39.5µs | 19.5ms | 6.72µs | 21.9ms | 29.1µs | **🔴 20.7µs**
Day 02 | 769µs | 17.9µs | 31.6µs | 9.68ms | 2.57ms | 836µs | 1.4µs | -
Day 03 | 754µs | 73.7µs | 32µs | 198ms | 19.8ms | 43.8µs | 49.9µs | -
Day 04 | 1.39s | 2.18ms | 2.63ms | 6.53ms | 2.34ms | 602µs | 74.9µs | -
Day 05 | 533µs | **🔴 5.83s** | 152ms | 448ms | 33µs | 123µs | 1.1ms | -
Day 06 | 133ms | 248µs | 24.6ms | 57.8ms | 30.5ms | 1.82ms | 2.2µs | -
Day 07 | 320µs | 1.47ms | 3.19ms | 300µs | 2.75ms | 2.03ms | 97.6µs | -
Day 08 | 32.3µs | 6.43µs | 688µs | 236ms | 278µs | 2.53ms | 237µs | -
Day 09 | 14.8ms | 21.8µs | 182µs | 436ms | 14.2ms | 11.3ms | 903µs | -
Day 10 | 120ms | 5.31ms | 1.75ms | 1.35ms | 30.5ms | 78.2µs | 61.3µs | -
Day 11 | 51.1ms | 46.1ms | 253µs | 71ms | 6.9ms | 79.3ms | 730µs | -
Day 12 | 79.6ms | 4.46µs | 4.26ms | 1.52ms | 15.8ms | 184µs | 975µs | -
Day 13 | 150ms | 123µs | 117ms | 4.3ms | 34.8ms | 10.3µs | 350µs | -
Day 14 | 310µs | **🔴 12.8s** | 99.8ms | 483ms | 11.6ms | 16.7ms | 346µs | -
Day 15 | 103ms | 53.5ms | **🔴 1.15s** | 641ms | 12.7ms | 738ms | 54.1ms | -
Day 16 | 537µs | 412ms | 349ms | 13.9ms | **🔴 607ms** | 2.22ms | 25.5µs | -
Day 17 | 90.5ms | 71ms | **🔴 700ms** | 82.1ms | 5.13ms | **🔴 849ms** | 2.5ms | -
Day 18 | 6.12ms | 252ms | 12.8ms | 117ms | **🔴 864ms** | 20.8ms | 51.9ms | -
Day 19 | 392µs | 558ms | 545µs | 250ms | 105ms | 28.6ms | **🔴 973ms** | -
Day 20 | **🔴 6.41s** | 343µs | 371ms | 25.6ms | 50.2ms | 11.6ms | 28ms | -
Day 21 | 637µs | 265ms | 113ms | 628ms | 23ms | 3.8ms | 2.02ms | -
Day 22 | **🔴 2.64s** | 32.3ms | 99.8ms | **🔴 6.74s** | 337µs | 94.2ms | 9.54ms | -
Day 23 | 47.9µs | 10.6µs | 3.62ms | 333ms | 15.2ms | **🔴 1.67s** | **🔴 505ms** | -
Day 24 | 237ms | 65.6ms | 236ms | 180ms | 297ms | 207ms | 3.85µs | -
Day 25 | 7.88µs | 149ms | 55.7ms | 15.4ms | 214ms | 48.5ms | 52.1ms | -
*Total* | *11.4s* | *20.5s* | *3.49s* | *11s* | *2.37s* | *3.82s* | *1.68s* | *20.7µs*


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
 &nbsp;  | 2015 | 2016 | 2017 | 2020 | 2021 | 2022
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 7.02µs | 79.2µs | 2.14µs | 248µs | 27.3µs | **🔴 14.4µs**
Day 02 | 99.5µs | 141µs | 17µs | 68.4µs | 1.5µs | -
Day 03 | 918µs | 389µs | 20.5µs | 5.49µs | 41.6µs | -
Day 04 | **🔴 1.92s** | 2.84ms | 3.38ms | 85µs | 105µs | -
Day 05 | 396µs | 8.17s | 55.1ms | 98µs | 1.06ms | -
Day 06 | 54.3ms | 1.28ms | 2.21ms | 31.2µs | 1.67µs | -
Day 07 | 356µs | 4.49ms | 1.03ms | 400µs | 34.7µs | -
Day 08 | 71µs | 21.4µs | 378µs | 97.4µs | 45.3µs | -
Day 09 | 8.7ms | 266µs | 99.3µs | 240µs | 219µs | -
Day 10 | 779ms | 261µs | 213µs | 1.18µs | 81.4µs | -
Day 11 | 84ms | 1.86s | 171µs | 24.5ms | 240µs | -
Day 12 | 596µs | 3.81µs | 1.6ms | 7.7µs | 8.6ms | -
Day 13 | 177ms | 180µs | **🔴 724ms** | 1.22µs | 475µs | -
Day 14 | 824µs | **🔴 59.7s** | 33.1ms | 6.82ms | 32µs | -
Day 15 | 52.3ms | 13.6ms | **🔴 1.62s** | **🔴 662ms** | 105ms | -
Day 16 | 474µs | 168ms | 29.1ms | 450µs | 12.5µs | -
Day 17 | 48.9ms | 45.2ms | 486ms | - | 2.75ms | -
Day 18 | 26.9ms | 510ms | 934µs | - | 41.6ms | -
Day 19 | 1.71ms | 70ns | - | - | 20.6ms | -
Day 20 | **🔴 2.75s** | 165µs | - | - | 37.7ms | -
Day 21 | 42.4µs | 51.8ms | - | - | 1.65µs | -
Day 22 | 724ms | 24ms | - | - | 16.4ms | -
Day 23 | 9.09µs | 8.02µs | - | - | **🔴 1.49s** | -
Day 24 | 8.25ms | 5.71ms | - | - | 17.7µs | -
Day 25 | 508ns | 11.9ms | - | - | 40.9ms | -
*Total* | *6.64s* | *1m10.5s* | *2.95s* | *695ms* | *1.77s* | *14.4µs*


## Zig
 &nbsp;  | 2020 | 2021
 ---:  | ---:  | ---: 
Day 01 | 587µs | 15.4µs
Day 02 | 181µs | 1.09µs
Day 03 | 27µs | 79.6µs
Day 04 | 3.01ms | 55.7µs
Day 05 | 263µs | 1.13ms
Day 06 | 13.8ms | 1.11µs
Day 07 | 1.32ms | 57.1µs
Day 08 | 7.67ms | 2.21ms
Day 09 | 257µs | 287µs
Day 10 | 52.1µs | 54.8µs
Day 11 | 38.7ms | 220µs
Day 12 | 2.4ms | 276µs
Day 13 | 18µs | 406µs
Day 14 | 9.51ms | 143µs
Day 15 | 909ms | **🔴 23ms**
Day 16 | 1.97ms | 534µs
Day 17 | - | 1.77ms
Day 18 | 12.1ms | **🔴 17.4ms**
Day 19 | - | -
Day 20 | 17.7ms | -
Day 21 | 4.29ms | 452µs
Day 22 | 200ms | -
Day 23 | **🔴 7.59s** | -
Day 24 | 127ms | -
Day 25 | 43.8ms | -
*Total* | *8.99s* | *48.1ms*


## 2015
 &nbsp;  | Crystal | Golang | Rust
 ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 67.3µs** | 29.1µs | 7.02µs
Day 02 | - | 769µs | 99.5µs
Day 03 | - | 754µs | 918µs
Day 04 | - | 1.39s | **🔴 1.92s**
Day 05 | - | 533µs | 396µs
Day 06 | - | 133ms | 54.3ms
Day 07 | - | 320µs | 356µs
Day 08 | - | 32.3µs | 71µs
Day 09 | - | 14.8ms | 8.7ms
Day 10 | - | 120ms | 779ms
Day 11 | - | 51.1ms | 84ms
Day 12 | - | 79.6ms | 596µs
Day 13 | - | 150ms | 177ms
Day 14 | - | 310µs | 824µs
Day 15 | - | 103ms | 52.3ms
Day 16 | - | 537µs | 474µs
Day 17 | - | 90.5ms | 48.9ms
Day 18 | - | 6.12ms | 26.9ms
Day 19 | - | 392µs | 1.71ms
Day 20 | - | **🔴 6.41s** | **🔴 2.75s**
Day 21 | - | 637µs | 42.4µs
Day 22 | - | **🔴 2.64s** | 724ms
Day 23 | - | 47.9µs | 9.09µs
Day 24 | - | 237ms | 8.25ms
Day 25 | - | 7.88µs | 508ns
*Total* | *67.3µs* | *11.4s* | *6.64s*

![Graph for year 2015](y2015.svg)

## 2016
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 130µs | 79.2µs
Day 02 | 17.9µs | 141µs
Day 03 | 73.7µs | 389µs
Day 04 | 2.18ms | 2.84ms
Day 05 | **🔴 5.83s** | 8.17s
Day 06 | 248µs | 1.28ms
Day 07 | 1.47ms | 4.49ms
Day 08 | 6.43µs | 21.4µs
Day 09 | 21.8µs | 266µs
Day 10 | 5.31ms | 261µs
Day 11 | 46.1ms | 1.86s
Day 12 | 4.46µs | 3.81µs
Day 13 | 123µs | 180µs
Day 14 | **🔴 12.8s** | **🔴 59.7s**
Day 15 | 53.5ms | 13.6ms
Day 16 | 412ms | 168ms
Day 17 | 71ms | 45.2ms
Day 18 | 252ms | 510ms
Day 19 | 558ms | 70ns
Day 20 | 343µs | 165µs
Day 21 | 265ms | 51.8ms
Day 22 | 32.3ms | 24ms
Day 23 | 10.6µs | 8.02µs
Day 24 | 65.6ms | 5.71ms
Day 25 | 149ms | 11.9ms
*Total* | *20.5s* | *1m10.5s*

![Graph for year 2016](y2016.svg)

## 2017
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 39.5µs | 2.14µs
Day 02 | 31.6µs | 17µs
Day 03 | 32µs | 20.5µs
Day 04 | 2.63ms | 3.38ms
Day 05 | 152ms | 55.1ms
Day 06 | 24.6ms | 2.21ms
Day 07 | 3.19ms | 1.03ms
Day 08 | 688µs | 378µs
Day 09 | 182µs | 99.3µs
Day 10 | 1.75ms | 213µs
Day 11 | 253µs | 171µs
Day 12 | 4.26ms | 1.6ms
Day 13 | 117ms | **🔴 724ms**
Day 14 | 99.8ms | 33.1ms
Day 15 | **🔴 1.15s** | **🔴 1.62s**
Day 16 | 349ms | 29.1ms
Day 17 | **🔴 700ms** | 486ms
Day 18 | 12.8ms | 934µs
Day 19 | 545µs | -
Day 20 | 371ms | -
Day 21 | 113ms | -
Day 22 | 99.8ms | -
Day 23 | 3.62ms | -
Day 24 | 236ms | -
Day 25 | 55.7ms | -
*Total* | *3.49s* | *2.95s*

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
 &nbsp;  | Crystal | Golang | Nim | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 415µs | 21.9ms | 522µs | 248µs | 587µs
Day 02 | 755µs | 836µs | 730µs | 68.4µs | 181µs
Day 03 | 2.7ms | 43.8µs | 122µs | 5.49µs | 27µs
Day 04 | 1.29ms | 602µs | 15.8ms | 85µs | 3.01ms
Day 05 | 1.06ms | 123µs | 316µs | 98µs | 263µs
Day 06 | 3.28ms | 1.82ms | 1.76ms | 31.2µs | 13.8ms
Day 07 | 1.62ms | 2.03ms | 2.46ms | 400µs | 1.32ms
Day 08 | 9.96ms | 2.53ms | 1.19ms | 97.4µs | 7.67ms
Day 09 | 1.66ms | 11.3ms | 1.59ms | 240µs | 257µs
Day 10 | 23.7µs | 78.2µs | 28.4µs | 1.18µs | 52.1µs
Day 11 | 80.2ms | 79.3ms | 36.5ms | 24.5ms | 38.7ms
Day 12 | 110µs | 184µs | 113µs | 7.7µs | 2.4ms
Day 13 | 162µs | 10.3µs | 24.9µs | 1.22µs | 18µs
Day 14 | 6.47ms | 16.7ms | 12.1ms | 6.82ms | 9.51ms
Day 15 | 731ms | 738ms | **🔴 837ms** | **🔴 662ms** | 909ms
Day 16 | 5.05ms | 2.22ms | 1.57ms | 450µs | 1.97ms
Day 17 | 298ms | **🔴 849ms** | 113ms | - | -
Day 18 | 1.27ms | 20.8ms | 1.2ms | - | 12.1ms
Day 19 | 7.69ms | 28.6ms | 212ms | - | -
Day 20 | 13.6ms | 11.6ms | 5.44ms | - | 17.7ms
Day 21 | 1.85ms | 3.8ms | 2.3ms | - | 4.29ms
Day 22 | 238ms | 94.2ms | 324ms | - | 200ms
Day 23 | 1.51s | **🔴 1.67s** | **🔴 1.1s** | - | **🔴 7.59s**
Day 24 | **🔴 13.9s** | 207ms | 181ms | - | 127ms
Day 25 | 48.1ms | 48.5ms | 48.7ms | - | 43.8ms
*Total* | *16.8s* | *3.82s* | *2.9s* | *695ms* | *8.99s*

![Graph for year 2020](y2020.svg)

## 2021
 &nbsp;  | Crystal | Golang | Haskell | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 412µs** | 29.1µs | **🔴 2.58ms** | 27.3µs | 15.4µs
Day 02 | 111µs | 1.4µs | **🔴 2.78ms** | 1.5µs | 1.09µs
Day 03 | **🔴 242µs** | 49.9µs | **🔴 3.73ms** | 41.6µs | 79.6µs
Day 04 | - | 74.9µs | 160µs | 105µs | 55.7µs
Day 05 | - | 1.1ms | - | 1.06ms | 1.13ms
Day 06 | - | 2.2µs | - | 1.67µs | 1.11µs
Day 07 | - | 97.6µs | - | 34.7µs | 57.1µs
Day 08 | - | 237µs | - | 45.3µs | 2.21ms
Day 09 | - | 903µs | - | 219µs | 287µs
Day 10 | - | 61.3µs | - | 81.4µs | 54.8µs
Day 11 | - | 730µs | - | 240µs | 220µs
Day 12 | - | 975µs | - | 8.6ms | 276µs
Day 13 | - | 350µs | - | 475µs | 406µs
Day 14 | - | 346µs | - | 32µs | 143µs
Day 15 | - | 54.1ms | - | 105ms | **🔴 23ms**
Day 16 | - | 25.5µs | - | 12.5µs | 534µs
Day 17 | - | 2.5ms | - | 2.75ms | 1.77ms
Day 18 | - | 51.9ms | - | 41.6ms | **🔴 17.4ms**
Day 19 | - | **🔴 973ms** | - | 20.6ms | -
Day 20 | - | 28ms | - | 37.7ms | -
Day 21 | - | 2.02ms | - | 1.65µs | 452µs
Day 22 | - | 9.54ms | - | 16.4ms | -
Day 23 | - | **🔴 505ms** | - | **🔴 1.49s** | -
Day 24 | - | 3.85µs | - | 17.7µs | -
Day 25 | - | 52.1ms | - | 40.9ms | -
*Total* | *764µs* | *1.68s* | *9.25ms* | *1.77s* | *48.1ms*

![Graph for year 2021](y2021.svg)

## 2022
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | **🔴 20.7µs** | **🔴 14.4µs**
Day 02 | - | -
Day 03 | - | -
Day 04 | - | -
Day 05 | - | -
Day 06 | - | -
Day 07 | - | -
Day 08 | - | -
Day 09 | - | -
Day 10 | - | -
Day 11 | - | -
Day 12 | - | -
Day 13 | - | -
Day 14 | - | -
Day 15 | - | -
Day 16 | - | -
Day 17 | - | -
Day 18 | - | -
Day 19 | - | -
Day 20 | - | -
Day 21 | - | -
Day 22 | - | -
Day 23 | - | -
Day 24 | - | -
Day 25 | - | -
*Total* | *20.7µs* | *14.4µs*

![Graph for year 2022](y2022.svg)
