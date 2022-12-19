package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Cave struct {
	rate int
	next [][2]byte
}

type Path struct {
	from int
	to   int
}

type Key struct {
	pos, t, todo int
}

func Parts(in []byte) (int, int) {
	caves := map[[2]byte]*Cave{}
	names := [][2]byte{}
	nonZero := 0
	for i := 0; i < len(in); i++ {
		id := [2]byte{in[i+6], in[i+7]}
		names = append(names, id)
		j, r := ChompOneOrTwoCharUInt[int](in, i+23)
		if r > 0 {
			nonZero++
		}
		cave := Cave{rate: r}
		caves[id] = &cave
		i = j + 24
		if in[i] == ' ' {
			i++
		}
		for {
			nc := [2]byte{in[i], in[i+1]}
			cave.next = append(cave.next, nc)
			i += 2
			if in[i] != ',' {
				break
			}
			i += 2
		}
	}
	sort.Slice(names, func(i, j int) bool {
		return caves[names[i]].rate > caves[names[j]].rate
	})
	idToIndex := map[[2]byte]int{}
	for i, id := range names {
		idToIndex[id] = i
	}

	dist := make(map[Path]int, len(caves)*len(caves))
	for i := 0; i < len(caves); i++ {
		for j := i + 1; j < len(caves); j++ {
			dist[Path{i, j}] = len(caves) + 1
			dist[Path{j, i}] = len(caves) + 1
		}
	}
	for i, id := range names {
		for _, n := range caves[id].next {
			dist[Path{i, idToIndex[n]}] = 1
		}
	}
	for i := 0; i < len(caves); i++ {
		for j := 0; j < len(caves); j++ {
			for k := j + 1; k < len(caves); k++ {
				d := dist[Path{j, k}]
				d2 := dist[Path{j, i}] + dist[Path{i, k}]
				if d > d2 {
					d = d2
				}
				dist[Path{j, k}] = d
				dist[Path{k, j}] = d
			}
		}
	}
	mem := map[Key]int{}
	var search func(cave, t int, todo int) int
	search = func(cave, t int, todo int) int {
		if res, ok := mem[Key{cave, t, todo}]; ok {
			return res
		}
		max := 0
		for i := 0; i < nonZero; i++ {
			if todo&(1<<i) != 0 {
				nt := t - dist[Path{cave, i}] - 1 // -1 for open
				if nt > 0 {
					pres := search(i, nt, todo^(1<<i))
					pres += caves[names[i]].rate * nt
					if max < pres {
						max = pres
					}
				}
			}
		}
		mem[Key{cave, t, todo}] = max
		return max
	}
	allTodo := (1 << nonZero) - 1
	p1 := search(idToIndex[[2]byte{'A', 'A'}], 30, allTodo)
	p2 := 0
	for m := 0; m < allTodo+1; m++ {
		pres := search(idToIndex[[2]byte{'A', 'A'}], 26, m)
		pres += search(idToIndex[[2]byte{'A', 'A'}], 26, allTodo^m)
		if pres > p2 {
			p2 = pres
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
