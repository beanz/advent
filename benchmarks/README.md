This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## 2022
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 16.8µs / None | 7.43µs / None
Day 02 | 4.5µs / None | 1.09µs / None
Day 03 | 49.6µs / None | 37.6µs / None
Day 04 | 20.2µs / None | 12.8µs / None
Day 05 | 12.5µs / None | 9.92µs / None
Day 06 | 32.5µs / None | 19µs / None
Day 07 | 24.5µs / None | 22.2µs / None
Day 08 | 665µs / None | **🔴 648µs** / None
Day 09 | 401µs / None | **🔴 387µs** / None
Day 10 | 1.61µs / None | 1.19µs / None
Day 11 | **🔴 34.5ms** / **🔴 11.2 MB** | -
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
*Total* | *35.7ms / 11.2 MB* | *1.15ms / None*

![Graph for year 2022](y2022.svg)

## 2021
 &nbsp;  | Crystal | Golang | Haskell | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 412µs** | 28.3µs / 81.9 KB | **🔴 2.58ms** | 27.2µs / None | 15.4µs
Day 02 | 111µs | 1.38µs / None | **🔴 2.78ms** | 1.67µs / None | 1.09µs
Day 03 | **🔴 242µs** | 49.6µs / None | **🔴 3.73ms** | 41.8µs / 2.0 KB | 79.6µs
Day 04 | - | 74µs / 79.2 KB | 160µs | 118µs / 102 KB | 55.7µs
Day 05 | - | 1.05ms / 1.1 MB | - | 1.07ms / 8.2 KB | 1.13ms
Day 06 | - | 2.2µs / None | - | 1.65µs / 512 B | 1.11µs
Day 07 | - | 97µs / 8.2 KB | - | 35.5µs / 3.2 KB | 57.1µs
Day 08 | - | 241µs / 167 KB | - | 48.1µs / 2.4 KB | 2.21ms
Day 09 | - | 937µs / 238 KB | - | 214µs / 19.5 KB | 287µs
Day 10 | - | 61.1µs / 920 B | - | 64.2µs / 2.3 KB | 54.8µs
Day 11 | - | 719µs / 223 KB | - | 243µs / 346 B | 220µs
Day 12 | - | 1.01ms / 3.0 MB | - | 8.63ms / 1.2 KB | 276µs
Day 13 | - | 344µs / 22.7 KB | - | 515µs / 265 KB | 406µs
Day 14 | - | 345µs / 119 KB | - | 34µs / 1.8 KB | 143µs
Day 15 | - | 53.7ms / 2.5 MB | - | 119ms / **🔴 133 MB** | **🔴 23ms**
Day 16 | - | 25.3µs / 5.1 KB | - | 13.9µs / 4.8 KB | 534µs
Day 17 | - | 2.45ms / 64.0 B | - | 1.92ms / None | 1.77ms
Day 18 | - | 50.5ms / 4.8 MB | - | 47.8ms / 15.5 MB | **🔴 17.4ms**
Day 19 | - | **🔴 960ms** / 16.2 MB | - | 20.7ms / 2.0 MB | -
Day 20 | - | 27.3ms / 82.5 KB | - | 38.3ms / 2.0 MB | -
Day 21 | - | 1.95ms / 2.3 MB | - | 1.7µs / 8.0 B | 452µs
Day 22 | - | 9.35ms / 3.8 MB | - | 17ms / 2.3 MB | -
Day 23 | - | **🔴 519ms** / **🔴 199 MB** | - | **🔴 1.56s** / **🔴 165 MB** | -
Day 24 | - | 3.85µs / 656 B | - | 15µs / 576 B | -
Day 25 | - | 52.5ms / None | - | 39.5ms / 19.4 KB | -
*Total* | *764µs* | *1.68s / 234 MB* | *9.25ms* | *1.85s / 321 MB* | *48.1ms*

![Graph for year 2021](y2021.svg)

