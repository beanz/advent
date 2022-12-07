package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func NextUInt(in []byte, i int) (j int, n int) {
	j = i
	for ; '0' <= in[j] && in[j] <= '9'; j++ {
		n = 10*n + int(in[j]-'0')
	}
	return
}

func NextLine(in []byte, i int) int {
	for in[i] != '\n' {
		i++
	}
	i++
	return i
}

func Parts(in []byte) (int, int) {
	t := 0
	n := 0
	for _, ch := range in {
		if '0' <= ch && ch <= '9' {
			n = 10*n + int(ch&0xf)
		} else {
			t += n
			n = 0
		}
	}
	p1 := 0
	min := 70000000
	need := 30000000 - (min - t)
	i := 0
	i = NextLine(in, i)
	Size(in, i, need, &min, &p1)
	return p1, min
}

func Size(in []byte, i int, need int, min *int, p1 *int) (int, int) {
	c := 0
	for i < len(in) {
		if '0' <= in[i] && in[i] <= '9' {
			j, n := NextUInt(in, i)
			i = j + 1
			c += n
		} else if in[i+5] == '.' {
			i += 8
			return i, c
		} else if in[i+2] == 'c' {
			i += 6
			i = NextLine(in, i)
			j, s := Size(in, i, need, min, p1)
			if s < 100000 {
				*p1 += s
			} else if s < *min && s > need {
				*min = s
			}
			c += s
			i = j
			continue
		}
		i = NextLine(in, i)
	}
	return i, c
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
