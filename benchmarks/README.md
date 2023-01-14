This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## 2022
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 17.4µs / None | 7.43µs / None
Day 02 | 4.47µs / None | 1.14µs / None
Day 03 | 51µs / None | 38.1µs / None
Day 04 | 19.1µs / None | 12.8µs / None
Day 05 | 12.9µs / None | 9.92µs / None
Day 06 | 7.05µs / None | 11.3µs / None
Day 07 | 29.9µs / None | 22.2µs / None
Day 08 | 680µs / None | 648µs / None
Day 09 | 394µs / None | 419µs / None
Day 10 | 1.7µs / None | 1.19µs / None
Day 11 | 14.1ms / None | 5.72ms / None
Day 12 | 572µs / None | 315µs / None
Day 13 | 553µs / 610 KB | 454µs / 391 KB
Day 14 | 6.41ms / None | 6.56ms / None
Day 15 | 5.35µs / 568 B | 2.22µs / None
Day 16 | **🔴 285ms** / **🔴 134 MB** | **🔴 378ms** / **🔴 35.7 MB**
Day 17 | 493µs / 229 KB | 347µs / None
Day 18 | 191µs / None | 222µs / None
Day 19 | **🔴 175ms** / **🔴 54.9 MB** | 63.7ms / **🔴 67.3 MB**
Day 20 | 45.6ms / None | 38.3ms / None
Day 21 | 404µs / 186 KB | 463µs / 270 KB
Day 22 | 897µs / None | 658µs / None
Day 23 | 99.9ms / 2.0 MB | 87.6ms / None
Day 24 | 127ms / 16.8 MB | **🔴 148ms** / 19.2 MB
Day 25 | 2.99µs / None | 7.29µs / None
*Total* | *757ms / 209 MB* | *731ms / 123 MB*

![Graph for year 2022](y2022.svg)

## 2021
 &nbsp;  | Crystal | Golang | Haskell | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 385µs** | 28.3µs / 81.9 KB | **🔴 2.54ms** | 27.2µs / None | 15.4µs
Day 02 | 109µs | 1.38µs / None | **🔴 1.86ms** | 1.67µs / None | 1.1µs
Day 03 | **🔴 237µs** | 49.6µs / None | **🔴 3.06ms** | 41.8µs / 2.0 KB | 85.2µs
Day 04 | - | 74.7µs / 79.2 KB | - | 118µs / 102 KB | 56.5µs
Day 05 | - | 1.05ms / 1.1 MB | - | 1.07ms / 8.2 KB | 1.12ms
Day 06 | - | 2.18µs / None | - | 1.23µs / 512 B | 1.1µs
Day 07 | - | 98.5µs / 8.2 KB | - | 35.5µs / 3.2 KB | 56.7µs
Day 08 | - | 233µs / 167 KB | - | 48.1µs / 2.4 KB | 2.01ms
Day 09 | - | 885µs / 238 KB | - | 214µs / 19.5 KB | 287µs
Day 10 | - | 61µs / 920 B | - | 64.2µs / 2.3 KB | 55µs
Day 11 | - | 735µs / 223 KB | - | 243µs / 346 B | 219µs
Day 12 | - | 996µs / 3.0 MB | - | 8.63ms / 1.2 KB | 255µs
Day 13 | - | 349µs / 22.7 KB | - | 515µs / 265 KB | 407µs
Day 14 | - | 348µs / 119 KB | - | 34µs / 1.8 KB | 135µs
Day 15 | - | 53.7ms / 2.5 MB | - | 119ms / **🔴 133 MB** | **🔴 22.8ms**
Day 16 | - | 25.5µs / 5.1 KB | - | 13.9µs / 4.8 KB | 534µs
Day 17 | - | 2.46ms / 64.0 B | - | 1.92ms / None | 1.76ms
Day 18 | - | 50.1ms / 4.8 MB | - | 47.8ms / 15.5 MB | **🔴 16.9ms**
Day 19 | - | **🔴 949ms** / 16.1 MB | - | 20.7ms / 2.0 MB | -
Day 20 | - | 27.3ms / 82.5 KB | - | 38.3ms / 2.0 MB | -
Day 21 | - | 1.96ms / 2.3 MB | - | 1.7µs / 8.0 B | 433µs
Day 22 | - | 9.41ms / 3.8 MB | - | 17ms / 2.3 MB | -
Day 23 | - | **🔴 520ms** / **🔴 199 MB** | - | **🔴 1.56s** / **🔴 165 MB** | -
Day 24 | - | 3.78µs / 656 B | - | 15µs / 576 B | -
Day 25 | - | 52.1ms / None | - | 39.5ms / 19.4 KB | -
*Total* | *732µs* | *1.67s / 234 MB* | *7.46ms* | *1.85s / 321 MB* | *47.1ms*