## 2020
 &nbsp;  | Crystal | Golang | Nim | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 415µs | 21.4ms / 14.1 MB | 522µs | 242µs / 144 KB | 587µs
Day 02 | 755µs | 817µs / 280 KB | 730µs | 68.4µs / 24.6 KB | 181µs
Day 03 | 2.7ms | 43.4µs / 16.3 KB | 122µs | 5.77µs / None | 27µs
Day 04 | 1.29ms | 617µs / 237 KB | 15.8ms | 95.5µs / None | 3.01ms
Day 05 | 1.06ms | 120µs / 51.9 KB | 316µs | 98.2µs / 12.4 KB | 263µs
Day 06 | 3.28ms | 1.75ms / 2.2 MB | 1.76ms | 31.3µs / None | 13.8ms
Day 07 | 1.62ms | 2ms / 648 KB | 2.46ms | 438µs / 281 KB | 1.32ms
Day 08 | 9.96ms | 2.45ms / 5.5 MB | 1.19ms | 96.9µs / None | 7.67ms
Day 09 | 1.66ms | 11.1ms / 44.0 MB | 1.59ms | 239µs / None | 257µs
Day 10 | 23.7µs | 77µs / 62.2 KB | 28.4µs | 1.02µs / None | 52.1µs
Day 11 | 466ms | 80.3ms / 4.6 MB | 36.5ms | 24.5ms / 2.0 MB | 38.7ms
Day 12 | 110µs | 181µs / 78.6 KB | 113µs | 7.82µs / None | 2.4ms
Day 13 | 162µs | 10.2µs / 5.1 KB | 24.9µs | 1.34µs / 256 B | 18µs
Day 14 | 6.47ms | 16.1ms / 7.4 MB | 12.1ms | 6.87ms / 4.5 MB | 9.51ms
Day 15 | 731ms | 724ms / **🔴 240 MB** | **🔴 837ms** | **🔴 650ms** / **🔴 49.4 MB** | 909ms
Day 16 | 5.05ms | 2.18ms / 1.1 MB | 1.57ms | 456µs / 141 KB | 1.97ms
Day 17 | 298ms | **🔴 847ms** / **🔴 338 MB** | 113ms | 72.9ms / **🔴 21.7 MB** | **🔴 2m32s**
Day 18 | 5.91ms | 20.4ms / 2.8 MB | 1.2ms | 252µs / None | 12.4ms
Day 19 | 7.69ms | 28ms / 6.6 MB | 212ms | - | 25ms
Day 20 | 13.6ms | 11.4ms / 5.3 MB | 5.44ms | - | 17.7ms
Day 21 | 1.85ms | 3.75ms / 438 KB | 2.3ms | - | 4.29ms
Day 22 | 238ms | 91.9ms / 44.0 MB | 324ms | - | 200ms
Day 23 | 1.51s | **🔴 1.75s** / 32.0 MB | **🔴 1.1s** | - | 7.59s
Day 24 | **🔴 13.9s** | 203ms / 7.9 MB | 181ms | - | 127ms
Day 25 | 48.1ms | 48.5ms / 336 B | 48.7ms | - | 43.8ms
*Total* | *17.2s* | *3.87s / 757 MB* | *2.9s* | *756ms / 78.2 MB* | *2m41s*

![Graph for year 2020](y2020.svg)

