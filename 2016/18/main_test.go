package main

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestNewRow(t *testing.T) {
	g := Game{"..^^.", 3, 0, false}
	assert.Equal(t, ".^^^^", g.NewRow(g.row))
	assert.Equal(t, "^^..^", g.NewRow(".^^^^"))
}

func TestPart1(t *testing.T) {
	g := Game{".^^.^.^^^^", 10, 0, false}
	assert.Equal(t, 38, g.Part1())
}
