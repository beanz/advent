package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	in     string
	p1, p2 int
}

func TestCalc(t *testing.T) {
	tests := []TestCase{
		{"abcdef", 609043, 6742839},
		{"pqrstuv", 1048970, 5714438},
		{ReadFileLines("input.txt")[0], 346386, 9958218},
	}
	for i, tc := range tests {
		p1, p2 := calc(tc.in)
		n := tc.in
		if i == 2 {
			n = "<input.txt"
		}
		assert.Equal(t, tc.p1, p1, "part 1: "+n)
		assert.Equal(t, tc.p2, p2, "part 2: "+n)
		if testing.Short() {
			break
		}
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