## 2019
 &nbsp;  | C++ | Crystal | Golang | Nim
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 2.48µs | 20µs | 6.65µs / 3.4 KB | 15.7µs
Day 02 | 1.18ms | 11.4ms | 2.49ms / 9.3 MB | 9.3ms
Day 03 | 49.5ms | 45ms | 19.6ms / 10.0 MB | 31.9ms
Day 04 | 4.02ms | 72.6ms | 2.33ms / 80.0 B | 86.2ms
Day 05 | 60µs | 123µs | 32.3µs / 78.8 KB | 87.5µs
Day 06 | 5.53µs | 8.66ms | 30.1ms / 18.4 MB | 91.4ms
Day 07 | 8.88ms | 16.2ms | 2.68ms / 5.5 MB | 7.67ms
Day 08 | 42.5µs | 485µs | 275µs / 29.7 KB | 29.1µs
Day 09 | 106ms | 119ms | 14.2ms / 74.6 KB | 13.8ms
Day 10 | 39ms | 19.5ms | 30.5ms / 11.3 MB | 29.7ms
Day 11 | 26.8ms | 30.1ms | 6.92ms / 888 KB | 5.01ms
Day 12 | 531ms | 308ms | 15.7ms / 736 B | 435ms
Day 13 | 205ms | 267ms | 34.5ms / 2.9 MB | 30.6ms
Day 14 | 6.69ms | 16ms | 11.6ms / 281 KB | 7.99ms
Day 15 | 46.4ms | 34ms | 12.4ms / 32.5 MB | 30.2ms
Day 16 | 284ms | 694ms | **🔴 605ms** / 1.1 MB | 689ms
Day 17 | 32ms | 25.2ms | 5.18ms / 304 KB | 4.1ms
Day 18 | **🔴 2.41s** | **🔴 21.1s** | **🔴 830ms** / **🔴 405 MB** | **🔴 1m8s**
Day 19 | 696ms | 553ms | 104ms / 66.6 MB | 115ms
Day 20 | 501ms | 482ms | 50.9ms / 64.4 MB | 867ms
Day 21 | 162ms | 132ms | 23ms / 124 KB | 20.8ms
Day 22 | 4.55µs | 190µs | 329µs / 111 KB | 48.1µs
Day 23 | 97ms | 81.3ms | 14.8ms / 4.7 MB | 15.7ms
Day 24 | 64.3ms | 97.5ms | 290ms / **🔴 196 MB** | 51.7ms
Day 25 | **🔴 1.54s** | 2.52s | 213ms / 43.8 MB | 202ms
*Total* | *6.82s* | *26.7s* | *2.32s / 873 MB* | *1m10.8s*

![Graph for year 2019](y2019.svg)

## 2018
 &nbsp;  | Golang
 ---:  | ---: 
Day 01 | 20.5ms / 13.2 MB
Day 02 | 9.97ms / 2.8 MB
Day 03 | 206ms / 64.1 MB
Day 04 | 6.34ms / 400 KB
Day 05 | 575ms / 48.3 MB
Day 06 | 57.6ms / 19.4 KB
Day 07 | 292µs / 68.7 KB
Day 08 | 225ms / **🔴 1.2 GB**
Day 09 | 448ms / 167 MB
Day 10 | 1.34ms / 768 KB
Day 11 | 70.8ms / 721 KB
Day 12 | 1.59ms / 1.5 MB
Day 13 | 4.33ms / 2.9 MB
Day 14 | 493ms / 21.0 MB
Day 15 | 638ms / 251 MB
Day 16 | 14ms / 11.1 MB
Day 17 | 79.9ms / 12.1 MB
Day 18 | 119ms / 166 MB
Day 19 | 249ms / 27.0 KB
Day 20 | 25.4ms / 8.6 MB
Day 21 | 626ms / 449 KB
Day 22 | **🔴 6.57s** / 241 MB
Day 23 | 329ms / 1.7 MB
Day 24 | 158ms / 42.6 MB
Day 25 | 15.3ms / 994 KB
*Total* | *10.9s / 2.3 GB*

![Graph for year 2018](y2018.svg)

