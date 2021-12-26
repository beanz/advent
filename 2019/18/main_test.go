package main

import (
	assert "github.com/stretchr/testify/require"
	"testing"
)

func ExampleMain() {
	main()
	//Output:
	// Part 1: 4406
	// Part 2: 1964
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}

func TestAlphaNumSet(t *testing.T) {
	cs := AlphaNumSet(0)
	cs = cs.Add('a')
	cs = cs.Add('b')
	assert.Equal(t, "ab", cs.String(), "alphanumset a&b")
	assert.True(t, cs.Contains('a'), "contains a")
	assert.False(t, cs.Contains('c'), "contains c")
}
