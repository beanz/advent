package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestPlay(t *testing.T) {
	line := "0222112222120000"
	assert.Equal(t, part1(line, 4), 4)
	assert.Equal(t, part2(line, 2, 2), " #\n# \n")
	input := ReadLines("input.txt")[0]
	assert.Equal(t, part1(input, 150), 1441)
	assert.Equal(t, part2(input, 25, 6),
		"###  #  # #### ###  ###  \n"+
			"#  # #  #    # #  # #  # \n"+
			"#  # #  #   #  ###  #  # \n"+
			"###  #  #  #   #  # ###  \n"+
			"# #  #  # #    #  # #    \n"+
			"#  #  ##  #### ###  #    \n")
}