![Graph for year 2021](y2021.svg)

## 2020
 &nbsp;  | Crystal | Golang | Nim | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 407µs | 21.5ms / 14.1 MB | 522µs | 242µs / 144 KB | 587µs
Day 02 | 784µs | 819µs / 280 KB | 730µs | 68.4µs / 24.6 KB | 179µs
Day 03 | 525µs | 43.4µs / 16.3 KB | 122µs | 5.77µs / None | 27.3µs
Day 04 | 1.3ms | 595µs / 237 KB | 15.8ms | 90.2µs / None | 3.05ms
Day 05 | 1.09ms | 121µs / 51.9 KB | 316µs | 98.2µs / 12.4 KB | 261µs
Day 06 | 3.64ms | 1.76ms / 2.2 MB | 1.76ms | 31.3µs / None | 13.6ms
Day 07 | 1.48ms | 1.99ms / 648 KB | 2.46ms | 438µs / 281 KB | 1.2ms
Day 08 | 933µs | 2.46ms / 5.5 MB | 1.19ms | 96.9µs / None | 7.63ms
Day 09 | 328µs | 11.1ms / 44.0 MB | 1.59ms | 239µs / None | 256µs
Day 10 | 22.9µs | 76.5µs / 62.2 KB | 28.4µs | 1.02µs / None | 54.2µs
Day 11 | 103ms | 79.4ms / 4.6 MB | 36.5ms | 24.5ms / 2.0 MB | 38.8ms
Day 12 | 115µs | 181µs / 78.6 KB | 113µs | 7.82µs / None | 2.35ms
Day 13 | 126µs | 10.3µs / 5.1 KB | 24.9µs | 1.34µs / 256 B | 18.4µs
Day 14 | 6.02ms | 16.2ms / 7.4 MB | 12.1ms | 6.87ms / 4.5 MB | 9.59ms
Day 15 | 813ms | 670ms / **🔴 240 MB** | **🔴 837ms** | **🔴 650ms** / **🔴 49.4 MB** | 884ms
Day 16 | 1ms | 2.16ms / 1.1 MB | 1.57ms | 456µs / 141 KB | 1.97ms
Day 17 | 268ms | **🔴 835ms** / **🔴 338 MB** | 113ms | 71.4ms / **🔴 21.7 MB** | **🔴 2m29s**
Day 18 | 1.1ms | 20.4ms / 2.8 MB | 1.2ms | 252µs / None | 12.4ms
Day 19 | 7.69ms | 28ms / 6.6 MB | 212ms | 55.3ms / 14.0 MB | 24.6ms
Day 20 | 8.12ms | 12.1ms / 5.3 MB | 5.44ms | 385µs / 90.9 KB | 17.9ms
Day 21 | 1.46ms | 3.73ms / 438 KB | 2.3ms | 396µs / 121 KB | 4.34ms
Day 22 | 180ms | 93.1ms / 44.0 MB | 324ms | 60.8ms / 15.1 MB | 202ms
Day 23 | 1.57s | **🔴 1.55s** / 32.0 MB | **🔴 1.1s** | **🔴 504ms** / None | 8.66s
Day 24 | **🔴 13.9s** | 204ms / 7.9 MB | 181ms | 119ms / None | 127ms
Day 25 | 50.7ms | 48.4ms / 336 B | 48.7ms | 43.6ms / None | 43.6ms
*Total* | *16.9s* | *3.6s / 757 MB* | *2.9s* | *1.54s / 108 MB* | *2m39s*

![Graph for year 2020](y2020.svg)

