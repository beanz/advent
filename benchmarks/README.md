This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## 2022
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 8.96µs / None | 5.4µs / None
Day 02 | 1.89µs / None | 591ns / None
Day 03 | 23.7µs / None | 18.2µs / None
Day 04 | 8.87µs / None | 4.83µs / None
Day 05 | 4.76µs / None | 3.08µs / None
Day 06 | 4.73µs / None | 5.07µs / None
Day 07 | 14.2µs / None | 7.87µs / None
Day 08 | 388µs / None | 254µs / None
Day 09 | 233µs / None | 184µs / None
Day 10 | 809ns / None | 522ns / None
Day 11 | 3.69ms / None | 2.14ms / None
Day 12 | 208µs / None | 114µs / None
Day 13 | 764µs / 610 KB | 236µs / 391 KB
Day 14 | 3.11ms / None | 3.6ms / None
Day 15 | 1.9µs / 568 B | 1.01µs / None
Day 16 | **🔴 141ms** / **🔴 134 MB** | **🔴 154ms** / **🔴 35.7 MB**
Day 17 | 468µs / 229 KB | 165µs / None
Day 18 | 87.6µs / None | 74.6µs / None
Day 19 | **🔴 116ms** / **🔴 55.0 MB** | 48.1ms / **🔴 43.1 MB**
Day 20 | 37.4ms / None | 22.8ms / None
Day 21 | 329µs / 186 KB | 186µs / 270 KB
Day 22 | 275µs / None | 298µs / None
Day 23 | 60.9ms / 2.0 MB | 44.9ms / None
Day 24 | 76.6ms / 16.8 MB | **🔴 75.9ms** / 19.2 MB
Day 25 | 1.66µs / None | 1.33µs / None
*Total* | *441ms / 209 MB* | *353ms / 98.6 MB*

![Graph for year 2022](y2022.svg)

## 2021
 &nbsp;  | Crystal | Golang | Haskell | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 207µs** | 59.8µs / 81.9 KB | **🔴 1.18ms** | 18.6µs / None | 11.8µs
Day 02 | 48.4µs | 855ns / None | **🔴 713µs** | 760ns / None | 720ns
Day 03 | **🔴 113µs** | 23.9µs / None | **🔴 1.08ms** | 18.9µs / 2.0 KB | 50.3µs
Day 04 | - | 122µs / 79.2 KB | - | 55.3µs / 102 KB | 53µs
Day 05 | - | 2.13ms / 1.1 MB | - | 458µs / 8.2 KB | 690µs
Day 06 | - | 999ns / None | - | 716ns / 512 B | 873ns
Day 07 | - | 48.9µs / 8.2 KB | - | 20.4µs / 3.3 KB | 26.4µs
Day 08 | - | 260µs / 167 KB | - | 12.3µs / 2.4 KB | 1.04ms
Day 09 | - | 560µs / 238 KB | - | 99.6µs / 19.6 KB | 118µs
Day 10 | - | 13.4µs / 920 B | - | 31.3µs / 2.5 KB | 26.1µs
Day 11 | - | 457µs / 223 KB | - | 102µs / 319 B | 70.4µs
Day 12 | - | 1.79ms / 3.0 MB | - | 4.31ms / 1.2 KB | 148µs
Day 13 | - | 205µs / 22.7 KB | - | 263µs / 265 KB | 259µs
Day 14 | - | 270µs / 119 KB | - | 16µs / 1.8 KB | 64.6µs
Day 15 | - | 31.4ms / 2.5 MB | - | 49.6ms / **🔴 133 MB** | **🔴 10.6ms**
Day 16 | - | 9.8µs / 5.1 KB | - | 6µs / 4.8 KB | 310µs
Day 17 | - | 1.29ms / 64.0 B | - | 1.56ms / None | 1.45ms
Day 18 | - | 28.2ms / 4.8 MB | - | 23.1ms / 15.5 MB | **🔴 6.08ms**
Day 19 | - | **🔴 525ms** / 16.4 MB | - | 10.4ms / 2.0 MB | -
Day 20 | - | 15.5ms / 82.5 KB | - | 20.4ms / 2.0 MB | -
Day 21 | - | 2.58ms / 2.3 MB | - | 1.01µs / 8.0 B | 203µs
Day 22 | - | 7.48ms / 3.8 MB | - | 10.6ms / 2.3 MB | -
Day 23 | - | **🔴 296ms** / **🔴 199 MB** | - | **🔴 639ms** / **🔴 165 MB** | -
Day 24 | - | 1.62µs / 656 B | - | 7.46µs / 576 B | -
Day 25 | - | 32.9ms / None | - | 26.7ms / 19.4 KB | -
*Total* | *368µs* | *946ms / 234 MB* | *2.97ms* | *787ms / 321 MB* | *21.2ms*