## 2017
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 40.8µs / 2.3 KB | 2.82µs / 16.4 KB
Day 02 | 31.6µs / 8.3 KB | 17.2µs / 2.0 KB
Day 03 | 32.3µs / 15.9 KB | 21.6µs / 14.3 KB
Day 04 | 2.64ms / 825 KB | 4.93ms / 2.0 MB
Day 05 | 152ms / 25.5 MB | 55.1ms / 24.9 KB
Day 06 | 24.5ms / 6.6 MB | 2.32ms / 1.8 MB
Day 07 | 3.09ms / 1.0 MB | 1.13ms / 523 KB
Day 08 | 676µs / 318 KB | 410µs / 38.2 KB
Day 09 | 182µs / 49.2 KB | 101µs / 89.3 KB
Day 10 | 1.74ms / 11.4 KB | 210µs / 1.1 KB
Day 11 | 253µs / 11.1 KB | 165µs / None
Day 12 | 4.25ms / 1.2 MB | 1.62ms / 1.1 MB
Day 13 | 116ms / 4.1 KB | **🔴 737ms** / 2.4 KB
Day 14 | 100ms / 1.7 MB | 40.5ms / **🔴 39.3 MB**
Day 15 | **🔴 1.16s** / 1.4 KB | **🔴 1.61s** / 32.0 B
Day 16 | 355ms / 82.8 MB | 34.1ms / 10.6 MB
Day 17 | 700ms / 48.5 KB | 484ms / 16.1 KB
Day 18 | 13.8ms / 5.7 MB | 1ms / 4.0 KB
Day 19 | 550µs / 44.8 KB | -
Day 20 | 406ms / **🔴 206 MB** | -
Day 21 | 111ms / 37.7 MB | -
Day 22 | 101ms / 526 KB | -
Day 23 | 3.78ms / 4.6 KB | -
Day 24 | 232ms / 59.9 MB | -
Day 25 | 56.1ms / 15.3 KB | -
*Total* | *3.54s / 430 MB* | *2.97s / 55.6 MB*

![Graph for year 2017](y2017.svg)

## 2016
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 138µs / 101 KB | 81.5µs / 34.9 KB
Day 02 | 19.2µs / 192 B | 140µs / 3.8 KB
Day 03 | 73.6µs / 49.2 KB | 501µs / 183 KB
Day 04 | 2.16ms / 642 KB | 2.98ms / 634 KB
Day 05 | **🔴 5.85s** / 3.2 KB | **🔴 9.21s** / **🔴 689 MB**
Day 06 | 249µs / 4.6 KB | 1.56ms / 5.8 KB
Day 07 | 1.48ms / 64.4 KB | 4.78ms / 1.0 MB
Day 08 | 6.41µs / 96.0 B | 24.5µs / 6.2 KB
Day 09 | 21.8µs / None | 289µs / 361 KB
Day 10 | 5.24ms / 5.5 MB | 278µs / 90.7 KB
Day 11 | 45.7ms / 16.8 MB | 2.25s / **🔴 785 MB**
Day 12 | 4.39µs / 3.0 KB | 3.97µs / 5.8 KB
Day 13 | 120µs / 82.1 KB | 193µs / 101 KB
Day 14 | **🔴 12.7s** / 33.1 KB | **🔴 8.83s** / 76.0 B
Day 15 | 53ms / 14.6 KB | 11.2ms / 432 B
Day 16 | 411ms / 17.8 MB | 161ms / 67.1 MB
Day 17 | 69.8ms / 52.5 MB | 44.3ms / 35.4 MB
Day 18 | 251ms / 224 B | 533ms / 63.8 MB
Day 19 | 532ms / **🔴 145 MB** | 67ns / None
Day 20 | 345µs / 120 KB | 177µs / 76.3 KB
Day 21 | 275ms / 48.2 MB | 55ms / 4.4 MB
Day 22 | 32.4ms / 391 KB | 23.9ms / 194 KB
Day 23 | 10.6µs / 9.0 KB | 8.11µs / 21.1 KB
Day 24 | 64.5ms / 27.3 MB | 7.42ms / 3.8 MB
Day 25 | 152ms / 16.8 KB | 11.8ms / 7.3 KB
*Total* | *20.5s / 314 MB* | *21.2s / 1.7 GB*

![Graph for year 2016](y2016.svg)

