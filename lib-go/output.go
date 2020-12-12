package aoc

import (
	"fmt"
	"os"
	"strconv"
	"strings"
)

func VISUAL() bool {
	return os.Getenv("AoC_VISUAL") != ""
}

func Screen() (int, int) {
	if !VISUAL() {
		return 80, 24
	}
	v := strings.Split(os.Getenv("AoC_VISUAL"), "x")
	col, err := strconv.Atoi(v[0])
	if err != nil {
		panic("Invalid screen defined in AoC_VISUAL bad column number")
	}
	row, err := strconv.Atoi(v[1])
	if err != nil {
		panic("Invalid screen defined in AoC_VISUAL bad row number")
	}
	return col, row
}

func Red(s string) string {
	return fmt.Sprintf("\033[31m%s\033[37m", s)
}

func Cyan(s string) string {
	return fmt.Sprintf("\033[36m%s\033[37m", s)
}

func Yellow(s string) string {
	return fmt.Sprintf("\033[33m%s\033[37m", s)
}

func Blue(s string) string {
	return fmt.Sprintf("\033[34m%s\033[37m", s)
}

func Green(s string) string {
	return fmt.Sprintf("\033[32m%s\033[37m", s)
}

func Magenta(s string) string {
	return fmt.Sprintf("\033[35m%s\033[37m", s)
}

func Bold(s string) string {
	return fmt.Sprintf("\033[7m%s\033[27m", s)
}

func ClearScreen() string {
	return "\033[3K\033[H\033[2J"
}

func CursorTo(x int, y int) string {
	return fmt.Sprintf("\033[%d;%dH", y, x)
}