![Graph for year 2021](y2021.svg)

## 2020
 &nbsp;  | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 240µs | 18.1ms / 14.1 MB | 148µs / 144 KB | 337µs
Day 02 | 392µs | 511µs / 280 KB | 22.2µs / 24.6 KB | 97.5µs
Day 03 | 289µs | 22.5µs / 16.3 KB | 2.71µs / None | 17.3µs
Day 04 | 743µs | 476µs / 237 KB | 46.9µs / None | 2.4ms
Day 05 | 488µs | 100µs / 51.9 KB | 60.6µs / 12.4 KB | 188µs
Day 06 | 1.88ms | 2.89ms / 2.2 MB | 15.9µs / None | 7.73ms
Day 07 | 690µs | 1.49ms / 648 KB | 240µs / 281 KB | 511µs
Day 08 | 477µs | 4.41ms / 5.5 MB | 72.4µs / None | 4.66ms
Day 09 | 148µs | 19.2ms / 44.0 MB | 126µs / None | 163µs
Day 10 | 10.3µs | 93.1µs / 62.2 KB | 677ns / None | 33.5µs
Day 11 | 39.1ms | 45ms / 4.6 MB | 14.7ms / 2.0 MB | 17.2ms
Day 12 | 48.4µs | 130µs / 78.6 KB | 2.35µs / None | 1.57ms
Day 13 | 92µs | 8.25µs / 5.1 KB | 453ns / 256 B | 9.22µs
Day 14 | 2.98ms | 10.6ms / 7.4 MB | 3.09ms / 4.5 MB | -
Day 15 | 367ms | 397ms / **🔴 240 MB** | **🔴 415ms** / **🔴 49.4 MB** | 542ms
Day 16 | 614µs | 1.8ms / 1.1 MB | 262µs / 141 KB | 1.23ms
Day 17 | 162ms | **🔴 540ms** / **🔴 338 MB** | 35.4ms / **🔴 21.7 MB** | 5.02ms
Day 18 | 593µs | 10.9ms / 2.8 MB | 157µs / None | 7.18ms
Day 19 | 3.87ms | 17.8ms / 6.9 MB | 34ms / 14.0 MB | 12.6ms
Day 20 | 4.69ms | 7.98ms / 5.3 MB | 111µs / 90.9 KB | 11.6ms
Day 21 | 850µs | 2.25ms / 438 KB | 221µs / 121 KB | 3.31ms
Day 22 | 118ms | 76.7ms / 44.0 MB | 31.7ms / 15.1 MB | 111ms
Day 23 | 1.01s | **🔴 677ms** / 32.0 MB | **🔴 169ms** / None | **🔴 4.59s**
Day 24 | **🔴 6.1s** | 131ms / 7.9 MB | 63.2ms / None | 77.3ms
Day 25 | 38.9ms | 40ms / 320 B | 35.6ms / None | 34.1ms
*Total* | *7.86s* | *2.01s / 758 MB* | *803ms / 108 MB* | *5.43s*

![Graph for year 2020](y2020.svg)

