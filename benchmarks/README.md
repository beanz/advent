This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## 2024
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 47.2µs / None | 18.2µs / None | 30µs / None
Day 02 | 47.5µs / None | 42.4µs / None | 24.8µs / None
Day 03 | 29.1µs / None | 12.5µs / None | 24.6µs / None
Day 04 | 272µs / None | 401µs / None | 148µs / None
Day 05 | 30.5µs / None | 16.1µs / None | 13.4µs / None
Day 06 | 4.94ms / None | 4.25ms / None | 4.34ms / None
Day 07 | 288µs / None | 242µs / None | 214µs / None
Day 08 | 6.79µs / None | 4.21µs / None | 3.76µs / None
Day 09 | 462µs / None | 587µs / None | 376µs / None
Day 10 | 114µs / None | 81.1µs / None | 1.79ms / None
Day 11 | 1.38ms / None | 985µs / None | 1.14ms / None
Day 12 | 591µs / None | 436µs / None | 12.8ms / None
Day 13 | 7.22µs / 48.0 B | 5.35µs / None | 4.63µs / None
Day 14 | 268µs / 32.0 B | 3.3ms / None | 4.7ms / None
Day 15 | 606µs / None | 1.23ms / None | 1.17ms / None
Day 16 | 565µs / None | 5.53ms / None | 8.51ms / None
Day 17 | 19.4µs / 24.0 B | 185µs / None | 77.8µs / None
Day 18 | 206µs / 32.0 B | 111µs / None | 125µs / None
Day 19 | 1.4ms / None | 1.8ms / None | 2.14ms / 20.6 KB
Day 20 | **🔴 19.9ms** / None | **🔴 27.8ms** / None | **🔴 21ms** / None
Day 21 | 63ns / None | 27ns / None | 17.4µs / 4.3 KB
Day 22 | **🔴 11.2ms** / None | **🔴 48.3ms** / None | **🔴 33ms** / **🔴 1.1 MB**
Day 23 | **🔴 12.7ms** / 48.0 B | 511µs / None | 479µs / None
Day 24 | 42.5µs / **🔴 14.3 KB** | 77.7µs / None | 102µs / 40.3 KB
Day 25 | 279µs / None | 204µs / None | 183µs / None
*Total* | *55.4ms / 14.5 KB* | *96.2ms / None* | *92.4ms / 1.2 MB*

![Graph for year 2024](y2024.svg)

## 2023
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 198µs / None | 87.8µs / None | 81.9µs / None
Day 02 | 7.3µs / None | 2.66µs / None | 2.3µs / None
Day 03 | 30.3µs / None | 24.5µs / None | 20.5µs / None
Day 04 | 34.3µs / 256 B | 17.2µs / None | 53.3µs / None
Day 05 | 60.8µs / 10.8 KB | 10.9µs / None | 655µs / None
Day 06 | 135ns / None | 125ns / None | 82ns / None
Day 07 | 371µs / 49.4 KB | 42.9µs / 48.0 KB | 99.7µs / None
Day 08 | 939µs / 426 KB | 2.25ms / None | 435µs / None
Day 09 | 38.2µs / None | 21.7µs / None | 17.7µs / None
Day 10 | 1.19ms / 891 KB | 101µs / None | 94.3µs / None
Day 11 | 13.2µs / None | 11.8µs / None | 4.16µs / None
Day 12 | 11.2ms / None | 15.9ms / None | 14.3ms / None
Day 13 | 111µs / 2.7 KB | 56.7µs / None | 71.8µs / None
Day 14 | 17.7ms / 16.4 KB | 14.9ms / 0.2 B | 13.4ms / **🔴 3.4 KB**
Day 15 | 141µs / 58.1 KB | 65.7µs / None | 70.2µs / None
Day 16 | 21.8ms / 98.3 KB | 11.4ms / None | 48.6ms / None
Day 17 | **🔴 223ms** / **🔴 13.2 MB** | **🔴 275ms** / **🔴 9.3 MB** | 2.31ms / None
Day 18 | 6.73µs / None | 2.85µs / None | 4.48µs / None
Day 19 | 288µs / 245 KB | 128µs / None | 1.31ms / None
Day 20 | 1.44ms / 2.9 KB | 3.11ms / None | 2.6µs / None
Day 21 | 28.9ms / 62.0 KB | 12.6ms / None | 593µs / None
Day 22 | 5.13ms / 1.1 MB | 1.38ms / 14.5 KB | 1.12ms / None
Day 23 | **🔴 516ms** / 2.7 MB | **🔴 284ms** / None | **🔴 230ms** / None
Day 24 | - | - | 402µs / None
Day 25 | 47.1ms / **🔴 21.2 MB** | 7.1ms / None | 189µs / None
*Total* | *876ms / 40.1 MB* | *628ms / 9.4 MB* | *314ms / 3.4 KB*

![Graph for year 2023](y2023.svg)

## 2022
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 8.96µs / None | 7.09µs / None | 5.4µs / None
Day 02 | 1.89µs / None | 608ns / None | 1.03µs / None
Day 03 | 23.7µs / None | 18.5µs / None | 8.35µs / None
Day 04 | 8.87µs / None | 5.67µs / None | 6.02µs / None
Day 05 | 4.76µs / None | 3.28µs / None | 3.01µs / None
Day 06 | 4.73µs / None | 5.2µs / None | 4.53µs / None
Day 07 | 14.2µs / None | 8.26µs / None | 7.35µs / None
Day 08 | 388µs / None | 288µs / None | 253µs / None
Day 09 | 233µs / None | 180µs / None | 224µs / None
Day 10 | 809ns / None | 597ns / None | 600ns / None
Day 11 | 3.69ms / None | 2.11ms / None | 2.46ms / None
Day 12 | 208µs / None | 116µs / None | 58.4µs / None
Day 13 | 764µs / 610 KB | 249µs / 391 KB | 5µs / None
Day 14 | 3.11ms / None | 3.28ms / None | 2.67ms / None
Day 15 | 1.9µs / 568 B | 1.07µs / None | 919ns / None
Day 16 | **🔴 141ms** / **🔴 134 MB** | **🔴 164ms** / **🔴 35.7 MB** | **🔴 198ms** / **🔴 52.4 MB**
Day 17 | 468µs / 229 KB | 159µs / None | 163µs / 102 KB
Day 18 | 94.4µs / None | 79.3µs / None | 82.5µs / None
Day 19 | **🔴 130ms** / **🔴 55.0 MB** | 24.3ms / **🔴 58.3 MB** | 11.2ms / None
Day 20 | 37.4ms / None | 23.9ms / None | 35.7ms / None
Day 21 | 284µs / 186 KB | 193µs / 270 KB | 78.4µs / None
Day 22 | 275µs / None | 310µs / None | 848µs / None
Day 23 | 60.9ms / 2.0 MB | 45.3ms / None | 64.6ms / None
Day 24 | 78.8ms / 16.8 MB | **🔴 70.8ms** / 19.2 MB | 77.1ms / **🔴 18.9 MB**
Day 25 | 1.66µs / None | 1.41µs / None | 1.15µs / None
*Total* | *457ms / 209 MB* | *335ms / 114 MB* | *394ms / 71.4 MB*

