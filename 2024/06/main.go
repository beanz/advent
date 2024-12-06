package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func dir(dx, dy int) int {
	if dx == 0 {
		if dy == -1 {
			return 0
		} else {
			return 1
		}
	}
	if dx == -1 {
		return 2
	}
	return 3
}

func Parts(in []byte, args ...int) (int, int) {
	pos := 0
	w := 0
LOOP:
	for ; pos < len(in); pos++ {
		switch in[pos] {
		case '^':
			break LOOP
		case '\n':
			if w == 0 {
				w = pos + 1
			}
		}
	}
	h := len(in) / w
	sx := pos % w
	sy := pos / w
	w--
	get := func(x, y int) byte {
		if 0 <= x && x < w && 0 <= y && y < h {
			return in[x+y*(w+1)]
		}
		return '!'
	}

	seen := [33410]bool{}
	c := 0
	part1 := func(ox, oy int) bool {
		seen2 := [133643]bool{}
		cx, cy := sx, sy
		dx, dy := 0, -1
		for 0 <= cx && cx < w && 0 <= cy && cy < h {
			k := (cx << 8) + cy
			if seen2[k<<2+dir(dx, dy)] {
				return true
			}
			if !seen[k] {
				c++
			}
			seen[k] = true
			seen2[k<<2+dir(dx, dy)] = true
			nx, ny := cx+dx, cy+dy
			ch := get(nx, ny)
			if ch == '#' || (nx == ox && ny == oy) {
				dx, dy = -dy, dx
				continue
			}
			cx, cy = nx, ny
		}
		return false
	}
	_ = part1(-1, -1)
	p1 := c
	p2 := 0
	nseen := [33410]bool{}
	p1seen := seen // the original set
	seen = nseen
	for oy := 0; oy < h; oy++ {
		for ox := 0; ox < w; ox++ {
			if !p1seen[(ox<<8)+oy] {
				continue
			}
			if part1(ox, oy) {
				p2++
			}
		}
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
