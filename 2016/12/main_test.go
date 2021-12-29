package main

import (
	_ "embed"
	"github.com/stretchr/testify/assert"
	"testing"

	"github.com/beanz/advent/lib-go/elfprog2016"
)

//go:embed test.txt
var test []byte

func TestPart1(t *testing.T) {
	prog := elfprog2016.NewElfProg(test)
	assert.Equal(t, 42, Part1(prog))
	prog = elfprog2016.NewElfProg(input)
	assert.Equal(t, 318007, Part1(prog))
}

func TestPart2(t *testing.T) {
	prog := elfprog2016.NewElfProg(test)
	assert.Equal(t, 42, Part2(prog))
	prog = elfprog2016.NewElfProg(input)
	assert.Equal(t, 9227661, Part2(prog))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
