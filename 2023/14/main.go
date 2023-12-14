package main

import (
	"bytes"
	_ "embed"
	"fmt"
	"os"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Rocks struct {
	in   []byte
	w, h int
	w1   int
}

func (r *Rocks) N() int {
	sc := 0
	for x := 0; x < r.w; x++ {
		ym := 0
		for y := 0; y < r.h; y++ {
			switch r.in[r.w1*y+x] {
			case '#':
				ym = y + 1
			case 'O':
				r.in[r.w1*y+x] = '.'
				r.in[r.w1*ym+x] = 'O'
				sc += (r.h - ym)
				ym += 1
			}
		}
	}
	return sc
}

func (r *Rocks) W() {
	for y := 0; y < r.h; y++ {
		xm := 0
		for x := 0; x < r.w; x++ {
			switch r.in[r.w1*y+x] {
			case '#':
				xm = x + 1
			case 'O':
				r.in[r.w1*y+x] = '.'
				r.in[r.w1*y+xm] = 'O'
				xm += 1
			}
		}
	}
}

func (r *Rocks) S() {
	for x := 0; x < r.w; x++ {
		ym := r.h - 1
		for y := r.h - 1; y >= 0; y-- {
			switch r.in[r.w1*y+x] {
			case '#':
				ym = y - 1
			case 'O':
				r.in[r.w1*y+x] = '.'
				r.in[r.w1*ym+x] = 'O'
				ym -= 1
			}
		}
	}
}

func (r *Rocks) E() int {
	sc := 0
	for y := 0; y < r.h; y++ {
		xm := r.w - 1
		for x := r.w - 1; x >= 0; x-- {
			switch r.in[r.w1*y+x] {
			case '#':
				xm = x - 1
			case 'O':
				r.in[r.w1*y+x] = '.'
				r.in[r.w1*y+xm] = 'O'
				sc += (r.h - y)
				xm -= 1
			}
		}
	}
	return sc
}

func (r *Rocks) PP() {
	var b bytes.Buffer
	for y := 0; y < r.h; y++ {
		for x := 0; x < r.w-1; x++ {
			b.Write(r.in[(r.w1)*y+x : (r.w1)*y+x+1])
		}
		b.Write([]byte{'\n'})
	}
	fmt.Fprintln(os.Stderr, b.String())
}

func (r *Rocks) K() string {
	return string(r.in)
}

func Parts(in []byte, args ...int) (int, int) {
	w := bytes.Index(in, []byte{'\n'})
	h := len(in) / (w + 1)
	r := &Rocks{in, w, h, w + 1}
	p1 := r.N()
	p2 := 0
	tar := 1000000000
	seen := make(map[string]int, 1024)
	for c := 1; c <= tar; c++ {
		r.W()
		r.S()
		p2 = r.E()
		k := r.K()
		if sc, ok := seen[k]; ok {
			l := c - sc
			j := (tar - c) / l
			c += j * l
		}
		seen[k] = c
		_ = r.N()
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