## 2019
 &nbsp;  | C++ | Crystal | Golang | Nim | Rust
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 3.27µs | 19.5µs | 6.66µs / 3.4 KB | 15.7µs | 1.54µs / None
Day 02 | 877µs | 4.87ms | 2.52ms / 9.3 MB | 9.3ms | 2.27ms / None
Day 03 | 53ms | 30.2ms | 19.2ms / 10.0 MB | 31.9ms | 86.9µs / None
Day 04 | 3.4ms | 38.9ms | 2.64ms / 80.0 B | 86.2ms | 1ms / None
Day 05 | 52µs | 67.7µs | 32.5µs / 78.8 KB | 87.5µs | 6.51µs / None
Day 06 | 4.38µs | 6.23ms | 30.6ms / 18.4 MB | 91.4ms | 236µs / 163 KB
Day 07 | 8.32ms | 6.52ms | 2.71ms / 5.5 MB | 7.67ms | 805µs / 102 KB
Day 08 | 42µs | 245µs | 276µs / 29.7 KB | 29.1µs | 24µs / None
Day 09 | 81.6ms | 63.3ms | 14.2ms / 74.6 KB | 13.8ms | 4.32ms / None
Day 10 | 41.2ms | 15.5ms | 30.3ms / 11.3 MB | 29.7ms | 1.91ms / None
Day 11 | 24ms | 18.1ms | 7.38ms / 888 KB | 5.01ms | 1.3ms / None
Day 12 | 487ms | 2.53s | 15.8ms / 736 B | 435ms | 7.83ms / None
Day 13 | 177ms | 170ms | 35.8ms / 2.9 MB | 30.6ms | 15.5µs / None
Day 14 | 7.86ms | 13.4ms | 11.6ms / 281 KB | 7.99ms | 4.24ms / 409 KB
Day 15 | 46.4ms | 33.7ms | 12.6ms / 32.5 MB | 30.2ms | 28.1µs / None
Day 16 | 265ms | 541ms | **🔴 604ms** / 1.1 MB | 689ms | **🔴 271ms** / 524 KB
Day 17 | 26.6ms | 25.7ms | 5.52ms / 304 KB | 4.1ms | 13.4µs / None
Day 18 | **🔴 2.43s** | **🔴 19.1s** | **🔴 814ms** / **🔴 405 MB** | **🔴 1m8s** | **🔴 400ms** / **🔴 94.4 MB**
Day 19 | 583ms | 408ms | 105ms / 66.6 MB | 115ms | 12.3µs / None
Day 20 | 557ms | 483ms | 59.9ms / 64.4 MB | 867ms | 11.1ms / None
Day 21 | 125ms | 375ms | 23.8ms / 124 KB | 20.8ms | 12µs / None
Day 22 | 4.37µs | 146µs | 397µs / 111 KB | 48.1µs | 15µs / None
Day 23 | 74.6ms | 64.4ms | 14.9ms / 4.7 MB | 15.7ms | 24.2µs / None
Day 24 | 50.4ms | 79.1ms | 331ms / **🔴 196 MB** | 51.7ms | 10.4ms / None
Day 25 | **🔴 1.46s** | 1.93s | 212ms / 43.8 MB | 202ms | -
*Total* | *6.49s* | *25.9s* | *2.36s / 873 MB* | *1m10.8s* | *717ms / 95.6 MB*

![Graph for year 2019](y2019.svg)

## 2018
 &nbsp;  | Golang
 ---:  | ---: 
Day 01 | 19.7ms / 13.2 MB
Day 02 | 9.46ms / 2.8 MB
Day 03 | 195ms / 64.2 MB
Day 04 | 6.34ms / 400 KB
Day 05 | 447ms / 48.3 MB
Day 06 | 57.7ms / 19.5 KB
Day 07 | 293µs / 68.7 KB
Day 08 | 229ms / **🔴 1.2 GB**
Day 09 | 443ms / 167 MB
Day 10 | 1.31ms / 768 KB
Day 11 | 70.4ms / 721 KB
Day 12 | 1.49ms / 1.5 MB
Day 13 | 4.15ms / 2.9 MB
Day 14 | 480ms / 21.0 MB
Day 15 | 632ms / 251 MB
Day 16 | 13.4ms / 11.1 MB
Day 17 | 81.3ms / 12.1 MB
Day 18 | 115ms / 166 MB
Day 19 | 249ms / 27.0 KB
Day 20 | 25.3ms / 8.6 MB
Day 21 | 626ms / 452 KB
Day 22 | **🔴 6.54s** / 241 MB
Day 23 | 330ms / 1.7 MB
Day 24 | 157ms / 42.6 MB
Day 25 | 15.3ms / 997 KB
*Total* | *10.8s / 2.3 GB*

![Graph for year 2018](y2018.svg)

