package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	g := make([]map[int]struct{}, 1536)
	id := 0
	{
		names := make(map[int]int, 2048)
		node_id := func(nb []byte) int {
			n := (int(nb[0]-'a')*26+int(nb[1]-'a'))*26 + int(nb[2]-'a')
			nid, ok := names[n]
			if !ok {
				names[n] = id
				g[id] = make(map[int]struct{}, 16)
				nid = id
				id++
			}
			return nid
		}
		for i := 0; i < len(in); i++ {
			fid := node_id(in[i : i+3])
			i += 4
			for ; in[i] == ' '; i += 4 {
				tid := node_id(in[i+1 : i+4])
				g[fid][tid] = struct{}{}
				g[tid][fid] = struct{}{}
			}
		}
	}
	start, end := 0, id-1
	for {
		p1 := find_cuts(g, start, end)
		if p1 != 0 {
			return p1 * (id - p1), 1
		}
		start++
		end--
		if end <= start {
			return 1, 1
		}
	}
}

func find_cuts(g []map[int]struct{}, start, end int) int {
	cuts := make([]int, 0, 512)
	for k := 0; k < 3; k++ {
		path := find_path(g, start, end, cuts)
		if path == nil {
			return 0
		}
		for i := 0; i < len(path)-1; i++ {
			cuts = append(cuts, edge(path[i], path[i+1]))
		}
	}
	path := find_path(g, start, end, cuts)
	if path != nil {
		// still connected so both points are in same partition; try again
		return 0
	}
	for len(cuts) > 3 {
		rm := cuts[0]
		cuts = cuts[1:]
		path := find_path(g, start, end, cuts)
		if path != nil {
			cuts = append(cuts, rm)
		}
	}
	todo := make([]int, 1, 1536)
	todo[0] = start
	e := make([]bool, 1536)
	p1 := 0
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if e[cur] {
			continue
		}
		e[cur] = true
		p1++
		for nxt := range g[cur] {
			if isCut(cuts, cur, nxt) {
				continue
			}
			todo = append(todo, nxt)
		}
	}

	c := 0
	for _, v := range e {
		if v {
			c++
		}
	}

	return p1
}

func edge(from, to int) int {
	if from < to {
		return from*1536 + to
	}
	return to*1536 + from
}

func find_path(g []map[int]struct{}, start, end int, cuts []int) []int {
	todo := make([][]int, 1, 1536)
	todo[0] = make([]int, 1, 16)
	todo[0][0] = start
	visit := make([]bool, 1536)
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		node := cur[len(cur)-1]
		if node == end {
			return cur
		}
		visit[node] = true
		for nxt := range g[node] {
			if visit[nxt] {
				continue
			}
			if isCut(cuts, node, nxt) {
				continue
			}
			npath := make([]int, len(cur)+1, 16)
			copy(npath, cur)
			npath[len(cur)] = nxt
			todo = append(todo, npath)
		}
	}
	return nil
}

func isCut(cuts []int, from, to int) bool {
	e := edge(from, to)
	e2 := edge(to, from)
	for _, cut := range cuts {
		if cut == e || cut == e2 {
			return true
		}
	}
	return false
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
