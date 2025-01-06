This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## 2024
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 47.2µs / None | 18.5µs / None | 37.7µs
Day 02 | 47.5µs / None | 43µs / None | 23.9µs
Day 03 | 29.1µs / None | 8.86µs / None | 28.2µs
Day 04 | 272µs / None | 454µs / None | 142µs
Day 05 | 30.5µs / None | 17.2µs / None | 13.7µs
Day 06 | 4.94ms / None | 3.78ms / None | 4.42ms
Day 07 | 288µs / None | 243µs / None | 207µs
Day 08 | 6.79µs / None | 3.31µs / None | 4.4µs
Day 09 | 462µs / None | 552µs / None | 316µs
Day 10 | 114µs / None | 39µs / None | 1.22ms
Day 11 | 1.38ms / None | 1.06ms / None | 987µs
Day 12 | 591µs / None | 451µs / None | 13.5ms
Day 13 | 7.22µs / 48.0 B | 5.64µs / None | 4.54µs
Day 14 | 268µs / 32.0 B | 3.8ms / None | 4.6ms
Day 15 | 606µs / None | 1.81ms / None | 1.17ms
Day 16 | 565µs / None | 5.61ms / None | 8.59ms
Day 17 | 19.4µs / 24.0 B | 216µs / None | 74.4µs
Day 18 | 206µs / 32.0 B | 124µs / None | 176µs
Day 19 | 1.4ms / None | 1.81ms / None | 2.05ms
Day 20 | **🔴 19.9ms** / None | **🔴 25.8ms** / None | **🔴 20.3ms**
Day 21 | 63ns / None | 28ns / None | 16.2µs
Day 22 | **🔴 11.2ms** / None | **🔴 48.1ms** / None | **🔴 35ms**
Day 23 | **🔴 12.7ms** / 48.0 B | 543µs / None | 476µs
Day 24 | 42.5µs / **🔴 14.3 KB** | 78.4µs / None | 92.6µs
Day 25 | 279µs / None | 199µs / None | 157µs
*Total* | *55.4ms / 14.5 KB* | *94.7ms / None* | *93.7ms*

![Graph for year 2024](y2024.svg)

## 2023
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 198µs / None | 91.4µs / None | 75.3µs
Day 02 | 7.3µs / None | 2.45µs / None | 2.39µs
Day 03 | 30.3µs / None | 24.2µs / None | 18.4µs
Day 04 | 34.3µs / 256 B | 17.1µs / None | 49.6µs
Day 05 | 60.8µs / 10.8 KB | 12.7µs / None | 1.97ms
Day 06 | 135ns / None | 108ns / None | 88ns
Day 07 | 371µs / 49.4 KB | 70.4µs / 24.5 KB | 108µs
Day 08 | 939µs / 426 KB | 2.37ms / None | 223µs
Day 09 | 38.2µs / None | 23.1µs / None | 19.9µs
Day 10 | 1.19ms / 891 KB | 101µs / None | 88.4µs
Day 11 | 13.2µs / None | 11.9µs / None | 10.8µs
Day 12 | 11.2ms / None | 16ms / None | **🔴 16.8ms**
Day 13 | 111µs / 2.7 KB | 61µs / None | 93.2µs
Day 14 | 16.3ms / 16.4 KB | 16.9ms / 0.2 B | -
Day 15 | 141µs / 58.1 KB | 62.2µs / None | 62.9µs
Day 16 | 21.8ms / 98.3 KB | 18.6ms / None | **🔴 43.1ms**
Day 17 | **🔴 223ms** / **🔴 13.2 MB** | **🔴 284ms** / **🔴 9.3 MB** | -
Day 18 | 6.73µs / None | 2.98µs / None | 3.77µs
Day 19 | 288µs / 245 KB | 143µs / None | 3.53ms
Day 20 | 1.28ms / 2.9 KB | 3.12ms / None | -
Day 21 | 28.9ms / 62.0 KB | 13.1ms / None | -
Day 22 | 5.13ms / 1.1 MB | 1.31ms / 7.5 KB | -
Day 23 | **🔴 516ms** / 2.7 MB | **🔴 291ms** / None | -
Day 24 | - | - | -
Day 25 | 47.1ms / **🔴 21.2 MB** | 7ms / None | -
*Total* | *874ms / 40.1 MB* | *654ms / 9.3 MB* | *66.2ms*

![Graph for year 2023](y2023.svg)

## 2022
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 8.96µs / None | 6.24µs / None
Day 02 | 1.89µs / None | 644ns / None
Day 03 | 23.7µs / None | 46µs / None
Day 04 | 8.87µs / None | 6µs / None
Day 05 | 4.76µs / None | 3.28µs / None
Day 06 | 4.73µs / None | 5.61µs / None
Day 07 | 14.2µs / None | 7.96µs / None
Day 08 | 388µs / None | 295µs / None
Day 09 | 233µs / None | 188µs / None
Day 10 | 809ns / None | 652ns / None
Day 11 | 3.69ms / None | 2.4ms / None
Day 12 | 208µs / None | 123µs / None
Day 13 | 764µs / 610 KB | 254µs / 391 KB
Day 14 | 3.11ms / None | 3.53ms / None
Day 15 | 1.9µs / 568 B | 1.05µs / None
Day 16 | **🔴 141ms** / **🔴 134 MB** | **🔴 173ms** / **🔴 35.7 MB**
Day 17 | 468µs / 229 KB | 167µs / None
Day 18 | 87.6µs / None | 86.8µs / None
Day 19 | **🔴 116ms** / **🔴 55.0 MB** | 51.6ms / **🔴 43.1 MB**
Day 20 | 37.4ms / None | 24.4ms / None
Day 21 | 329µs / 186 KB | 204µs / 270 KB
Day 22 | 275µs / None | 317µs / None
Day 23 | 60.9ms / 2.0 MB | 47.8ms / None
Day 24 | 76.6ms / 16.8 MB | **🔴 81.6ms** / 19.2 MB
Day 25 | 1.66µs / None | 1.41µs / None
*Total* | *441ms / 209 MB* | *386ms / 98.6 MB*

