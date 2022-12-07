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
		return c + n
	}
	return c + "/" + n
}

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

func Parts(in []byte) (int, int) {
	w := "/"
	s := make(map[string]int, 200)
	for i := 0; i < len(in); i++ {
		if in[i] == '$' {
			if in[i+2] == 'l' {
				continue
			}
			j := i + 5
			for in[j] != '\n' {
				j++
			}
			n := string(in[i+5 : j])
			w = cd(w, n)
			i = j
			continue
		}
		if '0' <= in[i] && in[i] <= '9' {
			j, b := NextUInt(in, i)
			d := w
			for {
				s[d] += b
				u := parent(d)
				if u == d {
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
	n := 30000000 - (m - s["/"])
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