## 2017
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 40µs / 2.3 KB | 2.82µs / 16.4 KB
Day 02 | 31.3µs / 8.3 KB | 17.2µs / 2.0 KB
Day 03 | 31.5µs / 15.9 KB | 21.6µs / 14.3 KB
Day 04 | 2.59ms / 825 KB | 4.93ms / 2.0 MB
Day 05 | 151ms / 25.5 MB | 55.1ms / 24.9 KB
Day 06 | 24.3ms / 6.6 MB | 2.32ms / 1.8 MB
Day 07 | 3.06ms / 1.0 MB | 1.13ms / 523 KB
Day 08 | 672µs / 318 KB | 410µs / 38.2 KB
Day 09 | 185µs / 49.2 KB | 101µs / 89.3 KB
Day 10 | 1.74ms / 11.4 KB | 210µs / 1.1 KB
Day 11 | 236µs / 11.1 KB | 165µs / None
Day 12 | 4.43ms / 1.2 MB | 1.62ms / 1.1 MB
Day 13 | 117ms / 4.1 KB | **🔴 737ms** / 2.4 KB
Day 14 | 100ms / 1.7 MB | 40.5ms / **🔴 39.3 MB**
Day 15 | **🔴 1.16s** / 1.4 KB | **🔴 1.61s** / 32.0 B
Day 16 | 359ms / 82.8 MB | 34.1ms / 10.6 MB
Day 17 | 699ms / 48.5 KB | 484ms / 16.1 KB
Day 18 | 12.5ms / 5.5 MB | 939µs / 4.0 KB
Day 19 | 592µs / 44.8 KB | -
Day 20 | 364ms / **🔴 206 MB** | -
Day 21 | 111ms / 37.7 MB | -
Day 22 | 99.6ms / 526 KB | -
Day 23 | 3.51ms / 4.6 KB | -
Day 24 | 234ms / 59.9 MB | -
Day 25 | 55.7ms / 15.3 KB | -
*Total* | *3.5s / 430 MB* | *2.97s / 55.6 MB*

![Graph for year 2017](y2017.svg)

## 2016
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 125µs / 101 KB | 81.5µs / 34.9 KB
Day 02 | 17.8µs / 192 B | 140µs / 3.8 KB
Day 03 | 73.2µs / 49.2 KB | 501µs / 183 KB
Day 04 | 2.16ms / 642 KB | 2.98ms / 634 KB
Day 05 | **🔴 5.83s** / 3.2 KB | **🔴 9.21s** / **🔴 689 MB**
Day 06 | 236µs / 4.6 KB | 1.56ms / 5.8 KB
Day 07 | 1.47ms / 64.4 KB | 4.78ms / 1.0 MB
Day 08 | 6.25µs / 96.0 B | 24.5µs / 6.2 KB
Day 09 | 21.4µs / None | 289µs / 361 KB
Day 10 | 5.23ms / 5.5 MB | 278µs / 90.7 KB
Day 11 | 45.4ms / 16.8 MB | 2.25s / **🔴 785 MB**
Day 12 | 4.41µs / 3.0 KB | 3.97µs / 5.8 KB
Day 13 | 122µs / 82.1 KB | 193µs / 101 KB
Day 14 | **🔴 12.7s** / 33.1 KB | **🔴 8.25s** / 76.0 B
Day 15 | 53ms / 14.6 KB | 11.2ms / 432 B
Day 16 | 404ms / 17.8 MB | 161ms / 67.1 MB
Day 17 | 69.6ms / 52.5 MB | 44.3ms / 35.4 MB
Day 18 | 251ms / 224 B | 533ms / 63.8 MB
Day 19 | 521ms / **🔴 145 MB** | 67ns / None
Day 20 | 341µs / 120 KB | 177µs / 76.3 KB
Day 21 | 263ms / 48.2 MB | 55ms / 4.4 MB
Day 22 | 32.1ms / 391 KB | 23.9ms / 194 KB
Day 23 | 10.4µs / 9.0 KB | 8.11µs / 21.1 KB
Day 24 | 65.3ms / 27.3 MB | 7.42ms / 3.8 MB
Day 25 | 151ms / 17.9 KB | 11.8ms / 7.3 KB
*Total* | *20.4s / 314 MB* | *20.6s / 1.7 GB*

![Graph for year 2016](y2016.svg)

## 2015
 &nbsp;  | Crystal | Golang | Rust
 ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 62.2µs** | 29.1µs / None | 6.9µs / None