![Graph for year 2022](y2022.svg)

## 2021
 &nbsp;  | Crystal | Golang | Haskell | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 207µs** | 59.8µs / 81.9 KB | **🔴 1.18ms** | 17.6µs / None | 5.18µs
Day 02 | 48.4µs | 855ns / None | **🔴 713µs** | 814ns / None | 720ns
Day 03 | **🔴 113µs** | 23.9µs / None | **🔴 1.08ms** | 18.8µs / 2.0 KB | 50.3µs
Day 04 | - | 122µs / 79.2 KB | - | 54.6µs / 102 KB | 53µs
Day 05 | - | 2.13ms / 1.1 MB | - | 354µs / 8.2 KB | 658µs
Day 06 | - | 999ns / None | - | 907ns / 512 B | 873ns
Day 07 | - | 48.9µs / 8.2 KB | - | 22.8µs / 3.3 KB | 26.4µs
Day 08 | - | 260µs / 167 KB | - | 16.4µs / 2.4 KB | 1.04ms
Day 09 | - | 539µs / 238 KB | - | 99.2µs / 19.6 KB | 118µs
Day 10 | - | 13.4µs / 920 B | - | 28.2µs / 2.5 KB | 26.1µs
Day 11 | - | 466µs / 223 KB | - | 122µs / 319 B | 70.4µs
Day 12 | - | 1.79ms / 3.0 MB | - | 4.57ms / 1.2 KB | 148µs
Day 13 | - | 205µs / 22.7 KB | - | 277µs / 265 KB | 259µs
Day 14 | - | 270µs / 119 KB | - | 15.6µs / 1.8 KB | 64.6µs
Day 15 | - | 31.4ms / 2.5 MB | - | 55.5ms / **🔴 133 MB** | **🔴 10.6ms**
Day 16 | - | 9.8µs / 5.1 KB | - | 6.14µs / 4.8 KB | 310µs
Day 17 | - | 1.29ms / 64.0 B | - | 1.6ms / None | 1.45ms
Day 18 | - | 27.8ms / 4.8 MB | - | 23.7ms / 15.5 MB | **🔴 6.08ms**
Day 19 | - | **🔴 525ms** / 16.4 MB | - | 10.5ms / 2.0 MB | -
Day 20 | - | 15.5ms / 82.5 KB | - | 20.3ms / 2.0 MB | -
Day 21 | - | 2.58ms / 2.3 MB | - | 1.11µs / 8.0 B | 203µs
Day 22 | - | 7.48ms / 3.8 MB | - | 11.4ms / 2.3 MB | -
Day 23 | - | **🔴 296ms** / **🔴 199 MB** | - | **🔴 689ms** / **🔴 165 MB** | -
Day 24 | - | 1.62µs / 656 B | - | 9.38µs / 576 B | -
Day 25 | - | 32.9ms / None | - | 28.3ms / 19.4 KB | -
*Total* | *368µs* | *946ms / 234 MB* | *2.97ms* | *846ms / 321 MB* | *21.2ms*

![Graph for year 2021](y2021.svg)

## 2020
 &nbsp;  | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 240µs | 18.1ms / 14.1 MB | 151µs / 144 KB | 352µs
Day 02 | 392µs | 511µs / 280 KB | 30.1µs / 24.6 KB | 57.6µs
Day 03 | 289µs | 22.5µs / 16.3 KB | 2.71µs / None | 12.1µs
Day 04 | 743µs | 429µs / 237 KB | 46.5µs / None | 1.71ms
Day 05 | 488µs | 100µs / 51.9 KB | 64.7µs / 12.4 KB | 188µs
Day 06 | 1.88ms | 3.62ms / 4.0 MB | 20µs / None | 7.73ms
Day 07 | 690µs | 1.32ms / 692 KB | 245µs / 281 KB | 511µs
Day 08 | 477µs | 4.41ms / 5.5 MB | 76µs / None | 4.66ms
Day 09 | 148µs | 19.2ms / 44.0 MB | 65.6µs / None | 163µs
Day 10 | 10.3µs | 93.1µs / 62.2 KB | 733ns / None | 28.4µs
Day 11 | 39.1ms | 45ms / 4.6 MB | 15.1ms / 2.0 MB | 17.2ms
Day 12 | 48.4µs | 130µs / 78.6 KB | 2.47µs / None | 1.57ms
Day 13 | 92µs | 8.25µs / 5.1 KB | - | 9.22µs
Day 14 | 2.98ms | 10.6ms / 7.4 MB | 3.34ms / 4.5 MB | -
Day 15 | 367ms | 397ms / **🔴 240 MB** | **🔴 418ms** / **🔴 49.4 MB** | 542ms
Day 16 | 614µs | 1.8ms / 1.1 MB | 256µs / 141 KB | 1.23ms
Day 17 | 162ms | **🔴 540ms** / **🔴 338 MB** | 34ms / **🔴 21.7 MB** | 5.02ms
Day 18 | 593µs | 10.9ms / 2.8 MB | 145µs / None | 7.18ms
Day 19 | 3.87ms | 17.8ms / 6.9 MB | 32.4ms / 14.0 MB | 12.6ms
Day 20 | 4.69ms | 7.98ms / 5.3 MB | 128µs / 90.9 KB | 11.6ms
Day 21 | 850µs | 2.25ms / 438 KB | 234µs / 121 KB | 3.31ms
Day 22 | 118ms | 76.7ms / 44.0 MB | 35.2ms / 15.1 MB | 111ms
Day 23 | 1.01s | **🔴 677ms** / 32.0 MB | **🔴 180ms** / None | **🔴 4.59s**
Day 24 | **🔴 6.1s** | 131ms / 7.9 MB | 45.7ms / None | 77.3ms
Day 25 | 38.9ms | 40ms / 320 B | 36.3ms / None | 34.1ms
*Total* | *7.86s* | *2.01s / 760 MB* | *801ms / 108 MB* | *5.43s*

