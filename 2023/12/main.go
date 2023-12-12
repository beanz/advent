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
	p1, p2 := 0, 0
	for i := 0; i < len(in); {
		end := bytes.Index(in[i:], []byte{' '})
		eol := bytes.Index(in[i:], []byte{'\n'})
		cache := [1048576]int{}
		r1 := Solve(in[i:i+eol], end, eol-end-1, 0, 0, 0, 1, cache[:])
		p1 += r1
		cache = [1048576]int{}
		r2 := Solve(in[i:i+eol], end, eol-end-1, 0, 0, 0, 5, cache[:])
		p2 += r2
		i += eol + 1
	}
	return p1, p2
}

func Solve(in []byte, eos, eon, si, ni, l, mul int, cache []int) int {
	//fmt.Fprint(os.Stderr, debug(in, eos, eon, si, ni, l, mul))
	k := (((si << 8) + ni) << 4) + l
	if cache[k] != 0 {
		return cache[k] - 1
	}
	m_eos := eos*mul + mul - 1
	s_mod := eos + 1
	m_eon := eon*mul + mul - 1
	n_mod := eon + 1
	var nni int
	var n int
	if ni < m_eon {
		nni, n = ChompUInt[int](in[eos+1+(ni%n_mod):], 0)
		nni += ni
		if n < l {
			return 0
		}
	}

	if si == m_eos {
		if ni >= m_eon {
			if l == 0 {
				return 1
			}
			return 0
		}
		if nni == m_eon && n == l {
			return 1
		}
		return 0
	}
	r := 0
	ch := in[si%s_mod]
	if ch == '.' || ch == '?' || ch == ' ' {
		if l == 0 {
			r += Solve(in, eos, eon, si+1, ni, 0, mul, cache)
		} else if l > 0 && ni < m_eon {
			if n == l {
				r += Solve(in, eos, eon, si+1, nni+1, 0, mul, cache)
			}
		}
	}
	if ch == '#' || ch == '?' || ch == ' ' {
		r += Solve(in, eos, eon, si+1, ni, l+1, mul, cache)
	}
	cache[k] = r + 1
	return r
}

func debug(in []byte, eos, eon, si, ni, l, mul int) string { // nolint:unused
	var b bytes.Buffer
	b.Write(in[:eos])
	for i := 1; i < mul; i++ {
		b.Write([]byte{'?'})
		b.Write(in[:eos])
	}
	b.Write([]byte{' '})
	b.Write(in[eos+1 : eos+eon+1])
	for i := 1; i < mul; i++ {
		b.Write([]byte{','})
		b.Write(in[eos+1 : eos+eon+1])
	}
	fmt.Fprintf(&b, " si=%d ni=%d l=%d\n", si, ni, l)
	m_eos := eos*mul + mul - 1
	m_eon := eon*mul + mul - 1
	for i := 0; i <= m_eos+1+m_eon; i++ {
		switch i {
		case si:
			b.Write([]byte{'|'})
		case m_eos + 1 + ni:
			b.Write([]byte{'^'})
		default:
			b.Write([]byte{' '})
		}
	}
	b.Write([]byte{'\n'})
	return b.String()
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
