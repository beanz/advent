package aoc

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"strconv"
	"strings"
	"unicode"
)

func InputBytes(embedded []byte) []byte {
	if len(os.Args) < 2 || os.Args[1][0] == '-' {
		return embedded
	}
	return ReadFileBytes(os.Args[1])
}

func InputString(embedded []byte) string {
	return string(InputBytes(embedded))
}

func InputInts(embedded []byte) []int {
	return Ints(InputString(embedded))
}

func InputLines(embedded []byte) []string {
	return strings.Split(strings.TrimSuffix(InputString(embedded), "\n"), "\n")
}

func InputChunks(embedded []byte) []string {
	return strings.Split(strings.TrimSuffix(InputString(embedded), "\n\n"), "\n\n")
}

func InputFile() string {
	if len(os.Args) < 2 {
		return "input.txt"
	}
	return os.Args[1]
}

func ReadFileBytes(file string) []byte {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		panic(fmt.Sprintf("Failed to read %s: %s\n", file, err))
	}
	return b
}

func ReadInputBytes() []byte {
	return ReadFileBytes(InputFile())
}

func ReadFileLines(file string) []string {
	return strings.Split(strings.TrimSuffix(string(ReadFileBytes(file)), "\n"), "\n")
}

func ReadInputLines() []string {
	return ReadFileLines(InputFile())
}

func ReadFileChunks(file string) []string {
	return strings.Split(strings.TrimSuffix(string(ReadFileBytes(file)),
		"\n\n"), "\n\n")
}

func ReadInputChunks() []string {
	return ReadChunks(InputFile())
}

// ReadLines slurps input from a file into a list of lines (strings)
func ReadLines(file string) []string {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatalf("File read %s failed: %s\n", file, err)
	}
	lines := strings.Split(string(b), "\n")
	return lines[:len(lines)-1]
}

func ReadFileInts(file string) []int {
	return Ints(string(ReadFileBytes(file)))
}

func ReadInputInts() []int {
	return ReadFileInts(InputFile())
}

// ReadIntsFromFile slurps input from a file into a list of integers
func ReadIntsFromFile(file string) []int {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatalf("File read %s failed: %s\n", file, err)
	}
	return SimpleReadInts(string(b))
}

func ReadFileIntLines(file string) [][]int {
	inp := ReadFileLines(file)
	lints := make([][]int, len(inp))
	for i, l := range inp {
		lints[i] = SimpleReadInts(l)
	}
	return lints
}

func ReadInputIntLines() [][]int {
	return ReadFileIntLines(InputFile())
}

func ReadChunks(file string) []string {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		log.Fatalf("File read %s failed: %s\n", file, err)
	}
	chunks := strings.Split(strings.TrimSuffix(string(b), "\n\n"), "\n\n")

	// strip trailing single '\n' from final chunk
	if len(chunks) > 0 {
		chunks[len(chunks)-1] = strings.TrimSuffix(chunks[len(chunks)-1], "\n")
	}
	return chunks
}

func ReadInt64s(lines []string) ([]int64, error) {
	nums := make([]int64, 0, len(lines))

	for _, line := range lines {
		n, err := strconv.ParseInt(line, 10, 64)
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
	values := ReadInts(strings.FieldsFunc(n, f))
	return values
}

func SimpleReadInt64s(l string) []int64 {
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
	values, err := ReadInt64s(strings.FieldsFunc(n, f))
	if err != nil {
		log.Fatalf("SimpleReadInts error: %s\n", err)
	}
	return values
}
