package aoc

import "fmt"

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
