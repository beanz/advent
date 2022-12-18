package aoc

import (
	"testing"

	assert "github.com/stretchr/testify/require"
)

func TestQueue(t *testing.T) {
	buf := [4]int{}
	q := NewQueue(buf[0:])
	assert.Equal(t, q.Len(), 0)
	assert.True(t, q.Empty())
	q.Push(1)
	assert.Equal(t, q.Len(), 1)
	assert.False(t, q.Empty())
	assert.Equal(t, q.Pop(), 1)
	assert.Equal(t, q.Len(), 0)
	assert.True(t, q.Empty())
	q.Push(2)
	q.Push(4)
	q.Push(8)
	q.Push(16)
	assert.Equal(t, q.Len(), 4)
	assert.False(t, q.Empty())
	assert.Equal(t, q.Pop(), 2)
	assert.Equal(t, q.Len(), 3)
	assert.False(t, q.Empty())
	assert.Equal(t, q.Pop(), 4)
	assert.Equal(t, q.Len(), 2)
	assert.False(t, q.Empty())
	assert.Equal(t, q.Pop(), 8)
	assert.Equal(t, q.Len(), 1)
	assert.False(t, q.Empty())
	assert.Equal(t, q.Pop(), 16)
	assert.Equal(t, q.Len(), 0)
	assert.True(t, q.Empty())
}
