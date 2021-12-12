package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestNextSum(t *testing.T) {
	door := NewDoor("abc")
	assert.Equal(t, "00000155f8105dff7f56ee10fa9b9abd", door.nextSum())
	assert.Equal(t, "000008f82c5b3924a1ecbebf60344e00", door.nextSum())
}

func TestParseGroup1(t *testing.T) {
}

func TestPlay1(t *testing.T) {
	if testing.Short() {
		t.Skip()
	}
	s := "abc"
	game := NewDoor(s)
	assert.Equal(t, "18f47a30", game.Part1(),
		"Next password should be calculated")
}

func TestPlay2(t *testing.T) {
	if testing.Short() {
		t.Skip()
	}
	s := "abc"
	game := NewDoor(s)
	assert.Equal(t, "05ace8e3", game.Part2(),
		"Next password should be calculated")
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
