package main

import (
	"fmt"
	"log"
	"math"
	"os"
	"strconv"

	. "github.com/beanz/advent/lib-go"
)

func counts(s string) map[rune]int {
	r := make(map[rune]int, 3)
	for _, b := range s {
		r[b]++
	}
	return r
}

func part1(line string, l int) int {
	min := math.MaxInt64
	res := -1
	for i := 0; i < len(line); i += l {
		r := counts(line[i : i+l])
		if r['0'] < min {
			min = r['0']
			res = r['1'] * r['2']
		}
	}
	return res
}

func part2(line string, w, h int) string {
	l := w * h
	s := ""
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			i := y*w + x
			for i < len(line) {
				if line[i] == '0' {
					s += " "
					break
				}
				if line[i] == '1' {
					s += "#"
					break
				}
				i += l
			}
		}
		s += "\n"
	}
	return s
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt> <w> <h>\n", os.Args[0])
	}
	line := ReadLines(os.Args[1])[0]
	var w, h int
	var err error
	if len(os.Args) < 3 {
		w = 25
	} else {
		w, err = strconv.Atoi(os.Args[2])
		if err != nil {
			panic(err)
		}
	}
	if len(os.Args) < 4 {
		h = 6
	} else {
		h, err = strconv.Atoi(os.Args[3])
		if err != nil {
			panic(err)
		}
	}
	l := w * h
	fmt.Printf("Part 1: %d\n", part1(line, l))
	fmt.Printf("Part 2:\n%s", part2(line, w, h))
}
