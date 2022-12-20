package main

import (
	_ "embed"
	"fmt"
	"strings"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

const BIG = 811589153

func mod(n, m int) int {
	a := n % m
	if a < 0 {
		a += m
	}
	return a
}

type Elt struct {
	num      int
	pre, nxt int
}

func Pretty(elts []Elt) string {
	var sb strings.Builder
	elt := elts[0]
	for range elts {
		fmt.Fprintf(&sb, "%d, ", elt.num)
		elt = elts[elt.nxt]
	}
	s := sb.String()
	return s[:len(s)-2]
}

func Mix(nums []int, rounds int, key int) int {
	ln := len(nums)
	elts := make([]Elt, ln)
	zero := 0
	for i, n := range nums {
		if n == 0 {
			zero = i
		}
		elts[i] = Elt{n * key, i - 1, i + 1}
	}
	elts[0].pre = ln - 1
	elts[ln-1].nxt = 0
	//fmt.Printf("  %s\n", Pretty(elts))
	for r := 0; r < rounds; r++ {
		for i, elt := range elts {
			num := elt.num
			//fmt.Printf("moving %d pre=%d nxt=%d\n", num, elt.pre, elt.nxt)
			elts[elt.nxt].pre = elt.pre
			elts[elt.pre].nxt = elt.nxt
			mix := mod(num, ln-1)
			nxt := elt.nxt
			for i := 0; i < mix; i++ {
				nxt = elts[nxt].nxt
			}
			pre := elts[nxt].pre
			elts[i].nxt = nxt
			elts[i].pre = pre
			elts[pre].nxt = i
			elts[nxt].pre = i
			//fmt.Printf("  %s\n", Pretty(elts))
		}
	}
	s := 0
	elt := elts[zero]
	for i := 0; i < 1000; i++ {
		elt = elts[elt.nxt]
	}
	//fmt.Printf("%d\n", elt.num)
	s += elt.num
	for i := 0; i < 1000; i++ {
		elt = elts[elt.nxt]
	}
	//fmt.Printf("%d\n", elt.num)
	s += elt.num
	for i := 0; i < 1000; i++ {
		elt = elts[elt.nxt]
	}
	//fmt.Printf("%d\n", elt.num)
	return s + elt.num
}

func Parts(in []byte) (int, int) {
	nums := make([]int, 0, 5000)
	nums2 := make([]int, 0, 5000)
	for i := 0; i < len(in); i++ {
		j, n := ChompInt[int](in, i)
		i = j
		nums = append(nums, n)
		nums2 = append(nums2, n)
	}
	return Mix(nums, 1, 1), Mix(nums2, 10, BIG)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
