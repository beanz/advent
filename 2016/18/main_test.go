package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 1913
	// Part 2: 19993564
}

func TestParts(t *testing.T) {
	g := Game{[]byte("..^^."), 2, 3, 0}
	p1, p2 := g.Parts()
	assert.Equal(t, 4, p1)
	assert.Equal(t, 6, p2)
	g = Game{[]byte(".^^.^.^^^^"), 10, 20, 0}
	p1, p2 = g.Parts()
	assert.Equal(t, 38, p1)
	assert.Equal(t, 93, p2)
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
