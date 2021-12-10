package main

import (
	"embed"
	"fmt"
	"io/ioutil"
	"math"
	"sort"
	"strconv"
	"strings"
	"time"
)

//go:embed results
var resultsFS embed.FS

func main() {
	benchmarks, err := loadBenchmarks()
	if err != nil {
		panic(err)
	}
	table := makeTable(benchmarks)
	ioutil.WriteFile("benchmarks.md", []byte(table), 0644)
}

func makeTable(benchmarks benchmarkData) string {
	sb := strings.Builder{}

	years := []int{}
	for year := range benchmarks {
		years = append(years, year)
	}
	sort.Ints(years)
	sb.WriteString(" &nbsp; ")
	yearRuntimes := make([]time.Duration, len(years))
	for i, year := range years {
		sb.WriteString(" | ")
		sb.WriteString(strconv.Itoa(year))
		totalRuntime := time.Duration(0)
		for _, runtime := range benchmarks[year] {
			totalRuntime += runtime
		}
		yearRuntimes[i] = totalRuntime
	}
	sb.WriteString("\n ---: ")
	for range years {
		sb.WriteString(" | ---: ")
	}
	sb.WriteByte('\n')
	for day := 1; day <= 25; day++ {
		sb.WriteString("Day ")
		sb.WriteString(strconv.Itoa(day))
		for i, year := range years {
			sb.WriteString(" | ")
			runtime := benchmarks[year][day]
			propTotal := float64(runtime) / float64(yearRuntimes[i])
			if runtime > 0 {
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
		for _, runtime := range benchmarks[year] {
			totalRuntime += runtime
		}
		sb.WriteString(" | *")
		sb.WriteString(formatDuration(totalRuntime))
		sb.WriteString("*")

	}

	return sb.String()
}

func loadBenchmarks() (benchmarkData, error) {
	benchmarks := benchmarkData{}
	yearDirs, err := resultsFS.ReadDir("results")
	if err != nil {
		panic(err)
	}

	for _, yearDir := range yearDirs {
		year, _ := strconv.Atoi(yearDir.Name())
		benchmarks[year] = map[int]time.Duration{}
		dayResults, err := resultsFS.ReadDir("results/" + yearDir.Name())
		if err != nil {
			return nil, err
		}
		for _, dayResult := range dayResults {
			day, err := strconv.Atoi(strings.TrimPrefix(strings.TrimSuffix(dayResult.Name(), "-ns"), "day"))
			if err != nil {
				return nil, err
			}
			path := fmt.Sprintf("results/%s/%s", yearDir.Name(), dayResult.Name())
			result, err := resultsFS.ReadFile(path)
			if err != nil {
				return nil, err
			}
			benchmark, err := strconv.ParseFloat(strings.TrimSpace(string(result)), 64)
			if err == nil {
				benchmarks[year][day] = time.Duration(int64(math.Round(benchmark)))
			}
		}
	}
	return benchmarks, nil
}

func formatDuration(dur time.Duration) string {
	for interval := time.Nanosecond; interval <= time.Second; interval *= 10 {
		if dur >= 100*interval {
			dur = dur.Round(interval)
		}
	}
	return dur.String()
}

type benchmarkData map[int]map[int]time.Duration
