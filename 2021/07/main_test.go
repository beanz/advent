package main

import (
	"fmt"
	"testing"

	"github.com/stretchr/testify/assert"

	. "github.com/beanz/advent/lib-go"
)

type TestCase struct {
	file string
	p1   int
	p2   int
}

func TestCalc(t *testing.T) {
	tests := []TestCase{
		{"test1.txt", 37, 168},
		{"test2.txt", 251456, 42005848},
		{"input.txt", 336701, 95167302},
	}
	for _, tc := range tests {
		p1, p2 := Calc(ReadIntsFromFile(tc.file))
		assert.Equal(t, tc.p1, p1, tc.file+" part 1")
		assert.Equal(t, tc.p2, p2, tc.file+" part 2")
	}
}

func TestMedianOfMedians(t *testing.T) {
	tests := [][]int{
		[]int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
		[]int{0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13},
		[]int{474, 475, 488, 479, 480, 476, 484, 485, 485, 473, 479, 480, 488, 483, 490, 496, 507, 498, 509, 491, 500, 492, 492, 497, 513, 493, 497, 503, 500, 501, 505, 492},
	}
	for _, inp := range tests {
		for i := 0; i < len(inp); i++ {
			t.Run(fmt.Sprintf("%v [%d]", inp, i), func(t *testing.T) {
				mom := MedianOfMedians(inp, i)
				simple := SimpleMedianN(inp, i)
				assert.Equal(t, simple, mom)
			})
		}
	}
}

func TestMedianOfMediansBig(t *testing.T) {
	for _, file := range []string{"test1.txt", "test2.txt", "input.txt"} {
		inp := ReadIntsFromFile(file)
		mom := MedianOfMedians(inp, len(inp)/2)
		simple := SimpleMedian(inp)
		assert.Equal(t, simple, mom, file)
	}
}

var res int

func BenchmarkCalc(b *testing.B) {
	inp := ReadIntsFromFile("input.txt")
	r := 0
	for n := 0; n < b.N; n++ {
		p1, p2 := Calc(inp)
		r += p1 + p2
	}
	res = r
}
func BenchmarkCalcRandom(b *testing.B) {
	inp := ReadIntsFromFile("test2.txt")
	r := 0
	for n := 0; n < b.N; n++ {
		p1, p2 := Calc(inp)
		r += p1 + p2
	}
	res = r
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