![Graph for year 2020](y2020.svg)

## 2019
 &nbsp;  | C++ | Crystal | Golang | Rust
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 1.39µs | 9.07µs | 5.45µs / 3.4 KB | 877ns / None
Day 02 | 600µs | 2.97ms | 4.87ms / 9.3 MB | 2.23ms / None
Day 03 | 25.2ms | 13.9ms | 7.07ms / 10.0 MB | 37.1µs / None
Day 04 | 1.69ms | 24.4ms | 1.15ms / 80.0 B | 592µs / None
Day 05 | 24.8µs | 46.4µs | 58.9µs / 78.8 KB | 2.93µs / None
Day 06 | 2.12µs | 2.78ms | 31.8ms / 18.4 MB | 138µs / 163 KB
Day 07 | 3.66ms | 5.24ms | 5.15ms / 5.5 MB | 512µs / 102 KB
Day 08 | 29.6µs | 137µs | 170µs / 29.7 KB | 19.2µs / None
Day 09 | 36.2ms | 51ms | 2.8ms / 74.6 KB | 1.78ms / None
Day 10 | 21.8ms | 8.09ms | 15.1ms / 11.3 MB | 1.11ms / None
Day 11 | 11.5ms | 11.3ms | 2.95ms / 888 KB | 498µs / None
Day 12 | 157ms | 122ms | 9.72ms / 736 B | 3.54ms / None
Day 13 | 76.6ms | 98.8ms | 9.13ms / 2.9 MB | 6.4µs / None
Day 14 | 2.94ms | 5.82ms | 6.08ms / 281 KB | 2.14ms / 409 KB
Day 15 | 21.8ms | 29.6ms | 19.5ms / 32.5 MB | 9.25µs / None
Day 16 | 160ms | 231ms | 179ms / 1.1 MB | **🔴 130ms** / 524 KB
Day 17 | 11.8ms | 14.1ms | 1.11ms / 303 KB | 5.21µs / None
Day 18 | - | **🔴 9.25s** | **🔴 485ms** / **🔴 405 MB** | **🔴 134ms** / **🔴 94.4 MB**
Day 19 | 276ms | 275ms | 83.8ms / 66.6 MB | 6.22µs / None
Day 20 | 276ms | 236ms | 58.5ms / 64.4 MB | 5.42ms / None
Day 21 | 57.8ms | 70.4ms | 4.78ms / 124 KB | 5.2µs / None
Day 22 | 2.09µs | 92µs | 211µs / 110 KB | 2.92µs / None
Day 23 | 34.4ms | 34.6ms | 7.34ms / 4.7 MB | 9.51µs / None
Day 24 | 21.2ms | 33.8ms | 225ms / **🔴 195 MB** | 4.25ms / None
Day 25 | **🔴 825ms** | 1.44s | 84.9ms / 50.8 MB | 12.2µs / None
*Total* | *2.02s* | *12s* | *1.25s / 880 MB* | *286ms / 95.6 MB*

![Graph for year 2019](y2019.svg)

## 2018
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 645µs / None | 685µs / None
Day 02 | 5.04ms / 2.8 MB | 459µs / None
Day 03 | 88.5ms / 64.2 MB | 4.57ms / None
Day 04 | 2.85ms / 399 KB | 7.86µs / None
Day 05 | 256ms / 48.3 MB | 5.18ms / None
Day 06 | 30.1ms / 19.4 KB | 7.2ms / None
Day 07 | 183µs / 68.6 KB | 4.06µs / None
Day 08 | 249µs / 162 KB | 72.2µs / None
Day 09 | 203ms / 167 MB | 41.3ms / **🔴 64.0 MB**
Day 10 | 1.24ms / 768 KB | 6.03µs / None
Day 11 | 27.8ms / 721 KB | 2.47ms / None
Day 12 | 1.91ms / 1.5 MB | 63.2µs / None
Day 13 | 5.81ms / 2.9 MB | 3.35ms / None
Day 14 | 118ms / 21.0 MB | 102ms / **🔴 33.6 MB**
Day 15 | 435ms / **🔴 261 MB** | **🔴 149ms** / 377 KB
Day 16 | 16.4ms / 10.1 MB | 135µs / None
Day 17 | 45.8ms / 12.1 MB | 799µs / None
Day 18 | 178ms / 166 MB | 19.9ms / None
Day 19 | 62.5ms / 27.0 KB | 45.9ms / None
Day 20 | 28.9ms / 8.5 MB | 207µs / None
Day 21 | 262ms / 448 KB | 141µs / None
Day 22 | **🔴 2.58s** / **🔴 241 MB** | 13.9ms / None
Day 23 | 162ms / 1.7 MB | 65.2ms / None
Day 24 | 94.3ms / 42.6 MB | 49.2ms / None
Day 25 | 8.5ms / 992 KB | 1.93ms / None
*Total* | *4.62s / 1.1 GB* | *514ms / 97.9 MB*

