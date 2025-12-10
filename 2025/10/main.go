package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Machine struct {
	goal1   int
	button1 []int
	button2 [][]int
	goal2   []int
}

func Parts(in []byte, args ...int) (int, int) {
	p1 := 0
	for i := 0; i < len(in); i++ {
		i++
		m := Machine{}
		c := 0
		for ; i < len(in) && in[i] != ']'; i++ {
			m.goal1 <<= 1
			if in[i] == '#' {
				m.goal1++
			}
			c++
		}
		i += 2
		for ; i < len(in) && in[i] != '{'; i++ {
			b := []int{}
			bn := 0
			for ; i < len(in) && in[i] != ')'; i++ {
				i++
				n := int(in[i] - '0')
				b = append(b, n)
				bn |= 1 << (c - 1 - n)
			}
			m.button1 = append(m.button1, bn)
			m.button2 = append(m.button2, b)
			i += 1
		}
		for i < len(in) && in[i] != '}' {
			i++
			j, n := ChompUInt[int](in, i)
			i = j
			m.goal2 = append(m.goal2, n)
		}
		i++
		todo := [][2]int{{0, 0}}
		seen := [1024]bool{}
		for len(todo) > 0 {
			cur := todo[0]
			todo = todo[1:]
			if cur[0] == m.goal1 {
				p1 += cur[1]
				break
			}
			if seen[cur[0]] {
				continue
			}
			seen[cur[0]] = true
			for _, b := range m.button1 {
				todo = append(todo, [2]int{cur[0] ^ b, cur[1] + 1})
			}
		}
	}
	return p1, 2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %v\n", p1)
		fmt.Printf("Part 2: %v\n", p2)
	}
}

var benchmark = false
