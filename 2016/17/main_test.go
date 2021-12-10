package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestCode(t *testing.T) {
	g := Game{4, 4, "hijkl", false}
	c := g.Code("")
	assert.True(t, c['U'])
	assert.True(t, c['D'])
	assert.True(t, c['L'])
	assert.False(t, c['R'])
}

func TestPart1(t *testing.T) {
	assert.Equal(t, "DDRRRD", Game{4, 4, "ihgpwlah", false}.Part1())
	assert.Equal(t, "DDUDRLRRUDRD", Game{4, 4, "kglvqrro", false}.Part1())
	assert.Equal(t, "DRURDRUDDLLDLUURRDULRLDUUDDDRR",
		Game{4, 4, "ulqzkmiv", false}.Part1())
	assert.Equal(t, "RLDUDRDDRR",
		Game{4, 4, "mmsxrhfx", false}.Part1())
}
func TestPart2(t *testing.T) {
	assert.Equal(t, 370, Game{4, 4, "ihgpwlah", false}.Part2())
	assert.Equal(t, 492, Game{4, 4, "kglvqrro", false}.Part2())
	assert.Equal(t, 830, Game{4, 4, "ulqzkmiv", false}.Part2())
	assert.Equal(t, 590, Game{4, 4, "mmsxrhfx", false}.Part2())
}

func BenchmarkMain(b *testing.B) {
	benchmark = true
	for i := 0; i < b.N; i++ {
		main()
	}
}