![Graph for year 2022](y2022.svg)

## 2021
 &nbsp;  | Crystal | Golang | Haskell | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 207µs** | 59.8µs / 81.9 KB | **🔴 1.18ms** | 15.7µs / None | 4.83µs / None
Day 02 | 48.4µs | 855ns / None | **🔴 713µs** | 985ns / None | 778ns / None
Day 03 | **🔴 113µs** | 23.9µs / None | **🔴 1.08ms** | 17.6µs / 2.0 KB | 38.7µs / None
Day 04 | - | 122µs / 79.2 KB | - | 50µs / 102 KB | 6.5µs / None
Day 05 | - | 2.13ms / 1.1 MB | - | 441µs / 8.2 KB | 708µs / None
Day 06 | - | 999ns / None | - | 966ns / 512 B | 412ns / None
Day 07 | - | 48.9µs / 8.2 KB | - | 7.45µs / 2.0 KB | 9.57µs / None
Day 08 | - | 260µs / 167 KB | - | 11.8µs / 2.4 KB | 14.8µs / None
Day 09 | - | 539µs / 238 KB | - | 94.1µs / 18.5 KB | 100µs / None
Day 10 | - | 13.4µs / 920 B | - | 28.5µs / 2.1 KB | 10.7µs / None
Day 11 | - | 466µs / 223 KB | - | 123µs / 319 B | 65.7µs / None
Day 12 | - | 1.79ms / 3.0 MB | - | 3.84ms / 1.2 KB | 46.3µs / None
Day 13 | - | 205µs / 22.7 KB | - | 243µs / 265 KB | 32µs / None
Day 14 | - | 270µs / 119 KB | - | 14.2µs / 1.8 KB | 10µs / None
Day 15 | - | 31.4ms / 2.5 MB | - | 49.1ms / **🔴 133 MB** | 11.2ms / None
Day 16 | - | 9.8µs / 5.1 KB | - | 5.69µs / 4.8 KB | 4.54µs / None
Day 17 | - | 1.29ms / 64.0 B | - | 1.56ms / None | 1.49ms / None
Day 18 | - | 27.8ms / 4.8 MB | - | 22.2ms / 15.5 MB | 2.11ms / None
Day 19 | - | **🔴 525ms** / 16.4 MB | - | 10.2ms / 2.0 MB | 14ms / 7.3 KB
Day 20 | - | 15.5ms / 82.5 KB | - | 17.8ms / 2.0 MB | 2.11ms / None
Day 21 | - | 2.58ms / 2.3 MB | - | 1.04µs / 8.0 B | 983ns / None
Day 22 | - | 7.48ms / 3.8 MB | - | 12.9ms / 2.3 MB | 20.8ms / None
Day 23 | - | **🔴 252ms** / **🔴 155 MB** | - | **🔴 635ms** / **🔴 165 MB** | **🔴 291ms** / **🔴 107 MB**
Day 24 | - | 1.73µs / 656 B | - | 7.7µs / 576 B | 445ns / None
Day 25 | - | 32.9ms / None | - | 27.3ms / 19.4 KB | 267µs / None
*Total* | *368µs* | *902ms / 189 MB* | *2.97ms* | *781ms / 321 MB* | *344ms / 107 MB*

![Graph for year 2021](y2021.svg)

## 2020
 &nbsp;  | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 240µs | 19.7ms / 14.1 MB | 137µs / 144 KB | 360µs / 93.9 KB
Day 02 | 392µs | 511µs / 280 KB | 23.9µs / 24.6 KB | 51.5µs / None
Day 03 | 289µs | 22.5µs / 16.3 KB | 2.53µs / None | 10.1µs / 21.9 KB
Day 04 | 743µs | 429µs / 237 KB | 47.7µs / None | 6.38µs / 448 B
Day 05 | 488µs | 100µs / 51.9 KB | 56.2µs / 12.4 KB | 159µs / 118 KB
Day 06 | 1.88ms | 3.62ms / 4.0 MB | 16.3µs / None | 70µs / 3.1 KB
Day 07 | 690µs | 1.32ms / 692 KB | 231µs / 281 KB | -
Day 08 | 477µs | 4.41ms / 5.5 MB | 70µs / None | 4.85ms / 3.1 MB
Day 09 | 148µs | 19.2ms / 44.0 MB | 58.2µs / None | 112µs / 34.4 KB
Day 10 | 10.3µs | 93.1µs / 62.2 KB | 713ns / None | 31.6µs / 8.8 KB
Day 11 | 39.1ms | 45ms / 4.6 MB | 13.8ms / 2.0 MB | 14.9ms / 43.5 KB
Day 12 | 48.4µs | 130µs / 78.6 KB | 2.82µs / None | 1.27ms / 90.3 KB
Day 13 | 92µs | 8.25µs / 5.1 KB | - | 9.96µs / 416 B
Day 14 | 2.98ms | 10.6ms / 7.4 MB | 3.12ms / 4.5 MB | -
Day 15 | 367ms | 397ms / **🔴 240 MB** | **🔴 378ms** / **🔴 49.4 MB** | 573ms / **🔴 240 MB**
Day 16 | 614µs | 1.8ms / 1.1 MB | 244µs / 141 KB | -
Day 17 | 162ms | **🔴 540ms** / **🔴 338 MB** | 31.5ms / **🔴 21.7 MB** | **🔴 1m11.8s** / 937 KB
Day 18 | 593µs | 10.9ms / 2.8 MB | 143µs / None | 8.4ms / 1.2 MB
Day 19 | 3.87ms | 17.8ms / 6.9 MB | 33.3ms / 14.0 MB | -
Day 20 | 4.69ms | 7.98ms / 5.3 MB | 111µs / 90.9 KB | 10.7ms / 285 KB
Day 21 | 850µs | 2.25ms / 438 KB | 215µs / 121 KB | -
Day 22 | 118ms | 76.7ms / 44.0 MB | 31.3ms / 15.1 MB | 6.33µs / 1.5 KB
Day 23 | 1.01s | **🔴 677ms** / 32.0 MB | **🔴 165ms** / None | 5.59s / 48.0 MB
Day 24 | **🔴 6.1s** | 131ms / 7.9 MB | 44.8ms / None | 76.7ms / 6.2 MB
Day 25 | 38.9ms | 40ms / 320 B | 35ms / None | 35.2ms / 160 B
*Total* | *7.86s* | *2.01s / 760 MB* | *737ms / 108 MB* | *1m18.1s / 300 MB*

