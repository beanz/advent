package aoc

import (
	"io/ioutil"
	"log"
	"strconv"
	"strings"
	"unicode"
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

// ReadIntsFromFile slurps input from a file into a list of integers
func ReadIntsFromFile(file string) []int {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatalf("File read %s failed: %s\n", file, err)
	}
	return SimpleReadInts(string(b))
}

func ReadChunks(file string) []string {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatalf("File read %s failed: %s\n", file, err)
	}
	chunks := strings.Split(string(b), "\n\n")

	// strip trailing single '\n' from final chunk
	l := len(chunks) - 1
	if chunks[l][len(chunks[l])-1] == '\n' {
		chunks[l] = chunks[l][:len(chunks[l])-1]
	}
	return chunks
}

func ReadInts(lines []string) ([]int, error) {
	nums := make([]int, 0, len(lines))

	for _, line := range lines {
		n, err := strconv.Atoi(line)
		if err != nil {
			return nil, err
		}
		nums = append(nums, n)
	}
	return nums, nil
}

func XSloppyReadInts(lines []string) []int {
	nums := make([]int, 0, len(lines))
	for _, line := range lines {
		n, err := strconv.Atoi(line)
		if err == nil {
			nums = append(nums, n)
		} else if line[len(line)-1] == ',' || line[len(line)-1] == ':' {
			n, err := strconv.Atoi(line[:len(line)-1])
			if err == nil {
				nums = append(nums, n)
			}
		}
	}
	return nums
}

func SimpleReadInts(l string) []int {
	n := ""
	for i := 0; i < len(l); i++ {
		if l[i] == '-' &&
			(i == len(l)-1 || !unicode.IsNumber(rune(l[i+1]))) {
			n += " "
		} else {
			n += string(l[i])
		}
	}
	f := func(c rune) bool {
		return !(unicode.IsNumber(c) || c == '-')
	}
	values, err := ReadInts(strings.FieldsFunc(n, f))
	if err != nil {
		log.Fatalf("SimpleReadInts error: %s\n", err)
	}
	return values
}