![Graph for year 2018](y2018.svg)

## 2017
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 10.7µs / 2.3 KB | 7.04µs / 16.4 KB
Day 02 | 17.1µs / 8.3 KB | 8.71µs / 2.0 KB
Day 03 | 30.9µs / 15.9 KB | 10.8µs / 14.3 KB
Day 04 | 1.57ms / 825 KB | 2.95ms / 2.0 MB
Day 05 | 80.1ms / 25.5 MB | 41.1ms / 24.9 KB
Day 06 | 16.1ms / 6.6 MB | 1.03ms / 1.8 MB
Day 07 | 2.69ms / 1.0 MB | 635µs / 523 KB
Day 08 | 617µs / 318 KB | 206µs / 38.2 KB
Day 09 | 130µs / 49.2 KB | 45.2µs / 89.3 KB
Day 10 | 436µs / 11.4 KB | 114µs / 1.1 KB
Day 11 | 139µs / 11.1 KB | 82.3µs / None
Day 12 | 3.33ms / 1.2 MB | 829µs / 1.1 MB
Day 13 | 26.6ms / 4.1 KB | **🔴 353ms** / 2.4 KB
Day 14 | 24.9ms / 1.7 MB | 22.3ms / **🔴 39.2 MB**
Day 15 | **🔴 510ms** / 1.4 KB | **🔴 407ms** / 32.0 B
Day 16 | 191ms / 82.8 MB | 19.3ms / 10.6 MB
Day 17 | 240ms / 48.5 KB | 229ms / 16.1 KB
Day 18 | 7.67ms / 5.7 MB | 11.8µs / None
Day 19 | 214µs / 44.8 KB | 37.7µs / None
Day 20 | 335ms / **🔴 206 MB** | 15ms / None
Day 21 | 66ms / 37.7 MB | 3.03µs / None
Day 22 | 58.6ms / 526 KB | 57.1ms / None
Day 23 | 1.54ms / 4.6 KB | 28.5µs / None
Day 24 | 119ms / 59.9 MB | 81.3ms / None
Day 25 | 31.2ms / 15.3 KB | 43.1ms / None
*Total* | *1.72s / 430 MB* | *1.27s / 55.5 MB*

![Graph for year 2017](y2017.svg)

## 2016
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 168µs / 101 KB | 40.2µs / 34.9 KB | 23.2µs
Day 02 | 7.97µs / 192 B | 71.9µs / 3.8 KB | 9.56µs
Day 03 | 62.3µs / 49.2 KB | 199µs / 122 KB | 18.2µs
Day 04 | 1.62ms / 644 KB | 1.68ms / 634 KB | 416µs
Day 05 | **🔴 3.8s** / 3.4 KB | **🔴 6.39s** / **🔴 689 MB** | **🔴 2.53s**
Day 06 | 114µs / 4.6 KB | 740µs / 5.8 KB | 3.96µs
Day 07 | 1.1ms / 66.4 KB | 2.27ms / 1.0 MB | 542µs
Day 08 | 3.71µs / 96.0 B | 9.89µs / 6.2 KB | 3.3µs
Day 09 | 7.86µs / None | 142µs / 361 KB | 6.08µs
Day 10 | 8.12ms / 5.5 MB | 131µs / 90.7 KB | 7.82µs
Day 11 | 24.7ms / 16.8 MB | 1.33s / **🔴 785 MB** | -
Day 12 | 4.74µs / 3.0 KB | 2.05µs / 5.8 KB | 57ns
Day 13 | 135µs / 82.1 KB | 102µs / 101 KB | 9.15µs
Day 14 | **🔴 9.17s** / 33.1 KB | **🔴 5.72s** / 76.0 B | -
Day 15 | 18.2ms / 14.6 KB | 4.62ms / 432 B | 251ns
Day 16 | 107ms / 17.8 MB | 57.1ms / 67.1 MB | 124ns
Day 17 | 75.7ms / 52.5 MB | 28.9ms / 35.4 MB | 20.7ms
Day 18 | 177ms / 224 B | 292ms / 63.8 MB | 732µs
Day 19 | 251ms / **🔴 145 MB** | 40ns / None | -
Day 20 | 276µs / 120 KB | 84.1µs / 76.4 KB | -
Day 21 | 135ms / 48.2 MB | 32.8ms / 4.4 MB | -
Day 22 | 16.9ms / 392 KB | 10.6ms / 194 KB | -
Day 23 | 12.8µs / 9.0 KB | 4.37µs / 21.1 KB | -
Day 24 | 67.2ms / 27.3 MB | 4.37ms / 3.8 MB | -
Day 25 | 59.6ms / 16.9 KB | 8.19ms / 7.3 KB | -
*Total* | *13.9s / 314 MB* | *13.9s / 1.7 GB* | *2.55s*

![Graph for year 2016](y2016.svg)

## 2015
 &nbsp;  | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 35.5µs** | 13.7µs / None | 12.9µs / None | 5.57µs