Day 02 | - | 757µs / 189 KB | 114µs / 16.0 KB
Day 03 | - | 741µs / 190 KB | 926µs / 279 KB
Day 04 | - | 1.39s / 56.0 B | **🔴 2.12s** / 159 MB
Day 05 | - | 531µs / 34.8 KB | 388µs / None
Day 06 | - | 121ms / 252 KB | 54.5ms / 19.2 KB
Day 07 | - | 319µs / 117 KB | 433µs / 148 KB
Day 08 | - | 30.9µs / 11.4 KB | 74.4µs / 29.6 KB
Day 09 | - | 14.6ms / 6.2 MB | 9.59ms / 651 KB
Day 10 | - | 118ms / 56.6 MB | 1.17s / **🔴 312 MB**
Day 11 | - | 50.8ms / 313 KB | 98ms / 15.0 MB
Day 12 | - | 77.9ms / 392 MB | 546µs / 357 KB
Day 13 | - | 148ms / 28.1 MB | 181ms / 7.2 MB
Day 14 | - | 305µs / 108 KB | 907µs / 425 B
Day 15 | - | 102ms / 67.5 MB | 77.4ms / 44.1 MB
Day 16 | - | 532µs / 262 KB | 525µs / 250 KB
Day 17 | - | 89.7ms / 3.0 KB | 65.1ms / 84.1 MB
Day 18 | - | 6.1ms / 42.8 KB | 27ms / 56.4 KB
Day 19 | - | 375µs / 413 KB | 1.62ms / 546 KB
Day 20 | - | **🔴 6.42s** / **🔴 493 MB** | **🔴 2.76s** / 126 MB
Day 21 | - | 629µs / 277 KB | 66.3µs / 16.9 KB
Day 22 | - | **🔴 2.65s** / **🔴 1.1 GB** | 749ms / **🔴 234 MB**
Day 23 | - | 45.6µs / 9.3 KB | 9.35µs / 1.2 KB
Day 24 | - | 233ms / 61.1 MB | 14.1ms / 10.0 MB
Day 25 | - | 7.59µs / 6.1 KB | 525ns / 32.0 B
*Total* | *62.2µs* | *11.4s / 2.2 GB* | *7.33s / 994 MB*

![Graph for year 2015](y2015.svg)

## C++
 &nbsp;  | 2019
 ---:  | ---: 
Day 01 | 3.27µs
Day 02 | 877µs
Day 03 | 53ms
Day 04 | 3.4ms
Day 05 | 52µs
Day 06 | 4.38µs
Day 07 | 8.32ms
Day 08 | 42µs
Day 09 | 81.6ms
Day 10 | 41.2ms
Day 11 | 24ms
Day 12 | 487ms
Day 13 | 177ms
Day 14 | 7.86ms
Day 15 | 46.4ms
Day 16 | 265ms
Day 17 | 26.6ms
Day 18 | **🔴 2.43s**
Day 19 | 583ms
Day 20 | 557ms
Day 21 | 125ms
Day 22 | 4.37µs
Day 23 | 74.6ms
Day 24 | 50.4ms
Day 25 | **🔴 1.46s**
*Total* | *6.49s*


## Crystal
 &nbsp;  | 2015 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 62.2µs** | 19.5µs | 407µs | **🔴 385µs**
Day 02 | - | 4.87ms | 784µs | 109µs
Day 03 | - | 30.2ms | 525µs | **🔴 237µs**
Day 04 | - | 38.9ms | 1.3ms | -
Day 05 | - | 67.7µs | 1.09ms | -
Day 06 | - | 6.23ms | 3.64ms | -
Day 07 | - | 6.52ms | 1.48ms | -
Day 08 | - | 245µs | 933µs | -
Day 09 | - | 63.3ms | 328µs | -
Day 10 | - | 15.5ms | 22.9µs | -
Day 11 | - | 18.1ms | 103ms | -
Day 12 | - | 2.53s | 115µs | -
Day 13 | - | 170ms | 126µs | -
Day 14 | - | 13.4ms | 6.02ms | -
Day 15 | - | 33.7ms | 813ms | -
Day 16 | - | 541ms | 1ms | -
Day 17 | - | 25.7ms | 268ms | -
Day 18 | - | **🔴 19.1s** | 1.1ms | -
Day 19 | - | 408ms | 7.69ms | -
Day 20 | - | 483ms | 8.12ms | -
Day 21 | - | 375ms | 1.46ms | -
Day 22 | - | 146µs | 180ms | -
Day 23 | - | 64.4ms | 1.57s | -
Day 24 | - | 79.1ms | **🔴 13.9s** | -
Day 25 | - | 1.93s | 50.7ms | -
*Total* | *62.2µs* | *25.9s* | *16.9s* | *732µs*


## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 29.1µs / None | 125µs / 101 KB | 40µs / 2.3 KB | 19.7ms / 13.2 MB | 6.66µs / 3.4 KB | 21.5ms / 14.1 MB | 28.3µs / 81.9 KB | 17.4µs / None
Day 02 | 757µs / 189 KB | 17.8µs / 192 B | 31.3µs / 8.3 KB | 9.46ms / 2.8 MB | 2.52ms / 9.3 MB | 819µs / 280 KB | 1.38µs / None | 4.47µs / None
Day 03 | 741µs / 190 KB | 73.2µs / 49.2 KB | 31.5µs / 15.9 KB | 195ms / 64.2 MB | 19.2ms / 10.0 MB | 43.4µs / 16.3 KB | 49.6µs / None | 51µs / None
Day 04 | 1.39s / 56.0 B | 2.16ms / 642 KB | 2.59ms / 825 KB | 6.34ms / 400 KB | 2.64ms / 80.0 B | 595µs / 237 KB | 74.7µs / 79.2 KB | 19.1µs / None
Day 05 | 531µs / 34.8 KB | **🔴 5.83s** / 3.2 KB | 151ms / 25.5 MB | 447ms / 48.3 MB | 32.5µs / 78.8 KB | 121µs / 51.9 KB | 1.05ms / 1.1 MB | 12.9µs / None
Day 06 | 121ms / 252 KB | 236µs / 4.6 KB | 24.3ms / 6.6 MB | 57.7ms / 19.5 KB | 30.6ms / 18.4 MB | 1.76ms / 2.2 MB | 2.18µs / None | 7.05µs / None
Day 07 | 319µs / 117 KB | 1.47ms / 64.4 KB | 3.06ms / 1.0 MB | 293µs / 68.7 KB | 2.71ms / 5.5 MB | 1.99ms / 648 KB | 98.5µs / 8.2 KB | 29.9µs / None
Day 08 | 30.9µs / 11.4 KB | 6.25µs / 96.0 B | 672µs / 318 KB | 229ms / **🔴 1.2 GB** | 276µs / 29.7 KB | 2.46ms / 5.5 MB | 233µs / 167 KB | 680µs / None
Day 09 | 14.6ms / 6.2 MB | 21.4µs / None | 185µs / 49.2 KB | 443ms / 167 MB | 14.2ms / 74.6 KB | 11.1ms / 44.0 MB | 885µs / 238 KB | 394µs / None
Day 10 | 118ms / 56.6 MB | 5.23ms / 5.5 MB | 1.74ms / 11.4 KB | 1.31ms / 768 KB | 30.3ms / 11.3 MB | 76.5µs / 62.2 KB | 61µs / 920 B | 1.7µs / None
Day 11 | 50.8ms / 313 KB | 45.4ms / 16.8 MB | 236µs / 11.1 KB | 70.4ms / 721 KB | 7.38ms / 888 KB | 79.4ms / 4.6 MB | 735µs / 223 KB | 14.1ms / None
Day 12 | 77.9ms / 392 MB | 4.41µs / 3.0 KB | 4.43ms / 1.2 MB | 1.49ms / 1.5 MB | 15.8ms / 736 B | 181µs / 78.6 KB | 996µs / 3.0 MB | 572µs / None
Day 13 | 148ms / 28.1 MB | 122µs / 82.1 KB | 117ms / 4.1 KB | 4.15ms / 2.9 MB | 35.8ms / 2.9 MB | 10.3µs / 5.1 KB | 349µs / 22.7 KB | 553µs / 610 KB
Day 14 | 305µs / 108 KB | **🔴 12.7s** / 33.1 KB | 100ms / 1.7 MB | 480ms / 21.0 MB | 11.6ms / 281 KB | 16.2ms / 7.4 MB | 348µs / 119 KB | 6.41ms / None
Day 15 | 102ms / 67.5 MB | 53ms / 14.6 KB | **🔴 1.16s** / 1.4 KB | 632ms / 251 MB | 12.6ms / 32.5 MB | 670ms / **🔴 240 MB** | 53.7ms / 2.5 MB | 5.35µs / 568 B
Day 16 | 532µs / 262 KB | 404ms / 17.8 MB | 359ms / 82.8 MB | 13.4ms / 11.1 MB | **🔴 604ms** / 1.1 MB | 2.16ms / 1.1 MB | 25.5µs / 5.1 KB | **🔴 285ms** / **🔴 134 MB**
Day 17 | 89.7ms / 3.0 KB | 69.6ms / 52.5 MB | 699ms / 48.5 KB | 81.3ms / 12.1 MB | 5.52ms / 304 KB | **🔴 835ms** / **🔴 338 MB** | 2.46ms / 64.0 B | 493µs / 229 KB
Day 18 | 6.1ms / 42.8 KB | 251ms / 224 B | 12.5ms / 5.5 MB | 115ms / 166 MB | **🔴 814ms** / **🔴 405 MB** | 20.4ms / 2.8 MB | 50.1ms / 4.8 MB | 191µs / None
Day 19 | 375µs / 413 KB | 521ms / **🔴 145 MB** | 592µs / 44.8 KB | 249ms / 27.0 KB | 105ms / 66.6 MB | 28ms / 6.6 MB | **🔴 949ms** / 16.1 MB | **🔴 175ms** / **🔴 54.9 MB**
Day 20 | **🔴 6.42s** / **🔴 493 MB** | 341µs / 120 KB | 364ms / **🔴 206 MB** | 25.3ms / 8.6 MB | 59.9ms / 64.4 MB | 12.1ms / 5.3 MB | 27.3ms / 82.5 KB | 45.6ms / None
Day 21 | 629µs / 277 KB | 263ms / 48.2 MB | 111ms / 37.7 MB | 626ms / 452 KB | 23.8ms / 124 KB | 3.73ms / 438 KB | 1.96ms / 2.3 MB | 404µs / 186 KB
Day 22 | **🔴 2.65s** / **🔴 1.1 GB** | 32.1ms / 391 KB | 99.6ms / 526 KB | **🔴 6.54s** / 241 MB | 397µs / 111 KB | 93.1ms / 44.0 MB | 9.41ms / 3.8 MB | 897µs / None
Day 23 | 45.6µs / 9.3 KB | 10.4µs / 9.0 KB | 3.51ms / 4.6 KB | 330ms / 1.7 MB | 14.9ms / 4.7 MB | **🔴 1.55s** / 32.0 MB | **🔴 520ms** / **🔴 199 MB** | 99.9ms / 2.0 MB
Day 24 | 233ms / 61.1 MB | 65.3ms / 27.3 MB | 234ms / 59.9 MB | 157ms / 42.6 MB | 331ms / **🔴 196 MB** | 204ms / 7.9 MB | 3.78µs / 656 B | 127ms / 16.8 MB
Day 25 | 7.59µs / 6.1 KB | 151ms / 17.9 KB | 55.7ms / 15.3 KB | 15.3ms / 997 KB | 212ms / 43.8 MB | 48.4ms / 336 B | 52.1ms / None | 2.99µs / None
*Total* | *11.4s / 2.2 GB* | *20.4s / 314 MB* | *3.5s / 430 MB* | *10.8s / 2.3 GB* | *2.36s / 873 MB* | *3.6s / 757 MB* | *1.67s / 234 MB* | *757ms / 209 MB*


