package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

var DX = []int{0, 1, 0, -1}
var DY = []int{-1, 0, 1, 0}

func Parts(in []byte, args ...int) (int, int) {
	w := bytes.IndexByte(in, '\n')
	h := len(in) / (w + 1)
	w1 := w + 1
	get := func(x, y int) byte {
		if 0 <= x && x < w && 0 <= y && y < h {
			return in[x+y*w1]
		}
		return 128
	}
	type rec struct{ x, y int }
	seen := [20480]bool{}
	p1, p2 := 0, 0
	for y := 0; y < h; y++ {
		for x := 0; x < w; x++ {
			if seen[x+y*w] {
				continue
			}
			ch := get(x, y)
			area := 0
			per := 0
			p := [4]map[rec]struct{}{}
			for k := 0; k < 4; k++ {
				p[k] = map[rec]struct{}{}
			}
			todo := []rec{{x, y}}
			for len(todo) > 0 {
				var cur rec
				cur, todo = todo[0], todo[1:]
				if seen[cur.x+cur.y*w] {
					continue
				}
				seen[cur.x+cur.y*w] = true
				area++
				for dir := 0; dir < 4; dir++ {
					nx, ny := cur.x+DX[dir], cur.y+DY[dir]
					if get(nx, ny) == ch {
						todo = append(todo, rec{nx, ny})
						continue
					}
					per++
					p[dir][cur] = struct{}{}
				}
			}
			sides := 0
			for dir, set := range p {
				seen_per := [20480]bool{}
				for cur := range set {
					if seen_per[cur.x+cur.y*w] {
						continue
					}
					sides++
					todo = append(todo, rec{cur.x, cur.y})
					for len(todo) > 0 {
						var cur rec
						cur, todo = todo[0], todo[1:]
						if seen_per[cur.x+cur.y*w] {
							continue
						}
						seen_per[cur.x+cur.y*w] = true
						ndir := (dir + 1) & 3
						nx, ny := cur.x+DX[ndir], cur.y+DY[ndir]
						r := rec{nx, ny}
						if _, ok := set[r]; ok {
							todo = append(todo, r)
						}
						ndir = (dir + 3) & 3
						nx, ny = cur.x+DX[ndir], cur.y+DY[ndir]
						r = rec{nx, ny}
						if _, ok := set[r]; ok {
							todo = append(todo, r)
						}
					}
				}
			}

			// fmt.Fprintf(os.Stderr, "%c %dx%d=%d %dx%d=%d\n",
			// 	ch, area, per, area*per, area, sides, area*sides)
			p1 += area * per
			p2 += area * sides
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