Day 02 | - | 27.5µs / None | 52µs / 16.0 KB | 4.48µs
Day 03 | - | 549µs / 166 KB | 467µs / 279 KB | 503µs
Day 04 | - | 942ms / 24.0 B | **🔴 1.5s** / 159 MB | 1.1s
Day 05 | - | 286µs / None | 139µs / None | 113µs
Day 06 | - | 64.5ms / 252 KB | 38.6ms / 19.2 KB | 9.06ms
Day 07 | - | 247µs / 117 KB | 240µs / 148 KB | 36.8µs
Day 08 | - | 7.75µs / None | 32.6µs / 29.6 KB | 4.33µs
Day 09 | - | 12.7ms / 6.2 MB | 5.06ms / 651 KB | 737µs
Day 10 | - | 60.3ms / 56.6 MB | 678ms / **🔴 312 MB** | 30.9ms
Day 11 | - | 26.8ms / 313 KB | 50.5ms / 15.0 MB | 3.52ms
Day 12 | - | 853µs / 367 KB | 292µs / 357 KB | 58.3µs
Day 13 | - | 81.5ms / 28.1 MB | 93.4ms / 7.2 MB | 2.28ms
Day 14 | - | 435µs / 180 KB | 405µs / 425 B | 38.7µs
Day 15 | - | 56ms / 67.5 MB | 45.2ms / 44.1 MB | 412µs
Day 16 | - | 506µs / 262 KB | 273µs / 250 KB | 7.61µs
Day 17 | - | 62.2ms / 3.0 KB | 43.5ms / 84.1 MB | 2.13ms
Day 18 | - | 47.9ms / 42.8 KB | 8.08ms / 56.4 KB | 14.6ms
Day 19 | - | 545µs / 413 KB | 1.11ms / 546 KB | 2.33ms
Day 20 | - | **🔴 3.58s** / **🔴 465 MB** | **🔴 1.25s** / 126 MB | **🔴 3.06s**
Day 21 | - | 417µs / 277 KB | 29.2µs / 16.9 KB | 3.7µs
Day 22 | - | 457ms / **🔴 435 MB** | 204ms / **🔴 234 MB** | 7.9ms
Day 23 | - | 22.4µs / 9.3 KB | 9.21µs / 1.2 KB | 6.75µs
Day 24 | - | 146ms / 61.1 MB | 7.72ms / 10.0 MB | **🔴 1.39s**
Day 25 | - | 8.95µs / 6.1 KB | 217ns / 32.0 B | 89ns
*Total* | *35.5µs* | *5.54s / 1.1 GB* | *3.93s / 994 MB* | *5.62s*

![Graph for year 2015](y2015.svg)

## C++
 &nbsp;  | 2019
 ---:  | ---: 
Day 01 | 1.39µs
Day 02 | 600µs
Day 03 | 25.2ms
Day 04 | 1.69ms
Day 05 | 24.8µs
Day 06 | 2.12µs
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
Day 01 | **🔴 35.5µs** | 9.07µs | 240µs | **🔴 207µs**
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
*Total* | *35.5µs* | *12s* | *7.86s* | *368µs*


## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 13.7µs / None | 168µs / 101 KB | 10.7µs / 2.3 KB | 645µs / None | 5.45µs / 3.4 KB | 18.1ms / 14.1 MB | 59.8µs / 81.9 KB | 8.96µs / None | 198µs / None | 47.2µs / None
Day 02 | 27.5µs / None | 7.97µs / 192 B | 17.1µs / 8.3 KB | 5.04ms / 2.8 MB | 4.87ms / 9.3 MB | 511µs / 280 KB | 855ns / None | 1.89µs / None | 7.3µs / None | 47.5µs / None
Day 03 | 549µs / 166 KB | 62.3µs / 49.2 KB | 30.9µs / 15.9 KB | 88.5ms / 64.2 MB | 7.07ms / 10.0 MB | 22.5µs / 16.3 KB | 23.9µs / None | 23.7µs / None | 30.3µs / None | 29.1µs / None
Day 04 | 942ms / 24.0 B | 1.62ms / 644 KB | 1.57ms / 825 KB | 2.85ms / 399 KB | 1.15ms / 80.0 B | 429µs / 237 KB | 122µs / 79.2 KB | 8.87µs / None | 34.3µs / 256 B | 272µs / None
Day 05 | 286µs / None | **🔴 3.8s** / 3.4 KB | 80.1ms / 25.5 MB | 256ms / 48.3 MB | 58.9µs / 78.8 KB | 100µs / 51.9 KB | 2.13ms / 1.1 MB | 4.76µs / None | 60.8µs / 10.8 KB | 30.5µs / None
Day 06 | 64.5ms / 252 KB | 114µs / 4.6 KB | 16.1ms / 6.6 MB | 30.1ms / 19.4 KB | 31.8ms / 18.4 MB | 3.62ms / 4.0 MB | 999ns / None | 4.73µs / None | 135ns / None | 4.94ms / None
Day 07 | 247µs / 117 KB | 1.1ms / 66.4 KB | 2.69ms / 1.0 MB | 183µs / 68.6 KB | 5.15ms / 5.5 MB | 1.32ms / 692 KB | 48.9µs / 8.2 KB | 14.2µs / None | 371µs / 49.4 KB | 288µs / None
Day 08 | 7.75µs / None | 3.71µs / 96.0 B | 617µs / 318 KB | 249µs / 162 KB | 170µs / 29.7 KB | 4.41ms / 5.5 MB | 260µs / 167 KB | 388µs / None | 939µs / 426 KB | 6.79µs / None
Day 09 | 12.7ms / 6.2 MB | 7.86µs / None | 130µs / 49.2 KB | 203ms / 167 MB | 2.8ms / 74.6 KB | 19.2ms / 44.0 MB | 539µs / 238 KB | 233µs / None | 38.2µs / None | 462µs / None
Day 10 | 60.3ms / 56.6 MB | 8.12ms / 5.5 MB | 436µs / 11.4 KB | 1.24ms / 768 KB | 15.1ms / 11.3 MB | 93.1µs / 62.2 KB | 13.4µs / 920 B | 809ns / None | 1.19ms / 891 KB | 114µs / None
Day 11 | 26.8ms / 313 KB | 24.7ms / 16.8 MB | 139µs / 11.1 KB | 27.8ms / 721 KB | 2.95ms / 888 KB | 45ms / 4.6 MB | 466µs / 223 KB | 3.69ms / None | 13.2µs / None | 1.38ms / None
Day 12 | 853µs / 367 KB | 4.74µs / 3.0 KB | 3.33ms / 1.2 MB | 1.91ms / 1.5 MB | 9.72ms / 736 B | 130µs / 78.6 KB | 1.79ms / 3.0 MB | 208µs / None | 11.2ms / None | 591µs / None
Day 13 | 81.5ms / 28.1 MB | 135µs / 82.1 KB | 26.6ms / 4.1 KB | 5.81ms / 2.9 MB | 9.13ms / 2.9 MB | 8.25µs / 5.1 KB | 205µs / 22.7 KB | 764µs / 610 KB | 111µs / 2.7 KB | 7.22µs / 48.0 B
Day 14 | 435µs / 180 KB | **🔴 9.17s** / 33.1 KB | 24.9ms / 1.7 MB | 118ms / 21.0 MB | 6.08ms / 281 KB | 10.6ms / 7.4 MB | 270µs / 119 KB | 3.11ms / None | 16.3ms / 16.4 KB | 268µs / 32.0 B
Day 15 | 56ms / 67.5 MB | 18.2ms / 14.6 KB | **🔴 510ms** / 1.4 KB | 435ms / **🔴 261 MB** | 19.5ms / 32.5 MB | 397ms / **🔴 240 MB** | 31.4ms / 2.5 MB | 1.9µs / 568 B | 141µs / 58.1 KB | 606µs / None
Day 16 | 506µs / 262 KB | 107ms / 17.8 MB | 191ms / 82.8 MB | 16.4ms / 10.1 MB | 179ms / 1.1 MB | 1.8ms / 1.1 MB | 9.8µs / 5.1 KB | **🔴 141ms** / **🔴 134 MB** | 21.8ms / 98.3 KB | 565µs / None
Day 17 | 62.2ms / 3.0 KB | 75.7ms / 52.5 MB | 240ms / 48.5 KB | 45.8ms / 12.1 MB | 1.11ms / 303 KB | **🔴 540ms** / **🔴 338 MB** | 1.29ms / 64.0 B | 468µs / 229 KB | **🔴 223ms** / **🔴 13.2 MB** | 19.4µs / 24.0 B
Day 18 | 47.9ms / 42.8 KB | 177ms / 224 B | 7.67ms / 5.7 MB | 178ms / 166 MB | **🔴 485ms** / **🔴 405 MB** | 10.9ms / 2.8 MB | 27.8ms / 4.8 MB | 87.6µs / None | 6.73µs / None | 206µs / 32.0 B
Day 19 | 545µs / 413 KB | 251ms / **🔴 145 MB** | 214µs / 44.8 KB | 62.5ms / 27.0 KB | 83.8ms / 66.6 MB | 17.8ms / 6.9 MB | **🔴 525ms** / 16.4 MB | **🔴 116ms** / **🔴 55.0 MB** | 288µs / 245 KB | 1.4ms / None
Day 20 | **🔴 3.58s** / **🔴 465 MB** | 276µs / 120 KB | 335ms / **🔴 206 MB** | 28.9ms / 8.5 MB | 58.5ms / 64.4 MB | 7.98ms / 5.3 MB | 15.5ms / 82.5 KB | 37.4ms / None | 1.28ms / 2.9 KB | **🔴 19.9ms** / None
Day 21 | 417µs / 277 KB | 135ms / 48.2 MB | 66ms / 37.7 MB | 262ms / 448 KB | 4.78ms / 124 KB | 2.25ms / 438 KB | 2.58ms / 2.3 MB | 329µs / 186 KB | 28.9ms / 62.0 KB | 63ns / None
Day 22 | 457ms / **🔴 435 MB** | 16.9ms / 392 KB | 58.6ms / 526 KB | **🔴 2.58s** / **🔴 241 MB** | 211µs / 110 KB | 76.7ms / 44.0 MB | 7.48ms / 3.8 MB | 275µs / None | 5.13ms / 1.1 MB | **🔴 11.2ms** / None
Day 23 | 22.4µs / 9.3 KB | 12.8µs / 9.0 KB | 1.54ms / 4.6 KB | 162ms / 1.7 MB | 7.34ms / 4.7 MB | **🔴 677ms** / 32.0 MB | **🔴 296ms** / **🔴 199 MB** | 60.9ms / 2.0 MB | **🔴 516ms** / 2.7 MB | **🔴 12.7ms** / 48.0 B
Day 24 | 146ms / 61.1 MB | 67.2ms / 27.3 MB | 119ms / 59.9 MB | 94.3ms / 42.6 MB | 225ms / **🔴 195 MB** | 131ms / 7.9 MB | 1.62µs / 656 B | 76.6ms / 16.8 MB | - | 42.5µs / **🔴 14.3 KB**
Day 25 | 8.95µs / 6.1 KB | 59.6ms / 16.9 KB | 31.2ms / 15.3 KB | 8.5ms / 992 KB | 84.9ms / 50.8 MB | 40ms / 320 B | 32.9ms / None | 1.66µs / None | 47.1ms / **🔴 21.2 MB** | 279µs / None
*Total* | *5.54s / 1.1 GB* | *13.9s / 314 MB* | *1.72s / 430 MB* | *4.62s / 1.1 GB* | *1.25s / 880 MB* | *2.01s / 760 MB* | *946ms / 234 MB* | *441ms / 209 MB* | *874ms / 40.1 MB* | *55.4ms / 14.5 KB*


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
Day 01 | 12.9µs / None | 40.2µs / 34.9 KB | 7.04µs / 16.4 KB | 685µs / None | 877ns / None | 151µs / 144 KB | 17.6µs / None | 6.24µs / None | 91.4µs / None | 18.5µs / None
Day 02 | 52µs / 16.0 KB | 71.9µs / 3.8 KB | 8.71µs / 2.0 KB | 459µs / None | 2.23ms / None | 30.1µs / 24.6 KB | 814ns / None | 644ns / None | 2.45µs / None | 43µs / None
Day 03 | 467µs / 279 KB | 199µs / 122 KB | 10.8µs / 14.3 KB | 4.57ms / None | 37.1µs / None | 2.71µs / None | 18.8µs / 2.0 KB | 46µs / None | 24.2µs / None | 8.86µs / None
Day 04 | **🔴 1.5s** / 159 MB | 1.68ms / 634 KB | 2.95ms / 2.0 MB | 7.86µs / None | 592µs / None | 46.5µs / None | 54.6µs / 102 KB | 6µs / None | 17.1µs / None | 454µs / None
Day 05 | 139µs / None | **🔴 6.39s** / **🔴 689 MB** | 41.1ms / 24.9 KB | 5.18ms / None | 2.93µs / None | 64.7µs / 12.4 KB | 354µs / 8.2 KB | 3.28µs / None | 12.7µs / None | 17.2µs / None
Day 06 | 38.6ms / 19.2 KB | 740µs / 5.8 KB | 1.03ms / 1.8 MB | 7.2ms / None | 138µs / 163 KB | 20µs / None | 907ns / 512 B | 5.61µs / None | 108ns / None | 3.78ms / None
Day 07 | 240µs / 148 KB | 2.27ms / 1.0 MB | 635µs / 523 KB | 4.06µs / None | 512µs / 102 KB | 245µs / 281 KB | 22.8µs / 3.3 KB | 7.96µs / None | 70.4µs / 24.5 KB | 243µs / None
Day 08 | 32.6µs / 29.6 KB | 9.89µs / 6.2 KB | 206µs / 38.2 KB | 72.2µs / None | 19.2µs / None | 76µs / None | 16.4µs / 2.4 KB | 295µs / None | 2.37ms / None | 3.31µs / None
Day 09 | 5.06ms / 651 KB | 142µs / 361 KB | 45.2µs / 89.3 KB | 41.3ms / **🔴 64.0 MB** | 1.78ms / None | 65.6µs / None | 99.2µs / 19.6 KB | 188µs / None | 23.1µs / None | 552µs / None
Day 10 | 678ms / **🔴 312 MB** | 131µs / 90.7 KB | 114µs / 1.1 KB | 6.03µs / None | 1.11ms / None | 733ns / None | 28.2µs / 2.5 KB | 652ns / None | 101µs / None | 39µs / None
Day 11 | 50.5ms / 15.0 MB | 1.33s / **🔴 785 MB** | 82.3µs / None | 2.47ms / None | 498µs / None | 15.1ms / 2.0 MB | 122µs / 319 B | 2.4ms / None | 11.9µs / None | 1.06ms / None
Day 12 | 292µs / 357 KB | 2.05µs / 5.8 KB | 829µs / 1.1 MB | 63.2µs / None | 3.54ms / None | 2.47µs / None | 4.57ms / 1.2 KB | 123µs / None | 16ms / None | 451µs / None
Day 13 | 93.4ms / 7.2 MB | 102µs / 101 KB | **🔴 353ms** / 2.4 KB | 3.35ms / None | 6.4µs / None | - | 277µs / 265 KB | 254µs / 391 KB | 61µs / None | 5.64µs / None
Day 14 | 405µs / 425 B | **🔴 5.72s** / 76.0 B | 22.3ms / **🔴 39.2 MB** | 102ms / **🔴 33.6 MB** | 2.14ms / 409 KB | 3.34ms / 4.5 MB | 15.6µs / 1.8 KB | 3.53ms / None | 16.9ms / 0.2 B | 3.8ms / None
Day 15 | 45.2ms / 44.1 MB | 4.62ms / 432 B | **🔴 407ms** / 32.0 B | **🔴 149ms** / 377 KB | 9.25µs / None | **🔴 418ms** / **🔴 49.4 MB** | 55.5ms / **🔴 133 MB** | 1.05µs / None | 62.2µs / None | 1.81ms / None
Day 16 | 273µs / 250 KB | 57.1ms / 67.1 MB | 19.3ms / 10.6 MB | 135µs / None | **🔴 130ms** / 524 KB | 256µs / 141 KB | 6.14µs / 4.8 KB | **🔴 173ms** / **🔴 35.7 MB** | 18.6ms / None | 5.61ms / None
Day 17 | 43.5ms / 84.1 MB | 28.9ms / 35.4 MB | 229ms / 16.1 KB | 799µs / None | 5.21µs / None | 34ms / **🔴 21.7 MB** | 1.6ms / None | 167µs / None | **🔴 284ms** / **🔴 9.3 MB** | 216µs / None
Day 18 | 8.08ms / 56.4 KB | 292ms / 63.8 MB | 11.8µs / None | 19.9ms / None | **🔴 134ms** / **🔴 94.4 MB** | 145µs / None | 23.7ms / 15.5 MB | 86.8µs / None | 2.98µs / None | 124µs / None
Day 19 | 1.11ms / 546 KB | 40ns / None | 37.7µs / None | 45.9ms / None | 6.22µs / None | 32.4ms / 14.0 MB | 10.5ms / 2.0 MB | 51.6ms / **🔴 43.1 MB** | 143µs / None | 1.81ms / None
Day 20 | **🔴 1.25s** / 126 MB | 84.1µs / 76.4 KB | 15ms / None | 207µs / None | 5.42ms / None | 128µs / 90.9 KB | 20.3ms / 2.0 MB | 24.4ms / None | 3.12ms / None | **🔴 25.8ms** / None
Day 21 | 29.2µs / 16.9 KB | 32.8ms / 4.4 MB | 3.03µs / None | 141µs / None | 5.2µs / None | 234µs / 121 KB | 1.11µs / 8.0 B | 204µs / 270 KB | 13.1ms / None | 28ns / None
Day 22 | 204ms / **🔴 234 MB** | 10.6ms / 194 KB | 57.1ms / None | 13.9ms / None | 2.92µs / None | 35.2ms / 15.1 MB | 11.4ms / 2.3 MB | 317µs / None | 1.31ms / 7.5 KB | **🔴 48.1ms** / None
Day 23 | 9.21µs / 1.2 KB | 4.37µs / 21.1 KB | 28.5µs / None | 65.2ms / None | 9.51µs / None | **🔴 180ms** / None | **🔴 689ms** / **🔴 165 MB** | 47.8ms / None | **🔴 291ms** / None | 543µs / None
Day 24 | 7.72ms / 10.0 MB | 4.37ms / 3.8 MB | 81.3ms / None | 49.2ms / None | 4.25ms / None | 45.7ms / None | 9.38µs / 576 B | **🔴 81.6ms** / 19.2 MB | - | 78.4µs / None
Day 25 | 217ns / 32.0 B | 8.19ms / 7.3 KB | 43.1ms / None | 1.93ms / None | 12.2µs / None | 36.3ms / None | 28.3ms / 19.4 KB | 1.41µs / None | 7ms / None | 199µs / None
*Total* | *3.93s / 994 MB* | *13.9s / 1.7 GB* | *1.27s / 55.5 MB* | *514ms / 97.9 MB* | *286ms / 95.6 MB* | *801ms / 108 MB* | *846ms / 321 MB* | *386ms / 98.6 MB* | *654ms / 9.3 MB* | *94.7ms / None*


