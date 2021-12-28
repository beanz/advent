package main

import (
	_ "embed"
	"github.com/stretchr/testify/assert"
	"testing"
)

//go:embed test1.txt
var test1 []byte

func ExampleMain() {
	main()
	//Output:
	// Part 1: 31
	// Part 2: 55
}

func TestNextFloors(t *testing.T) {
	assert.ElementsMatch(t, []Floor{SECOND}, NextFloors(FIRST))
	assert.ElementsMatch(t, []Floor{FIRST, THIRD}, NextFloors(SECOND))
	assert.ElementsMatch(t, []Floor{SECOND, FOURTH}, NextFloors(THIRD))
	assert.ElementsMatch(t, []Floor{THIRD}, NextFloors(FOURTH))
}

func TestVisitKey(t *testing.T) {
	f := NewFacility(test1)
	assert.Equal(t, "0!1020!", f.VisitKey(f.state))

	f = NewFacility([]byte(`The first floor contains a hydrogen-compatible microchip.
The second floor contains a hydrogen generator.
The third floor contains a lithium-compatible microchip and a lithium generator.
`))
	assert.Equal(t, "0!10!2", f.VisitKey(f.state))

	f = NewFacility([]byte(`The second floor contains a hydrogen-compatible microchip and a hydrogen generator.
The third floor contains a lithium-compatible microchip and a lithium generator.
`))
	of := NewFacility([]byte(`The second floor contains a lithium-compatible microchip and a lithium generator.
The third floor contains a hydrogen-compatible microchip and a hydrogen generator.
`))
	assert.Equal(t, f.VisitKey(f.state), of.VisitKey(of.state))
}

func TestPart1(t *testing.T) {
	f := NewFacility(test1)
	assert.Equal(t, uint(11), f.Part1())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
