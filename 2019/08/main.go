package main

import (
	_ "embed"
	"fmt"
	"math"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

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
	line := InputLines(input)[0]
	w := 25
	h := 6
	if InputFile() == "test1.txt" {
		w = 3
		h = 2
	}
	l := w * h
	p1 := part1(line, l)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := part2(line, w, h)
	if !benchmark {
		fmt.Printf("Part 2:\n%s", p2)
	}
}

var benchmark = false