## Haskell
 &nbsp;  | 2021
 ---:  | ---: 
Day 01 | **🔴 2.54ms**
Day 02 | **🔴 1.86ms**
Day 03 | **🔴 3.06ms**
Day 04 | -
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
*Total* | *7.46ms*


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
 &nbsp;  | 2015 | 2016 | 2017 | 2019 | 2020 | 2021 | 2022
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 6.9µs / None | 81.5µs / 34.9 KB | 2.82µs / 16.4 KB | 1.54µs / None | 242µs / 144 KB | 27.2µs / None | 7.43µs / None
Day 02 | 114µs / 16.0 KB | 140µs / 3.8 KB | 17.2µs / 2.0 KB | 2.27ms / None | 68.4µs / 24.6 KB | 1.67µs / None | 1.14µs / None
Day 03 | 926µs / 279 KB | 501µs / 183 KB | 21.6µs / 14.3 KB | 86.9µs / None | 5.77µs / None | 41.8µs / 2.0 KB | 38.1µs / None
Day 04 | **🔴 2.12s** / 159 MB | 2.98ms / 634 KB | 4.93ms / 2.0 MB | 1ms / None | 90.2µs / None | 118µs / 102 KB | 12.8µs / None
Day 05 | 388µs / None | **🔴 9.21s** / **🔴 689 MB** | 55.1ms / 24.9 KB | 6.51µs / None | 98.2µs / 12.4 KB | 1.07ms / 8.2 KB | 9.92µs / None
Day 06 | 54.5ms / 19.2 KB | 1.56ms / 5.8 KB | 2.32ms / 1.8 MB | 236µs / 163 KB | 31.3µs / None | 1.23µs / 512 B | 11.3µs / None
Day 07 | 433µs / 148 KB | 4.78ms / 1.0 MB | 1.13ms / 523 KB | 805µs / 102 KB | 438µs / 281 KB | 35.5µs / 3.2 KB | 22.2µs / None
Day 08 | 74.4µs / 29.6 KB | 24.5µs / 6.2 KB | 410µs / 38.2 KB | 24µs / None | 96.9µs / None | 48.1µs / 2.4 KB | 648µs / None
Day 09 | 9.59ms / 651 KB | 289µs / 361 KB | 101µs / 89.3 KB | 4.32ms / None | 239µs / None | 214µs / 19.5 KB | 419µs / None
Day 10 | 1.17s / **🔴 312 MB** | 278µs / 90.7 KB | 210µs / 1.1 KB | 1.91ms / None | 1.02µs / None | 64.2µs / 2.3 KB | 1.19µs / None
Day 11 | 98ms / 15.0 MB | 2.25s / **🔴 785 MB** | 165µs / None | 1.3ms / None | 24.5ms / 2.0 MB | 243µs / 346 B | 5.72ms / None
Day 12 | 546µs / 357 KB | 3.97µs / 5.8 KB | 1.62ms / 1.1 MB | 7.83ms / None | 7.82µs / None | 8.63ms / 1.2 KB | 315µs / None
Day 13 | 181ms / 7.2 MB | 193µs / 101 KB | **🔴 737ms** / 2.4 KB | 15.5µs / None | 1.34µs / 256 B | 515µs / 265 KB | 454µs / 391 KB
Day 14 | 907µs / 425 B | **🔴 8.25s** / 76.0 B | 40.5ms / **🔴 39.3 MB** | 4.24ms / 409 KB | 6.87ms / 4.5 MB | 34µs / 1.8 KB | 6.56ms / None
Day 15 | 77.4ms / 44.1 MB | 11.2ms / 432 B | **🔴 1.61s** / 32.0 B | 28.1µs / None | **🔴 650ms** / **🔴 49.4 MB** | 119ms / **🔴 133 MB** | 2.22µs / None
Day 16 | 525µs / 250 KB | 161ms / 67.1 MB | 34.1ms / 10.6 MB | **🔴 271ms** / 524 KB | 456µs / 141 KB | 13.9µs / 4.8 KB | **🔴 378ms** / **🔴 35.7 MB**
Day 17 | 65.1ms / 84.1 MB | 44.3ms / 35.4 MB | 484ms / 16.1 KB | 13.4µs / None | 71.4ms / **🔴 21.7 MB** | 1.92ms / None | 347µs / None
Day 18 | 27ms / 56.4 KB | 533ms / 63.8 MB | 939µs / 4.0 KB | **🔴 400ms** / **🔴 94.4 MB** | 252µs / None | 47.8ms / 15.5 MB | 222µs / None
Day 19 | 1.62ms / 546 KB | 67ns / None | - | 12.3µs / None | 55.3ms / 14.0 MB | 20.7ms / 2.0 MB | 63.7ms / **🔴 67.3 MB**
Day 20 | **🔴 2.76s** / 126 MB | 177µs / 76.3 KB | - | 11.1ms / None | 385µs / 90.9 KB | 38.3ms / 2.0 MB | 38.3ms / None
Day 21 | 66.3µs / 16.9 KB | 55ms / 4.4 MB | - | 12µs / None | 396µs / 121 KB | 1.7µs / 8.0 B | 463µs / 270 KB
Day 22 | 749ms / **🔴 234 MB** | 23.9ms / 194 KB | - | 15µs / None | 60.8ms / 15.1 MB | 17ms / 2.3 MB | 658µs / None
Day 23 | 9.35µs / 1.2 KB | 8.11µs / 21.1 KB | - | 24.2µs / None | **🔴 504ms** / None | **🔴 1.56s** / **🔴 165 MB** | 87.6ms / None
Day 24 | 14.1ms / 10.0 MB | 7.42ms / 3.8 MB | - | 10.4ms / None | 119ms / None | 15µs / 576 B | **🔴 148ms** / 19.2 MB
Day 25 | 525ns / 32.0 B | 11.8ms / 7.3 KB | - | - | 43.6ms / None | 39.5ms / 19.4 KB | 7.29µs / None
*Total* | *7.33s / 994 MB* | *20.6s / 1.7 GB* | *2.97s / 55.6 MB* | *717ms / 95.6 MB* | *1.54s / 108 MB* | *1.85s / 321 MB* | *731ms / 123 MB*


