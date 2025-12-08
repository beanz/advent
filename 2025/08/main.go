package main

import (
	_ "embed"
	"fmt"
	"slices"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Int uint32

func Parts(in []byte, args ...int) (int, int) {
	dist := make([][3]int, 0, 500000)
	point := make([][3]int, 0, 1024)
	for i := 0; i < len(in); i++ {
		p := [3]int{}
		i, p[0] = ChompUInt[int](in, i)
		i, p[1] = ChompUInt[int](in, i+1)
		i, p[2] = ChompUInt[int](in, i+1)
		for j := 0; j < len(point); j++ {
			dx, dy, dz := (p[0] - point[j][0]), (p[1] - point[j][1]), (p[2] - point[j][2])
			d := (dx * dx) + (dy * dy) + (dz * dz)
			dist = append(dist, [3]int{d, len(point), j})
		}
		point = append(point, p)
	}
	slices.SortFunc(dist, func(a [3]int, b [3]int) int {
		return a[0] - b[0]
	})
	conns := 1000
	if len(point) < 30 {
		conns = 10
	}
	count := 0
	parent := make([]Int, len(point))
	size := make([]Int, len(point))
	for i := range parent {
		parent[i] = Int(i)
		size[i] = 1
	}
	var find func(i Int) Int
	find = func(i Int) Int {
		p := parent[i]
		if p == i {
			return i
		}
		p = find(p)
		parent[i] = p
		return p
	}
	union := func(i, j Int) Int {
		ir := find(i)
		jr := find(j)
		if ir == jr {
			return size[ir]
		}
		parent[jr] = ir
		size[ir] += size[jr]
		size[jr] = 0
		return size[ir]
	}
	p1, p2 := 0, 0
	for _, d := range dist {
		s := union(Int(d[1]), Int(d[2]))
		count++
		if int(s) == len(point) {
			p2 = point[d[1]][0] * point[d[2]][0]
			break
		}
		if count == conns {
			s := slices.Clone(size)
			slices.SortFunc(s, func(a Int, b Int) int { return int(b) - int(a) })
			p1 = int(s[0]) * int(s[1]) * int(s[2])
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