![Graph for year 2020](y2020.svg)

## 2019
 &nbsp;  | C++ | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 1.39µs | 9.07µs | 5.45µs / 3.4 KB | 1.11µs / None | 963ns / None
Day 02 | 600µs | 2.97ms | 4.87ms / 9.3 MB | 1.83ms / None | 5.92µs / None
Day 03 | 25.2ms | 13.9ms | 7.07ms / 10.0 MB | 36.1µs / None | 84.3µs / None
Day 04 | 1.69ms | 24.4ms | 1.15ms / 80.0 B | 663µs / None | 905ns / None
Day 05 | 24.8µs | 46.4µs | 58.9µs / 78.8 KB | 2.45µs / None | 2.33µs / None
Day 06 | 2.23µs | 2.78ms | 31.8ms / 18.4 MB | 131µs / 163 KB | 23.9µs / None
Day 07 | 3.66ms | 5.24ms | 3.48ms / 5.5 MB | 471µs / 102 KB | 8.19µs / None
Day 08 | 29.6µs | 137µs | 170µs / 29.7 KB | 18.4µs / None | 14.8µs / None
Day 09 | 36.2ms | 51ms | 2.8ms / 74.6 KB | 1.65ms / None | 3.33µs / None
Day 10 | 21.8ms | 8.09ms | 15.1ms / 11.3 MB | 1.03ms / None | 758µs / None
Day 11 | 11.5ms | 11.3ms | 2.95ms / 888 KB | 436µs / None | 218µs / 33.0 KB
Day 12 | 157ms | 122ms | 9.72ms / 736 B | 4.39ms / None | 3.49ms / None
Day 13 | 76.6ms | 98.8ms | 9.13ms / 2.9 MB | 5.67µs / None | 5.42µs / None
Day 14 | 2.94ms | 5.82ms | 6.08ms / 281 KB | 1.91ms / 409 KB | 503µs / None
Day 15 | 21.8ms | 29.6ms | 19.5ms / 32.5 MB | 7.21µs / None | 7.23µs / None
Day 16 | 160ms | 231ms | 179ms / 1.1 MB | **🔴 122ms** / 524 KB | 101ms / None
Day 17 | 11.8ms | 14.1ms | 1.11ms / 303 KB | 5.68µs / None | 3.61µs / None
Day 18 | - | **🔴 9.25s** | **🔴 508ms** / **🔴 405 MB** | **🔴 125ms** / **🔴 94.4 MB** | **🔴 691ms** / **🔴 254 MB**
Day 19 | 276ms | 275ms | 83.8ms / 66.6 MB | 5.69µs / None | 7.45µs / None
Day 20 | 276ms | 236ms | 58.5ms / 64.4 MB | 5.13ms / None | 6.81ms / None
Day 21 | 57.8ms | 70.4ms | 4.78ms / 124 KB | 5.41µs / None | 4.25µs / None
Day 22 | 2.09µs | 92µs | 211µs / 110 KB | 2.62µs / None | 2.03µs / None
Day 23 | 34.4ms | 34.6ms | 7.34ms / 4.7 MB | 10.6µs / None | 8.52µs / None
Day 24 | 21.2ms | 33.8ms | 225ms / **🔴 195 MB** | 2.34ms / None | 2.58ms / 696 B
Day 25 | **🔴 825ms** | 1.44s | 84.9ms / 50.8 MB | 10.5µs / None | 10.5µs / None
*Total* | *2.02s* | *12s* | *1.27s / 880 MB* | *267ms / 95.6 MB* | *807ms / 254 MB*

![Graph for year 2019](y2019.svg)

## 2018
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 645µs / None | 648µs / None | 651µs / None
Day 02 | 5.04ms / 2.8 MB | 470µs / None | 49.5µs / None
Day 03 | 88.5ms / 64.2 MB | 4.07ms / None | 2.07ms / None
Day 04 | 2.85ms / 399 KB | 7.71µs / None | 8.02µs / None
Day 05 | 256ms / 48.3 MB | 5.09ms / None | 2.98ms / None
Day 06 | 30.1ms / 19.4 KB | 6.22ms / None | 5.91ms / None
Day 07 | 183µs / 68.6 KB | 4.11µs / None | 2.73µs / None
Day 08 | 249µs / 162 KB | 66.4µs / None | 54.3µs / None
Day 09 | 203ms / 167 MB | 43.2ms / **🔴 64.0 MB** | 33.2ms / **🔴 64.0 MB**
Day 10 | 1.24ms / 768 KB | 5.14µs / None | 5.34µs / None
Day 11 | 27.8ms / 721 KB | 2.24ms / None | 1.92ms / None
Day 12 | 1.91ms / 1.5 MB | 55.7µs / None | 30.3µs / None
Day 13 | 5.81ms / 2.9 MB | 3.35ms / None | 12.4ms / 1.2 KB
Day 14 | 118ms / 21.0 MB | **🔴 103ms** / **🔴 33.6 MB** | 171ms / **🔴 20.5 MB**
Day 15 | 435ms / **🔴 261 MB** | **🔴 145ms** / 11.5 KB | 134ms / None
Day 16 | 16.4ms / 10.1 MB | 112µs / None | 119µs / None
Day 17 | 45.8ms / 12.1 MB | 781µs / None | **🔴 1.29s** / 1.0 B
Day 18 | 178ms / 166 MB | 21.8ms / None | 10.3ms / 12.7 KB
Day 19 | 65.7ms / 27.0 KB | 41.8ms / None | 8.23µs / None
Day 20 | 28.9ms / 8.5 MB | 163µs / None | 183µs / None
Day 21 | 262ms / 448 KB | 125µs / None | 144µs / 328 KB
Day 22 | **🔴 943ms** / **🔴 229 MB** | 13.3ms / None | 2.43ms / None
Day 23 | 162ms / 1.7 MB | 61.5ms / None | 33.8ms / None
Day 24 | 94.3ms / 42.6 MB | 45.5ms / None | 4.57ms / None
Day 25 | 8.5ms / 992 KB | 1.89ms / None | 642µs / None
*Total* | *2.98s / 1.0 GB* | *501ms / 97.6 MB* | *1.7s / 84.8 MB*

![Graph for year 2018](y2018.svg)

