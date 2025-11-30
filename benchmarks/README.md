This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## 2024
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 47.2µs / None | 19µs / None | 32.6µs / None
Day 02 | 47.5µs / None | 40.5µs / None | 29.6µs / None
Day 03 | 29.1µs / None | 10.2µs / None | 26.9µs / None
Day 04 | 272µs / None | 418µs / None | 165µs / None
Day 05 | 30.5µs / None | 17.4µs / None | 14.6µs / None
Day 06 | 4.94ms / None | 4.12ms / None | 4.67ms / None
Day 07 | 288µs / None | 251µs / None | 237µs / None
Day 08 | 6.79µs / None | 4.4µs / None | 4.05µs / None
Day 09 | 462µs / None | 595µs / None | 410µs / None
Day 10 | 114µs / None | 80.7µs / None | 1.97ms / None
Day 11 | 1.38ms / None | 1.1ms / None | 1.21ms / None
Day 12 | 591µs / None | 402µs / None | 13.8ms / None
Day 13 | 7.22µs / 48.0 B | 5.39µs / None | 5.03µs / None
Day 14 | 268µs / 32.0 B | 3.44ms / None | 5.17ms / None
Day 15 | 606µs / None | 1.33ms / None | 1.25ms / None
Day 16 | 565µs / None | 5.53ms / None | 9.31ms / None
Day 17 | 19.4µs / 24.0 B | 205µs / None | 83.1µs / None
Day 18 | 206µs / 32.0 B | 120µs / None | 137µs / None
Day 19 | 1.4ms / None | 1.79ms / None | 2.26ms / 20.6 KB
Day 20 | **🔴 19.9ms** / None | **🔴 29.1ms** / None | **🔴 22.7ms** / None
Day 21 | 63ns / None | 29ns / None | 20.6µs / 4.3 KB
Day 22 | **🔴 11.2ms** / None | **🔴 48.8ms** / None | **🔴 35.5ms** / **🔴 1.1 MB**
Day 23 | **🔴 12.7ms** / 48.0 B | 532µs / None | 520µs / None
Day 24 | 42.5µs / **🔴 14.3 KB** | 84.4µs / None | 112µs / 40.3 KB
Day 25 | 279µs / None | 257µs / None | 198µs / None
*Total* | *55.4ms / 14.5 KB* | *98.3ms / None* | *99.8ms / 1.2 MB*

![Graph for year 2024](y2024.svg)

## 2023
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 198µs / None | 67.8µs / None | 84.9µs / None
Day 02 | 7.3µs / None | 2.73µs / None | 2.43µs / None
Day 03 | 30.3µs / None | 27.1µs / None | 21.4µs / None
Day 04 | 34.3µs / 256 B | 17.3µs / None | 51.1µs / None
Day 05 | 60.8µs / 10.8 KB | 11.2µs / None | 664µs / None
Day 06 | 135ns / None | 138ns / None | 80ns / None
Day 07 | 371µs / 49.4 KB | 45µs / 48.0 KB | 105µs / None
Day 08 | 939µs / 426 KB | 2.3ms / None | 466µs / None
Day 09 | 38.2µs / None | 21.7µs / None | 18.2µs / None
Day 10 | 1.19ms / 891 KB | 107µs / None | 96.4µs / None
Day 11 | 13.2µs / None | 11µs / None | 4.17µs / None
Day 12 | 11.2ms / None | 16.5ms / None | 14.7ms / None
Day 13 | 111µs / 2.7 KB | 60.1µs / None | 74.1µs / None
Day 14 | 17.7ms / 16.4 KB | 15.4ms / 0.2 B | 13.5ms / **🔴 3.4 KB**
Day 15 | 141µs / 58.1 KB | 61.7µs / None | 69.7µs / None
Day 16 | 21.8ms / 98.3 KB | 11.2ms / None | 47.8ms / None
Day 17 | **🔴 223ms** / **🔴 13.2 MB** | **🔴 283ms** / **🔴 9.3 MB** | 2.36ms / None
Day 18 | 6.73µs / None | 2.93µs / None | 4.5µs / None
Day 19 | 288µs / 245 KB | 135µs / None | 1.35ms / None
Day 20 | 1.44ms / 2.9 KB | 3.18ms / None | 2.56µs / None
Day 21 | 28.9ms / 62.0 KB | 13.2ms / None | 590µs / None
Day 22 | 5.13ms / 1.1 MB | 1.44ms / 14.5 KB | 1.15ms / None
Day 23 | **🔴 516ms** / 2.7 MB | **🔴 289ms** / None | **🔴 244ms** / None
Day 24 | - | - | 444µs / None
Day 25 | 47.1ms / **🔴 21.2 MB** | 6.13ms / None | 201µs / None
*Total* | *876ms / 40.1 MB* | *642ms / 9.3 MB* | *328ms / 3.4 KB*

![Graph for year 2023](y2023.svg)

