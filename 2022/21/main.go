package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Id(a, b, c, d byte) int {
	return ((int(a-'a')*26+int(b-'a'))*26+int(c-'a'))*26 + int(d-'a')
}

func ChompCharId(in []byte, i int, l int, mul int, off byte) int {
	id := 0
	for j := 0; j < l; j++ {
		id = mul*id + int(in[i+j]-off)
	}
	return id
}

type Node struct {
	val   int
	left  int
	right int
	op    byte
}

const HUMN = 136877

func Parts(in []byte) (int, int) {
	nodes := map[int]*Node{}
	for i := 0; i < len(in); {
		id := ChompCharId(in, i, 4, 26, 'a')
		i += 6
		if '0' <= in[i] && in[i] <= '9' {
			j, n := ChompUInt[int](in, i)
			nodes[id] = &Node{val: n}
			i = j + 1
			continue
		}
		left := ChompCharId(in, i, 4, 26, 'a')
		right := ChompCharId(in, i+7, 4, 26, 'a')
		nodes[id] = &Node{left: left, right: right, op: in[i+5]}
		i += 12
	}
	root := Id('r', 'o', 'o', 't')
	left, leftHasHumn := Part1(nodes, nodes[root].left)
	right, rightHasHumn := Part1(nodes, nodes[root].right)
	if rightHasHumn {
		left, right = right, left
	} else if !leftHasHumn {
		panic("unreachable")
	}
	return left + right, Balance(nodes, nodes[root].left, right)
}

func Part1(nodes map[int]*Node, id int) (int, bool) {
	if nodes[id].op == 0 {
		return nodes[id].val, id == HUMN
	}
	left, lHumn := Part1(nodes, nodes[id].left)
	right, rHumn := Part1(nodes, nodes[id].right)
	var val int
	switch nodes[id].op {
	case '+':
		val = left + right
	case '-':
		val = left - right
	case '*':
		val = left * right
	case '/':
		val = left / right
	default:
		panic("unreachable")
	}
	if !lHumn && !rHumn {
		nodes[id].op = 0
		nodes[id].val = val
		return val, false
	}
	return val, true
}

func Balance(nodes map[int]*Node, id, value int) int {
	if id == HUMN {
		return value
	}
	left, lHumn := Part1(nodes, nodes[id].left)
	right, rHumn := Part1(nodes, nodes[id].right)
	switch nodes[id].op {
	case '+':
		if lHumn {
			return Balance(nodes, nodes[id].left, value-right)
		} else if rHumn {
			return Balance(nodes, nodes[id].right, value-left)
		} else {
			panic("unreachable")
		}
	case '*':
		if lHumn {
			return Balance(nodes, nodes[id].left, value/right)
		} else if rHumn {
			return Balance(nodes, nodes[id].right, value/left)
		} else {
			panic("unreachable")
		}
	case '/':
		if lHumn {
			return Balance(nodes, nodes[id].left, value*right)
		} else if rHumn {
			return Balance(nodes, nodes[id].right, value*left)
		} else {
			panic("unreachable")
		}
	case '-':
		if lHumn {
			return Balance(nodes, nodes[id].left, value+right)
		} else if rHumn {
			return Balance(nodes, nodes[id].right, left-value)
		} else {
			panic("unreachable")
		}
	}
	return value
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
