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
	g := &Game{[]*Item{
		&Item{HYDROGEN, GENERATOR, SECOND},
		&Item{HYDROGEN, CHIP, FIRST},
		&Item{LITHIUM, GENERATOR, THIRD},
		&Item{LITHIUM, CHIP, FIRST},
	}, FIRST, false}
	assert.Equal(t, "0!1,0,2,0!", g.VisitKey())
	g = &Game{[]*Item{
		&Item{HYDROGEN, GENERATOR, SECOND},
		&Item{HYDROGEN, CHIP, FIRST},
		&Item{LITHIUM, GENERATOR, THIRD},
		&Item{LITHIUM, CHIP, THIRD},
	}, FIRST, false}
	assert.Equal(t, "0!1,0!2", g.VisitKey())

	g = &Game{[]*Item{
		&Item{HYDROGEN, GENERATOR, SECOND},
		&Item{HYDROGEN, CHIP, SECOND},
		&Item{LITHIUM, GENERATOR, THIRD},
		&Item{LITHIUM, CHIP, THIRD},
	}, FIRST, false}
	og := &Game{[]*Item{
		&Item{HYDROGEN, GENERATOR, THIRD},
		&Item{HYDROGEN, CHIP, THIRD},
		&Item{LITHIUM, GENERATOR, SECOND},
		&Item{LITHIUM, CHIP, SECOND},
	}, FIRST, false}
	assert.Equal(t, g.VisitKey(), og.VisitKey())
}

func TestPart1(t *testing.T) {
	g := NewGame(test1)
	assert.Equal(t, 11, g.Part1())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