## Zig
 &nbsp;  | 2020 | 2021
 ---:  | ---:  | ---: 
Day 01 | 587µs | 15.4µs
Day 02 | 179µs | 1.1µs
Day 03 | 27.3µs | 85.2µs
Day 04 | 3.05ms | 56.5µs
Day 05 | 261µs | 1.12ms
Day 06 | 13.6ms | 1.1µs
Day 07 | 1.2ms | 56.7µs
Day 08 | 7.63ms | 2.01ms
Day 09 | 256µs | 287µs
Day 10 | 54.2µs | 55µs
Day 11 | 38.8ms | 219µs
Day 12 | 2.35ms | 255µs
Day 13 | 18.4µs | 407µs
Day 14 | 9.59ms | 135µs
Day 15 | 884ms | **🔴 22.8ms**
Day 16 | 1.97ms | 534µs
Day 17 | **🔴 2m29s** | 1.76ms
Day 18 | 12.4ms | **🔴 16.9ms**
Day 19 | 24.6ms | -
Day 20 | 17.9ms | -
Day 21 | 4.34ms | 433µs
Day 22 | 202ms | -
Day 23 | 8.66s | -
Day 24 | 127ms | -
Day 25 | 43.6ms | -
*Total* | *2m39s* | *47.1ms*

