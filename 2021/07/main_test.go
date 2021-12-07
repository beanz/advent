package main

import (
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