## 2019
 &nbsp;  | C++ | Crystal | Golang | Rust
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 1.39µs | 9.07µs | 5.45µs / 3.4 KB | 610ns / None
Day 02 | 600µs | 2.97ms | 6.12ms / 9.3 MB | 2.11ms / None
Day 03 | 25.2ms | 13.9ms | 7.07ms / 10.0 MB | 31.9µs / None
Day 04 | 1.69ms | 24.4ms | 1.15ms / 80.0 B | 478µs / None
Day 05 | 24.8µs | 46.4µs | 58.9µs / 78.8 KB | 2.63µs / None
Day 06 | 2.12µs | 2.78ms | 31.8ms / 18.4 MB | 126µs / 163 KB
Day 07 | 3.66ms | 5.24ms | 5.15ms / 5.5 MB | 483µs / 102 KB
Day 08 | 29.6µs | 137µs | 170µs / 29.7 KB | 18.8µs / None
Day 09 | 36.2ms | 51ms | 2.8ms / 74.6 KB | 1.7ms / None
Day 10 | 21.8ms | 8.09ms | 15.1ms / 11.3 MB | 1.05ms / None
Day 11 | 11.5ms | 11.3ms | 2.95ms / 888 KB | 567µs / None
Day 12 | 157ms | 122ms | 9.14ms / 736 B | 3.65ms / None
Day 13 | 76.6ms | 98.8ms | 9.98ms / 2.9 MB | 5.95µs / None
Day 14 | 2.94ms | 5.82ms | 6.08ms / 281 KB | 2.11ms / 409 KB
Day 15 | 21.8ms | 29.6ms | 19.5ms / 32.5 MB | 8.97µs / None
Day 16 | 160ms | 231ms | 179ms / 1.1 MB | **🔴 126ms** / 524 KB
Day 17 | 11.8ms | 14.1ms | 1.22ms / 304 KB | 4.86µs / None
Day 18 | - | **🔴 9.25s** | **🔴 489ms** / **🔴 405 MB** | **🔴 167ms** / **🔴 94.4 MB**
Day 19 | 276ms | 275ms | 83.8ms / 66.6 MB | 5.7µs / None
Day 20 | 276ms | 236ms | 58.5ms / 64.4 MB | 5.63ms / None
Day 21 | 57.8ms | 70.4ms | 4.78ms / 124 KB | 6.17µs / None
Day 22 | 2.09µs | 92µs | 211µs / 110 KB | 2.76µs / None
Day 23 | 34.4ms | 34.6ms | 7.34ms / 4.7 MB | 10.9µs / None
Day 24 | 21.2ms | 33.8ms | **🔴 266ms** / **🔴 196 MB** | 4.75ms / None
Day 25 | **🔴 825ms** | 1.44s | 75.3ms / 43.4 MB | 10.7µs / None
*Total* | *2.02s* | *12s* | *1.28s / 873 MB* | *316ms / 95.6 MB*

![Graph for year 2019](y2019.svg)

## 2018
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 645µs / None | 633µs / None
Day 02 | 5.04ms / 2.8 MB | 486µs / None
Day 03 | 88.5ms / 64.2 MB | 4.06ms / None
Day 04 | 2.85ms / 399 KB | 10.6µs / None
Day 05 | 256ms / 48.3 MB | 4.91ms / None
Day 06 | 30.1ms / 19.4 KB | 6.55ms / None
Day 07 | 183µs / 68.6 KB | 3.46µs / None
Day 08 | 249µs / 162 KB | 66.1µs / None
Day 09 | 203ms / 167 MB | 36.1ms / **🔴 64.0 MB**
Day 10 | 1.24ms / 768 KB | 5.52µs / None
Day 11 | 27.8ms / 721 KB | 2.58ms / None
Day 12 | 1.91ms / 1.5 MB | 62.3µs / None
Day 13 | 5.81ms / 2.9 MB | 3.45ms / None
Day 14 | 118ms / 21.0 MB | 90.2ms / **🔴 33.6 MB**
Day 15 | 524ms / **🔴 251 MB** | **🔴 148ms** / 377 KB
Day 16 | 16.4ms / 10.1 MB | 127µs / None
Day 17 | 45.8ms / 12.1 MB | 756µs / None
Day 18 | 178ms / 166 MB | 20.2ms / None
Day 19 | 62.5ms / 27.0 KB | 43ms / None
Day 20 | 27.5ms / 8.6 MB | 274µs / None
Day 21 | 262ms / 448 KB | 175µs / None
Day 22 | **🔴 2.58s** / **🔴 241 MB** | 15.6ms / None
Day 23 | 162ms / 1.7 MB | 59.1ms / None
Day 24 | 94.3ms / 42.6 MB | 46ms / None
Day 25 | 8.5ms / 992 KB | 2ms / None
*Total* | *4.71s / 1.0 GB* | *484ms / 97.9 MB*

![Graph for year 2018](y2018.svg)

