package aoc

import (
	assert "github.com/stretchr/testify/require"
	"testing"
)

func TestAlphaNumSet(t *testing.T) {
	cs := NewAlphaNumSet()
	cs = cs.Add('a')
	cs = cs.Add('b')
	assert.Equal(t, "ab", cs.String(), "alphanumset a&b")
	assert.True(t, cs.Contains('a'), "contains a")
	assert.False(t, cs.Contains('c'), "contains c")
	assert.Equal(t, 2, cs.Size(), "alphanumset size")
	cs = cs.Add('z')
	cs = cs.Add('A')
	cs = cs.Add('Z')
	cs = cs.Add('0')
	cs = cs.Add('9')
	assert.Equal(t, 7, cs.Size(), "alphanumset size")
	assert.Equal(t, "09AZabz", cs.String(), "alphanumset a&b")
}
