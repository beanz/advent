package aoc

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

func TestSimpleReadInts(t *testing.T) {
	assert.ElementsMatch(t, []int{324, 1156, 1208, 1575},
		SimpleReadInts("324 <-> 1156, 1208, 1575"))

	assert.ElementsMatch(t, []int{0, 14, 91, 65, 26, 71},
		SimpleReadInts("/dev/grid/node-x0-y14    91T   65T    26T   71%"))
}
