package main

import (
	_ "embed"
	"fmt"
	"math/bits"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Cave struct {
	rate int
	next []int
}

func key(cave, t, todo int) int {
	return (((todo << 6) + cave) << 5) + t
}

func charsToId(a, b byte) int {
	return int(a-'A')*26 + int(b-'A')
}

func Parts(in []byte) (int, int) {
	caves := map[int]*Cave{}
	names := []int{}
	nonZero := 0
	for i := 0; i < len(in); i++ {
		id := charsToId(in[i+6], in[i+7])
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
			nc := charsToId(in[i], in[i+1])
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
	idToIndex := [676]int{}
	for i, id := range names {
		idToIndex[id] = i
	}
	Path := func(i, j int) int {
		return 64*i + j
	}
	dist := [64 * 64]int{}
	for i := 0; i < len(caves); i++ {
		for j := i + 1; j < len(caves); j++ {
			dist[Path(i, j)] = len(caves) + 1
			dist[Path(j, i)] = len(caves) + 1
		}
	}
	for i, id := range names {
		for _, n := range caves[id].next {
			dist[Path(i, idToIndex[n])] = 1
		}
	}
	for i := 0; i < len(caves); i++ {
		for j := 0; j < len(caves); j++ {
			for k := j + 1; k < len(caves); k++ {
				d := dist[Path(j, k)]
				d2 := dist[Path(j, i)] + dist[Path(i, k)]
				if d > d2 {
					d = d2
				}
				dist[Path(j, k)] = d
				dist[Path(k, j)] = d
			}
		}
	}
	mem := make(map[int]int, 1320000)
	var search func(cave, t int, todo int) int
	search = func(cave, t int, todo int) int {
		k := key(cave, t, todo)
		if res, ok := mem[k]; ok {
			return res
		}
		max := 0
		for i := 0; i < nonZero; i++ {
			if todo&(1<<i) != 0 {
				nt := t - dist[Path(cave, i)] - 1 // -1 for open
				if nt > 0 {
					pres := search(i, nt, todo^(1<<i))
					pres += caves[names[i]].rate * nt
					if max < pres {
						max = pres
					}
				}
			}
		}
		mem[k] = max
		return max
	}
	start := idToIndex[charsToId('A', 'A')]
	allTodo := (1 << nonZero) - 1
	p1 := search(start, 30, allTodo)
	p2 := 0
	for m := 0; m < allTodo+1; m++ {
		if bits.OnesCount(uint(m)) != (nonZero+1)/2 {
			continue
		}
		pres := search(start, 26, m)
		pres += search(start, 26, allTodo^m)
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
