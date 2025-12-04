package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	p1 := 0
	w := bytes.IndexByte(in, '\n') + 1
	h := len(in) / w
	neighbours := [][2]int{
		{-1, -1}, {0, -1}, {1, -1},
		{-1, 0}, {1, 0},
		{-1, 1}, {0, 1}, {1, 1},
	}
	for y := 0; y < h; y++ {
		for x := 0; x < w-1; x++ {
			if in[x+y*w] != '@' {
				continue
			}
			c := 0
			for _, o := range neighbours {
				nx, ny := x+o[0], y+o[1]
				if !(0 <= nx && nx < w-1 && 0 <= ny && ny < h) {
					continue
				}
				if in[nx+ny*w] == '@' {
					c++
				}
			}
			if c < 4 {
				p1++
			}
		}
	}
	p2 := 0
	done := false
	for !done {
		done = true
		for y := 0; y < h; y++ {
			for x := 0; x < w-1; x++ {
				if in[x+y*w] != '@' {
					continue
				}
				c := 0
				for _, o := range neighbours {
					nx, ny := x+o[0], y+o[1]
					if !(0 <= nx && nx < w-1 && 0 <= ny && ny < h) {
						continue
					}
					if in[nx+ny*w] == '@' {
						c++
					}
				}
				if c < 4 {
					done = false
					p2++
					in[x+y*w] = '_'
				}
			}
		}
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
