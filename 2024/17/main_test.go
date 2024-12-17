package main

import (
	_ "embed"
	"testing"

	"github.com/beanz/advent/lib-go/tester"
	"github.com/stretchr/testify/assert"
)

//go:embed input.txt
var safeinput []byte

func Test_comp(t *testing.T) {
	same := func(a, b string, n int) {
		assert.True(t, comp([]byte(a), []byte(b), n))
	}
	diff := func(a, b string, n int) {
		assert.False(t, comp([]byte(a), []byte(b), n))
	}
	same("3,2,1", "1", 1)
	same("3,2,1", "2,1", 2)
	same("3,2,1", "3,2,1", 3)
	for i := 1; i <= 6; i++ {
		same("0,3,5,4,3,0", "0,3,5,4,3,0", i)
	}
	diff("3,2,1", "2,1", 3)
	diff("3,2,1", "3,4,1", 3)
}

func TestParts(t *testing.T) {
	tester.RunAnyWithArgs[string,int](t, Parts)
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
