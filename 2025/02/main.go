package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func invalid(id []byte) int {
	l := len(id)
OUTER:
	for i := 2; i <= l; i++ {
		if l%i != 0 {
			continue
		}
		m := l / i
		for j := m; j < len(id); j++ {
			if id[j] != id[j%m] {
				continue OUTER
			}
		}
		return i
	}
	return 0
}

func Parts(in []byte, args ...int) (int, int) {
	p1, p2 := 0, 0
	for i := 0; i < len(in); i++ {
		var s, e int
		si := i
		i, s = ChompUInt[int](in, i)
		sl := i - si
		i++
		i, e = ChompUInt[int](in, i)
		ns := &num{n: s, b: in, i: si, l: sl}
		for {
			b := ns.bytes()
			n := invalid(b)
			if n >= 2 {
				p2 += ns.n
				if n == 2 {
					p1 += ns.n
				}
			}
			if ns.n == e {
				break
			}
			ns.inc()
		}
	}
	return p1, p2
}

type num struct {
	n    int
	b    []byte
	i, l int
}

func (n *num) inc() {
	n.n++
	for j := n.l - 1; j >= 0; j-- {
		n.b[n.i+j]++
		if n.b[n.i+j] != ':' {
			return
		}
		n.b[n.i+j] = '0'
	}
	n.i--
	n.b[n.i] = '1'
	n.l++
}

func (n *num) bytes() []byte {
	return n.b[n.i : n.i+n.l]
}

func (n *num) String() string {
	return fmt.Sprintf("%d %d %q", n.i, n.l, string(n.bytes()))
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
