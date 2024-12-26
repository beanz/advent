package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, string) {
	ex, ey := 70, 70
	corrupt := 1024
	if len(in) < 150 {
		ex, ey = 6, 6
		corrupt = 12
	}
	w := ex + 1
	drops := make([][2]int, 0, 4096)
	m := [8192]int{}
	n := 0
	for i := 0; i < len(in); {
		var j, x, y int
		j, x = ChompUInt[int](in, i)
		j, y = ChompUInt[int](in, j+1)
		i = j + 1
		drops = append(drops, [2]int{x, y})
		m[x+y*w] = n + 1
		n++
	}
	todo := [16384]rec{}
	p1 := search(m[:], ex, ey, corrupt, todo[:0])
	hi := n
	lo := corrupt + 1
	for {
		mid := (lo + hi) / 2
		if search(m[:], ex, ey, mid, todo[:0]) != -1 {
			lo = mid + 1
		} else {
			hi = mid
		}
		if lo == hi {
			break
		}
	}
	return p1, fmt.Sprintf("%d,%d", drops[lo-1][0], drops[lo-1][1])
}

var DX = []int{0, 1, 0, -1}
var DY = []int{-1, 0, 1, 0}

func search(m []int, ex, ey, corrupt int, todo []rec) int {
	w, h := ex+1, ey+1
	todo = append(todo, rec{0, 0, 0})
	seen := [8000]bool{}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if cur.x == ex && cur.y == ey {
			return cur.st
		}
		for d := 0; d < 4; d++ {
			nx, ny := cur.x+DX[d], cur.y+DY[d]
			if !(0 <= nx && nx < w && 0 <= ny && ny < h) {
				continue
			}
			k := nx + ny*w
			if seen[k] {
				continue
			}
			seen[k] = true
			c := m[k]
			if c != 0 && (c-1) < corrupt {
				continue
			}
			todo = append(todo, rec{nx, ny, cur.st + 1})
		}
	}
	return -1
}

type rec struct {
	x, y, st int
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
