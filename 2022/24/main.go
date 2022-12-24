package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Search struct {
	x, y, t    int
	start, end bool
	k          int
}

func S(x, y, t int, start, end bool) Search {
	k := t
	k = (k << 7) + x
	k = (k << 5) + y
	k = (k << 1)
	if start {
		k++
	}
	k = (k << 1)
	if end {
		k++
	}
	return Search{x, y, t, start, end, k}
}

func Parts(in []byte) (int, int) {
	m := NewByteMap(in)
	sx, sy := 0, 0
	for ; m.GetXY(sx, sy) != '.'; sx++ {
	}
	w, h := m.Width(), m.Height()
	b := [1000][3200]bool{}
	for sy := 1; sy < h-1; sy++ {
		for sx := 1; sx < w-1; sx++ {
			ch := m.GetXY(sx, sy)
			var ix, iy int
			switch ch {
			case '.':
				continue
			case '^':
				iy = -1
			case 'v':
				iy = 1
			case '<':
				ix = -1
			case '>':
				ix = 1
			}
			x, y := sx, sy
			b[0][m.XYToIndex(x, y)] = true
			for t := 1; t < 1000; t++ {
				x += ix
				y += iy
				if x == 0 {
					x = w - 2
				}
				if y == 0 {
					y = h - 2
				}
				if x == w-1 {
					x = 1
				}
				if y == h-1 {
					y = 1
				}
				b[t][m.XYToIndex(x, y)] = true
			}
		}
	}
	//fmt.Printf("%d,%d %d,%d\n", sx, sy, m.Width(), m.Height())
	todoArray := [6400]Search{}
	todo := NewDeque(todoArray[0:])
	todo.Push(S(sx, sy, 0, false, false))
	seen := [16777216]bool{}
	p1, p2 := 0, 0
	for todo.Len() > 0 {
		cur := todo.Pop()
		if seen[cur.k] {
			continue
		}
		seen[cur.k] = true
		if cur.y == h-1 {
			if cur.start && cur.end {
				p2 = cur.t
				break
			}
			if p1 == 0 {
				p1 = cur.t
			}
			cur.end = true
			cur.k |= 1
		} else if cur.y == 0 && cur.end {
			cur.start = true
			cur.k |= 2
		}
		for _, o := range [][2]int{{0, 0}, {0, -1}, {0, 1}, {-1, 0}, {1, 0}} {
			nx, ny := cur.x+o[0], cur.y+o[1]
			if !(0 <= nx && nx < w && 0 <= ny && ny < h) {
				continue
			}
			if m.GetXY(nx, ny) == '#' {
				continue
			}
			if ny < h-1 && b[cur.t+1][m.XYToIndex(nx, ny)] {
				continue
			}
			s := S(nx, ny, cur.t+1, cur.start, cur.end)
			todo.Push(s)
		}
	}
	return p1, p2
}

func Pretty(m *ByteMap, b []bool, ex, ey int) string {
	var sb strings.Builder
	for y := 0; y < m.Height(); y++ {
		for x := 0; x < m.Width(); x++ {
			if ex == x && ey == y {
				fmt.Fprint(&sb, "X")
				continue
			}
			i := m.XYToIndex(x, y)
			if b[i] {
				fmt.Fprint(&sb, "*")
				continue
			}
			if m.Get(i) == '#' {
				fmt.Fprint(&sb, "#")
				continue
			}
			fmt.Fprint(&sb, ".")
		}
		fmt.Fprintln(&sb)
	}
	return sb.String()
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
