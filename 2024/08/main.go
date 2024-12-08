package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	a := make(map[byte][]int, 64)
	var x, y, w int
	for i := 0; i < len(in); i++ {
		switch in[i] {
		case '\n':
			w = x
			y++
			x = 0
			continue
		case '.':
		default:
			if _, ok := a[in[i]]; !ok {
				a[in[i]] = make([]int, 0, 4)
			}
			a[in[i]] = append(a[in[i]], i)
		}
		x++
	}
	h := len(in) / (w + 1)
	p1 := 0
	an1 := make([]bool, 4096)
	p1s := func(x, y int) bool {
		if !(0 <= x && x < w && 0 <= y && y < h) {
			return false
		}
		if !an1[x+y*w] {
			p1++
		}
		an1[x+y*w] = true
		return true
	}
	p2 := 0
	an2 := make([]bool, 4096)
	p2s := func(x, y int) bool {
		if !(0 <= x && x < w && 0 <= y && y < h) {
			return false
		}
		if !an2[x+y*w] {
			p2++
		}
		an2[x+y*w] = true
		return true
	}

	for _, nodes := range a {
		for i := range nodes {
			for j := i + 1; j < len(nodes); j++ {
				a, b := nodes[i], nodes[j]
				ax, ay := a%(w+1), a/(w+1)
				bx, by := b%(w+1), b/(w+1)
				p2s(ax, ay)
				p2s(bx, by)
				dx, dy := ax-bx, ay-by
				x, y := ax+dx, ay+dy
				if p1s(x, y) {
					for p2s(x, y) {
						x, y = x+dx, y+dy
					}
				}
				x, y = bx-dx, by-dy
				if p1s(x, y) {
					for p2s(x, y) {
						x, y = x-dx, y-dy
					}
				}
			}
		}
	}

	// for y := 0; y < h; y++ {
	// 	for x := 0; x < w; x++ {
	// 		ch := string(in[x+y*(w+1)])
	// 		if an1[x+y*w] {
	// 			ch = Red(ch)
	// 		}
	// 		if an2[x+y*w] {
	// 			ch = Bold(ch)
	// 		}
	// 		fmt.Fprintf(os.Stderr, "%s", ch)
	// 	}
	// 	fmt.Fprintln(os.Stderr)
	// }

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