## 2017
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 10.7µs / 2.3 KB | 7.09µs / 16.4 KB | 2.9µs / None
Day 02 | 17.1µs / 8.3 KB | 7.69µs / 2.0 KB | 3.8µs / None
Day 03 | 27.9µs / 15.9 KB | 7.91µs / 14.3 KB | 23.8µs / None
Day 04 | 1.57ms / 825 KB | 2.69ms / 2.0 MB | 377µs / None
Day 05 | 80.1ms / 25.5 MB | 39.5ms / 24.9 KB | 48.8ms / None
Day 06 | 16.1ms / 6.6 MB | 972µs / 1.8 MB | 405µs / None
Day 07 | 2.69ms / 1.0 MB | 608µs / 523 KB | 90.1µs / **🔴 69.7 KB**
Day 08 | 617µs / 318 KB | 189µs / 38.2 KB | 18.7µs / None
Day 09 | 36.5µs / None | 49.5µs / 89.3 KB | 16.4µs / None
Day 10 | 434µs / 11.4 KB | 91.9µs / 1.1 KB | 268µs / None
Day 11 | 132µs / 11.1 KB | 75.5µs / None | 19.1µs / None
Day 12 | 2.99ms / 1.2 MB | 732µs / 1.1 MB | 41.9µs / None
Day 13 | 26.6ms / 4.1 KB | **🔴 233ms** / 2.4 KB | 14.8ms / None
Day 14 | 27ms / 1.7 MB | 21.4ms / **🔴 39.2 MB** | 11.3ms / None
Day 15 | **🔴 510ms** / 1.4 KB | **🔴 388ms** / 32.0 B | **🔴 361ms** / None
Day 16 | 226ms / 82.8 MB | 16.8ms / 10.6 MB | 5.11ms / 3.7 KB
Day 17 | 240ms / 48.5 KB | 197ms / 16.1 KB | **🔴 212ms** / None
Day 18 | 7.76ms / 7.0 MB | 9.89µs / None | 5.91µs / None
Day 19 | 214µs / 44.8 KB | 42.2µs / None | 20µs / None
Day 20 | 335ms / **🔴 206 MB** | 14.1ms / None | 97.4ms / None
Day 21 | 66ms / 37.7 MB | 2.92µs / None | 3.42µs / None
Day 22 | 58.6ms / 526 KB | 55ms / None | 50.4ms / None
Day 23 | 1.69ms / 8.4 KB | 30.7µs / None | 29.8µs / None
Day 24 | 119ms / 59.9 MB | 77.2ms / None | 65.8ms / None
Day 25 | 31.2ms / 15.3 KB | 41.3ms / None | 35.1ms / None
*Total* | *1.75s / 432 MB* | *1.09s / 55.5 MB* | *903ms / 73.4 KB*

![Graph for year 2017](y2017.svg)

## 2016
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 168µs / 101 KB | 35.7µs / 34.9 KB | 23.7µs / None
Day 02 | 7.97µs / 192 B | 65.4µs / 3.8 KB | 9.36µs / None
Day 03 | 62.3µs / 49.2 KB | 183µs / 138 KB | 20µs / None
Day 04 | 1.62ms / 644 KB | 1.62ms / 634 KB | 425µs / None
Day 05 | **🔴 3.8s** / 3.4 KB | **🔴 6s** / **🔴 689 MB** | **🔴 2.45s** / **🔴 33.0 B**
Day 06 | 114µs / 4.6 KB | 728µs / 5.8 KB | 3.3µs / None
Day 07 | 1.1ms / 66.4 KB | 2.17ms / 1.0 MB | 512µs / None
Day 08 | 3.71µs / 96.0 B | 11.4µs / 6.2 KB | 2.94µs / None
Day 09 | 7.86µs / None | 138µs / 361 KB | 5.47µs / None
Day 10 | 8.12ms / 5.5 MB | 115µs / 90.7 KB | 7.54µs / None
Day 11 | 24.7ms / 16.8 MB | 1.19s / **🔴 785 MB** | 4.27µs / None
Day 12 | 4.74µs / 3.0 KB | 1.84µs / 5.8 KB | 69ns / None
Day 13 | 135µs / 82.1 KB | 92.9µs / 101 KB | 9.55µs / None
Day 14 | **🔴 8.95s** / 33.1 KB | **🔴 5.03s** / 76.0 B | **🔴 4.37s** / **🔴 65.0 B**
Day 15 | 18.2ms / 14.6 KB | 4.11ms / 432 B | 257ns / None
Day 16 | 107ms / 17.8 MB | 32.9ms / 67.1 MB | 132ns / None
Day 17 | 75.7ms / 52.5 MB | 28.4ms / 35.4 MB | 19.4ms / None
Day 18 | 177ms / 224 B | 272ms / 63.8 MB | 726µs / None
Day 19 | 251ms / **🔴 145 MB** | 37ns / None | 27ns / None
Day 20 | 276µs / 120 KB | 63.3µs / 89.1 KB | 23.4µs / None
Day 21 | 127ms / 47.7 MB | 32.6ms / 4.4 MB | 1.06µs / None
Day 22 | 16.9ms / 392 KB | 11ms / 194 KB | 862µs / None
Day 23 | 12.8µs / 9.0 KB | 4.19µs / 21.1 KB | 75ns / None
Day 24 | 67.2ms / 27.3 MB | 4.18ms / 3.8 MB | 724µs / None
Day 25 | 59.6ms / 16.9 KB | 7.18ms / 7.3 KB | 96ns / None
*Total* | *13.7s / 314 MB* | *12.6s / 1.7 GB* | *6.85s / 98.0 B*

![Graph for year 2016](y2016.svg)

## 2015
 &nbsp;  | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 37µs** | 13.7µs / None | 12.5µs / None | 4.84µs / None
Day 02 | - | 27.5µs / None | 43µs / 16.0 KB | 4.24µs / None
Day 03 | - | 549µs / 166 KB | 377µs / 279 KB | 462µs / 98.7 KB
Day 04 | - | 942ms / 24.0 B | **🔴 1.4s** / 159 MB | 966ms / 64.0 B
Day 05 | - | 286µs / None | 219µs / None | 92µs / None
Day 06 | - | 64.5ms / 252 KB | 37.3ms / 19.2 KB | 12.5ms / None
Day 07 | - | 247µs / 117 KB | 221µs / 148 KB | 36.8µs / 17.4 KB
Day 08 | - | 7.75µs / None | 32µs / 29.6 KB | 3.63µs / None
Day 09 | - | 12.7ms / 6.2 MB | 5ms / 651 KB | 694µs / None
Day 10 | - | 60.3ms / 56.6 MB | 678ms / **🔴 312 MB** | 30.5ms / **🔴 14.0 MB**
Day 11 | - | 26.8ms / 313 KB | 70.5ms / 16.8 MB | 2.99ms / None
Day 12 | - | 853µs / 367 KB | 310µs / 357 KB | 48.4µs / None
Day 13 | - | 81.5ms / 28.1 MB | 55.8ms / 7.2 MB | 2.82ms / None
Day 14 | - | 435µs / 180 KB | 378µs / 425 B | 44.6µs / None
Day 15 | - | 56ms / 67.5 MB | 41.4ms / 44.1 MB | 410µs / None
Day 16 | - | 506µs / 262 KB | 244µs / 250 KB | 7.94µs / None
Day 17 | - | 62.2ms / 3.0 KB | 30.2ms / 84.1 MB | 2.13ms / None
Day 18 | - | 47.9ms / 42.8 KB | 10.9ms / 56.4 KB | 14.5ms / None
Day 19 | - | 545µs / 413 KB | 1.01ms / 546 KB | 2.52ms / 392 KB
Day 20 | - | **🔴 3.58s** / **🔴 465 MB** | **🔴 1.18s** / 126 MB | **🔴 3.1s** / 1.0 B
Day 21 | - | 417µs / 277 KB | 28µs / 16.9 KB | 3.85µs / None
Day 22 | - | 457ms / **🔴 435 MB** | 375ms / **🔴 234 MB** | 8.28ms / None
Day 23 | - | 22.4µs / 9.3 KB | 6.16µs / 1.2 KB | 6.93µs / None
Day 24 | - | 146ms / 61.1 MB | 7.03ms / 10.0 MB | **🔴 1.41s** / 1.0 B
Day 25 | - | 8.95µs / 6.1 KB | 223ns / 32.0 B | 91ns / None
*Total* | *37µs* | *5.54s / 1.1 GB* | *3.89s / 996 MB* | *5.56s / 14.5 MB*