## 2017
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 10.7µs / 2.3 KB | 6.64µs / 16.4 KB
Day 02 | 17.1µs / 8.3 KB | 7.65µs / 2.0 KB
Day 03 | 30.9µs / 15.9 KB | 9.48µs / 14.3 KB
Day 04 | 1.93ms / 825 KB | 2.91ms / 2.0 MB
Day 05 | 80.1ms / 25.5 MB | 39ms / 24.9 KB
Day 06 | 16.1ms / 6.6 MB | 1.15ms / 1.8 MB
Day 07 | 2.69ms / 1.0 MB | 577µs / 523 KB
Day 08 | 617µs / 318 KB | 189µs / 38.2 KB
Day 09 | 130µs / 49.2 KB | 42.8µs / 89.3 KB
Day 10 | 436µs / 11.4 KB | 90.7µs / 1.1 KB
Day 11 | 139µs / 11.1 KB | 81.9µs / None
Day 12 | 3.33ms / 1.2 MB | 754µs / 1.1 MB
Day 13 | 26.6ms / 4.1 KB | **🔴 326ms** / 2.4 KB
Day 14 | 24.9ms / 1.7 MB | 20.4ms / **🔴 39.2 MB**
Day 15 | **🔴 510ms** / 1.4 KB | **🔴 571ms** / 32.0 B
Day 16 | 191ms / 82.8 MB | 17.7ms / 10.6 MB
Day 17 | 240ms / 48.5 KB | 201ms / 16.1 KB
Day 18 | 7.81ms / 5.7 MB | 9.45µs / None
Day 19 | 215µs / 44.8 KB | 32.3µs / None
Day 20 | 335ms / **🔴 206 MB** | 15.8ms / None
Day 21 | 65.3ms / 37.7 MB | 2.88µs / None
Day 22 | 58.6ms / 526 KB | 51.1ms / None
Day 23 | 1.54ms / 4.6 KB | 26.5µs / None
Day 24 | 119ms / 59.9 MB | 65.1ms / None
Day 25 | 31.2ms / 15.3 KB | 40.3ms / None
*Total* | *1.72s / 430 MB* | *1.35s / 55.5 MB*

![Graph for year 2017](y2017.svg)

## 2016
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 168µs / 101 KB | 37.1µs / 34.9 KB
Day 02 | 7.97µs / 192 B | 71.1µs / 3.8 KB
Day 03 | 62.3µs / 49.2 KB | 237µs / 183 KB
Day 04 | 1.78ms / 642 KB | 1.51ms / 634 KB
Day 05 | **🔴 4.14s** / 3.2 KB | **🔴 5.92s** / **🔴 689 MB**
Day 06 | 114µs / 4.6 KB | 687µs / 5.8 KB
Day 07 | 1.07ms / 64.4 KB | 2.15ms / 1.0 MB
Day 08 | 4.2µs / 96.0 B | 10.5µs / 6.2 KB
Day 09 | 9.8µs / None | 140µs / 361 KB
Day 10 | 8.12ms / 5.5 MB | 119µs / 90.7 KB
Day 11 | 27.8ms / 16.8 MB | 1.24s / **🔴 785 MB**
Day 12 | 4.74µs / 3.0 KB | 1.85µs / 5.8 KB
Day 13 | 135µs / 82.1 KB | 99.3µs / 101 KB
Day 14 | **🔴 9.17s** / 33.1 KB | **🔴 5.72s** / 76.0 B
Day 15 | 18.2ms / 14.6 KB | 4.24ms / 432 B
Day 16 | 114ms / 17.8 MB | 54.5ms / 67.1 MB
Day 17 | 91.3ms / 52.5 MB | 27.3ms / 35.4 MB
Day 18 | 177ms / 224 B | 311ms / 63.8 MB
Day 19 | 287ms / **🔴 145 MB** | 36ns / None
Day 20 | 276µs / 120 KB | 76.6µs / 76.4 KB
Day 21 | 135ms / 48.2 MB | 29.9ms / 4.4 MB
Day 22 | 16.9ms / 392 KB | 9.79ms / 194 KB
Day 23 | 12.8µs / 9.0 KB | 3.82µs / 21.1 KB
Day 24 | 67.2ms / 27.3 MB | 4.05ms / 3.8 MB
Day 25 | 59.6ms / 16.9 KB | 7.27ms / 7.3 KB
*Total* | *14.3s / 314 MB* | *13.3s / 1.7 GB*

![Graph for year 2016](y2016.svg)

## 2015
 &nbsp;  | Crystal | Golang | Rust
 ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 26.4µs** | 11.7µs / None | 12µs / None
