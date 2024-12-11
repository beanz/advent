package main

import (
	_ "embed"
	"testing"

	"github.com/beanz/advent/lib-go/tester"
	"github.com/stretchr/testify/assert"
)

//go:embed input.txt
var safeinput []byte

func Test_uintLen(t *testing.T) {
	assert.Equal(t, 1, uintLen(0))
	assert.Equal(t, 1, uintLen(9))
	assert.Equal(t, 2, uintLen(10))
	assert.Equal(t, 2, uintLen(99))
	assert.Equal(t, 3, uintLen(100))
	assert.Equal(t, 3, uintLen(999))
}

func TestParts(t *testing.T) {
	tester.RunWithArgs(t, Parts)
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		b.StopTimer()
		copy(input, safeinput)
		b.StartTimer()
		main()
	}
}
