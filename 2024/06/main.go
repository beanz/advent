package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

var DX = []int{0, 1, 0, -1}
var DY = []int{-1, 0, 1, 0}

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
	cx, cy := sx, sy
	dx, dy := 0, -1
	p1 := 0
	for 0 <= cx && cx < w && 0 <= cy && cy < h {
		k := (cx << 8) + cy
		if !seen[k] {
			p1++
		}
		seen[k] = true
		var nx, ny int
		for {
			nx, ny = cx+dx, cy+dy
			if get(nx, ny) != '#' {
				break
			}
			dx, dy = -dy, dx
			continue
		}
		cx, cy = nx, ny
	}
	part2 := func(ox, oy int) bool {
		seen2 := [133643]bool{}
		cx, cy := sx, sy
		dir := 0
		for 0 <= cx && cx < w && 0 <= cy && cy < h {
			k := ((cx<<8)+cy)<<2 + dir
			if seen2[k] {
				return true
			}
			seen2[k] = true
			nx, ny := cx+DX[dir], cy+DY[dir]
			if (nx == ox && ny == oy) || get(nx, ny) == '#' {
				dir = (dir + 1) & 3
				continue
			}
			cx, cy = nx, ny
		}
		return false
	}
	p2 := 0
	for oy := 0; oy < h; oy++ {
		for ox := 0; ox < w; ox++ {
			if !seen[(ox<<8)+oy] {
				continue
			}
			if part2(ox, oy) {
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