![Graph for year 2015](y2015.svg)

## C++
 &nbsp;  | 2019
 ---:  | ---: 
Day 01 | 1.39µs
Day 02 | 600µs
Day 03 | 25.2ms
Day 04 | 1.69ms
Day 05 | 24.8µs
Day 06 | 2.23µs
Day 07 | 3.66ms
Day 08 | 29.6µs
Day 09 | 36.2ms
Day 10 | 21.8ms
Day 11 | 11.5ms
Day 12 | 157ms
Day 13 | 76.6ms
Day 14 | 2.94ms
Day 15 | 21.8ms
Day 16 | 160ms
Day 17 | 11.8ms
Day 18 | -
Day 19 | 276ms
Day 20 | 276ms
Day 21 | 57.8ms
Day 22 | 2.09µs
Day 23 | 34.4ms
Day 24 | 21.2ms
Day 25 | **🔴 825ms**
*Total* | *2.02s*


## Crystal
 &nbsp;  | 2015 | 2019 | 2020 | 2021
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 37µs** | 9.07µs | 240µs | **🔴 207µs**
Day 02 | - | 2.97ms | 392µs | 48.4µs
Day 03 | - | 13.9ms | 289µs | **🔴 113µs**
Day 04 | - | 24.4ms | 743µs | -
Day 05 | - | 46.4µs | 488µs | -
Day 06 | - | 2.78ms | 1.88ms | -
Day 07 | - | 5.24ms | 690µs | -
Day 08 | - | 137µs | 477µs | -
Day 09 | - | 51ms | 148µs | -
Day 10 | - | 8.09ms | 10.3µs | -
Day 11 | - | 11.3ms | 39.1ms | -
Day 12 | - | 122ms | 48.4µs | -
Day 13 | - | 98.8ms | 92µs | -
Day 14 | - | 5.82ms | 2.98ms | -
Day 15 | - | 29.6ms | 367ms | -
Day 16 | - | 231ms | 614µs | -
Day 17 | - | 14.1ms | 162ms | -
Day 18 | - | **🔴 9.25s** | 593µs | -
Day 19 | - | 275ms | 3.87ms | -
Day 20 | - | 236ms | 4.69ms | -
Day 21 | - | 70.4ms | 850µs | -
Day 22 | - | 92µs | 118ms | -
Day 23 | - | 34.6ms | 1.01s | -
Day 24 | - | 33.8ms | **🔴 6.1s** | -
Day 25 | - | 1.44s | 38.9ms | -
*Total* | *37µs* | *12s* | *7.86s* | *368µs*


## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 13.7µs / None | 168µs / 101 KB | 10.7µs / 2.3 KB | 645µs / None | 5.45µs / 3.4 KB | 19.7ms / 14.1 MB | 59.8µs / 81.9 KB | 8.96µs / None | 198µs / None | 47.2µs / None
Day 02 | 27.5µs / None | 7.97µs / 192 B | 17.1µs / 8.3 KB | 5.04ms / 2.8 MB | 4.87ms / 9.3 MB | 511µs / 280 KB | 855ns / None | 1.89µs / None | 7.3µs / None | 47.5µs / None
Day 03 | 549µs / 166 KB | 62.3µs / 49.2 KB | 27.9µs / 15.9 KB | 88.5ms / 64.2 MB | 7.07ms / 10.0 MB | 22.5µs / 16.3 KB | 23.9µs / None | 23.7µs / None | 30.3µs / None | 29.1µs / None
Day 04 | 942ms / 24.0 B | 1.62ms / 644 KB | 1.57ms / 825 KB | 2.85ms / 399 KB | 1.15ms / 80.0 B | 429µs / 237 KB | 122µs / 79.2 KB | 8.87µs / None | 34.3µs / 256 B | 272µs / None
Day 05 | 286µs / None | **🔴 3.8s** / 3.4 KB | 80.1ms / 25.5 MB | 256ms / 48.3 MB | 58.9µs / 78.8 KB | 100µs / 51.9 KB | 2.13ms / 1.1 MB | 4.76µs / None | 60.8µs / 10.8 KB | 30.5µs / None
Day 06 | 64.5ms / 252 KB | 114µs / 4.6 KB | 16.1ms / 6.6 MB | 30.1ms / 19.4 KB | 31.8ms / 18.4 MB | 3.62ms / 4.0 MB | 999ns / None | 4.73µs / None | 135ns / None | 4.94ms / None
Day 07 | 247µs / 117 KB | 1.1ms / 66.4 KB | 2.69ms / 1.0 MB | 183µs / 68.6 KB | 3.48ms / 5.5 MB | 1.32ms / 692 KB | 48.9µs / 8.2 KB | 14.2µs / None | 371µs / 49.4 KB | 288µs / None
Day 08 | 7.75µs / None | 3.71µs / 96.0 B | 617µs / 318 KB | 249µs / 162 KB | 170µs / 29.7 KB | 4.41ms / 5.5 MB | 260µs / 167 KB | 388µs / None | 939µs / 426 KB | 6.79µs / None
Day 09 | 12.7ms / 6.2 MB | 7.86µs / None | 36.5µs / None | 203ms / 167 MB | 2.8ms / 74.6 KB | 19.2ms / 44.0 MB | 539µs / 238 KB | 233µs / None | 38.2µs / None | 462µs / None
Day 10 | 60.3ms / 56.6 MB | 8.12ms / 5.5 MB | 434µs / 11.4 KB | 1.24ms / 768 KB | 15.1ms / 11.3 MB | 93.1µs / 62.2 KB | 13.4µs / 920 B | 809ns / None | 1.19ms / 891 KB | 114µs / None
Day 11 | 26.8ms / 313 KB | 24.7ms / 16.8 MB | 132µs / 11.1 KB | 27.8ms / 721 KB | 2.95ms / 888 KB | 45ms / 4.6 MB | 466µs / 223 KB | 3.69ms / None | 13.2µs / None | 1.38ms / None
Day 12 | 853µs / 367 KB | 4.74µs / 3.0 KB | 2.99ms / 1.2 MB | 1.91ms / 1.5 MB | 9.72ms / 736 B | 130µs / 78.6 KB | 1.79ms / 3.0 MB | 208µs / None | 11.2ms / None | 591µs / None
Day 13 | 81.5ms / 28.1 MB | 135µs / 82.1 KB | 26.6ms / 4.1 KB | 5.81ms / 2.9 MB | 9.13ms / 2.9 MB | 8.25µs / 5.1 KB | 205µs / 22.7 KB | 764µs / 610 KB | 111µs / 2.7 KB | 7.22µs / 48.0 B
Day 14 | 435µs / 180 KB | **🔴 8.95s** / 33.1 KB | 27ms / 1.7 MB | 118ms / 21.0 MB | 6.08ms / 281 KB | 10.6ms / 7.4 MB | 270µs / 119 KB | 3.11ms / None | 17.7ms / 16.4 KB | 268µs / 32.0 B
Day 15 | 56ms / 67.5 MB | 18.2ms / 14.6 KB | **🔴 510ms** / 1.4 KB | 435ms / **🔴 261 MB** | 19.5ms / 32.5 MB | 397ms / **🔴 240 MB** | 31.4ms / 2.5 MB | 1.9µs / 568 B | 141µs / 58.1 KB | 606µs / None
Day 16 | 506µs / 262 KB | 107ms / 17.8 MB | 226ms / 82.8 MB | 16.4ms / 10.1 MB | 179ms / 1.1 MB | 1.8ms / 1.1 MB | 9.8µs / 5.1 KB | **🔴 141ms** / **🔴 134 MB** | 21.8ms / 98.3 KB | 565µs / None
Day 17 | 62.2ms / 3.0 KB | 75.7ms / 52.5 MB | 240ms / 48.5 KB | 45.8ms / 12.1 MB | 1.11ms / 303 KB | **🔴 540ms** / **🔴 338 MB** | 1.29ms / 64.0 B | 468µs / 229 KB | **🔴 223ms** / **🔴 13.2 MB** | 19.4µs / 24.0 B
Day 18 | 47.9ms / 42.8 KB | 177ms / 224 B | 7.76ms / 7.0 MB | 178ms / 166 MB | **🔴 508ms** / **🔴 405 MB** | 10.9ms / 2.8 MB | 27.8ms / 4.8 MB | 94.4µs / None | 6.73µs / None | 206µs / 32.0 B
Day 19 | 545µs / 413 KB | 251ms / **🔴 145 MB** | 214µs / 44.8 KB | 65.7ms / 27.0 KB | 83.8ms / 66.6 MB | 17.8ms / 6.9 MB | **🔴 525ms** / 16.4 MB | **🔴 130ms** / **🔴 55.0 MB** | 288µs / 245 KB | 1.4ms / None
Day 20 | **🔴 3.58s** / **🔴 465 MB** | 276µs / 120 KB | 335ms / **🔴 206 MB** | 28.9ms / 8.5 MB | 58.5ms / 64.4 MB | 7.98ms / 5.3 MB | 15.5ms / 82.5 KB | 37.4ms / None | 1.44ms / 2.9 KB | **🔴 19.9ms** / None
Day 21 | 417µs / 277 KB | 127ms / 47.7 MB | 66ms / 37.7 MB | 262ms / 448 KB | 4.78ms / 124 KB | 2.25ms / 438 KB | 2.58ms / 2.3 MB | 284µs / 186 KB | 28.9ms / 62.0 KB | 63ns / None
Day 22 | 457ms / **🔴 435 MB** | 16.9ms / 392 KB | 58.6ms / 526 KB | **🔴 943ms** / **🔴 229 MB** | 211µs / 110 KB | 76.7ms / 44.0 MB | 7.48ms / 3.8 MB | 275µs / None | 5.13ms / 1.1 MB | **🔴 11.2ms** / None
Day 23 | 22.4µs / 9.3 KB | 12.8µs / 9.0 KB | 1.69ms / 8.4 KB | 162ms / 1.7 MB | 7.34ms / 4.7 MB | **🔴 677ms** / 32.0 MB | **🔴 252ms** / **🔴 155 MB** | 60.9ms / 2.0 MB | **🔴 516ms** / 2.7 MB | **🔴 12.7ms** / 48.0 B
Day 24 | 146ms / 61.1 MB | 67.2ms / 27.3 MB | 119ms / 59.9 MB | 94.3ms / 42.6 MB | 225ms / **🔴 195 MB** | 131ms / 7.9 MB | 1.73µs / 656 B | 78.8ms / 16.8 MB | - | 42.5µs / **🔴 14.3 KB**
Day 25 | 8.95µs / 6.1 KB | 59.6ms / 16.9 KB | 31.2ms / 15.3 KB | 8.5ms / 992 KB | 84.9ms / 50.8 MB | 40ms / 320 B | 32.9ms / None | 1.66µs / None | 47.1ms / **🔴 21.2 MB** | 279µs / None
*Total* | *5.54s / 1.1 GB* | *13.7s / 314 MB* | *1.75s / 432 MB* | *2.98s / 1.0 GB* | *1.27s / 880 MB* | *2.01s / 760 MB* | *902ms / 189 MB* | *457ms / 209 MB* | *876ms / 40.1 MB* | *55.4ms / 14.5 KB*


## Haskell
 &nbsp;  | 2021
 ---:  | ---: 
Day 01 | **🔴 1.18ms**
Day 02 | **🔴 713µs**
Day 03 | **🔴 1.08ms**
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
*Total* | *2.97ms*