## Zig
 &nbsp;  | 2015 | 2016 | 2020 | 2021 | 2023 | 2024
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 5.57µs | 23.2µs | 352µs | 5.18µs | 75.3µs | 37.7µs
Day 02 | 4.48µs | 9.56µs | 57.6µs | 720ns | 2.39µs | 23.9µs
Day 03 | 503µs | 18.2µs | 12.1µs | 50.3µs | 18.4µs | 28.2µs
Day 04 | 1.1s | 416µs | 1.71ms | 53µs | 49.6µs | 142µs
Day 05 | 113µs | **🔴 2.53s** | 188µs | 658µs | 1.97ms | 13.7µs
Day 06 | 9.06ms | 3.96µs | 7.73ms | 873ns | 88ns | 4.42ms
Day 07 | 36.8µs | 542µs | 511µs | 26.4µs | 108µs | 207µs
Day 08 | 4.33µs | 3.3µs | 4.66ms | 1.04ms | 223µs | 4.4µs
Day 09 | 737µs | 6.08µs | 163µs | 118µs | 19.9µs | 316µs
Day 10 | 30.9ms | 7.82µs | 28.4µs | 26.1µs | 88.4µs | 1.22ms
Day 11 | 3.52ms | - | 17.2ms | 70.4µs | 10.8µs | 987µs
Day 12 | 58.3µs | 57ns | 1.57ms | 148µs | **🔴 16.8ms** | 13.5ms
Day 13 | 2.28ms | 9.15µs | 9.22µs | 259µs | 93.2µs | 4.54µs
Day 14 | 38.7µs | - | - | 64.6µs | - | 4.6ms
Day 15 | 412µs | 251ns | 542ms | **🔴 10.6ms** | 62.9µs | 1.17ms
Day 16 | 7.61µs | 124ns | 1.23ms | 310µs | **🔴 43.1ms** | 8.59ms
Day 17 | 2.13ms | 20.7ms | 5.02ms | 1.45ms | - | 74.4µs
Day 18 | 14.6ms | 732µs | 7.18ms | **🔴 6.08ms** | 3.77µs | 176µs
Day 19 | 2.33ms | - | 12.6ms | - | 3.53ms | 2.05ms
Day 20 | **🔴 3.06s** | - | 11.6ms | - | - | **🔴 20.3ms**
Day 21 | 3.7µs | - | 3.31ms | 203µs | - | 16.2µs
Day 22 | 7.9ms | - | 111ms | - | - | **🔴 35ms**
Day 23 | 6.75µs | - | **🔴 4.59s** | - | - | 476µs
Day 24 | **🔴 1.39s** | - | 77.3ms | - | - | 92.6µs
Day 25 | 89ns | - | 34.1ms | - | - | 157µs
*Total* | *5.62s* | *2.55s* | *5.43s* | *21.2ms* | *66.2ms* | *93.7ms*