## 2022
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 8.96µs / None | 7.31µs / None | 5.43µs / None
Day 02 | 1.89µs / None | 633ns / None | 1.04µs / None
Day 03 | 23.7µs / None | 19.4µs / None | 8.34µs / None
Day 04 | 8.87µs / None | 5.9µs / None | 5.99µs / None
Day 05 | 4.76µs / None | 3.58µs / None | 3.14µs / None
Day 06 | 4.73µs / None | 5.48µs / None | 4.53µs / None
Day 07 | 14.2µs / None | 8.49µs / None | 7.77µs / None
Day 08 | 388µs / None | 293µs / None | 269µs / None
Day 09 | 233µs / None | 193µs / None | 221µs / None
Day 10 | 809ns / None | 558ns / None | 614ns / None
Day 11 | 3.69ms / None | 2.08ms / None | 2.6ms / None
Day 12 | 208µs / None | 126µs / None | 64.9µs / None
Day 13 | 764µs / 610 KB | 264µs / 391 KB | 5.04µs / None
Day 14 | 3.11ms / None | 3.38ms / None | 2.67ms / None
Day 15 | 1.9µs / 568 B | 1.08µs / None | 920ns / None
Day 16 | **🔴 141ms** / **🔴 134 MB** | **🔴 170ms** / **🔴 35.7 MB** | **🔴 215ms** / **🔴 52.4 MB**
Day 17 | 468µs / 229 KB | 164µs / None | 165µs / 102 KB
Day 18 | 94.4µs / None | 85.4µs / None | 84.2µs / None
Day 19 | **🔴 130ms** / **🔴 55.0 MB** | 27.1ms / **🔴 58.3 MB** | 12.2ms / None
Day 20 | 37.4ms / None | 24.3ms / None | 36.5ms / None
Day 21 | 284µs / 186 KB | 202µs / 270 KB | 75.4µs / None
Day 22 | 275µs / None | 322µs / None | 908µs / None
Day 23 | 60.9ms / 2.0 MB | 45.9ms / None | 66.8ms / None
Day 24 | 78.8ms / 16.8 MB | **🔴 74.6ms** / 19.2 MB | 80.5ms / **🔴 18.9 MB**
Day 25 | 1.66µs / None | 1.24µs / None | 1.18µs / None
*Total* | *457ms / 209 MB* | *349ms / 114 MB* | *418ms / 71.4 MB*

![Graph for year 2022](y2022.svg)

## 2021
 &nbsp;  | Crystal | Golang | Haskell | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 207µs** | 59.8µs / 81.9 KB | **🔴 1.18ms** | 12.3µs / None | 4.83µs / None
Day 02 | 48.4µs | 855ns / None | **🔴 713µs** | 1.06µs / None | 813ns / None
Day 03 | **🔴 113µs** | 23.9µs / None | **🔴 1.08ms** | 21.5µs / 2.0 KB | 39.5µs / None
Day 04 | - | 122µs / 79.2 KB | - | 54µs / 102 KB | 6.48µs / None
Day 05 | - | 2.13ms / 1.1 MB | - | 474µs / 8.2 KB | 711µs / None
Day 06 | - | 999ns / None | - | 912ns / 512 B | 412ns / None
Day 07 | - | 48.9µs / 8.2 KB | - | 8.06µs / 2.0 KB | 9.28µs / None
Day 08 | - | 260µs / 167 KB | - | 12.9µs / 2.4 KB | 14.5µs / None
Day 09 | - | 539µs / 238 KB | - | 97.9µs / 18.5 KB | 101µs / None
Day 10 | - | 13.4µs / 920 B | - | 24.5µs / 2.1 KB | 10.8µs / None
Day 11 | - | 466µs / 223 KB | - | 132µs / 319 B | 69.8µs / None
Day 12 | - | 1.79ms / 3.0 MB | - | 4.02ms / 1.2 KB | 52.1µs / None
Day 13 | - | 205µs / 22.7 KB | - | 252µs / 265 KB | 35.5µs / None
Day 14 | - | 270µs / 119 KB | - | 14.9µs / 1.8 KB | 10µs / None
Day 15 | - | 31.4ms / 2.5 MB | - | 51.1ms / **🔴 133 MB** | 11.1ms / None
Day 16 | - | 9.8µs / 5.1 KB | - | 5.98µs / 4.8 KB | 4.57µs / None
Day 17 | - | 1.29ms / 64.0 B | - | 1.62ms / None | 1.49ms / None
Day 18 | - | 27.8ms / 4.8 MB | - | 22ms / 15.5 MB | 2.12ms / None
Day 19 | - | **🔴 525ms** / 16.4 MB | - | 10.1ms / 2.0 MB | 14ms / 7.3 KB
Day 20 | - | 15.5ms / 82.5 KB | - | 18ms / 2.0 MB | 2.15ms / None
Day 21 | - | 2.58ms / 2.3 MB | - | 1.17µs / 8.0 B | 990ns / None
Day 22 | - | 7.48ms / 3.8 MB | - | 11.9ms / 2.3 MB | 23.1ms / None
Day 23 | - | **🔴 252ms** / **🔴 155 MB** | - | **🔴 630ms** / **🔴 165 MB** | **🔴 284ms** / **🔴 107 MB**
Day 24 | - | 1.73µs / 656 B | - | 8.14µs / 576 B | 445ns / None
Day 25 | - | 32.9ms / None | - | 28.6ms / 19.4 KB | 265µs / None
*Total* | *368µs* | *902ms / 189 MB* | *2.97ms* | *778ms / 321 MB* | *340ms / 107 MB*

![Graph for year 2021](y2021.svg)

## 2020
 &nbsp;  | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 240µs | 19.7ms / 14.1 MB | 144µs / 144 KB | 352µs / 93.9 KB
