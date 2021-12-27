package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

type TestCase struct {
	lines []byte
	dist  int
	steps int
}

func TestPlay(t *testing.T) {
	tests := []TestCase{
		{[]byte("R8,U5,L5,D3\nU7,R6,D4,L4\n"), 6, 30},
		{[]byte("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\n" +
			"U98,R91,D20,R16,D67,R40,U7,R15,U6,R7\n"), 135, 410},
		{[]byte("R75,D30,R83,U83,L12,D49,R71,U7,L72\n" +
			"U62,R66,U55,R34,D71,R55,D58,R83\n"), 159, 610},
		{input, 225, 35194},
	}
	for _, tc := range tests {
		d, s := Calc(tc.lines)
		assert.Equal(t, tc.dist, d)
		assert.Equal(t, tc.steps, s)
	}
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
