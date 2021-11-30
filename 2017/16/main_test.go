package main

import (
	"github.com/stretchr/testify/assert"
	"testing"

	. "github.com/beanz/advent/lib-go"
)

func TestSpin(t *testing.T) {
	d := &Dance{"abcde", []string{}, false}
	d.Spin(3)
	assert.Equal(t, "cdeab", d.programs)

	d = &Dance{"abcde", []string{}, false}
	d.Spin(1)
	assert.Equal(t, "eabcd", d.programs)
}

func TestExchange(t *testing.T) {
	d := &Dance{"eabcd", []string{}, false}
	d.Exchange(3, 4)
	assert.Equal(t, "eabdc", d.programs)
}

func TestPartner(t *testing.T) {
	d := &Dance{"eabdc", []string{}, false}
	d.Partner('e', 'b')
	assert.Equal(t, "baedc", d.programs)
}

func TestPart1(t *testing.T) {
	dance := ReadDance("abcdefghijklmnop", ReadLines("input.txt")[0])
	assert.Equal(t, "ionlbkfeajgdmphc", dance.Part1())
}

func TestPart2(t *testing.T) {
	dance := ReadDance("abcdefghijklmnop", ReadLines("input.txt")[0])
	assert.Equal(t, "fdnphiegakolcmjb", dance.Part2())
}
