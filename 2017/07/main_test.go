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
	assert.Equal(t, "tknk", NewTower(InputLines(test1)).Part1())
	assert.Equal(t, "eqgvf", NewTower(InputLines(input)).Part1())
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 60, NewTower(InputLines(test1)).Part2())
	assert.Equal(t, 757, NewTower(InputLines(input)).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
