package main

import (
	"bytes"
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func hash(s []byte) int {
	var r byte
	for i := 0; i < len(s); i++ {
		r += s[i]
		r *= 17
	}
	return int(r)
}

type lens struct {
	l []byte
	v byte
}

func Parts(in []byte, args ...int) (int, int) {
	p1 := 0
	b := [256][]lens{}
	for i := 0; i < len(in); {
		j := i
		k := 0
		for ; j < len(in) && in[j] != ',' && in[j] != '\n'; j++ {
			if in[j] == '-' || in[j] == '=' {
				k = j
			}
		}
		p1 += hash(in[i:j])
		bn := hash(in[i:k])
		if b[bn] == nil {
			b[bn] = make([]lens, 0, 8)
		}
		if in[k] == '-' {
			n := 0
			for ii := 0; ii < len(b[bn]); ii++ {
				if !bytes.Equal(b[bn][ii].l, in[i:k]) {
					b[bn][n] = b[bn][ii]
					n++

				}
			}
			b[bn] = b[bn][:n]
		} else {
			v := in[k+1] - '0'
			var found bool
			for ii := 0; ii < len(b[bn]); ii++ {
				if bytes.Equal(b[bn][ii].l, in[i:k]) {
					found = true
					b[bn][ii].v = v
					break
				}
			}
			if !found {
				b[bn] = append(b[bn], lens{in[i:k], v})
			}
		}
		i = j + 1
	}
	p2 := 0
	for bn, be := range b {
		for sn, s := range be {
			p2 += (bn + 1) * (sn + 1) * int(s.v)
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
