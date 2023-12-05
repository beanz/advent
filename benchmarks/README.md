This was borrowed from [adsmf's Advent of Code repo](https://github.com/adsmf/adventofcode/tree/master/benchmarks).

# Benchmarks
The following are the benchmarks for the Go implementations of solutions for each day. The results are as measured by a `BenchmarkMain` benchmark in each solution.

## 2023
 &nbsp;  | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---: 
Day 01 | 186µs / None | **🔴 92.8µs** / None | **🔴 74.1µs**
Day 02 | 5.88µs / None | 2.4µs / None | 2.59µs
Day 03 | 26.7µs / None | 17.4µs / None | 14µs
Day 04 | 33.9µs / 256 B | 19µs / None | **🔴 52.9µs**
Day 05 | **🔴 4.2s** / **🔴 12.6 KB** | - | -
Day 06 | - | - | -
Day 07 | - | - | -
Day 08 | - | - | -
Day 09 | - | - | -
Day 10 | - | - | -
Day 11 | - | - | -
Day 12 | - | - | -
Day 13 | - | - | -
Day 14 | - | - | -
Day 15 | - | - | -
Day 16 | - | - | -
Day 17 | - | - | -
Day 18 | - | - | -
Day 19 | - | - | -
Day 20 | - | - | -
Day 21 | - | - | -
Day 22 | - | - | -
Day 23 | - | - | -
Day 24 | - | - | -
Day 25 | - | - | -
*Total* | *4.2s / 12.9 KB* | *132µs / None* | *144µs*

![Graph for year 2023](y2023.svg)

## 2022
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 8.96µs / None | 3.78µs / None
Day 02 | 1.89µs / None | 642ns / None
Day 03 | 23.7µs / None | 19.2µs / None
Day 04 | 8.87µs / None | 5.64µs / None
Day 05 | 4.76µs / None | 3.55µs / None
Day 06 | 4.73µs / None | 5.83µs / None
Day 07 | 14.2µs / None | 9.67µs / None
Day 08 | 388µs / None | 280µs / None
Day 09 | 233µs / None | 197µs / None
Day 10 | 809ns / None | 512ns / None
Day 11 | 3.69ms / None | 2.36ms / None
Day 12 | 208µs / None | 121µs / None
Day 13 | 764µs / 610 KB | 251µs / 391 KB
Day 14 | 3.11ms / None | 3.9ms / None
Day 15 | 1.9µs / 568 B | 1.11µs / None
Day 16 | **🔴 141ms** / **🔴 134 MB** | **🔴 187ms** / **🔴 35.7 MB**
Day 17 | 468µs / 229 KB | 205µs / None
Day 18 | 87.6µs / None | 87µs / None
Day 19 | **🔴 116ms** / **🔴 55.0 MB** | 52.6ms / **🔴 43.1 MB**
Day 20 | 37.4ms / None | 25.6ms / None
Day 21 | 329µs / 186 KB | 215µs / 270 KB
Day 22 | 275µs / None | 327µs / None
Day 23 | 60.9ms / 2.0 MB | 48.9ms / None
Day 24 | 76.6ms / 16.8 MB | **🔴 84.8ms** / 19.2 MB
Day 25 | 1.66µs / None | 1.25µs / None
*Total* | *441ms / 209 MB* | *407ms / 98.6 MB*

![Graph for year 2022](y2022.svg)

## 2021
 &nbsp;  | Crystal | Golang | Haskell | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 207µs** | 59.8µs / 81.9 KB | **🔴 1.18ms** | 13.6µs / None | 11.8µs
Day 02 | 48.4µs | 855ns / None | **🔴 713µs** | 899ns / None | 720ns
Day 03 | **🔴 113µs** | 23.9µs / None | **🔴 1.08ms** | 19.3µs / 2.0 KB | 50.3µs
Day 04 | - | 122µs / 79.2 KB | - | 54.3µs / 102 KB | 53µs
Day 05 | - | 2.13ms / 1.1 MB | - | 441µs / 8.2 KB | 690µs
Day 06 | - | 999ns / None | - | 739ns / 512 B | 873ns
Day 07 | - | 48.9µs / 8.2 KB | - | 23µs / 3.3 KB | 26.4µs
Day 08 | - | 260µs / 167 KB | - | 14.6µs / 2.4 KB | 1.04ms
Day 09 | - | 539µs / 238 KB | - | 104µs / 19.6 KB | 118µs
Day 10 | - | 13.4µs / 920 B | - | 14.5µs / 2.5 KB | 26.1µs
Day 11 | - | 466µs / 223 KB | - | 79.8µs / 319 B | 70.4µs
Day 12 | - | 1.79ms / 3.0 MB | - | 4.38ms / 1.2 KB | 148µs
Day 13 | - | 205µs / 22.7 KB | - | 273µs / 265 KB | 259µs
Day 14 | - | 270µs / 119 KB | - | 15.7µs / 1.8 KB | 64.6µs
Day 15 | - | 31.4ms / 2.5 MB | - | 59.5ms / **🔴 133 MB** | **🔴 10.6ms**
Day 16 | - | 9.8µs / 5.1 KB | - | 5.98µs / 4.8 KB | 310µs
Day 17 | - | 1.29ms / 64.0 B | - | 1.6ms / None | 1.45ms
Day 18 | - | 27.8ms / 4.8 MB | - | 22.9ms / 15.5 MB | **🔴 6.08ms**
Day 19 | - | **🔴 525ms** / 16.4 MB | - | 10.6ms / 2.0 MB | -
Day 20 | - | 15.5ms / 82.5 KB | - | 19.6ms / 2.0 MB | -
Day 21 | - | 2.58ms / 2.3 MB | - | 1.12µs / 8.0 B | 203µs
Day 22 | - | 7.48ms / 3.8 MB | - | 12.8ms / 2.3 MB | -
Day 23 | - | **🔴 296ms** / **🔴 199 MB** | - | **🔴 748ms** / **🔴 165 MB** | -
Day 24 | - | 1.62µs / 656 B | - | 8.05µs / 576 B | -
Day 25 | - | 32.9ms / None | - | 29.3ms / 19.4 KB | -
*Total* | *368µs* | *946ms / 234 MB* | *2.97ms* | *910ms / 320 MB* | *21.2ms*

![Graph for year 2021](y2021.svg)

## 2020
 &nbsp;  | Crystal | Golang | Rust | Zig
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 240µs | 18.1ms / 14.1 MB | 149µs / 144 KB | 337µs
Day 02 | 392µs | 511µs / 280 KB | 23.6µs / 24.6 KB | 97.5µs
Day 03 | 289µs | 22.5µs / 16.3 KB | 2.69µs / None | 17.3µs
Day 04 | 743µs | 429µs / 237 KB | 49.1µs / None | 2.4ms
Day 05 | 488µs | 100µs / 51.9 KB | 64.5µs / 12.4 KB | 188µs
Day 06 | 1.88ms | 3.62ms / 4.0 MB | 15µs / None | 7.73ms
Day 07 | 690µs | 1.32ms / 692 KB | 255µs / 281 KB | 511µs
Day 08 | 477µs | 4.41ms / 5.5 MB | 72.7µs / None | 4.66ms
Day 09 | 148µs | 19.2ms / 44.0 MB | 108µs / None | 163µs
Day 10 | 10.3µs | 93.1µs / 62.2 KB | 696ns / None | 33.5µs
Day 11 | 39.1ms | 45ms / 4.6 MB | 14.7ms / 2.0 MB | 17.2ms
Day 12 | 48.4µs | 130µs / 78.6 KB | 2.46µs / None | 1.57ms
Day 13 | 92µs | 8.25µs / 5.1 KB | 465ns / 256 B | 9.22µs
Day 14 | 2.98ms | 10.6ms / 7.4 MB | 3.24ms / 4.5 MB | -
Day 15 | 367ms | 397ms / **🔴 240 MB** | **🔴 437ms** / **🔴 49.4 MB** | 542ms
Day 16 | 614µs | 1.8ms / 1.1 MB | 249µs / 141 KB | 1.23ms
Day 17 | 162ms | **🔴 540ms** / **🔴 338 MB** | 36ms / **🔴 21.7 MB** | 5.02ms
Day 18 | 593µs | 10.9ms / 2.8 MB | 131µs / None | 7.18ms
Day 19 | 3.87ms | 17.8ms / 6.9 MB | 35.4ms / 14.0 MB | 12.6ms
Day 20 | 4.69ms | 7.98ms / 5.3 MB | 111µs / 90.9 KB | 11.6ms
Day 21 | 850µs | 2.25ms / 438 KB | 239µs / 121 KB | 3.31ms
Day 22 | 118ms | 76.7ms / 44.0 MB | 32.9ms / 15.1 MB | 111ms
Day 23 | 1.01s | **🔴 677ms** / 32.0 MB | **🔴 179ms** / None | **🔴 4.59s**
Day 24 | **🔴 6.1s** | 131ms / 7.9 MB | 77.6ms / None | 77.3ms
Day 25 | 38.9ms | 40ms / 320 B | 37ms / None | 34.1ms
*Total* | *7.86s* | *2.01s / 760 MB* | *855ms / 108 MB* | *5.43s*

![Graph for year 2020](y2020.svg)

## 2019
 &nbsp;  | C++ | Crystal | Golang | Rust
 ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 1.39µs | 9.07µs | 5.45µs / 3.4 KB | 659ns / None
Day 02 | 600µs | 2.97ms | 4.87ms / 9.3 MB | 2.04ms / None
Day 03 | 25.2ms | 13.9ms | 7.07ms / 10.0 MB | 34.4µs / None
Day 04 | 1.69ms | 24.4ms | 1.15ms / 80.0 B | 520µs / None
Day 05 | 24.8µs | 46.4µs | 58.9µs / 78.8 KB | 2.41µs / None
Day 06 | 2.12µs | 2.78ms | 31.8ms / 18.4 MB | 132µs / 163 KB
Day 07 | 3.66ms | 5.24ms | 5.15ms / 5.5 MB | 491µs / 102 KB
Day 08 | 29.6µs | 137µs | 170µs / 29.7 KB | 19.4µs / None
Day 09 | 36.2ms | 51ms | 2.8ms / 74.6 KB | 1.77ms / None
Day 10 | 21.8ms | 8.09ms | 15.1ms / 11.3 MB | 1.05ms / None
Day 11 | 11.5ms | 11.3ms | 2.95ms / 888 KB | 536µs / None
Day 12 | 157ms | 122ms | 9.72ms / 736 B | 4.03ms / None
Day 13 | 76.6ms | 98.8ms | 9.13ms / 2.9 MB | 5.1µs / None
Day 14 | 2.94ms | 5.82ms | 6.08ms / 281 KB | 2.13ms / 409 KB
Day 15 | 21.8ms | 29.6ms | 19.5ms / 32.5 MB | 9.52µs / None
Day 16 | 160ms | 231ms | 179ms / 1.1 MB | **🔴 131ms** / 524 KB
Day 17 | 11.8ms | 14.1ms | 1.11ms / 303 KB | 4.75µs / None
Day 18 | - | **🔴 9.25s** | **🔴 485ms** / **🔴 405 MB** | **🔴 175ms** / **🔴 94.4 MB**
Day 19 | 276ms | 275ms | 83.8ms / 66.6 MB | 6.31µs / None
Day 20 | 276ms | 236ms | 58.5ms / 64.4 MB | 5.9ms / None
Day 21 | 57.8ms | 70.4ms | 4.78ms / 124 KB | 4.75µs / None
Day 22 | 2.09µs | 92µs | 211µs / 110 KB | 2.79µs / None
Day 23 | 34.4ms | 34.6ms | 7.34ms / 4.7 MB | 8.86µs / None
Day 24 | 21.2ms | 33.8ms | 225ms / **🔴 195 MB** | 5.06ms / None
Day 25 | **🔴 825ms** | 1.44s | 84.9ms / 50.8 MB | 10.5µs / None
*Total* | *2.02s* | *12s* | *1.25s / 880 MB* | *329ms / 95.6 MB*

![Graph for year 2019](y2019.svg)

## 2018
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 645µs / None | 692µs / None
Day 02 | 5.04ms / 2.8 MB | 489µs / None
Day 03 | 88.5ms / 64.2 MB | 4.16ms / None
Day 04 | 2.85ms / 399 KB | 11µs / None
Day 05 | 256ms / 48.3 MB | 5.11ms / None
Day 06 | 30.1ms / 19.4 KB | 6.97ms / None
Day 07 | 183µs / 68.6 KB | 4.16µs / None
Day 08 | 249µs / 162 KB | 70.8µs / None
Day 09 | 203ms / 167 MB | 42.5ms / **🔴 64.0 MB**
Day 10 | 1.24ms / 768 KB | 5.71µs / None
Day 11 | 27.8ms / 721 KB | 2.71ms / None
Day 12 | 1.91ms / 1.5 MB | 67.7µs / None
Day 13 | 5.81ms / 2.9 MB | 3.88ms / None
Day 14 | 118ms / 21.0 MB | 104ms / **🔴 33.6 MB**
Day 15 | 435ms / **🔴 261 MB** | **🔴 156ms** / 377 KB
Day 16 | 16.4ms / 10.1 MB | 135µs / None
Day 17 | 45.8ms / 12.1 MB | 796µs / None
Day 18 | 178ms / 166 MB | 20.5ms / None
Day 19 | 62.5ms / 27.0 KB | 43.4ms / None
Day 20 | 28.9ms / 8.5 MB | 293µs / None
Day 21 | 262ms / 448 KB | 215µs / None
Day 22 | **🔴 2.58s** / **🔴 241 MB** | 16.8ms / None
Day 23 | 162ms / 1.7 MB | 65.7ms / None
Day 24 | 94.3ms / 42.6 MB | 50.3ms / None
Day 25 | 8.5ms / 992 KB | 2.17ms / None
*Total* | *4.62s / 1.1 GB* | *527ms / 97.9 MB*

![Graph for year 2018](y2018.svg)

## 2017
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 10.7µs / 2.3 KB | 1.13µs / 16.4 KB
Day 02 | 17.1µs / 8.3 KB | 8.33µs / 2.0 KB
Day 03 | 30.9µs / 15.9 KB | 11.3µs / 14.3 KB
Day 04 | 1.57ms / 825 KB | 3.11ms / 2.0 MB
Day 05 | 80.1ms / 25.5 MB | 40.4ms / 24.9 KB
Day 06 | 16.1ms / 6.6 MB | 1.31ms / 1.8 MB
Day 07 | 2.69ms / 1.0 MB | 640µs / 523 KB
Day 08 | 617µs / 318 KB | 209µs / 38.2 KB
Day 09 | 130µs / 49.2 KB | 47.3µs / 89.3 KB
Day 10 | 436µs / 11.4 KB | 99.8µs / 1.1 KB
Day 11 | 139µs / 11.1 KB | 80.6µs / None
Day 12 | 3.33ms / 1.2 MB | 858µs / 1.1 MB
Day 13 | 26.6ms / 4.1 KB | **🔴 353ms** / 2.4 KB
Day 14 | 24.9ms / 1.7 MB | 22.3ms / **🔴 39.2 MB**
Day 15 | **🔴 510ms** / 1.4 KB | **🔴 617ms** / 32.0 B
Day 16 | 191ms / 82.8 MB | 19.1ms / 10.6 MB
Day 17 | 240ms / 48.5 KB | 207ms / 16.1 KB
Day 18 | 7.67ms / 5.7 MB | 9.99µs / None
Day 19 | 214µs / 44.8 KB | 35.5µs / None
Day 20 | 335ms / **🔴 206 MB** | 17.3ms / None
Day 21 | 66ms / 37.7 MB | 3.39µs / None
Day 22 | 58.6ms / 526 KB | 56.9ms / None
Day 23 | 1.54ms / 4.6 KB | 28.8µs / None
Day 24 | 119ms / 59.9 MB | 74.4ms / None
Day 25 | 31.2ms / 15.3 KB | 43.6ms / None
*Total* | *1.72s / 430 MB* | *1.46s / 55.5 MB*

![Graph for year 2017](y2017.svg)

## 2016
 &nbsp;  | Golang | Rust
 ---:  | ---:  | ---: 
Day 01 | 168µs / 101 KB | 41.3µs / 34.9 KB
Day 02 | 7.97µs / 192 B | 77.1µs / 3.8 KB
Day 03 | 62.3µs / 49.2 KB | 252µs / 183 KB
Day 04 | 1.78ms / 642 KB | 1.62ms / 634 KB
Day 05 | **🔴 3.8s** / 3.4 KB | **🔴 5.68s** / **🔴 689 MB**
Day 06 | 114µs / 4.6 KB | 718µs / 5.8 KB
Day 07 | 1.07ms / 64.4 KB | 2.28ms / 1.0 MB
Day 08 | 3.71µs / 96.0 B | 11.3µs / 6.2 KB
Day 09 | 9.8µs / None | 152µs / 361 KB
Day 10 | 8.12ms / 5.5 MB | 131µs / 90.7 KB
Day 11 | 24.7ms / 16.8 MB | 1.38s / **🔴 785 MB**
Day 12 | 4.74µs / 3.0 KB | 1.96µs / 5.8 KB
Day 13 | 135µs / 82.1 KB | 106µs / 101 KB
Day 14 | **🔴 9.17s** / 33.1 KB | **🔴 5.36s** / 76.0 B
Day 15 | 18.2ms / 14.6 KB | 4.25ms / 432 B
Day 16 | 114ms / 17.8 MB | 58.3ms / 67.1 MB
Day 17 | 91.3ms / 52.5 MB | 27.6ms / 35.4 MB
Day 18 | 177ms / 224 B | 325ms / 63.8 MB
Day 19 | 251ms / **🔴 145 MB** | 39ns / None
Day 20 | 276µs / 120 KB | 83.9µs / 76.4 KB
Day 21 | 135ms / 48.2 MB | 31.4ms / 4.4 MB
Day 22 | 16.9ms / 392 KB | 10.4ms / 194 KB
Day 23 | 12.8µs / 9.0 KB | 4.02µs / 21.1 KB
Day 24 | 67.2ms / 27.3 MB | 4.27ms / 3.8 MB
Day 25 | 59.6ms / 16.9 KB | 8.01ms / 7.3 KB
*Total* | *13.9s / 314 MB* | *12.9s / 1.7 GB*

![Graph for year 2016](y2016.svg)

## 2015
 &nbsp;  | Crystal | Golang | Rust
 ---:  | ---:  | ---:  | ---: 
Day 01 | **🔴 26.4µs** | 11.7µs / None | 3.35µs / None
Day 02 | - | 459µs / 189 KB | 54.2µs / 16.0 KB
Day 03 | - | 552µs / 190 KB | 537µs / 279 KB
Day 04 | - | 948ms / 56.0 B | **🔴 1.34s** / 159 MB
Day 05 | - | 252µs / 34.8 KB | 218µs / None
Day 06 | - | 64.9ms / 252 KB | 38.4ms / 19.2 KB
Day 07 | - | 247µs / 117 KB | 235µs / 148 KB
Day 08 | - | 21.2µs / 11.4 KB | 34.8µs / 29.6 KB
Day 09 | - | 12.7ms / 6.2 MB | 5.16ms / 651 KB
Day 10 | - | 60.3ms / 56.6 MB | 734ms / **🔴 312 MB**
Day 11 | - | 26.8ms / 313 KB | 66.5ms / 15.0 MB
Day 12 | - | 853µs / 367 KB | 299µs / 357 KB
Day 13 | - | 81.5ms / 28.1 MB | 91.6ms / 7.2 MB
Day 14 | - | 239µs / 108 KB | 410µs / 425 B
Day 15 | - | 56ms / 67.5 MB | 42.9ms / 44.1 MB
Day 16 | - | 511µs / 262 KB | 261µs / 250 KB
Day 17 | - | 64.5ms / 3.0 KB | 43ms / 84.1 MB
Day 18 | - | 3.88ms / 42.8 KB | 11.4ms / 56.4 KB
Day 19 | - | 545µs / 413 KB | 1.08ms / 546 KB
Day 20 | - | **🔴 3.58s** / **🔴 465 MB** | **🔴 1.22s** / 126 MB
Day 21 | - | 537µs / 277 KB | 45.5µs / 16.9 KB
Day 22 | - | 457ms / **🔴 435 MB** | 401ms / **🔴 234 MB**
Day 23 | - | 22.4µs / 9.3 KB | 5.62µs / 1.2 KB
Day 24 | - | 146ms / 61.1 MB | 9.17ms / 10.0 MB
Day 25 | - | 8.95µs / 6.1 KB | 208ns / 32.0 B
*Total* | *26.4µs* | *5.51s / 1.1 GB* | *4s / 994 MB*

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
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 11.7µs / None | 168µs / 101 KB | 10.7µs / 2.3 KB | 645µs / None | 5.45µs / 3.4 KB | 18.1ms / 14.1 MB | 59.8µs / 81.9 KB | 8.96µs / None | 186µs / None
Day 02 | 459µs / 189 KB | 7.97µs / 192 B | 17.1µs / 8.3 KB | 5.04ms / 2.8 MB | 4.87ms / 9.3 MB | 511µs / 280 KB | 855ns / None | 1.89µs / None | 5.88µs / None
Day 03 | 552µs / 190 KB | 62.3µs / 49.2 KB | 30.9µs / 15.9 KB | 88.5ms / 64.2 MB | 7.07ms / 10.0 MB | 22.5µs / 16.3 KB | 23.9µs / None | 23.7µs / None | 26.7µs / None
Day 04 | 948ms / 56.0 B | 1.78ms / 642 KB | 1.57ms / 825 KB | 2.85ms / 399 KB | 1.15ms / 80.0 B | 429µs / 237 KB | 122µs / 79.2 KB | 8.87µs / None | 33.9µs / 256 B
Day 05 | 252µs / 34.8 KB | **🔴 3.8s** / 3.4 KB | 80.1ms / 25.5 MB | 256ms / 48.3 MB | 58.9µs / 78.8 KB | 100µs / 51.9 KB | 2.13ms / 1.1 MB | 4.76µs / None | **🔴 4.2s** / **🔴 12.6 KB**
Day 06 | 64.9ms / 252 KB | 114µs / 4.6 KB | 16.1ms / 6.6 MB | 30.1ms / 19.4 KB | 31.8ms / 18.4 MB | 3.62ms / 4.0 MB | 999ns / None | 4.73µs / None | -
Day 07 | 247µs / 117 KB | 1.07ms / 64.4 KB | 2.69ms / 1.0 MB | 183µs / 68.6 KB | 5.15ms / 5.5 MB | 1.32ms / 692 KB | 48.9µs / 8.2 KB | 14.2µs / None | -
Day 08 | 21.2µs / 11.4 KB | 3.71µs / 96.0 B | 617µs / 318 KB | 249µs / 162 KB | 170µs / 29.7 KB | 4.41ms / 5.5 MB | 260µs / 167 KB | 388µs / None | -
Day 09 | 12.7ms / 6.2 MB | 9.8µs / None | 130µs / 49.2 KB | 203ms / 167 MB | 2.8ms / 74.6 KB | 19.2ms / 44.0 MB | 539µs / 238 KB | 233µs / None | -
Day 10 | 60.3ms / 56.6 MB | 8.12ms / 5.5 MB | 436µs / 11.4 KB | 1.24ms / 768 KB | 15.1ms / 11.3 MB | 93.1µs / 62.2 KB | 13.4µs / 920 B | 809ns / None | -
Day 11 | 26.8ms / 313 KB | 24.7ms / 16.8 MB | 139µs / 11.1 KB | 27.8ms / 721 KB | 2.95ms / 888 KB | 45ms / 4.6 MB | 466µs / 223 KB | 3.69ms / None | -
Day 12 | 853µs / 367 KB | 4.74µs / 3.0 KB | 3.33ms / 1.2 MB | 1.91ms / 1.5 MB | 9.72ms / 736 B | 130µs / 78.6 KB | 1.79ms / 3.0 MB | 208µs / None | -
Day 13 | 81.5ms / 28.1 MB | 135µs / 82.1 KB | 26.6ms / 4.1 KB | 5.81ms / 2.9 MB | 9.13ms / 2.9 MB | 8.25µs / 5.1 KB | 205µs / 22.7 KB | 764µs / 610 KB | -
Day 14 | 239µs / 108 KB | **🔴 9.17s** / 33.1 KB | 24.9ms / 1.7 MB | 118ms / 21.0 MB | 6.08ms / 281 KB | 10.6ms / 7.4 MB | 270µs / 119 KB | 3.11ms / None | -
Day 15 | 56ms / 67.5 MB | 18.2ms / 14.6 KB | **🔴 510ms** / 1.4 KB | 435ms / **🔴 261 MB** | 19.5ms / 32.5 MB | 397ms / **🔴 240 MB** | 31.4ms / 2.5 MB | 1.9µs / 568 B | -
Day 16 | 511µs / 262 KB | 114ms / 17.8 MB | 191ms / 82.8 MB | 16.4ms / 10.1 MB | 179ms / 1.1 MB | 1.8ms / 1.1 MB | 9.8µs / 5.1 KB | **🔴 141ms** / **🔴 134 MB** | -
Day 17 | 64.5ms / 3.0 KB | 91.3ms / 52.5 MB | 240ms / 48.5 KB | 45.8ms / 12.1 MB | 1.11ms / 303 KB | **🔴 540ms** / **🔴 338 MB** | 1.29ms / 64.0 B | 468µs / 229 KB | -
Day 18 | 3.88ms / 42.8 KB | 177ms / 224 B | 7.67ms / 5.7 MB | 178ms / 166 MB | **🔴 485ms** / **🔴 405 MB** | 10.9ms / 2.8 MB | 27.8ms / 4.8 MB | 87.6µs / None | -
Day 19 | 545µs / 413 KB | 251ms / **🔴 145 MB** | 214µs / 44.8 KB | 62.5ms / 27.0 KB | 83.8ms / 66.6 MB | 17.8ms / 6.9 MB | **🔴 525ms** / 16.4 MB | **🔴 116ms** / **🔴 55.0 MB** | -
Day 20 | **🔴 3.58s** / **🔴 465 MB** | 276µs / 120 KB | 335ms / **🔴 206 MB** | 28.9ms / 8.5 MB | 58.5ms / 64.4 MB | 7.98ms / 5.3 MB | 15.5ms / 82.5 KB | 37.4ms / None | -
Day 21 | 537µs / 277 KB | 135ms / 48.2 MB | 66ms / 37.7 MB | 262ms / 448 KB | 4.78ms / 124 KB | 2.25ms / 438 KB | 2.58ms / 2.3 MB | 329µs / 186 KB | -
Day 22 | 457ms / **🔴 435 MB** | 16.9ms / 392 KB | 58.6ms / 526 KB | **🔴 2.58s** / **🔴 241 MB** | 211µs / 110 KB | 76.7ms / 44.0 MB | 7.48ms / 3.8 MB | 275µs / None | -
Day 23 | 22.4µs / 9.3 KB | 12.8µs / 9.0 KB | 1.54ms / 4.6 KB | 162ms / 1.7 MB | 7.34ms / 4.7 MB | **🔴 677ms** / 32.0 MB | **🔴 296ms** / **🔴 199 MB** | 60.9ms / 2.0 MB | -
Day 24 | 146ms / 61.1 MB | 67.2ms / 27.3 MB | 119ms / 59.9 MB | 94.3ms / 42.6 MB | 225ms / **🔴 195 MB** | 131ms / 7.9 MB | 1.62µs / 656 B | 76.6ms / 16.8 MB | -
Day 25 | 8.95µs / 6.1 KB | 59.6ms / 16.9 KB | 31.2ms / 15.3 KB | 8.5ms / 992 KB | 84.9ms / 50.8 MB | 40ms / 320 B | 32.9ms / None | 1.66µs / None | -
*Total* | *5.51s / 1.1 GB* | *13.9s / 314 MB* | *1.72s / 430 MB* | *4.62s / 1.1 GB* | *1.25s / 880 MB* | *2.01s / 760 MB* | *946ms / 234 MB* | *441ms / 209 MB* | *4.2s / 12.9 KB*


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
 &nbsp;  | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023
 ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---:  | ---: 
Day 01 | 3.35µs / None | 41.3µs / 34.9 KB | 1.13µs / 16.4 KB | 692µs / None | 659ns / None | 149µs / 144 KB | 13.6µs / None | 3.78µs / None | **🔴 92.8µs** / None
Day 02 | 54.2µs / 16.0 KB | 77.1µs / 3.8 KB | 8.33µs / 2.0 KB | 489µs / None | 2.04ms / None | 23.6µs / 24.6 KB | 899ns / None | 642ns / None | 2.4µs / None
Day 03 | 537µs / 279 KB | 252µs / 183 KB | 11.3µs / 14.3 KB | 4.16ms / None | 34.4µs / None | 2.69µs / None | 19.3µs / 2.0 KB | 19.2µs / None | 17.4µs / None
Day 04 | **🔴 1.34s** / 159 MB | 1.62ms / 634 KB | 3.11ms / 2.0 MB | 11µs / None | 520µs / None | 49.1µs / None | 54.3µs / 102 KB | 5.64µs / None | 19µs / None
Day 05 | 218µs / None | **🔴 5.68s** / **🔴 689 MB** | 40.4ms / 24.9 KB | 5.11ms / None | 2.41µs / None | 64.5µs / 12.4 KB | 441µs / 8.2 KB | 3.55µs / None | -
Day 06 | 38.4ms / 19.2 KB | 718µs / 5.8 KB | 1.31ms / 1.8 MB | 6.97ms / None | 132µs / 163 KB | 15µs / None | 739ns / 512 B | 5.83µs / None | -
Day 07 | 235µs / 148 KB | 2.28ms / 1.0 MB | 640µs / 523 KB | 4.16µs / None | 491µs / 102 KB | 255µs / 281 KB | 23µs / 3.3 KB | 9.67µs / None | -
Day 08 | 34.8µs / 29.6 KB | 11.3µs / 6.2 KB | 209µs / 38.2 KB | 70.8µs / None | 19.4µs / None | 72.7µs / None | 14.6µs / 2.4 KB | 280µs / None | -
Day 09 | 5.16ms / 651 KB | 152µs / 361 KB | 47.3µs / 89.3 KB | 42.5ms / **🔴 64.0 MB** | 1.77ms / None | 108µs / None | 104µs / 19.6 KB | 197µs / None | -
Day 10 | 734ms / **🔴 312 MB** | 131µs / 90.7 KB | 99.8µs / 1.1 KB | 5.71µs / None | 1.05ms / None | 696ns / None | 14.5µs / 2.5 KB | 512ns / None | -
Day 11 | 66.5ms / 15.0 MB | 1.38s / **🔴 785 MB** | 80.6µs / None | 2.71ms / None | 536µs / None | 14.7ms / 2.0 MB | 79.8µs / 319 B | 2.36ms / None | -
Day 12 | 299µs / 357 KB | 1.96µs / 5.8 KB | 858µs / 1.1 MB | 67.7µs / None | 4.03ms / None | 2.46µs / None | 4.38ms / 1.2 KB | 121µs / None | -
Day 13 | 91.6ms / 7.2 MB | 106µs / 101 KB | **🔴 353ms** / 2.4 KB | 3.88ms / None | 5.1µs / None | 465ns / 256 B | 273µs / 265 KB | 251µs / 391 KB | -
Day 14 | 410µs / 425 B | **🔴 5.36s** / 76.0 B | 22.3ms / **🔴 39.2 MB** | 104ms / **🔴 33.6 MB** | 2.13ms / 409 KB | 3.24ms / 4.5 MB | 15.7µs / 1.8 KB | 3.9ms / None | -
Day 15 | 42.9ms / 44.1 MB | 4.25ms / 432 B | **🔴 617ms** / 32.0 B | **🔴 156ms** / 377 KB | 9.52µs / None | **🔴 437ms** / **🔴 49.4 MB** | 59.5ms / **🔴 133 MB** | 1.11µs / None | -
Day 16 | 261µs / 250 KB | 58.3ms / 67.1 MB | 19.1ms / 10.6 MB | 135µs / None | **🔴 131ms** / 524 KB | 249µs / 141 KB | 5.98µs / 4.8 KB | **🔴 187ms** / **🔴 35.7 MB** | -
Day 17 | 43ms / 84.1 MB | 27.6ms / 35.4 MB | 207ms / 16.1 KB | 796µs / None | 4.75µs / None | 36ms / **🔴 21.7 MB** | 1.6ms / None | 205µs / None | -
Day 18 | 11.4ms / 56.4 KB | 325ms / 63.8 MB | 9.99µs / None | 20.5ms / None | **🔴 175ms** / **🔴 94.4 MB** | 131µs / None | 22.9ms / 15.5 MB | 87µs / None | -
Day 19 | 1.08ms / 546 KB | 39ns / None | 35.5µs / None | 43.4ms / None | 6.31µs / None | 35.4ms / 14.0 MB | 10.6ms / 2.0 MB | 52.6ms / **🔴 43.1 MB** | -
Day 20 | **🔴 1.22s** / 126 MB | 83.9µs / 76.4 KB | 17.3ms / None | 293µs / None | 5.9ms / None | 111µs / 90.9 KB | 19.6ms / 2.0 MB | 25.6ms / None | -
Day 21 | 45.5µs / 16.9 KB | 31.4ms / 4.4 MB | 3.39µs / None | 215µs / None | 4.75µs / None | 239µs / 121 KB | 1.12µs / 8.0 B | 215µs / 270 KB | -
Day 22 | 401ms / **🔴 234 MB** | 10.4ms / 194 KB | 56.9ms / None | 16.8ms / None | 2.79µs / None | 32.9ms / 15.1 MB | 12.8ms / 2.3 MB | 327µs / None | -
Day 23 | 5.62µs / 1.2 KB | 4.02µs / 21.1 KB | 28.8µs / None | 65.7ms / None | 8.86µs / None | **🔴 179ms** / None | **🔴 748ms** / **🔴 165 MB** | 48.9ms / None | -
Day 24 | 9.17ms / 10.0 MB | 4.27ms / 3.8 MB | 74.4ms / None | 50.3ms / None | 5.06ms / None | 77.6ms / None | 8.05µs / 576 B | **🔴 84.8ms** / 19.2 MB | -
Day 25 | 208ns / 32.0 B | 8.01ms / 7.3 KB | 43.6ms / None | 2.17ms / None | 10.5µs / None | 37ms / None | 29.3ms / 19.4 KB | 1.25µs / None | -
*Total* | *4s / 994 MB* | *12.9s / 1.7 GB* | *1.46s / 55.5 MB* | *527ms / 97.9 MB* | *329ms / 95.6 MB* | *855ms / 108 MB* | *910ms / 320 MB* | *407ms / 98.6 MB* | *132µs / None*


## Zig
 &nbsp;  | 2020 | 2021 | 2023
 ---:  | ---:  | ---:  | ---: 
Day 01 | 337µs | 11.8µs | **🔴 74.1µs**
Day 02 | 97.5µs | 720ns | 2.59µs
Day 03 | 17.3µs | 50.3µs | 14µs
Day 04 | 2.4ms | 53µs | **🔴 52.9µs**
Day 05 | 188µs | 690µs | -
Day 06 | 7.73ms | 873ns | -
Day 07 | 511µs | 26.4µs | -
Day 08 | 4.66ms | 1.04ms | -
Day 09 | 163µs | 118µs | -
Day 10 | 33.5µs | 26.1µs | -
Day 11 | 17.2ms | 70.4µs | -
Day 12 | 1.57ms | 148µs | -
Day 13 | 9.22µs | 259µs | -
Day 14 | - | 64.6µs | -
Day 15 | 542ms | **🔴 10.6ms** | -
Day 16 | 1.23ms | 310µs | -
Day 17 | 5.02ms | 1.45ms | -
Day 18 | 7.18ms | **🔴 6.08ms** | -
Day 19 | 12.6ms | - | -
Day 20 | 11.6ms | - | -
Day 21 | 3.31ms | 203µs | -
Day 22 | 111ms | - | -
Day 23 | **🔴 4.59s** | - | -
Day 24 | 77.3ms | - | -
Day 25 | 34.1ms | - | -
*Total* | *5.43s* | *21.2ms* | *144µs*

