package main

import (
	_ "embed"
	"github.com/stretchr/testify/assert"
	"testing"
	. "github.com/beanz/advent/lib-go"
)

//go:embed test.txt
var test1 []byte

func TestPart1(t *testing.T) {
	assert.Equal(t, 5, NewProg(InputInts(test1)).Part1())
	assert.Equal(t, 355965, NewProg(InputInts(input)).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 10, NewProg(InputInts(test1)).Part2())
	assert.Equal(t, 26948068, NewProg(InputInts(input)).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