Day 02 | 392µs | 511µs / 280 KB | 26.1µs / 24.6 KB | 51.3µs / None
Day 03 | 289µs | 22.5µs / 16.3 KB | 2.84µs / None | 527µs / 31.9 KB
Day 04 | 743µs | 429µs / 237 KB | 51.2µs / None | 2.05ms / 249 KB
Day 05 | 488µs | 100µs / 51.9 KB | 62.2µs / 12.4 KB | 1.76ms / 128 KB
Day 06 | 1.88ms | 3.62ms / 4.0 MB | 17.3µs / None | 8.11ms / 498 KB
Day 07 | 690µs | 1.32ms / 692 KB | 250µs / 281 KB | 1.35ms / 656 MB
Day 08 | 477µs | 4.41ms / 5.5 MB | 68.5µs / None | 5.25ms / 3.1 MB
Day 09 | 148µs | 19.2ms / 44.0 MB | 61.8µs / None | 111µs / 34.4 KB
Day 10 | 10.3µs | 93.1µs / 62.2 KB | 701ns / None | 30.6µs / 8.8 KB
Day 11 | 39.1ms | 45ms / 4.6 MB | 13.8ms / 2.0 MB | 15.1ms / 53.0 KB
Day 12 | 48.4µs | 130µs / 78.6 KB | 3.21µs / None | 2.33ms / 92.3 KB
Day 13 | 92µs | 8.25µs / 5.1 KB | - | 14.4µs / 589 B
Day 14 | 2.98ms | 10.6ms / 7.4 MB | 3.31ms / 4.5 MB | 6.27ms / 6.1 MB
Day 15 | 367ms | 397ms / **🔴 240 MB** | **🔴 390ms** / **🔴 49.4 MB** | 663ms / 240 MB
Day 16 | 614µs | 1.8ms / 1.1 MB | 259µs / 141 KB | 1.14ms / 158 KB
Day 17 | 162ms | **🔴 540ms** / **🔴 338 MB** | 34.1ms / **🔴 21.7 MB** | **🔴 1m13.7s** / 937 KB
Day 18 | 593µs | 10.9ms / 2.8 MB | 143µs / None | 8.22ms / 1.2 MB
Day 19 | 3.87ms | 17.8ms / 6.9 MB | 33.8ms / 14.0 MB | 10.4ms / 108 KB
Day 20 | 4.69ms | 7.98ms / 5.3 MB | 115µs / 90.9 KB | 11.1ms / 305 KB
Day 21 | 850µs | 2.25ms / 438 KB | 222µs / 121 KB | 2.97ms / 172 KB
Day 22 | 118ms | 76.7ms / 44.0 MB | 31.4ms / 15.1 MB | 106ms / **🔴 4.7 GB**
Day 23 | 1.01s | **🔴 677ms** / 32.0 MB | **🔴 179ms** / None | 5.9s / 48.0 MB
Day 24 | **🔴 6.1s** | 131ms / 7.9 MB | 46.2ms / None | 77.6ms / 6.2 MB
Day 25 | 38.9ms | 40ms / 320 B | 35.4ms / None | 34.6ms / 174 B
*Total* | *7.86s* | *2.01s / 760 MB* | *768ms / 108 MB* | *1m20.6s / 5.7 GB*

![Graph for year 2020](y2020.svg)

## 2019
 &nbsp;  | C++ | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 1.39µs | 9.07µs | 5.45µs / 3.4 KB | 1.2µs / None | 1.02µs / None
Day 02 | 743µs | 2.97ms | 4.87ms / 9.3 MB | 1.95ms / None | 6.32µs / None
Day 03 | 25.2ms | 13.9ms | 7.07ms / 10.0 MB | 39.5µs / None | 84µs / None
Day 04 | 1.69ms | 24.4ms | 1.15ms / 80.0 B | 720µs / None | 916ns / None
Day 05 | 24.8µs | 46.4µs | 58.9µs / 78.8 KB | 2.66µs / None | 2.33µs / None
Day 06 | 2.23µs | 2.78ms | 31.8ms / 18.4 MB | 147µs / 163 KB | 20.9µs / None
Day 07 | 3.66ms | 5.24ms | 3.48ms / 5.5 MB | 497µs / 102 KB | 8.62µs / None
Day 08 | 29.6µs | 137µs | 170µs / 29.7 KB | 19.3µs / None | 15.2µs / None
Day 09 | 36.2ms | 51ms | 2.8ms / 74.6 KB | 1.85ms / None | 3.29µs / None
Day 10 | 21.8ms | 8.09ms | 15.1ms / 11.3 MB | 1.06ms / None | 771µs / None
Day 11 | 11.5ms | 11.3ms | 2.95ms / 888 KB | 467µs / None | 223µs / 33.0 KB
Day 12 | 157ms | 122ms | 9.72ms / 736 B | 4.8ms / None | 3.75ms / None
Day 13 | 76.6ms | 98.8ms | 9.13ms / 2.9 MB | 6.1µs / None | 5.31µs / None
Day 14 | 2.94ms | 5.82ms | 6.08ms / 281 KB | 2.22ms / 409 KB | 536µs / None
Day 15 | 21.8ms | 29.6ms | 19.5ms / 32.5 MB | 8.32µs / None | 7.26µs / None
Day 16 | 160ms | 231ms | 179ms / 1.1 MB | **🔴 130ms** / 524 KB | 102ms / None
Day 17 | 11.8ms | 14.1ms | 1.11ms / 303 KB | 5.92µs / None | 3.62µs / None
Day 18 | - | **🔴 9.25s** | **🔴 508ms** / **🔴 405 MB** | **🔴 132ms** / **🔴 94.4 MB** | **🔴 696ms** / **🔴 254 MB**
Day 19 | 276ms | 275ms | 83.8ms / 66.6 MB | 6.28µs / None | 7.6µs / None
Day 20 | 276ms | 236ms | 58.5ms / 64.4 MB | 5.51ms / None | 7.37ms / None
Day 21 | 57.8ms | 70.4ms | 4.78ms / 124 KB | 5.74µs / None | 4.34µs / None
Day 22 | 2.09µs | 92µs | 211µs / 110 KB | 2.84µs / None | 2.06µs / None
Day 23 | 34.4ms | 34.6ms | 7.34ms / 4.7 MB | 11.6µs / None | 8.49µs / None
Day 24 | 21.2ms | 33.8ms | 225ms / **🔴 195 MB** | 2.72ms / None | 2.6ms / 696 B
Day 25 | **🔴 825ms** | 1.44s | 84.9ms / 50.8 MB | 14.1µs / None | 12.2µs / None
*Total* | *2.02s* | *12s* | *1.27s / 880 MB* | *284ms / 95.6 MB* | *813ms / 254 MB*

