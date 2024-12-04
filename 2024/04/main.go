package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	m := NewByteMap(in)
	p1, p2 := 0, 0
	for x := 0; x < m.Width(); x++ {
		for y := 0; y < m.Height(); y++ {
			if m.GetXY(x, y) != 'X' {
				continue
			}
			for ox := -1; ox <= 1; ox++ {
				for oy := -1; oy <= 1; oy++ {
					if ox == 0 && oy == 0 {
						continue
					}
					if !m.Contains(m.XYToIndex(x+ox*3, y+oy*3)) {
						continue
					}
					if m.GetXY(x+ox, y+oy) == 'M' && m.GetXY(x+ox*2, y+oy*2) == 'A' && m.GetXY(x+ox*3, y+oy*3) == 'S' {
						p1++
					}
				}
			}
		}
	}
	for x := 1; x < m.Width()-1; x++ {
		for y := 1; y < m.Height()-1; y++ {
			if m.GetXY(x, y) != 'A' {
				continue
			}
			mas := func(ox, oy int) bool {
				if !(m.GetXY(x+ox, y+oy) == 'M' && m.GetXY(x-ox, y-oy) == 'S') &&
					!(m.GetXY(x+ox, y+oy) == 'S' && m.GetXY(x-ox, y-oy) == 'M') {
					return false
				}
				return true
			}
			if mas(-1, -1) && mas(-1, 1) {
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
