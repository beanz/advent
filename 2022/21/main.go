package main

import (
	_ "embed"
	"fmt"
	"math/big"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func ChompCharId(in []byte, i int, l int, mul int, off byte) int {
	id := 0
	for j := 0; j < l; j++ {
		id = mul*id + int(in[i+j]-off)
	}
	return id
}

func ChompId(m map[int]int, in []byte, i int, l int, mul int, off byte) int {
	v := ChompCharId(in, i, l, mul, off)
	if id, ok := m[v]; ok {
		return id
	}
	m[v] = len(m)
	return m[v]
}

type Node struct {
	val   int
	left  int
	right int
	op    byte
}

func Parts(in []byte) (int, int) {
	idToIndex := make(map[int]int, 2048)
	root := ChompId(idToIndex, []byte("root"), 0, 4, 26, 'a')
	humn := ChompId(idToIndex, []byte("humn"), 0, 4, 26, 'a') // 1th id
	nodes := [2048]*Node{}
	for i := 0; i < len(in); {
		id := ChompId(idToIndex, in, i, 4, 26, 'a')
		i += 6
		if '0' <= in[i] && in[i] <= '9' {
			j, n := ChompUInt[int](in, i)
			nodes[id] = &Node{val: n}
			i = j + 1
			continue
		}
		left := ChompId(idToIndex, in, i, 4, 26, 'a')
		right := ChompId(idToIndex, in, i+7, 4, 26, 'a')
		nodes[id] = &Node{left: left, right: right, op: in[i+5]}
		i += 12
	}
	nodesSlice := nodes[:len(idToIndex)]
	p1, _ := Part1(nodesSlice, root, humn)
	nodes[0].op = '-'
	nodes[1].val = 0
	fZero := Part2(nodesSlice, root)
	nodes[1].val = 1
	fOne := Part2(nodesSlice, root)
	fZeroSubOne := big.NewRat(0, 1)
	fZeroSubOne.Sub(fZero, fOne)
	ans := big.NewRat(0, 1)
	ans.Quo(fZero, fZeroSubOne)
	if !ans.IsInt() {
		panic("not integer")
	}
	return p1, int(ans.Num().Int64())
}

func Part2(nodes []*Node, id int) *big.Rat {
	if nodes[id].op == 0 {
		return big.NewRat(int64(nodes[id].val), 1)
	}
	left := Part2(nodes, nodes[id].left)
	right := Part2(nodes, nodes[id].right)
	val := big.NewRat(0, 1)
	switch nodes[id].op {
	case '+':
		val = val.Add(left, right)
	case '-':
		val = val.Sub(left, right)
	case '*':
		val = val.Mul(left, right)
	case '/':
		val = val.Quo(left, right)
	}
	return val
}

func Part1(nodes []*Node, id int, humn int) (int, bool) {
	if nodes[id].op == 0 {
		return nodes[id].val, id == humn
	}
	left, lhumn := Part1(nodes, nodes[id].left, humn)
	right, rhumn := Part1(nodes, nodes[id].right, humn)
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
	if !lhumn && !rhumn {
		nodes[id].val = val
		nodes[id].op = 0
	}
	return val, lhumn || rhumn
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