![Graph for year 2019](y2019.svg)

## 2018
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 645µs / None | 698µs / None | 654µs / None
Day 02 | 5.04ms / 2.8 MB | 528µs / None | 48.6µs / None
Day 03 | 88.5ms / 64.2 MB | 4.34ms / None | 2.04ms / None
Day 04 | 2.85ms / 399 KB | 8.25µs / None | 8.04µs / None
Day 05 | 256ms / 48.3 MB | 5.64ms / None | 2.97ms / None
Day 06 | 30.1ms / 19.4 KB | 6.68ms / None | 6.51ms / None
Day 07 | 183µs / 68.6 KB | 4.17µs / None | 2.71µs / None
Day 08 | 249µs / 162 KB | 75.2µs / None | 56.1µs / None
Day 09 | 203ms / 167 MB | 40.6ms / **🔴 64.0 MB** | 33.8ms / **🔴 64.0 MB**
Day 10 | 1.24ms / 768 KB | 5.47µs / None | 5.29µs / None
Day 11 | 27.8ms / 721 KB | 3.16ms / None | 2.01ms / None
Day 12 | 1.91ms / 1.5 MB | 62.4µs / None | 32.1µs / None
Day 13 | 5.81ms / 2.9 MB | 3.48ms / None | 12.2ms / 1.2 KB
Day 14 | 118ms / 21.0 MB | 104ms / **🔴 33.6 MB** | 171ms / **🔴 20.5 MB**
Day 15 | 435ms / **🔴 261 MB** | **🔴 157ms** / 11.5 KB | 144ms / None
Day 16 | 16.4ms / 10.1 MB | 119µs / None | 124µs / None
Day 17 | 45.8ms / 12.1 MB | 828µs / None | **🔴 1.31s** / 1.0 B
Day 18 | 178ms / 166 MB | 23.8ms / None | 10.3ms / 12.7 KB
Day 19 | 65.7ms / 27.0 KB | 44.4ms / None | 8.14µs / None
Day 20 | 28.9ms / 8.5 MB | 175µs / None | 181µs / None
Day 21 | 262ms / 448 KB | 144µs / None | 156µs / 328 KB
Day 22 | **🔴 943ms** / **🔴 229 MB** | 14.1ms / None | 2.36ms / None
Day 23 | 162ms / 1.7 MB | 66.8ms / None | 33.8ms / None
Day 24 | 94.3ms / 42.6 MB | 58.6ms / None | 4.47ms / None
Day 25 | 8.5ms / 992 KB | 2.04ms / None | 663µs / None
*Total* | *2.98s / 1.0 GB* | *537ms / 97.6 MB* | *1.73s / 84.8 MB*

![Graph for year 2018](y2018.svg)

## 2017
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 10.7µs / 2.3 KB | 7.52µs / 16.4 KB | 3.16µs / None
Day 02 | 17.1µs / 8.3 KB | 8.45µs / 2.0 KB | 4.05µs / None
Day 03 | 27.9µs / 15.9 KB | 10.1µs / 14.3 KB | 28.1µs / None
Day 04 | 1.57ms / 825 KB | 3.09ms / 2.0 MB | 413µs / None
Day 05 | 80.1ms / 25.5 MB | 42.8ms / 24.9 KB | 52.6ms / None
Day 06 | 16.1ms / 6.6 MB | 1.05ms / 1.8 MB | 428µs / None
Day 07 | 2.69ms / 1.0 MB | 659µs / 523 KB | 99.1µs / **🔴 69.7 KB**
Day 08 | 617µs / 318 KB | 222µs / 38.2 KB | 20µs / None
Day 09 | 36.5µs / None | 54.4µs / 89.3 KB | 17.1µs / None
Day 10 | 434µs / 11.4 KB | 99.6µs / 1.1 KB | 273µs / None
Day 11 | 132µs / 11.1 KB | 98µs / None | 19.5µs / None
Day 12 | 2.99ms / 1.2 MB | 785µs / 1.1 MB | 45.2µs / None
Day 13 | 26.6ms / 4.1 KB | **🔴 250ms** / 2.4 KB | 15.8ms / None
Day 14 | 27ms / 1.7 MB | 23.9ms / **🔴 39.2 MB** | 11.5ms / None
Day 15 | **🔴 510ms** / 1.4 KB | **🔴 412ms** / 32.0 B | **🔴 362ms** / None
Day 16 | 226ms / 82.8 MB | 19.3ms / 10.6 MB | 5.14ms / 3.7 KB
Day 17 | 240ms / 48.5 KB | 211ms / 16.1 KB | **🔴 222ms** / None
Day 18 | 7.76ms / 7.0 MB | 10.2µs / None | 6.11µs / None
Day 19 | 214µs / 44.8 KB | 39.1µs / None | 20.3µs / None
Day 20 | 335ms / **🔴 206 MB** | 15.5ms / None | 95.4ms / None
Day 21 | 66ms / 37.7 MB | 3.1µs / None | 3.37µs / None
Day 22 | 58.6ms / 526 KB | 58.7ms / None | 51.1ms / None
Day 23 | 1.69ms / 8.4 KB | 33µs / None | 29.6µs / None
Day 24 | 119ms / 59.9 MB | 85.2ms / None | 64.6ms / None
Day 25 | 31.2ms / 15.3 KB | 44.6ms / None | 35.5ms / None
*Total* | *1.75s / 432 MB* | *1.17s / 55.5 MB* | *917ms / 73.4 KB*

