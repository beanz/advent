package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func parent(d string) string {
	l := strings.LastIndex(d, "/")
	if l == 0 {
		return "/"
	}
	return d[:l]
}

func cd(c, n string) string {
	if n == "/" {
		return n
	}
	if n == ".." {
		return parent(c)
	}
	if c == "/" {
		return "/" + n
	}
	return c + "/" + n
}

func bparent(d []byte) []byte {
	for j := len(d) - 1; j > 0; j-- {
		if d[j] == '/' {
			return d[:j]
		}
	}
	return d[:1]
}

func bcd(c, n []byte) []byte {
	if len(n) == 1 && n[0] == '/' {
		return n
	}
	if len(n) == 2 && n[0] == '.' && n[1] == '.' {
		return bparent(c)
	}
	if len(c) == 1 && c[0] == '/' {
		return append(c, n...)
	}
	c = append(c, '/')
	return append(c, n...)
}

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

func key(d []byte) int {
	k := len(d)
	for i, ch := range d {
		k ^= int(ch) * (19 + i*7)
	}
	return k
}

func Parts(in []byte) (int, int) {
	w := []byte{'/'}
	s := make(map[int]int, 200)
	for i := 0; i < len(in); i++ {
		if in[i] == '$' {
			if in[i+2] == 'l' {
				continue
			}
			j := i + 5
			for in[j] != '\n' {
				j++
			}
			n := in[i+5 : j]
			w = bcd(w, n)
			i = j
			continue
		}
		if '0' <= in[i] && in[i] <= '9' {
			j, b := NextUInt(in, i)
			d := w
			for {
				s[key(d)] += b
				u := bparent(d)
				if len(u) == len(d) {
					break
				}
				d = u
			}
			for in[j] != '\n' {
				j++
			}
			i = j
			continue
		}
		j := i
		for in[j] != '\n' {
			j++
		}
		i = j
	}
	m := 70000000
	n := 30000000 - (m - s[key([]byte{'/'})])
	c := 0
	for _, v := range s {
		if v <= 100000 {
			c += v
		}
		if v >= n && v < m {
			m = v
		}
	}
	return c, m
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
