package main

import (
	"fmt"
	"io/ioutil"
	"path/filepath"
	"math"
	"regexp"
	"os"
	"sort"
	"strconv"
	"strings"
	"time"
)

func main() {
	benchmarks, err := loadBenchmarks(os.Args[1])
	if err != nil {
		panic(err)
	}
	table := makeTable(benchmarks)
	ioutil.WriteFile("benchmarks.md", []byte(table), 0644)
}

func makeTable(benchmarks benchmarkData) string {
	sb := strings.Builder{}

	languages := []string{}
	for lang := range benchmarks {
			languages = append(languages, lang)
		}
	sort.Strings(languages)
	for _, lang := range languages {
		sb.WriteByte('\n')
		sb.WriteString("## ")
		sb.WriteString(lang)
		sb.WriteByte('\n')

		years := []string{}
		for year := range benchmarks[lang] {
			years = append(years, year)
		}
		sort.Strings(years)
		sb.WriteString(" &nbsp; ")
		yearRuntimes := make([]time.Duration, len(years))
		for i, year := range years {
			sb.WriteString(" | ")
			sb.WriteString(year)
			totalRuntime := time.Duration(0)
			for _, runtime := range benchmarks[lang][year] {
				totalRuntime += runtime
			}
			yearRuntimes[i] = totalRuntime
		}
		sb.WriteString("\n ---: ")
		for range years {
			sb.WriteString(" | ---: ")
		}
		sb.WriteByte('\n')
		for _, day := range []string{
			"01", "02", "03", "04", "05", "06",
			"07", "08", "09", "10", "11", "12",
			"13", "14", "15", "16", "17", "18",
			"19", "20", "21", "22", "23", "24",
			"25"} {
			sb.WriteString("Day ")
			sb.WriteString(day)
			for i, year := range years {
				sb.WriteString(" | ")
				runtime, ok := benchmarks[lang][year][day]
				propTotal := float64(runtime) / float64(yearRuntimes[i])
				if ok {
					strength := ""
					prefix := ""
					if propTotal > 0.2 {
						strength = "**"
						prefix = "🔴 "
					}
					sb.WriteString(strength)
					sb.WriteString(prefix)
					sb.WriteString(formatDuration(runtime))
					sb.WriteString(strength)
				} else {
					sb.WriteByte('-')
				}
			}
			sb.WriteByte('\n')
		}
		sb.WriteString("*Total*")
		for _, year := range years {
			totalRuntime := time.Duration(0)
			for _, runtime := range benchmarks[lang][year] {
				totalRuntime += runtime
			}
			sb.WriteString(" | *")
			sb.WriteString(formatDuration(totalRuntime))
			sb.WriteString("*")
		}
		sb.WriteByte('\n')
		sb.WriteByte('\n')
	}

	return sb.String()
}

func loadBenchmarks(dir string) (benchmarkData, error) {
	benchmarks := benchmarkData{}
	rustRe :=
		regexp.MustCompile(`/aoc-rust/target/release/aoc-(\d+)-(\d+).ns$`)
	otherRe :=
		regexp.MustCompile(`/(\d+)/(\d+)/aoc-(\w+).ns$`)
	language := map[string]string{
		"go": "Golang",
		"cr": "Crystal",
		"zig": "Zig",
		"cpp": "C++",
		"nim": "Nim",
	}
	err := filepath.Walk(dir, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}
		if path == dir {
			return nil
		}
		if path[len(path)-3:] != ".ns" {
			return nil
		}
		if m := rustRe.FindStringSubmatch(path); m != nil {
			err := benchmarks.readResult(path, "rust", m[1], m[2])
			if err != nil {
				fmt.Printf("Failed to read path, %s: %s\n", path, err)
			}
			return nil
		} else if m := otherRe.FindStringSubmatch(path); m != nil {
			if lang, ok := language[m[3]]; ok {
				err := benchmarks.readResult(path, lang, m[1], m[2])
				if err != nil {
					fmt.Printf("Failed to read path, %s: %s\n", path, err)
				}
				return nil
			}
		}
		fmt.Println("unexpected benchmark file: ", path)
		return nil
	})
	if err != nil {
		return nil, err
	}
	return benchmarks, nil
}

func (bm benchmarkData) readResult(file string, lang, year, day string) error {
	if _, ok := bm[lang]; !ok {
		bm[lang] = map[string]map[string]time.Duration{}
	}
	if _, ok := bm[lang][year]; !ok {
		bm[lang][year] = map[string]time.Duration{}
	}
	data, err := os.ReadFile(file)
	if err != nil {
		return err
	}
	result := strings.TrimSpace(string(data))
	multiplier := float64(1)
	switch {
	case len(result) > 3 && result[len(result)-2:] == "ns":
		// rust result
		s := strings.Split(result, ": ")
		result = s[1][:len(s[1])-3]
	case len(result) > 14 && result[:13] == "BenchmarkMain":
		// go result
		result = strings.Split(result[:len(result)-6], "\t")[2]
	default:
		return fmt.Errorf("unknown results format: %s", result)
	}
	benchmark, err := strconv.ParseFloat(strings.TrimSpace(string(result)), 64)
	if err != nil {
		return err
	}
	bm[lang][year][day] = time.Duration(int64(math.Round(benchmark*multiplier)))
	return nil
}

func formatDuration(dur time.Duration) string {
	for interval := time.Nanosecond; interval <= time.Second; interval *= 10 {
		if dur >= 100*interval {
			dur = dur.Round(interval)
		}
	}
	return dur.String()
}

type benchmarkData map[string]map[string]map[string]time.Duration
