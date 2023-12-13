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
	p1 := 0
	p2 := 0
	for _, ch := range bytes.Split(in, []byte("\n\n")) {
		p1 += reflect(ch, 0)
		p2 += reflect(ch, 1)
	}
	return p1, p2
}

func reflect(in []byte, wrong int) int {
	w := bytes.Index(in, []byte{'\n'})
	h := (1 + len(in)) / (w + 1)
	for r := 0; r < w-1; r++ {
		cw := 0
		for o := 0; o < w; o++ {
			xl := r - o
			xr := r + o + 1
			if 0 <= xl && xr < w {
				for y := 0; y < h; y++ {
					yi := (w + 1) * y
					if in[yi+xl] != in[yi+xr] {
						cw++
					}
				}
			}
		}
		if cw == wrong {
			return r + 1
		}
	}
	for r := 0; r < h-1; r++ {
		cw := 0
		for o := 0; o < h; o++ {
			yu := r - o
			yd := r + o + 1
			yui := (w + 1) * yu
			ydi := (w + 1) * yd
			if 0 <= yu && yd < h {
				for x := 0; x < w; x++ {
					if in[yui+x] != in[ydi+x] {
						cw++
					}
				}
			}
		}
		if cw == wrong {
			return 100 * (r + 1)
		}
	}
	return -1
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