![Graph for year 2017](y2017.svg)

## 2016
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 168µs / 101 KB | 39µs / 34.9 KB | 26.3µs / None
Day 02 | 7.97µs / 192 B | 69.4µs / 3.8 KB | 9.88µs / None
Day 03 | 62.3µs / 49.2 KB | 205µs / 138 KB | 19.9µs / None
Day 04 | 1.62ms / 644 KB | 1.74ms / 634 KB | 423µs / None
Day 05 | **🔴 3.8s** / 3.4 KB | **🔴 6.33s** / **🔴 689 MB** | **🔴 2.49s** / **🔴 33.0 B**
Day 06 | 114µs / 4.6 KB | 774µs / 5.8 KB | 3.68µs / None
Day 07 | 1.1ms / 66.4 KB | 2.54ms / 1.0 MB | 556µs / None
Day 08 | 3.71µs / 96.0 B | 10.3µs / 6.2 KB | 3.19µs / None
Day 09 | 7.86µs / None | 162µs / 361 KB | 6.42µs / None
Day 10 | 8.12ms / 5.5 MB | 125µs / 90.7 KB | 8.06µs / None
Day 11 | 24.7ms / 16.8 MB | 1.29s / **🔴 785 MB** | -
Day 12 | 4.74µs / 3.0 KB | 1.98µs / 5.8 KB | 74ns / None
Day 13 | 135µs / 82.1 KB | 106µs / 101 KB | 10.3µs / None
Day 14 | **🔴 8.95s** / 33.1 KB | **🔴 5.66s** / 76.0 B | **🔴 4.72s** / **🔴 65.0 B**
Day 15 | 18.2ms / 14.6 KB | 4.43ms / 432 B | 269ns / None
Day 16 | 107ms / 17.8 MB | 36.5ms / 67.1 MB | 139ns / None
Day 17 | 75.7ms / 52.5 MB | 30.5ms / 35.4 MB | 21ms / None
Day 18 | 177ms / 224 B | 301ms / 63.8 MB | 783µs / None
Day 19 | 251ms / **🔴 145 MB** | 41ns / None | 28ns / None
Day 20 | 276µs / 120 KB | 72.2µs / 89.1 KB | 25.4µs / None
Day 21 | 127ms / 47.7 MB | 35.3ms / 4.4 MB | 1.1µs / None
Day 22 | 16.9ms / 392 KB | 11.4ms / 194 KB | 919µs / None
Day 23 | 12.8µs / 9.0 KB | 4.69µs / 21.1 KB | 75ns / None
Day 24 | 67.2ms / 27.3 MB | 4.58ms / 3.8 MB | 791µs / None
Day 25 | 59.6ms / 16.9 KB | 7.74ms / 7.3 KB | 109ns / None
*Total* | *13.7s / 314 MB* | *13.7s / 1.7 GB* | *7.23s / 98.0 B*

![Graph for year 2016](y2016.svg)

## 2015
 &nbsp;  | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 37µs** | 13.7µs / None | 9.77µs / None | 5.35µs / None
Day 02 | - | 27.5µs / None | 48µs / 16.0 KB | 4.63µs / None
Day 03 | - | 549µs / 166 KB | 410µs / 279 KB | 486µs / 98.7 KB
Day 04 | - | 942ms / 24.0 B | **🔴 1.49s** / 159 MB | 1.03s / 65.0 B
Day 05 | - | 286µs / None | 222µs / None | 98.5µs / None
Day 06 | - | 64.5ms / 252 KB | 40.8ms / 19.2 KB | 13.5ms / None
Day 07 | - | 247µs / 117 KB | 236µs / 148 KB | 40.6µs / 17.4 KB
Day 08 | - | 7.75µs / None | 34.6µs / 29.6 KB | 3.91µs / None
Day 09 | - | 12.7ms / 6.2 MB | 4.67ms / 651 KB | 709µs / None
Day 10 | - | 60.3ms / 56.6 MB | 628ms / **🔴 334 MB** | 32.3ms / **🔴 14.0 MB**
Day 11 | - | 26.8ms / 313 KB | 49.8ms / 16.8 MB | 3.09ms / None
Day 12 | - | 853µs / 367 KB | 316µs / 357 KB | 50.6µs / None
Day 13 | - | 81.5ms / 28.1 MB | 58.7ms / 7.2 MB | 3.12ms / None
Day 14 | - | 435µs / 180 KB | 404µs / 425 B | 45.2µs / None
Day 15 | - | 56ms / 67.5 MB | 44.8ms / 44.1 MB | 428µs / None
Day 16 | - | 506µs / 262 KB | 277µs / 250 KB | 8.36µs / None
Day 17 | - | 62.2ms / 3.0 KB | 33ms / 84.1 MB | 2.2ms / None
Day 18 | - | 47.9ms / 42.8 KB | 11.8ms / 56.4 KB | 14.9ms / None
Day 19 | - | 545µs / 413 KB | 1.15ms / 546 KB | 2.55ms / 392 KB
Day 20 | - | **🔴 3.58s** / **🔴 465 MB** | **🔴 1.27s** / 126 MB | **🔴 3.12s** / 1.0 B
Day 21 | - | 417µs / 277 KB | 29.5µs / 16.9 KB | 4µs / None
Day 22 | - | 457ms / **🔴 435 MB** | 464ms / **🔴 234 MB** | 8.3ms / None
Day 23 | - | 22.4µs / 9.3 KB | 6.2µs / 1.2 KB | 6.94µs / None
Day 24 | - | 146ms / 61.1 MB | 7.44ms / 10.0 MB | **🔴 1.47s** / 1.0 B
Day 25 | - | 8.95µs / 6.1 KB | 248ns / 32.0 B | 92ns / None
*Total* | *37µs* | *5.54s / 1.1 GB* | *4.1s / 1.0 GB* | *5.7s / 14.5 MB*

