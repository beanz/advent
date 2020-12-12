package aoc

import (
	"os"
)

func DEBUG() bool {
	return os.Getenv("AoC_DEBUG") != ""
}