## 2015
 &nbsp;  | Crystal | Golang | Rust
 ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 67.3µs** | 28.9µs / None | 6.95µs / None
Day 02 | - | 753µs / 189 KB | 114µs / 16.0 KB
Day 03 | - | 741µs / 190 KB | 926µs / 279 KB
Day 04 | - | 1.39s / 56.0 B | **🔴 2.12s** / 159 MB
Day 05 | - | 530µs / 34.8 KB | 388µs / None
Day 06 | - | 130ms / 252 KB | 54.5ms / 19.2 KB
Day 07 | - | 316µs / 117 KB | 433µs / 148 KB
Day 08 | - | 30.8µs / 11.4 KB | 74.4µs / 29.6 KB
Day 09 | - | 15.1ms / 6.2 MB | 9.59ms / 651 KB
Day 10 | - | 119ms / 56.6 MB | 1.17s / **🔴 312 MB**
Day 11 | - | 50.8ms / 313 KB | 98ms / 15.0 MB
Day 12 | - | 78.1ms / 392 MB | 546µs / 357 KB
Day 13 | - | 148ms / 28.1 MB | 181ms / 7.2 MB
Day 14 | - | 305µs / 108 KB | 907µs / 425 B
Day 15 | - | 103ms / 67.5 MB | 77.4ms / 44.1 MB
Day 16 | - | 534µs / 262 KB | 525µs / 250 KB
Day 17 | - | 89.9ms / 3.0 KB | 65.1ms / 84.1 MB
Day 18 | - | 6.1ms / 42.8 KB | 27ms / 56.4 KB
Day 19 | - | 372µs / 413 KB | 1.62ms / 546 KB
Day 20 | - | **🔴 6.36s** / **🔴 493 MB** | **🔴 2.76s** / 126 MB
Day 21 | - | 633µs / 277 KB | 61.7µs / 16.9 KB
Day 22 | - | **🔴 2.77s** / **🔴 1.1 GB** | 749ms / **🔴 234 MB**
Day 23 | - | 45.4µs / 9.3 KB | 9.35µs / 1.2 KB
Day 24 | - | 234ms / 61.1 MB | 14.1ms / 10.0 MB
Day 25 | - | 7.69µs / 6.1 KB | 525ns / 32.0 B
*Total* | *67.3µs* | *11.5s / 2.2 GB* | *7.33s / 994 MB*

![Graph for year 2015](y2015.svg)

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
Day 11 | - | 30.1ms | 466ms | -
Day 12 | - | 308ms | 110µs | -
Day 13 | - | 267ms | 162µs | -
Day 14 | - | 16ms | 6.47ms | -
Day 15 | - | 34ms | 731ms | -
Day 16 | - | 694ms | 5.05ms | -
Day 17 | - | 25.2ms | 298ms | -
Day 18 | - | **🔴 21.1s** | 5.91ms | -
Day 19 | - | 553ms | 7.69ms | -
Day 20 | - | 482ms | 13.6ms | -
Day 21 | - | 132ms | 1.85ms | -
Day 22 | - | 190µs | 238ms | -
Day 23 | - | 81.3ms | 1.51s | -
Day 24 | - | 97.5ms | **🔴 13.9s** | -
Day 25 | - | 2.52s | 48.1ms | -
*Total* | *67.3µs* | *26.7s* | *17.2s* | *764µs*


## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 28.9µs / None | 138µs / 101 KB | 40.8µs / 2.3 KB | 20.5ms / 13.2 MB | 6.65µs / 3.4 KB | 21.4ms / 14.1 MB | 28.3µs / 81.9 KB | 16.8µs / None
Day 02 | 753µs / 189 KB | 19.2µs / 192 B | 31.6µs / 8.3 KB | 9.97ms / 2.8 MB | 2.49ms / 9.3 MB | 817µs / 280 KB | 1.38µs / None | 4.5µs / None
Day 03 | 741µs / 190 KB | 73.6µs / 49.2 KB | 32.3µs / 15.9 KB | 206ms / 64.1 MB | 19.6ms / 10.0 MB | 43.4µs / 16.3 KB | 49.6µs / None | 49.6µs / None
Day 04 | 1.39s / 56.0 B | 2.16ms / 642 KB | 2.64ms / 825 KB | 6.34ms / 400 KB | 2.33ms / 80.0 B | 617µs / 237 KB | 74µs / 79.2 KB | 20.2µs / None
Day 05 | 530µs / 34.8 KB | **🔴 5.85s** / 3.2 KB | 152ms / 25.5 MB | 575ms / 48.3 MB | 32.3µs / 78.8 KB | 120µs / 51.9 KB | 1.05ms / 1.1 MB | 12.5µs / None
Day 06 | 130ms / 252 KB | 249µs / 4.6 KB | 24.5ms / 6.6 MB | 57.6ms / 19.4 KB | 30.1ms / 18.4 MB | 1.75ms / 2.2 MB | 2.2µs / None | 32.5µs / None
Day 07 | 316µs / 117 KB | 1.48ms / 64.4 KB | 3.09ms / 1.0 MB | 292µs / 68.7 KB | 2.68ms / 5.5 MB | 2ms / 648 KB | 97µs / 8.2 KB | 24.5µs / None
Day 08 | 30.8µs / 11.4 KB | 6.41µs / 96.0 B | 676µs / 318 KB | 225ms / **🔴 1.2 GB** | 275µs / 29.7 KB | 2.45ms / 5.5 MB | 241µs / 167 KB | 665µs / None
Day 09 | 15.1ms / 6.2 MB | 21.8µs / None | 182µs / 49.2 KB | 448ms / 167 MB | 14.2ms / 74.6 KB | 11.1ms / 44.0 MB | 937µs / 238 KB | 401µs / None
Day 10 | 119ms / 56.6 MB | 5.24ms / 5.5 MB | 1.74ms / 11.4 KB | 1.34ms / 768 KB | 30.5ms / 11.3 MB | 77µs / 62.2 KB | 61.1µs / 920 B | 1.61µs / None
Day 11 | 50.8ms / 313 KB | 45.7ms / 16.8 MB | 253µs / 11.1 KB | 70.8ms / 721 KB | 6.92ms / 888 KB | 80.3ms / 4.6 MB | 719µs / 223 KB | **🔴 34.5ms** / **🔴 11.2 MB**
Day 12 | 78.1ms / 392 MB | 4.39µs / 3.0 KB | 4.25ms / 1.2 MB | 1.59ms / 1.5 MB | 15.7ms / 736 B | 181µs / 78.6 KB | 1.01ms / 3.0 MB | -
Day 13 | 148ms / 28.1 MB | 120µs / 82.1 KB | 116ms / 4.1 KB | 4.33ms / 2.9 MB | 34.5ms / 2.9 MB | 10.2µs / 5.1 KB | 344µs / 22.7 KB | -
Day 14 | 305µs / 108 KB | **🔴 12.7s** / 33.1 KB | 100ms / 1.7 MB | 493ms / 21.0 MB | 11.6ms / 281 KB | 16.1ms / 7.4 MB | 345µs / 119 KB | -
Day 15 | 103ms / 67.5 MB | 53ms / 14.6 KB | **🔴 1.16s** / 1.4 KB | 638ms / 251 MB | 12.4ms / 32.5 MB | 724ms / **🔴 240 MB** | 53.7ms / 2.5 MB | -
Day 16 | 534µs / 262 KB | 411ms / 17.8 MB | 355ms / 82.8 MB | 14ms / 11.1 MB | **🔴 605ms** / 1.1 MB | 2.18ms / 1.1 MB | 25.3µs / 5.1 KB | -
Day 17 | 89.9ms / 3.0 KB | 69.8ms / 52.5 MB | 700ms / 48.5 KB | 79.9ms / 12.1 MB | 5.18ms / 304 KB | **🔴 847ms** / **🔴 338 MB** | 2.45ms / 64.0 B | -
Day 18 | 6.1ms / 42.8 KB | 251ms / 224 B | 13.8ms / 5.7 MB | 119ms / 166 MB | **🔴 830ms** / **🔴 405 MB** | 20.4ms / 2.8 MB | 50.5ms / 4.8 MB | -
Day 19 | 372µs / 413 KB | 532ms / **🔴 145 MB** | 550µs / 44.8 KB | 249ms / 27.0 KB | 104ms / 66.6 MB | 28ms / 6.6 MB | **🔴 960ms** / 16.2 MB | -
Day 20 | **🔴 6.36s** / **🔴 493 MB** | 345µs / 120 KB | 406ms / **🔴 206 MB** | 25.4ms / 8.6 MB | 50.9ms / 64.4 MB | 11.4ms / 5.3 MB | 27.3ms / 82.5 KB | -
Day 21 | 633µs / 277 KB | 275ms / 48.2 MB | 111ms / 37.7 MB | 626ms / 449 KB | 23ms / 124 KB | 3.75ms / 438 KB | 1.95ms / 2.3 MB | -
Day 22 | **🔴 2.77s** / **🔴 1.1 GB** | 32.4ms / 391 KB | 101ms / 526 KB | **🔴 6.57s** / 241 MB | 329µs / 111 KB | 91.9ms / 44.0 MB | 9.35ms / 3.8 MB | -
Day 23 | 45.4µs / 9.3 KB | 10.6µs / 9.0 KB | 3.78ms / 4.6 KB | 329ms / 1.7 MB | 14.8ms / 4.7 MB | **🔴 1.75s** / 32.0 MB | **🔴 519ms** / **🔴 199 MB** | -
Day 24 | 234ms / 61.1 MB | 64.5ms / 27.3 MB | 232ms / 59.9 MB | 158ms / 42.6 MB | 290ms / **🔴 196 MB** | 203ms / 7.9 MB | 3.85µs / 656 B | -
Day 25 | 7.69µs / 6.1 KB | 152ms / 16.8 KB | 56.1ms / 15.3 KB | 15.3ms / 994 KB | 213ms / 43.8 MB | 48.5ms / 336 B | 52.5ms / None | -
*Total* | *11.5s / 2.2 GB* | *20.5s / 314 MB* | *3.54s / 430 MB* | *10.9s / 2.3 GB* | *2.32s / 873 MB* | *3.87s / 757 MB* | *1.68s / 234 MB* | *35.7ms / 11.2 MB*


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
Day 01 | 6.95µs / None | 81.5µs / 34.9 KB | 2.82µs / 16.4 KB | 242µs / 144 KB | 27.2µs / None | 7.43µs / None
Day 02 | 114µs / 16.0 KB | 140µs / 3.8 KB | 17.2µs / 2.0 KB | 68.4µs / 24.6 KB | 1.67µs / None | 1.09µs / None
Day 03 | 926µs / 279 KB | 501µs / 183 KB | 21.6µs / 14.3 KB | 5.77µs / None | 41.8µs / 2.0 KB | 37.6µs / None
Day 04 | **🔴 2.12s** / 159 MB | 2.98ms / 634 KB | 4.93ms / 2.0 MB | 95.5µs / None | 118µs / 102 KB | 12.8µs / None
Day 05 | 388µs / None | **🔴 9.21s** / **🔴 689 MB** | 55.1ms / 24.9 KB | 98.2µs / 12.4 KB | 1.07ms / 8.2 KB | 9.92µs / None
Day 06 | 54.5ms / 19.2 KB | 1.56ms / 5.8 KB | 2.32ms / 1.8 MB | 31.3µs / None | 1.65µs / 512 B | 19µs / None
Day 07 | 433µs / 148 KB | 4.78ms / 1.0 MB | 1.13ms / 523 KB | 438µs / 281 KB | 35.5µs / 3.2 KB | 22.2µs / None
Day 08 | 74.4µs / 29.6 KB | 24.5µs / 6.2 KB | 410µs / 38.2 KB | 96.9µs / None | 48.1µs / 2.4 KB | **🔴 648µs** / None
Day 09 | 9.59ms / 651 KB | 289µs / 361 KB | 101µs / 89.3 KB | 239µs / None | 214µs / 19.5 KB | **🔴 387µs** / None
Day 10 | 1.17s / **🔴 312 MB** | 278µs / 90.7 KB | 210µs / 1.1 KB | 1.02µs / None | 64.2µs / 2.3 KB | 1.19µs / None
Day 11 | 98ms / 15.0 MB | 2.25s / **🔴 785 MB** | 165µs / None | 24.5ms / 2.0 MB | 243µs / 346 B | -
Day 12 | 546µs / 357 KB | 3.97µs / 5.8 KB | 1.62ms / 1.1 MB | 7.82µs / None | 8.63ms / 1.2 KB | -
Day 13 | 181ms / 7.2 MB | 193µs / 101 KB | **🔴 737ms** / 2.4 KB | 1.34µs / 256 B | 515µs / 265 KB | -
Day 14 | 907µs / 425 B | **🔴 8.83s** / 76.0 B | 40.5ms / **🔴 39.3 MB** | 6.87ms / 4.5 MB | 34µs / 1.8 KB | -
Day 15 | 77.4ms / 44.1 MB | 11.2ms / 432 B | **🔴 1.61s** / 32.0 B | **🔴 650ms** / **🔴 49.4 MB** | 119ms / **🔴 133 MB** | -
Day 16 | 525µs / 250 KB | 161ms / 67.1 MB | 34.1ms / 10.6 MB | 456µs / 141 KB | 13.9µs / 4.8 KB | -
Day 17 | 65.1ms / 84.1 MB | 44.3ms / 35.4 MB | 484ms / 16.1 KB | 72.9ms / **🔴 21.7 MB** | 1.92ms / None | -
Day 18 | 27ms / 56.4 KB | 533ms / 63.8 MB | 1ms / 4.0 KB | 252µs / None | 47.8ms / 15.5 MB | -
Day 19 | 1.62ms / 546 KB | 67ns / None | - | - | 20.7ms / 2.0 MB | -
Day 20 | **🔴 2.76s** / 126 MB | 177µs / 76.3 KB | - | - | 38.3ms / 2.0 MB | -
Day 21 | 61.7µs / 16.9 KB | 55ms / 4.4 MB | - | - | 1.7µs / 8.0 B | -
Day 22 | 749ms / **🔴 234 MB** | 23.9ms / 194 KB | - | - | 17ms / 2.3 MB | -
Day 23 | 9.35µs / 1.2 KB | 8.11µs / 21.1 KB | - | - | **🔴 1.56s** / **🔴 165 MB** | -
Day 24 | 14.1ms / 10.0 MB | 7.42ms / 3.8 MB | - | - | 15µs / 576 B | -
Day 25 | 525ns / 32.0 B | 11.8ms / 7.3 KB | - | - | 39.5ms / 19.4 KB | -
*Total* | *7.33s / 994 MB* | *21.2s / 1.7 GB* | *2.97s / 55.6 MB* | *756ms / 78.2 MB* | *1.85s / 321 MB* | *1.15ms / None*


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
Day 17 | **🔴 2m32s** | 1.77ms
Day 18 | 12.4ms | **🔴 17.4ms**
Day 19 | 25ms | -
Day 20 | 17.7ms | -
Day 21 | 4.29ms | 452µs
Day 22 | 200ms | -
Day 23 | 7.59s | -
Day 24 | 127ms | -
Day 25 | 43.8ms | -
*Total* | *2m41s* | *48.1ms*

