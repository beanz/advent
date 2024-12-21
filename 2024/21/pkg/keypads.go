package keypads

import (
	_ "embed"
	"fmt"
)

//go:embed dirpad.txt
var dirpad []byte

//go:embed numpad.txt
var numpad []byte

type Pad map[uint16][]string

var DirPad = solve(dirpad, 5)
var NumPad = solve(numpad, 5)
var cache = map[int]map[string][]int{}

func MoveLen(s string, max int) int {
	if _, ok := cache[max]; !ok {
		cache[max] = map[string][]int{}
	}
	return moveLen(s, 0, max)
}

func moveLen(s string, depth, max int) int {
	v, ok := cache[max][s]
	if !ok {
		cache[max][s] = make([]int, max+1)
	} else {
		if v[depth] != 0 {
			return v[depth] - 1
		}
	}
	pad := DirPad
	if depth == 0 {
		pad = NumPad
	}
	l := 0
	var cur byte = 'A'
	for _, key := range []byte(s) {
		paths := pad.Paths(cur, key)
		if depth == max {
			l += 1 + len(paths[0])
		} else {
			min := -1
			for _, path := range paths {
				sl := moveLen(path+"A", depth+1, max)
				if min == -1 || min > sl {
					min = sl
				}
			}
			l += min
		}
		cur = key
	}
	cache[max][s][depth] = l + 1
	return l
}

func (p Pad) Paths(from, to byte) []string {
	k := uint16(from)<<8 + uint16(to)
	if v, ok := p[k]; ok {
		return v
	}
	panic(fmt.Sprintf("unexpected move from %c to %c", from, to))
}

func solve(in []byte, w int) Pad {
	h := len(in) / (w + 1) // account for newlines
	type S struct {
		x, y int
		ch   byte
	}
	type R struct {
		x, y int
		path string
	}
	s := []S{}
	for y := 1; y < h-1; y++ {
		for x := 1; x < w-1; x++ {
			if ch := in[x+y*(w+1)]; ch != '#' {
				s = append(s, S{x, y, ch})
			}
		}
	}
	res := Pad{}
	for i := 0; i < len(s); i++ {
		sx, sy, sch := s[i].x, s[i].y, s[i].ch
		for j := 0; j < len(s); j++ {
			_, _, tch := s[j].x, s[j].y, s[j].ch
			k := (uint16(sch) << 8) + uint16(tch)
			if i == j {
				res[k] = []string{""}
				continue
			}
			todo := []R{{sx, sy, ""}}
			seen := map[int]int{}
			for len(todo) > 0 {
				cx, cy, path := todo[0].x, todo[0].y, todo[0].path
				todo = todo[1:]
				if v, ok := seen[(cx<<8)+cy]; ok && v < len(path) {
					continue
				}
				seen[(cx<<8)+cy] = len(path)
				if in[cx+cy*(w+1)] == tch {
					res[k] = append(res[k], path)
					continue
				}
				for _, o := range []S{{0, -1, '^'}, {1, 0, '>'}, {0, 1, 'v'}, {-1, 0, '<'}} {
					nx, ny, nch := cx+o.x, cy+o.y, o.ch
					if in[cx+cy*(w+1)] != '#' {
						todo = append(todo, R{nx, ny, path + string(nch)})
					}
				}
			}
		}
	}
	return res
}
