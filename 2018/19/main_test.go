package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPart1(t *testing.T) {
	assert.Equal(t, 6, Part1(NewElfProg2018(ReadLines("test.txt"))))
	assert.Equal(t, 1764, Part1(NewElfProg2018(ReadLines("input.txt"))))
}

func TestPart2(t *testing.T) {
	assert.Equal(t, 18992484, Part2(NewElfProg2018(ReadLines("input.txt"))))
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
