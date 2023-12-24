package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	w := bytes.Index(in, []byte{'\n'})
	w1 := w + 1
	h := len(in) / w1
	in[1] = '#'
	in[len(in)-3] = '#'
	start := 1 + w1
	end := len(in) - 3 - w1
	return graph(in, start, end, w, h, true), graph(in, start, end, w, h, false)
}

type Rec struct {
	i, si, steps int
	visit        map[int]struct{}
}

func graph(in []byte, start, end, w, h int, part1 bool) int {
	w1 := w + 1
	g := make(map[int]map[int]int, 50)
	visit := make([]bool, 32000)
	offsets := [4]int{-1, 1, -w1, w1}
	chars := [4]byte{'<', '>', '^', 'v'}
	todo := make([]Rec, 1, 128)
	todo[0] = Rec{start, start, 0, make(map[int]struct{}, 32)}
	for len(todo) > 0 {
		cur := todo[0]
		todo = todo[1:]
		if _, ok := cur.visit[cur.i]; ok {
			continue
		}
		cur.visit[cur.i] = struct{}{}
		n := make([]int, 0, 4)
		ch := in[cur.i]
		for k := 0; k < 4; k++ {
			o := offsets[k]
			dir := chars[k]
			if in[cur.i+o] == '#' {
				continue
			}
			if part1 && ch != '.' && ch != dir {
				continue
			}
			if !part1 && ch == '#' {
				continue
			}
			n = append(n, cur.i+o)
		}
		if len(n) > 2 || cur.i == end {
			if _, ok := g[cur.si]; !ok {
				g[cur.si] = make(map[int]int, 32)
			}
			g[cur.si][cur.i] = cur.steps
			if !part1 {
				if _, ok := g[cur.i]; !ok {
					g[cur.i] = make(map[int]int, 32)
				}
				g[cur.i][cur.si] = cur.steps
			}
			if visit[cur.i] {
				continue
			}
			visit[cur.i] = true
			for _, ni := range n {
				if _, ok := cur.visit[ni]; ok {
					continue
				}
				todo = append(todo,
					Rec{ni, cur.i, 1, map[int]struct{}{cur.i: {}}})
			}
			continue
		}
		for _, ni := range n {
			if _, ok := cur.visit[ni]; ok {
				continue
			}
			todo = append(todo, Rec{ni, cur.si, cur.steps + 1, cur.visit})
		}
	}

	gn := make([][][2]int, 50)
	gi := make(map[int]int, 50)
	gni := 0
	for i, nxt := range g {
		if _, ok := gi[i]; !ok {
			gi[i] = gni
			gni++
		}
		gn[gi[i]] = make([][2]int, 0, len(nxt))
		for ni, steps := range nxt {
			if _, ok := gi[ni]; !ok {
				gi[ni] = gni
				gni++
			}
			gn[gi[i]] = append(gn[gi[i]], [2]int{gi[ni], steps})
		}
	}

	endi := gi[end]
	todo2 := make([][2]int, 1, 128)
	todo2[0] = [2]int{gi[start], 0}
	visit2 := make([]bool, 32000)
	res := 0
	for len(todo2) > 0 {
		cur := todo2[len(todo2)-1]
		todo2 = todo2[:len(todo2)-1]
		i, steps := cur[0], cur[1]
		if steps == -1 {
			visit2[i] = false
			continue
		}
		if i == endi {
			if res < steps {
				res = steps
			}
			continue
		}
		if visit2[i] {
			continue
		}
		visit2[i] = true
		todo2 = append(todo2, [2]int{i, -1})
		for _, nxt := range gn[i] {
			if !visit2[nxt[0]] {
				todo2 = append(todo2, [2]int{nxt[0], steps + nxt[1]})
			}
		}
	}
	return res + 2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
