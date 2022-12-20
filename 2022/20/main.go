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

type Int = int16

func Pretty(nums []int, idx []int) string {
	var sb strings.Builder
	for _, i := range idx {
		fmt.Fprintf(&sb, "%d, ", nums[i])
	}
	s := sb.String()
	return s[:len(s)-2]
}

func Mix(nums []Int, rounds int, key int) int {
	ln := Int(len(nums))
	idx := [5000]int16{}
	var i Int
	for i = 0; i < ln; i++ {
		idx[i] = i
	}
	for r := 0; r < rounds; r++ {
		var i Int
		for i = 0; i < ln; i++ {
			num := int(nums[i]) * key
			j := 0
			for ; idx[j] != i; j++ {
			}
			n := Mod(j+num, int(ln-1)) // -1 because we've removed one
			if j < n {
				copy(idx[j:n], idx[j+1:n+1])
				idx[n] = i
			} else {
				copy(idx[n+1:j+1], idx[n:j])
				idx[n] = i
			}
			//fmt.Printf("  %s\n", Pretty(nums, idx))
		}
	}
	var zero Int
	for ; nums[zero] != 0; zero++ {
	}
	nZero := 0
	for ; idx[nZero] != zero; nZero++ {
	}
	return int(nums[idx[Mod(nZero+1000, int(ln))]])*key + int(nums[idx[Mod(nZero+2000, int(ln))]])*key + int(nums[idx[Mod(nZero+3000, int(ln))]])*key
}

func Parts(in []byte) (int, int) {
	nums := [5000]Int{}
	l := 0
	for i := 0; i < len(in); i++ {
		j, n := ChompInt[Int](in, i)
		i = j
		nums[l] = n
		l++
	}
	return Mix(nums[:l], 1, 1), Mix(nums[:l], 10, BIG)
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