## Rust
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 12.5µs / None | 35.7µs / 34.9 KB | 7.09µs / 16.4 KB | 648µs / None | 1.11µs / None | 137µs / 144 KB | 15.7µs / None | 7.09µs / None | 87.8µs / None | 18.2µs / None
Day 02 | 43µs / 16.0 KB | 65.4µs / 3.8 KB | 7.69µs / 2.0 KB | 470µs / None | 1.83ms / None | 23.9µs / 24.6 KB | 985ns / None | 608ns / None | 2.66µs / None | 42.4µs / None
Day 03 | 377µs / 279 KB | 183µs / 138 KB | 7.91µs / 14.3 KB | 4.07ms / None | 36.1µs / None | 2.53µs / None | 17.6µs / 2.0 KB | 18.5µs / None | 24.5µs / None | 12.5µs / None
Day 04 | **🔴 1.4s** / 159 MB | 1.62ms / 634 KB | 2.69ms / 2.0 MB | 7.71µs / None | 663µs / None | 47.7µs / None | 50µs / 102 KB | 5.67µs / None | 17.2µs / None | 401µs / None
Day 05 | 219µs / None | **🔴 6s** / **🔴 689 MB** | 39.5ms / 24.9 KB | 5.09ms / None | 2.45µs / None | 56.2µs / 12.4 KB | 441µs / 8.2 KB | 3.28µs / None | 10.9µs / None | 16.1µs / None
Day 06 | 37.3ms / 19.2 KB | 728µs / 5.8 KB | 972µs / 1.8 MB | 6.22ms / None | 131µs / 163 KB | 16.3µs / None | 966ns / 512 B | 5.2µs / None | 125ns / None | 4.25ms / None
Day 07 | 221µs / 148 KB | 2.17ms / 1.0 MB | 608µs / 523 KB | 4.11µs / None | 471µs / 102 KB | 231µs / 281 KB | 7.45µs / 2.0 KB | 8.26µs / None | 42.9µs / 48.0 KB | 242µs / None
Day 08 | 32µs / 29.6 KB | 11.4µs / 6.2 KB | 189µs / 38.2 KB | 66.4µs / None | 18.4µs / None | 70µs / None | 11.8µs / 2.4 KB | 288µs / None | 2.25ms / None | 4.21µs / None
Day 09 | 5ms / 651 KB | 138µs / 361 KB | 49.5µs / 89.3 KB | 43.2ms / **🔴 64.0 MB** | 1.65ms / None | 58.2µs / None | 94.1µs / 18.5 KB | 180µs / None | 21.7µs / None | 587µs / None
Day 10 | 678ms / **🔴 312 MB** | 115µs / 90.7 KB | 91.9µs / 1.1 KB | 5.14µs / None | 1.03ms / None | 713ns / None | 28.5µs / 2.1 KB | 597ns / None | 101µs / None | 81.1µs / None
Day 11 | 70.5ms / 16.8 MB | 1.19s / **🔴 785 MB** | 75.5µs / None | 2.24ms / None | 436µs / None | 13.8ms / 2.0 MB | 123µs / 319 B | 2.11ms / None | 11.8µs / None | 985µs / None
Day 12 | 310µs / 357 KB | 1.84µs / 5.8 KB | 732µs / 1.1 MB | 55.7µs / None | 4.39ms / None | 2.82µs / None | 3.84ms / 1.2 KB | 116µs / None | 15.9ms / None | 436µs / None
Day 13 | 55.8ms / 7.2 MB | 92.9µs / 101 KB | **🔴 233ms** / 2.4 KB | 3.35ms / None | 5.67µs / None | - | 243µs / 265 KB | 249µs / 391 KB | 56.7µs / None | 5.35µs / None
Day 14 | 378µs / 425 B | **🔴 5.03s** / 76.0 B | 21.4ms / **🔴 39.2 MB** | **🔴 103ms** / **🔴 33.6 MB** | 1.91ms / 409 KB | 3.12ms / 4.5 MB | 14.2µs / 1.8 KB | 3.28ms / None | 14.9ms / 0.2 B | 3.3ms / None
Day 15 | 41.4ms / 44.1 MB | 4.11ms / 432 B | **🔴 388ms** / 32.0 B | **🔴 145ms** / 11.5 KB | 7.21µs / None | **🔴 378ms** / **🔴 49.4 MB** | 49.1ms / **🔴 133 MB** | 1.07µs / None | 65.7µs / None | 1.23ms / None
Day 16 | 244µs / 250 KB | 32.9ms / 67.1 MB | 16.8ms / 10.6 MB | 112µs / None | **🔴 122ms** / 524 KB | 244µs / 141 KB | 5.69µs / 4.8 KB | **🔴 164ms** / **🔴 35.7 MB** | 11.4ms / None | 5.53ms / None
Day 17 | 30.2ms / 84.1 MB | 28.4ms / 35.4 MB | 197ms / 16.1 KB | 781µs / None | 5.68µs / None | 31.5ms / **🔴 21.7 MB** | 1.56ms / None | 159µs / None | **🔴 275ms** / **🔴 9.3 MB** | 185µs / None
Day 18 | 10.9ms / 56.4 KB | 272ms / 63.8 MB | 9.89µs / None | 21.8ms / None | **🔴 125ms** / **🔴 94.4 MB** | 143µs / None | 22.2ms / 15.5 MB | 79.3µs / None | 2.85µs / None | 111µs / None
Day 19 | 1.01ms / 546 KB | 37ns / None | 42.2µs / None | 41.8ms / None | 5.69µs / None | 33.3ms / 14.0 MB | 10.2ms / 2.0 MB | 24.3ms / **🔴 58.3 MB** | 128µs / None | 1.8ms / None
Day 20 | **🔴 1.18s** / 126 MB | 63.3µs / 89.1 KB | 14.1ms / None | 163µs / None | 5.13ms / None | 111µs / 90.9 KB | 17.8ms / 2.0 MB | 23.9ms / None | 3.11ms / None | **🔴 27.8ms** / None
Day 21 | 28µs / 16.9 KB | 32.6ms / 4.4 MB | 2.92µs / None | 125µs / None | 5.41µs / None | 215µs / 121 KB | 1.04µs / 8.0 B | 193µs / 270 KB | 12.6ms / None | 27ns / None
Day 22 | 375ms / **🔴 234 MB** | 11ms / 194 KB | 55ms / None | 13.3ms / None | 2.62µs / None | 31.3ms / 15.1 MB | 12.9ms / 2.3 MB | 310µs / None | 1.38ms / 14.5 KB | **🔴 48.3ms** / None
Day 23 | 6.16µs / 1.2 KB | 4.19µs / 21.1 KB | 30.7µs / None | 61.5ms / None | 10.6µs / None | **🔴 165ms** / None | **🔴 635ms** / **🔴 165 MB** | 45.3ms / None | **🔴 284ms** / None | 511µs / None
Day 24 | 7.03ms / 10.0 MB | 4.18ms / 3.8 MB | 77.2ms / None | 45.5ms / None | 2.34ms / None | 44.8ms / None | 7.7µs / 576 B | **🔴 70.8ms** / 19.2 MB | - | 77.7µs / None
Day 25 | 223ns / 32.0 B | 7.18ms / 7.3 KB | 41.3ms / None | 1.89ms / None | 10.5µs / None | 35ms / None | 27.3ms / 19.4 KB | 1.41µs / None | 7.1ms / None | 204µs / None
*Total* | *3.89s / 996 MB* | *12.6s / 1.7 GB* | *1.09s / 55.5 MB* | *501ms / 97.6 MB* | *267ms / 95.6 MB* | *737ms / 108 MB* | *781ms / 321 MB* | *335ms / 114 MB* | *628ms / 9.4 MB* | *96.2ms / None*


