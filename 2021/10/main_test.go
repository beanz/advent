package main

import (
	_ "embed"
	"github.com/stretchr/testify/assert"
	"math/rand"
	"testing"
)

//go:embed test1.txt
var test1 []byte

type TestCase struct {
	file string
	data []byte
	p1   int
	p2   int
}

func TestCalc(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", test1, 26397, 288957},
		{"input.txt", input, 390993, 2391385187},
	}
	for _, tc := range tests {
		p1, p2 := Calc(tc.data)
		assert.Equal(t, tc.p1, p1, tc.file)
		assert.Equal(t, tc.p2, p2, tc.file)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}

const momlen = 10
const momrange = 1000

var result int

func BenchmarkMoM(b *testing.B) {
	rand.Seed(95167302)
	inp := make([]int, momlen)
	for i := 0; i < len(inp); i++ {
		inp[i] = rand.Intn(momrange)
	}
	var r int
	for i := 0; i < b.N; i++ {
		r += MedianOfMedians(inp, len(inp)/2)
	}
	result = r
}

func BenchmarkSimpleMedian(b *testing.B) {
	rand.Seed(95167302)
	inp := make([]int, momlen)
	for i := 0; i < len(inp); i++ {
		inp[i] = rand.Intn(momrange)
	}
	var r int
	for i := 0; i < b.N; i++ {
		r += SimpleMedianN(inp, len(inp)/2)
	}
	result = r
}
