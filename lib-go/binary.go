package aoc

import (
	"fmt"
	"strconv"
)

func IntToBin(n int) string {
	return strconv.FormatInt(int64(n), 2)
}

func BinToInt(s string) int {
	i, err := strconv.ParseInt(s, 2, 32)
	if err != nil {
		panic(fmt.Sprintf("invalid binary int %s: %s", s, err))
	}
	return int(i)
}
