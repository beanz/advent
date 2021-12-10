package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestNextFloors(t *testing.T) {
	assert.ElementsMatch(t, []Floor{SECOND}, NextFloors(FIRST))
	assert.ElementsMatch(t, []Floor{FIRST, THIRD}, NextFloors(SECOND))
	assert.ElementsMatch(t, []Floor{SECOND, FOURTH}, NextFloors(THIRD))
	assert.ElementsMatch(t, []Floor{THIRD}, NextFloors(FOURTH))
}

func TestVisitKey(t *testing.T) {
	g := &Game{[]*Item{
		&Item{HYDROGEN, GENERATOR, SECOND},
		&Item{HYDROGEN, CHIP, FIRST},
		&Item{LITHIUM, GENERATOR, THIRD},
		&Item{LITHIUM, CHIP, FIRST},
	}, FIRST, false}
	assert.Equal(t, "1!2,1,3,1!", g.VisitKey())
	g = &Game{[]*Item{
		&Item{HYDROGEN, GENERATOR, SECOND},
		&Item{HYDROGEN, CHIP, FIRST},
		&Item{LITHIUM, GENERATOR, THIRD},
		&Item{LITHIUM, CHIP, THIRD},
	}, FIRST, false}
	assert.Equal(t, "1!2,1!3", g.VisitKey())
}

func TestPart1(t *testing.T) {
	g := &Game{[]*Item{
		&Item{HYDROGEN, GENERATOR, SECOND},
		&Item{HYDROGEN, CHIP, FIRST},
		&Item{LITHIUM, GENERATOR, THIRD},
		&Item{LITHIUM, CHIP, FIRST},
	}, FIRST, false}
	assert.Equal(t, 11, g.Part1())
}

func TestPart1Full(t *testing.T) {
	g := readGame()
	assert.Equal(t, 31, g.Part1())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