Day 02 | - | 459µs / 189 KB | 48.1µs / 16.0 KB
Day 03 | - | 552µs / 190 KB | 438µs / 279 KB
Day 04 | - | 966ms / 56.0 B | **🔴 1.37s** / 159 MB
Day 05 | - | 252µs / 34.8 KB | 202µs / None
Day 06 | - | 64.9ms / 252 KB | 37.5ms / 19.2 KB
Day 07 | - | 247µs / 117 KB | 214µs / 148 KB
Day 08 | - | 21.2µs / 11.4 KB | 30.2µs / 29.6 KB
Day 09 | - | 12.7ms / 6.2 MB | 4.58ms / 651 KB
Day 10 | - | 60.3ms / 56.6 MB | 677ms / **🔴 312 MB**
Day 11 | - | 26.8ms / 313 KB | 44.3ms / 15.0 MB
Day 12 | - | 72.4ms / 392 MB | 282µs / 357 KB
Day 13 | - | 81.5ms / 28.1 MB | 55.1ms / 7.2 MB
Day 14 | - | 239µs / 108 KB | 370µs / 425 B
Day 15 | - | 56ms / 67.5 MB | 38.9ms / 44.1 MB
Day 16 | - | 511µs / 262 KB | 240µs / 250 KB
Day 17 | - | 64.5ms / 3.0 KB | 39.8ms / 84.1 MB
Day 18 | - | 3.88ms / 42.8 KB | 10.7ms / 56.4 KB
Day 19 | - | 545µs / 413 KB | 930µs / 546 KB
Day 20 | - | **🔴 4.09s** / **🔴 493 MB** | **🔴 1.14s** / 126 MB
Day 21 | - | 537µs / 277 KB | 36.1µs / 16.9 KB
Day 22 | - | **🔴 1.42s** / **🔴 1.1 GB** | 368ms / **🔴 234 MB**
Day 23 | - | 22.4µs / 9.3 KB | 8.23µs / 1.2 KB
Day 24 | - | 146ms / 61.1 MB | 8.52ms / 10.0 MB
Day 25 | - | 8.95µs / 6.1 KB | 221ns / 32.0 B
*Total* | *26.4µs* | *7.07s / 2.2 GB* | *3.81s / 994 MB*

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
Day 01 | **🔴 26.4µs** | 9.07µs | 240µs | **🔴 207µs**
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
*Total* | *26.4µs* | *12s* | *7.86s* | *368µs*