## Zig
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 4.84µs / None | 23.7µs / None | 2.9µs / None | 651µs / None | 963ns / None | 360µs / 93.9 KB | 4.83µs / None | 5.4µs / None | 81.9µs / None | 30µs / None
Day 02 | 4.24µs / None | 9.36µs / None | 3.8µs / None | 49.5µs / None | 5.92µs / None | 51.5µs / None | 778ns / None | 1.03µs / None | 2.3µs / None | 24.8µs / None
Day 03 | 462µs / 98.7 KB | 20µs / None | 23.8µs / None | 2.07ms / None | 84.3µs / None | 10.1µs / 21.9 KB | 38.7µs / None | 8.35µs / None | 20.5µs / None | 24.6µs / None
Day 04 | 966ms / 64.0 B | 425µs / None | 377µs / None | 8.02µs / None | 905ns / None | 6.38µs / 448 B | 6.5µs / None | 6.02µs / None | 53.3µs / None | 148µs / None
Day 05 | 92µs / None | **🔴 2.45s** / **🔴 33.0 B** | 48.8ms / None | 2.98ms / None | 2.33µs / None | 159µs / 118 KB | 708µs / None | 3.01µs / None | 655µs / None | 13.4µs / None
Day 06 | 12.5ms / None | 3.3µs / None | 405µs / None | 5.91ms / None | 23.9µs / None | 70µs / 3.1 KB | 412ns / None | 4.53µs / None | 82ns / None | 4.34ms / None
Day 07 | 36.8µs / 17.4 KB | 512µs / None | 90.1µs / **🔴 69.7 KB** | 2.73µs / None | 8.19µs / None | - | 9.57µs / None | 7.35µs / None | 99.7µs / None | 214µs / None
Day 08 | 3.63µs / None | 2.94µs / None | 18.7µs / None | 54.3µs / None | 14.8µs / None | 4.85ms / 3.1 MB | 14.8µs / None | 253µs / None | 435µs / None | 3.76µs / None
Day 09 | 694µs / None | 5.47µs / None | 16.4µs / None | 33.2ms / **🔴 64.0 MB** | 3.33µs / None | 112µs / 34.4 KB | 100µs / None | 224µs / None | 17.7µs / None | 376µs / None
Day 10 | 30.5ms / **🔴 14.0 MB** | 7.54µs / None | 268µs / None | 5.34µs / None | 758µs / None | 31.6µs / 8.8 KB | 10.7µs / None | 600ns / None | 94.3µs / None | 1.79ms / None
Day 11 | 2.99ms / None | 4.27µs / None | 19.1µs / None | 1.92ms / None | 218µs / 33.0 KB | 14.9ms / 43.5 KB | 65.7µs / None | 2.46ms / None | 4.16µs / None | 1.14ms / None
Day 12 | 48.4µs / None | 69ns / None | 41.9µs / None | 30.3µs / None | 3.49ms / None | 1.27ms / 90.3 KB | 46.3µs / None | 58.4µs / None | 14.3ms / None | 12.8ms / None
Day 13 | 2.82ms / None | 9.55µs / None | 14.8ms / None | 12.4ms / 1.2 KB | 5.42µs / None | 9.96µs / 416 B | 32µs / None | 5µs / None | 71.8µs / None | 4.63µs / None
Day 14 | 44.6µs / None | **🔴 4.37s** / **🔴 65.0 B** | 11.3ms / None | 171ms / **🔴 20.5 MB** | 503µs / None | - | 10µs / None | 2.67ms / None | 13.4ms / **🔴 3.4 KB** | 4.7ms / None
Day 15 | 410µs / None | 257ns / None | **🔴 361ms** / None | 134ms / None | 7.23µs / None | 573ms / **🔴 240 MB** | 11.2ms / None | 919ns / None | 70.2µs / None | 1.17ms / None
Day 16 | 7.94µs / None | 132ns / None | 5.11ms / 3.7 KB | 119µs / None | 101ms / None | - | 4.54µs / None | **🔴 198ms** / **🔴 52.4 MB** | 48.6ms / None | 8.51ms / None
Day 17 | 2.13ms / None | 19.4ms / None | **🔴 212ms** / None | **🔴 1.29s** / 1.0 B | 3.61µs / None | **🔴 1m11.8s** / 937 KB | 1.49ms / None | 163µs / 102 KB | 2.31ms / None | 77.8µs / None
Day 18 | 14.5ms / None | 726µs / None | 5.91µs / None | 10.3ms / 12.7 KB | **🔴 691ms** / **🔴 254 MB** | 8.4ms / 1.2 MB | 2.11ms / None | 82.5µs / None | 4.48µs / None | 125µs / None
Day 19 | 2.52ms / 392 KB | 27ns / None | 20µs / None | 8.23µs / None | 7.45µs / None | - | 14ms / 7.3 KB | 11.2ms / None | 1.31ms / None | 2.14ms / 20.6 KB
Day 20 | **🔴 3.1s** / 1.0 B | 23.4µs / None | 97.4ms / None | 183µs / None | 6.81ms / None | 10.7ms / 285 KB | 2.11ms / None | 35.7ms / None | 2.6µs / None | **🔴 21ms** / None
Day 21 | 3.85µs / None | 1.06µs / None | 3.42µs / None | 144µs / 328 KB | 4.25µs / None | - | 983ns / None | 78.4µs / None | 593µs / None | 17.4µs / 4.3 KB
Day 22 | 8.28ms / None | 862µs / None | 50.4ms / None | 2.43ms / None | 2.03µs / None | 6.33µs / 1.5 KB | 20.8ms / None | 848µs / None | 1.12ms / None | **🔴 33ms** / **🔴 1.1 MB**
Day 23 | 6.93µs / None | 75ns / None | 29.8µs / None | 33.8ms / None | 8.52µs / None | 5.59s / 48.0 MB | **🔴 291ms** / **🔴 107 MB** | 64.6ms / None | **🔴 230ms** / None | 479µs / None
Day 24 | **🔴 1.41s** / 1.0 B | 724µs / None | 65.8ms / None | 4.57ms / None | 2.58ms / 696 B | 76.7ms / 6.2 MB | 445ns / None | 77.1ms / **🔴 18.9 MB** | 402µs / None | 102µs / 40.3 KB
Day 25 | 91ns / None | 96ns / None | 35.1ms / None | 642µs / None | 10.5µs / None | 35.2ms / 160 B | 267µs / None | 1.15µs / None | 189µs / None | 183µs / None
*Total* | *5.56s / 14.5 MB* | *6.85s / 98.0 B* | *903ms / 73.4 KB* | *1.7s / 84.8 MB* | *807ms / 254 MB* | *1m18.1s / 300 MB* | *344ms / 107 MB* | *394ms / 71.4 MB* | *314ms / 3.4 KB* | *92.4ms / 1.2 MB*

