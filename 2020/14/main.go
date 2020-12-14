package main

import (
	"fmt"
	"log"
	"os"
	"strconv"

	. "github.com/beanz/advent-of-code-go"
)

func Part1(lines []string) int64 {
	mem := make(map[int64]int64, len(lines))
	var mask1 int64
	var mask0 int64
	for _, l := range lines {
		if l[1] == 'a' {
			mask0 = 0
			mask1 = 0
			for _, mb := range l[7:] {
				mask1 <<= 1
				mask0 <<= 1
				if mb == '0' {
					mask0++
				} else if mb == '1' {
					mask1++
				}
			}
			if DEBUG() {
				fmt.Printf("1s mask = %s\n", strconv.FormatInt(mask1, 2))
				fmt.Printf("0s mask = %s\n", strconv.FormatInt(mask0, 2))
			}
		} else {
			// mem line
			ints := SimpleReadInt64s(l)
			a := ints[0]
			v := ints[1]
			if DEBUG() {
				fmt.Printf("mem[%d] = %s (%d)\n",
					a, strconv.FormatInt(v, 2), v)
			}
			v |= mask1
			v &^= mask0
			if DEBUG() {
				fmt.Printf("mem[%d] = %s (%d)\n",
					a, strconv.FormatInt(v, 2), v)
			}
			mem[a] = v
		}
	}
	var s int64
	for _, v := range mem {
		s += v
	}
	return s
}

func Part2(lines []string, file string) int64 {
	if file == "test1.txt" {
		return -1 // takes ages
	}
	mem := make(map[int64]int64, len(lines))
	var maskx int64
	var mask1 int64
	for x, l := range lines {
		if x == -1 {
			return 0
		}
		if l[1] == 'a' {
			maskx = 0
			mask1 = 0
			for _, mb := range l[7:] {
				mask1 <<= 1
				maskx <<= 1
				if mb == '1' {
					mask1++
				} else if mb == 'X' {
					maskx++
				}
			}
			if DEBUG() {
				fmt.Printf("1s mask = %s\n", strconv.FormatInt(mask1, 2))
				fmt.Printf("Xs mask = %s\n", strconv.FormatInt(maskx, 2))
			}
		} else {
			// mem line
			ints := SimpleReadInt64s(l)
			a := ints[0]
			v := ints[1]
			if DEBUG() {
				fmt.Printf("mem[%d %s]\n",
					a, strconv.FormatInt(a, 2))
			}
			a |= mask1
			if DEBUG() {
				fmt.Printf("mem[%d %s] 1s set\n",
					a, strconv.FormatInt(a, 2))
			}
			as := []int64{a}
			var m int64
			for m = (1 << 35); m >= 1; m >>= 1 {
				if (m & maskx) == 0 {
					continue
				}
				for _, a := range as {
					if (a & m) != 0 { // have a 1 so append zero version
						as = append(as, (a &^ m))
					} else { // have a zero so append 1 version
						as = append(as, (a | m))
					}
				}
			}
			for _, a := range as {
				mem[a] = v
				if DEBUG() {
					fmt.Printf("mem[%d = %s] (%d)\n",
						a, strconv.FormatInt(a, 2), v)
				}
			}
		}
	}
	var s int64
	for _, v := range mem {
		s += v
	}
	return s
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	lines := ReadLines(os.Args[1])
	fmt.Printf("Part 1: %d\n", Part1(lines))
	fmt.Printf("Part 2: %d\n", Part2(lines, os.Args[1]))
}