## Golang
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 11.7µs / None | 168µs / 101 KB | 10.7µs / 2.3 KB | 645µs / None | 5.45µs / 3.4 KB | 18.1ms / 14.1 MB | 59.8µs / 81.9 KB | 8.96µs / None
Day 02 | 459µs / 189 KB | 7.97µs / 192 B | 17.1µs / 8.3 KB | 5.04ms / 2.8 MB | 6.12ms / 9.3 MB | 511µs / 280 KB | 855ns / None | 1.89µs / None
Day 03 | 552µs / 190 KB | 62.3µs / 49.2 KB | 30.9µs / 15.9 KB | 88.5ms / 64.2 MB | 7.07ms / 10.0 MB | 22.5µs / 16.3 KB | 23.9µs / None | 23.7µs / None
Day 04 | 966ms / 56.0 B | 1.78ms / 642 KB | 1.93ms / 825 KB | 2.85ms / 399 KB | 1.15ms / 80.0 B | 476µs / 237 KB | 122µs / 79.2 KB | 8.87µs / None
Day 05 | 252µs / 34.8 KB | **🔴 4.14s** / 3.2 KB | 80.1ms / 25.5 MB | 256ms / 48.3 MB | 58.9µs / 78.8 KB | 100µs / 51.9 KB | 2.13ms / 1.1 MB | 4.76µs / None
Day 06 | 64.9ms / 252 KB | 114µs / 4.6 KB | 16.1ms / 6.6 MB | 30.1ms / 19.4 KB | 31.8ms / 18.4 MB | 2.89ms / 2.2 MB | 999ns / None | 4.73µs / None
Day 07 | 247µs / 117 KB | 1.07ms / 64.4 KB | 2.69ms / 1.0 MB | 183µs / 68.6 KB | 5.15ms / 5.5 MB | 1.49ms / 648 KB | 48.9µs / 8.2 KB | 14.2µs / None
Day 08 | 21.2µs / 11.4 KB | 4.2µs / 96.0 B | 617µs / 318 KB | 249µs / 162 KB | 170µs / 29.7 KB | 4.41ms / 5.5 MB | 260µs / 167 KB | 388µs / None
Day 09 | 12.7ms / 6.2 MB | 9.8µs / None | 130µs / 49.2 KB | 203ms / 167 MB | 2.8ms / 74.6 KB | 19.2ms / 44.0 MB | 560µs / 238 KB | 233µs / None
Day 10 | 60.3ms / 56.6 MB | 8.12ms / 5.5 MB | 436µs / 11.4 KB | 1.24ms / 768 KB | 15.1ms / 11.3 MB | 93.1µs / 62.2 KB | 13.4µs / 920 B | 809ns / None
Day 11 | 26.8ms / 313 KB | 27.8ms / 16.8 MB | 139µs / 11.1 KB | 27.8ms / 721 KB | 2.95ms / 888 KB | 45ms / 4.6 MB | 457µs / 223 KB | 3.69ms / None
Day 12 | 72.4ms / 392 MB | 4.74µs / 3.0 KB | 3.33ms / 1.2 MB | 1.91ms / 1.5 MB | 9.14ms / 736 B | 130µs / 78.6 KB | 1.79ms / 3.0 MB | 208µs / None
Day 13 | 81.5ms / 28.1 MB | 135µs / 82.1 KB | 26.6ms / 4.1 KB | 5.81ms / 2.9 MB | 9.98ms / 2.9 MB | 8.25µs / 5.1 KB | 205µs / 22.7 KB | 764µs / 610 KB
Day 14 | 239µs / 108 KB | **🔴 9.17s** / 33.1 KB | 24.9ms / 1.7 MB | 118ms / 21.0 MB | 6.08ms / 281 KB | 10.6ms / 7.4 MB | 270µs / 119 KB | 3.11ms / None
Day 15 | 56ms / 67.5 MB | 18.2ms / 14.6 KB | **🔴 510ms** / 1.4 KB | 524ms / **🔴 251 MB** | 19.5ms / 32.5 MB | 397ms / **🔴 240 MB** | 31.4ms / 2.5 MB | 1.9µs / 568 B
Day 16 | 511µs / 262 KB | 114ms / 17.8 MB | 191ms / 82.8 MB | 16.4ms / 10.1 MB | 179ms / 1.1 MB | 1.8ms / 1.1 MB | 9.8µs / 5.1 KB | **🔴 141ms** / **🔴 134 MB**
Day 17 | 64.5ms / 3.0 KB | 91.3ms / 52.5 MB | 240ms / 48.5 KB | 45.8ms / 12.1 MB | 1.22ms / 304 KB | **🔴 540ms** / **🔴 338 MB** | 1.29ms / 64.0 B | 468µs / 229 KB
Day 18 | 3.88ms / 42.8 KB | 177ms / 224 B | 7.81ms / 5.7 MB | 178ms / 166 MB | **🔴 489ms** / **🔴 405 MB** | 10.9ms / 2.8 MB | 28.2ms / 4.8 MB | 87.6µs / None
Day 19 | 545µs / 413 KB | 287ms / **🔴 145 MB** | 215µs / 44.8 KB | 62.5ms / 27.0 KB | 83.8ms / 66.6 MB | 17.8ms / 6.9 MB | **🔴 525ms** / 16.4 MB | **🔴 116ms** / **🔴 55.0 MB**
Day 20 | **🔴 4.09s** / **🔴 493 MB** | 276µs / 120 KB | 335ms / **🔴 206 MB** | 27.5ms / 8.6 MB | 58.5ms / 64.4 MB | 7.98ms / 5.3 MB | 15.5ms / 82.5 KB | 37.4ms / None
Day 21 | 537µs / 277 KB | 135ms / 48.2 MB | 65.3ms / 37.7 MB | 262ms / 448 KB | 4.78ms / 124 KB | 2.25ms / 438 KB | 2.58ms / 2.3 MB | 329µs / 186 KB
Day 22 | **🔴 1.42s** / **🔴 1.1 GB** | 16.9ms / 392 KB | 58.6ms / 526 KB | **🔴 2.58s** / **🔴 241 MB** | 211µs / 110 KB | 76.7ms / 44.0 MB | 7.48ms / 3.8 MB | 275µs / None
Day 23 | 22.4µs / 9.3 KB | 12.8µs / 9.0 KB | 1.54ms / 4.6 KB | 162ms / 1.7 MB | 7.34ms / 4.7 MB | **🔴 677ms** / 32.0 MB | **🔴 296ms** / **🔴 199 MB** | 60.9ms / 2.0 MB
Day 24 | 146ms / 61.1 MB | 67.2ms / 27.3 MB | 119ms / 59.9 MB | 94.3ms / 42.6 MB | **🔴 266ms** / **🔴 196 MB** | 131ms / 7.9 MB | 1.62µs / 656 B | 76.6ms / 16.8 MB
Day 25 | 8.95µs / 6.1 KB | 59.6ms / 16.9 KB | 31.2ms / 15.3 KB | 8.5ms / 992 KB | 75.3ms / 43.4 MB | 40ms / 320 B | 32.9ms / None | 1.66µs / None
*Total* | *7.07s / 2.2 GB* | *14.3s / 314 MB* | *1.72s / 430 MB* | *4.71s / 1.0 GB* | *1.28s / 873 MB* | *2.01s / 758 MB* | *946ms / 234 MB* | *441ms / 209 MB*


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
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 12µs / None | 37.1µs / 34.9 KB | 6.64µs / 16.4 KB | 633µs / None | 610ns / None | 148µs / 144 KB | 18.6µs / None | 5.4µs / None
Day 02 | 48.1µs / 16.0 KB | 71.1µs / 3.8 KB | 7.65µs / 2.0 KB | 486µs / None | 2.11ms / None | 22.2µs / 24.6 KB | 760ns / None | 591ns / None
Day 03 | 438µs / 279 KB | 237µs / 183 KB | 9.48µs / 14.3 KB | 4.06ms / None | 31.9µs / None | 2.71µs / None | 18.9µs / 2.0 KB | 18.2µs / None
Day 04 | **🔴 1.37s** / 159 MB | 1.51ms / 634 KB | 2.91ms / 2.0 MB | 10.6µs / None | 478µs / None | 46.9µs / None | 55.3µs / 102 KB | 4.83µs / None
Day 05 | 202µs / None | **🔴 5.92s** / **🔴 689 MB** | 39ms / 24.9 KB | 4.91ms / None | 2.63µs / None | 60.6µs / 12.4 KB | 458µs / 8.2 KB | 3.08µs / None
Day 06 | 37.5ms / 19.2 KB | 687µs / 5.8 KB | 1.15ms / 1.8 MB | 6.55ms / None | 126µs / 163 KB | 15.9µs / None | 716ns / 512 B | 5.07µs / None
Day 07 | 214µs / 148 KB | 2.15ms / 1.0 MB | 577µs / 523 KB | 3.46µs / None | 483µs / 102 KB | 240µs / 281 KB | 20.4µs / 3.3 KB | 7.87µs / None
Day 08 | 30.2µs / 29.6 KB | 10.5µs / 6.2 KB | 189µs / 38.2 KB | 66.1µs / None | 18.8µs / None | 72.4µs / None | 12.3µs / 2.4 KB | 254µs / None
Day 09 | 4.58ms / 651 KB | 140µs / 361 KB | 42.8µs / 89.3 KB | 36.1ms / **🔴 64.0 MB** | 1.7ms / None | 126µs / None | 99.6µs / 19.6 KB | 184µs / None
Day 10 | 677ms / **🔴 312 MB** | 119µs / 90.7 KB | 90.7µs / 1.1 KB | 5.52µs / None | 1.05ms / None | 677ns / None | 31.3µs / 2.5 KB | 522ns / None
Day 11 | 44.3ms / 15.0 MB | 1.24s / **🔴 785 MB** | 81.9µs / None | 2.58ms / None | 567µs / None | 14.7ms / 2.0 MB | 102µs / 319 B | 2.14ms / None
Day 12 | 282µs / 357 KB | 1.85µs / 5.8 KB | 754µs / 1.1 MB | 62.3µs / None | 3.65ms / None | 2.35µs / None | 4.31ms / 1.2 KB | 114µs / None
Day 13 | 55.1ms / 7.2 MB | 99.3µs / 101 KB | **🔴 326ms** / 2.4 KB | 3.45ms / None | 5.95µs / None | 453ns / 256 B | 263µs / 265 KB | 236µs / 391 KB
Day 14 | 370µs / 425 B | **🔴 5.72s** / 76.0 B | 20.4ms / **🔴 39.2 MB** | 90.2ms / **🔴 33.6 MB** | 2.11ms / 409 KB | 3.09ms / 4.5 MB | 16µs / 1.8 KB | 3.6ms / None
Day 15 | 38.9ms / 44.1 MB | 4.24ms / 432 B | **🔴 571ms** / 32.0 B | **🔴 148ms** / 377 KB | 8.97µs / None | **🔴 415ms** / **🔴 49.4 MB** | 49.6ms / **🔴 133 MB** | 1.01µs / None
Day 16 | 240µs / 250 KB | 54.5ms / 67.1 MB | 17.7ms / 10.6 MB | 127µs / None | **🔴 126ms** / 524 KB | 262µs / 141 KB | 6µs / 4.8 KB | **🔴 154ms** / **🔴 35.7 MB**
Day 17 | 39.8ms / 84.1 MB | 27.3ms / 35.4 MB | 201ms / 16.1 KB | 756µs / None | 4.86µs / None | 35.4ms / **🔴 21.7 MB** | 1.56ms / None | 165µs / None
Day 18 | 10.7ms / 56.4 KB | 311ms / 63.8 MB | 9.45µs / None | 20.2ms / None | **🔴 167ms** / **🔴 94.4 MB** | 157µs / None | 23.1ms / 15.5 MB | 74.6µs / None
Day 19 | 930µs / 546 KB | 36ns / None | 32.3µs / None | 43ms / None | 5.7µs / None | 34ms / 14.0 MB | 10.4ms / 2.0 MB | 48.1ms / **🔴 43.1 MB**
Day 20 | **🔴 1.14s** / 126 MB | 76.6µs / 76.4 KB | 15.8ms / None | 274µs / None | 5.63ms / None | 111µs / 90.9 KB | 20.4ms / 2.0 MB | 22.8ms / None
Day 21 | 36.1µs / 16.9 KB | 29.9ms / 4.4 MB | 2.88µs / None | 175µs / None | 6.17µs / None | 221µs / 121 KB | 1.01µs / 8.0 B | 186µs / 270 KB
Day 22 | 368ms / **🔴 234 MB** | 9.79ms / 194 KB | 51.1ms / None | 15.6ms / None | 2.76µs / None | 31.7ms / 15.1 MB | 10.6ms / 2.3 MB | 298µs / None
Day 23 | 8.23µs / 1.2 KB | 3.82µs / 21.1 KB | 26.5µs / None | 59.1ms / None | 10.9µs / None | **🔴 169ms** / None | **🔴 639ms** / **🔴 165 MB** | 44.9ms / None
Day 24 | 8.52ms / 10.0 MB | 4.05ms / 3.8 MB | 65.1ms / None | 46ms / None | 4.75ms / None | 63.2ms / None | 7.46µs / 576 B | **🔴 75.9ms** / 19.2 MB
Day 25 | 221ns / 32.0 B | 7.27ms / 7.3 KB | 40.3ms / None | 2ms / None | 10.7µs / None | 35.6ms / None | 26.7ms / 19.4 KB | 1.33µs / None
*Total* | *3.81s / 994 MB* | *13.3s / 1.7 GB* | *1.35s / 55.5 MB* | *484ms / 97.9 MB* | *316ms / 95.6 MB* | *803ms / 108 MB* | *787ms / 321 MB* | *353ms / 98.6 MB*


## Zig
 &nbsp;  | 2020 | 2021
 ---:  | ---:  | ---: 
Day 01 | 337µs | 11.8µs
Day 02 | 97.5µs | 720ns
Day 03 | 17.3µs | 50.3µs
Day 04 | 2.4ms | 53µs
Day 05 | 188µs | 690µs
Day 06 | 7.73ms | 873ns
Day 07 | 511µs | 26.4µs
Day 08 | 4.66ms | 1.04ms
Day 09 | 163µs | 118µs
Day 10 | 33.5µs | 26.1µs
Day 11 | 17.2ms | 70.4µs
Day 12 | 1.57ms | 148µs
Day 13 | 9.22µs | 259µs
Day 14 | - | 64.6µs
Day 15 | 542ms | **🔴 10.6ms**
Day 16 | 1.23ms | 310µs
Day 17 | 5.02ms | 1.45ms
Day 18 | 7.18ms | **🔴 6.08ms**
Day 19 | 12.6ms | -
Day 20 | 11.6ms | -
Day 21 | 3.31ms | 203µs
Day 22 | 111ms | -
Day 23 | **🔴 4.59s** | -
Day 24 | 77.3ms | -
Day 25 | 34.1ms | -
*Total* | *5.43s* | *21.2ms*

