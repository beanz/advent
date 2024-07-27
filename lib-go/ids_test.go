package aoc

import (
	"testing"

	assert "github.com/stretchr/testify/require"
)

func Test_IDBuilder(t *testing.T) {
	ib := NewIDBuilder(LowerAZID{}, 3)
	assert.Equal(t, 26, ib.Add('z'))
	assert.Equal(t, 728, ib.Add('z'))
	assert.Equal(t, 19682, ib.Add('z'))
	assert.Equal(t, "zzz", ib.Pretty(19682))
}

func Test_ListIDTracker(t *testing.T) {
	it := NewListIDTracker(10)
	assert.Equal(t, 0, it.Add([]byte("foo")))
	assert.Equal(t, 1, it.Add([]byte("bar")))
	assert.Equal(t, 0, it.Add([]byte("foo")))
	assert.Equal(t, 2, it.Add([]byte("AZaz09")))

	assert.Equal(t, 3, it.Len())

	assert.Equal(t, "foo", it.Pretty(0))
	assert.Equal(t, "bar", it.Pretty(1))
	assert.Equal(t, "AZaz09", it.Pretty(2))
}

func Test_List2IDTracker(t *testing.T) {
	it := NewList2IDTracker(262144)
	assert.Equal(t, 0, it.Add([]byte("foo")))
	assert.Equal(t, 1, it.Add([]byte("bar")))
	assert.Equal(t, 0, it.Add([]byte("foo")))
	assert.Equal(t, 2, it.Add([]byte("baz")))

	assert.Equal(t, 3, it.Len())
	assert.Equal(t, "foo", it.Pretty(0))
	assert.Equal(t, "bar", it.Pretty(1))
	assert.Equal(t, "baz", it.Pretty(2))
}
