package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte
var DX = []int{-1, 0, 1, 0}
var DY = []int{0, -1, 0, 1}

func Parts(in []byte) (int, int) {
	m := NewByteMap(in)
	p1, p2 := 0, 0
	w := m.Width()
	h := m.Height()
	DI := []int{-1, -(w + 1), 1, w + 1}
	m.VisitXYI(func(x, y, i int, v byte) (byte, bool) {
		s := 1
		p1Done := false
		for j := 0; j < 4; j++ {
			nx, ny, ni := x+DX[j], y+DY[j], i+DI[j]
			c := 0
			visible := true
			for nx >= 0 && ny >= 0 && nx < w && ny < h {
				c++
				if m.Get(ni) >= v {
					visible = false
					break
				}
				nx, ny, ni = nx+DX[j], ny+DY[j], ni+DI[j]
			}
			s *= c
			if visible && !p1Done {
				p1++
				p1Done = true
			}
		}
		if s > p2 {
			p2 = s
		}
		return 0, false
	})
	return p1, p2
}

func main() {
	in := InputBytes(input)
	p1, p2 := Parts(in)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
