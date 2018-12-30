package aoc

import (
	"io/ioutil"
	"log"
	"strings"
)

// ReadLines slurps input from a file into a list of lines (strings)
func ReadLines(file string) []string {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatalf("File read %s failed: %s\n", file, err)
	}
	lines := strings.Split(string(b), "\n")
	return lines[:len(lines)-1]
}