![Graph for year 2015](y2015.svg)

## C++
 &nbsp;  | 2019
 ---:  | ---: 
Day 01 | 1.39µs
Day 02 | 743µs
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
Day 01 | 9.77µs / None | 39µs / 34.9 KB | 7.52µs / 16.4 KB | 698µs / None | 1.2µs / None | 144µs / 144 KB | 12.3µs / None | 7.31µs / None | 67.8µs / None | 19µs / None
Day 02 | 48µs / 16.0 KB | 69.4µs / 3.8 KB | 8.45µs / 2.0 KB | 528µs / None | 1.95ms / None | 26.1µs / 24.6 KB | 1.06µs / None | 633ns / None | 2.73µs / None | 40.5µs / None
Day 03 | 410µs / 279 KB | 205µs / 138 KB | 10.1µs / 14.3 KB | 4.34ms / None | 39.5µs / None | 2.84µs / None | 21.5µs / 2.0 KB | 19.4µs / None | 27.1µs / None | 10.2µs / None
Day 04 | **🔴 1.49s** / 159 MB | 1.74ms / 634 KB | 3.09ms / 2.0 MB | 8.25µs / None | 720µs / None | 51.2µs / None | 54µs / 102 KB | 5.9µs / None | 17.3µs / None | 418µs / None
Day 05 | 222µs / None | **🔴 6.33s** / **🔴 689 MB** | 42.8ms / 24.9 KB | 5.64ms / None | 2.66µs / None | 62.2µs / 12.4 KB | 474µs / 8.2 KB | 3.58µs / None | 11.2µs / None | 17.4µs / None
Day 06 | 40.8ms / 19.2 KB | 774µs / 5.8 KB | 1.05ms / 1.8 MB | 6.68ms / None | 147µs / 163 KB | 17.3µs / None | 912ns / 512 B | 5.48µs / None | 138ns / None | 4.12ms / None
Day 07 | 236µs / 148 KB | 2.54ms / 1.0 MB | 659µs / 523 KB | 4.17µs / None | 497µs / 102 KB | 250µs / 281 KB | 8.06µs / 2.0 KB | 8.49µs / None | 45µs / 48.0 KB | 251µs / None
Day 08 | 34.6µs / 29.6 KB | 10.3µs / 6.2 KB | 222µs / 38.2 KB | 75.2µs / None | 19.3µs / None | 68.5µs / None | 12.9µs / 2.4 KB | 293µs / None | 2.3ms / None | 4.4µs / None
Day 09 | 4.67ms / 651 KB | 162µs / 361 KB | 54.4µs / 89.3 KB | 40.6ms / **🔴 64.0 MB** | 1.85ms / None | 61.8µs / None | 97.9µs / 18.5 KB | 193µs / None | 21.7µs / None | 595µs / None
Day 10 | 628ms / **🔴 334 MB** | 125µs / 90.7 KB | 99.6µs / 1.1 KB | 5.47µs / None | 1.06ms / None | 701ns / None | 24.5µs / 2.1 KB | 558ns / None | 107µs / None | 80.7µs / None
Day 11 | 49.8ms / 16.8 MB | 1.29s / **🔴 785 MB** | 98µs / None | 3.16ms / None | 467µs / None | 13.8ms / 2.0 MB | 132µs / 319 B | 2.08ms / None | 11µs / None | 1.1ms / None
Day 12 | 316µs / 357 KB | 1.98µs / 5.8 KB | 785µs / 1.1 MB | 62.4µs / None | 4.8ms / None | 3.21µs / None | 4.02ms / 1.2 KB | 126µs / None | 16.5ms / None | 402µs / None
Day 13 | 58.7ms / 7.2 MB | 106µs / 101 KB | **🔴 250ms** / 2.4 KB | 3.48ms / None | 6.1µs / None | - | 252µs / 265 KB | 264µs / 391 KB | 60.1µs / None | 5.39µs / None
Day 14 | 404µs / 425 B | **🔴 5.66s** / 76.0 B | 23.9ms / **🔴 39.2 MB** | 104ms / **🔴 33.6 MB** | 2.22ms / 409 KB | 3.31ms / 4.5 MB | 14.9µs / 1.8 KB | 3.38ms / None | 15.4ms / 0.2 B | 3.44ms / None
Day 15 | 44.8ms / 44.1 MB | 4.43ms / 432 B | **🔴 412ms** / 32.0 B | **🔴 157ms** / 11.5 KB | 8.32µs / None | **🔴 390ms** / **🔴 49.4 MB** | 51.1ms / **🔴 133 MB** | 1.08µs / None | 61.7µs / None | 1.33ms / None
Day 16 | 277µs / 250 KB | 36.5ms / 67.1 MB | 19.3ms / 10.6 MB | 119µs / None | **🔴 130ms** / 524 KB | 259µs / 141 KB | 5.98µs / 4.8 KB | **🔴 170ms** / **🔴 35.7 MB** | 11.2ms / None | 5.53ms / None
Day 17 | 33ms / 84.1 MB | 30.5ms / 35.4 MB | 211ms / 16.1 KB | 828µs / None | 5.92µs / None | 34.1ms / **🔴 21.7 MB** | 1.62ms / None | 164µs / None | **🔴 283ms** / **🔴 9.3 MB** | 205µs / None
Day 18 | 11.8ms / 56.4 KB | 301ms / 63.8 MB | 10.2µs / None | 23.8ms / None | **🔴 132ms** / **🔴 94.4 MB** | 143µs / None | 22ms / 15.5 MB | 85.4µs / None | 2.93µs / None | 120µs / None
Day 19 | 1.15ms / 546 KB | 41ns / None | 39.1µs / None | 44.4ms / None | 6.28µs / None | 33.8ms / 14.0 MB | 10.1ms / 2.0 MB | 27.1ms / **🔴 58.3 MB** | 135µs / None | 1.79ms / None
Day 20 | **🔴 1.27s** / 126 MB | 72.2µs / 89.1 KB | 15.5ms / None | 175µs / None | 5.51ms / None | 115µs / 90.9 KB | 18ms / 2.0 MB | 24.3ms / None | 3.18ms / None | **🔴 29.1ms** / None
Day 21 | 29.5µs / 16.9 KB | 35.3ms / 4.4 MB | 3.1µs / None | 144µs / None | 5.74µs / None | 222µs / 121 KB | 1.17µs / 8.0 B | 202µs / 270 KB | 13.2ms / None | 29ns / None
Day 22 | 464ms / **🔴 234 MB** | 11.4ms / 194 KB | 58.7ms / None | 14.1ms / None | 2.84µs / None | 31.4ms / 15.1 MB | 11.9ms / 2.3 MB | 322µs / None | 1.44ms / 14.5 KB | **🔴 48.8ms** / None
Day 23 | 6.2µs / 1.2 KB | 4.69µs / 21.1 KB | 33µs / None | 66.8ms / None | 11.6µs / None | **🔴 179ms** / None | **🔴 630ms** / **🔴 165 MB** | 45.9ms / None | **🔴 289ms** / None | 532µs / None
Day 24 | 7.44ms / 10.0 MB | 4.58ms / 3.8 MB | 85.2ms / None | 58.6ms / None | 2.72ms / None | 46.2ms / None | 8.14µs / 576 B | **🔴 74.6ms** / 19.2 MB | - | 84.4µs / None
Day 25 | 248ns / 32.0 B | 7.74ms / 7.3 KB | 44.6ms / None | 2.04ms / None | 14.1µs / None | 35.4ms / None | 28.6ms / 19.4 KB | 1.24µs / None | 6.13ms / None | 257µs / None
*Total* | *4.1s / 1.0 GB* | *13.7s / 1.7 GB* | *1.17s / 55.5 MB* | *537ms / 97.6 MB* | *284ms / 95.6 MB* | *768ms / 108 MB* | *778ms / 321 MB* | *349ms / 114 MB* | *642ms / 9.3 MB* | *98.3ms / None*


