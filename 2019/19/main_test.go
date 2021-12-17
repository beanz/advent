package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 211
	// Part 2: 8071006
}

func TestParts(t *testing.T) {
	p := FastInt64s(InputBytes(input), 4096)
	beam := NewBeam(p)
	assert.Equal(t, 211, beam.part1())
	beam.size = 5 - 1
	assert.Equal(t, true, beam.inBeam(36, 45))
	assert.Equal(t, true, beam.squareFits(36, 45))
	assert.Equal(t, 36, beam.squareFitsY(45))
	assert.Equal(t, 360045, beam.part2())
	beam.size = 100 - 1
	assert.Equal(t, 8071006, beam.part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
