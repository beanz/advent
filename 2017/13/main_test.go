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
	assert.Equal(t, 24, NewFirewall(InputBytes(test1)).Part1())
	assert.Equal(t, 1928, NewFirewall(InputBytes(input)).Part1())
}

func TestPart2(t *testing.T) {
	if testing.Short() {
		t.Skip()
	}
	assert.Equal(t, 10, NewFirewall(InputBytes(test1)).Part2())
	assert.Equal(t, 3830344, NewFirewall(InputBytes(input)).Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