## Zig
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 5.35µs / None | 26.3µs / None | 3.16µs / None | 654µs / None | 1.02µs / None | 352µs / 93.9 KB | 4.83µs / None | 5.43µs / None | 84.9µs / None | 32.6µs / None
Day 02 | 4.63µs / None | 9.88µs / None | 4.05µs / None | 48.6µs / None | 6.32µs / None | 51.3µs / None | 813ns / None | 1.04µs / None | 2.43µs / None | 29.6µs / None
Day 03 | 486µs / 98.7 KB | 19.9µs / None | 28.1µs / None | 2.04ms / None | 84µs / None | 527µs / 31.9 KB | 39.5µs / None | 8.34µs / None | 21.4µs / None | 26.9µs / None
Day 04 | 1.03s / 65.0 B | 423µs / None | 413µs / None | 8.04µs / None | 916ns / None | 2.05ms / 249 KB | 6.48µs / None | 5.99µs / None | 51.1µs / None | 165µs / None
Day 05 | 98.5µs / None | **🔴 2.49s** / **🔴 33.0 B** | 52.6ms / None | 2.97ms / None | 2.33µs / None | 1.76ms / 128 KB | 711µs / None | 3.14µs / None | 664µs / None | 14.6µs / None
Day 06 | 13.5ms / None | 3.68µs / None | 428µs / None | 6.51ms / None | 20.9µs / None | 8.11ms / 498 KB | 412ns / None | 4.53µs / None | 80ns / None | 4.67ms / None
Day 07 | 40.6µs / 17.4 KB | 556µs / None | 99.1µs / **🔴 69.7 KB** | 2.71µs / None | 8.62µs / None | 1.35ms / 656 MB | 9.28µs / None | 7.77µs / None | 105µs / None | 237µs / None
Day 08 | 3.91µs / None | 3.19µs / None | 20µs / None | 56.1µs / None | 15.2µs / None | 5.25ms / 3.1 MB | 14.5µs / None | 269µs / None | 466µs / None | 4.05µs / None
Day 09 | 709µs / None | 6.42µs / None | 17.1µs / None | 33.8ms / **🔴 64.0 MB** | 3.29µs / None | 111µs / 34.4 KB | 101µs / None | 221µs / None | 18.2µs / None | 410µs / None
Day 10 | 32.3ms / **🔴 14.0 MB** | 8.06µs / None | 273µs / None | 5.29µs / None | 771µs / None | 30.6µs / 8.8 KB | 10.8µs / None | 614ns / None | 96.4µs / None | 1.97ms / None
Day 11 | 3.09ms / None | - | 19.5µs / None | 2.01ms / None | 223µs / 33.0 KB | 15.1ms / 53.0 KB | 69.8µs / None | 2.6ms / None | 4.17µs / None | 1.21ms / None
Day 12 | 50.6µs / None | 74ns / None | 45.2µs / None | 32.1µs / None | 3.75ms / None | 2.33ms / 92.3 KB | 52.1µs / None | 64.9µs / None | 14.7ms / None | 13.8ms / None
Day 13 | 3.12ms / None | 10.3µs / None | 15.8ms / None | 12.2ms / 1.2 KB | 5.31µs / None | 14.4µs / 589 B | 35.5µs / None | 5.04µs / None | 74.1µs / None | 5.03µs / None
Day 14 | 45.2µs / None | **🔴 4.72s** / **🔴 65.0 B** | 11.5ms / None | 171ms / **🔴 20.5 MB** | 536µs / None | 6.27ms / 6.1 MB | 10µs / None | 2.67ms / None | 13.5ms / **🔴 3.4 KB** | 5.17ms / None
Day 15 | 428µs / None | 269ns / None | **🔴 362ms** / None | 144ms / None | 7.26µs / None | 663ms / 240 MB | 11.1ms / None | 920ns / None | 69.7µs / None | 1.25ms / None
Day 16 | 8.36µs / None | 139ns / None | 5.14ms / 3.7 KB | 124µs / None | 102ms / None | 1.14ms / 158 KB | 4.57µs / None | **🔴 215ms** / **🔴 52.4 MB** | 47.8ms / None | 9.31ms / None
Day 17 | 2.2ms / None | 21ms / None | **🔴 222ms** / None | **🔴 1.31s** / 1.0 B | 3.62µs / None | **🔴 1m13.7s** / 937 KB | 1.49ms / None | 165µs / 102 KB | 2.36ms / None | 83.1µs / None
Day 18 | 14.9ms / None | 783µs / None | 6.11µs / None | 10.3ms / 12.7 KB | **🔴 696ms** / **🔴 254 MB** | 8.22ms / 1.2 MB | 2.12ms / None | 84.2µs / None | 4.5µs / None | 137µs / None
Day 19 | 2.55ms / 392 KB | 28ns / None | 20.3µs / None | 8.14µs / None | 7.6µs / None | 10.4ms / 108 KB | 14ms / 7.3 KB | 12.2ms / None | 1.35ms / None | 2.26ms / 20.6 KB
Day 20 | **🔴 3.12s** / 1.0 B | 25.4µs / None | 95.4ms / None | 181µs / None | 7.37ms / None | 11.1ms / 305 KB | 2.15ms / None | 36.5ms / None | 2.56µs / None | **🔴 22.7ms** / None
Day 21 | 4µs / None | 1.1µs / None | 3.37µs / None | 156µs / 328 KB | 4.34µs / None | 2.97ms / 172 KB | 990ns / None | 75.4µs / None | 590µs / None | 20.6µs / 4.3 KB
Day 22 | 8.3ms / None | 919µs / None | 51.1ms / None | 2.36ms / None | 2.06µs / None | 106ms / **🔴 4.7 GB** | 23.1ms / None | 908µs / None | 1.15ms / None | **🔴 35.5ms** / **🔴 1.1 MB**
Day 23 | 6.94µs / None | 75ns / None | 29.6µs / None | 33.8ms / None | 8.49µs / None | 5.9s / 48.0 MB | **🔴 284ms** / **🔴 107 MB** | 66.8ms / None | **🔴 244ms** / None | 520µs / None
Day 24 | **🔴 1.47s** / 1.0 B | 791µs / None | 64.6ms / None | 4.47ms / None | 2.6ms / 696 B | 77.6ms / 6.2 MB | 445ns / None | 80.5ms / **🔴 18.9 MB** | 444µs / None | 112µs / 40.3 KB
Day 25 | 92ns / None | 109ns / None | 35.5ms / None | 663µs / None | 12.2µs / None | 34.6ms / 174 B | 265µs / None | 1.18µs / None | 201µs / None | 198µs / None
*Total* | *5.7s / 14.5 MB* | *7.23s / 98.0 B* | *917ms / 73.4 KB* | *1.73s / 84.8 MB* | *813ms / 254 MB* | *1m20.6s / 5.7 GB* | *340ms / 107 MB* | *418ms / 71.4 MB* | *328ms / 3.4 KB* | *99.8ms / 1.2 MB*

