package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte, args ...int) (int, int) {
	a := [80 * 4]int{}
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
			j := 4 * int(in[i]-'0')
			for ; a[j] != 0; j++ {
			}
			a[j] = i + 1 // offset to avoid default/empty 0 value
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

	for k := 0; k < 80; k++ {
		for i := 0; i < 4; i++ {
			ai := a[4*k+i]
			if ai == 0 {
				break
			}
			ai--
			ax, ay := ai%(w+1), ai/(w+1)
			for j := i + 1; j < 4; j++ {
				bi := a[4*k+j]
				if bi == 0 {
					break
				}
				bi--
				bx, by := bi%(w+1), bi/(w+1)
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
