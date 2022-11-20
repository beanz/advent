package main

import (
	"fmt"
	"io/ioutil"
	"math"
	"os"
	"path/filepath"
	"regexp"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/erkkah/margaid"
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

	for _, year := range []string{"2015", "2016", "2017", "2018", "2019", "2020", "2021"} {
		sb.WriteByte('\n')
		sb.WriteString("## ")
		sb.WriteString(year)
		sb.WriteByte('\n')

		langs := make([]string, 0, len(languages))
		for _, lang := range languages {
			if _, ok := benchmarks[lang][year]; !ok {
				continue
			}
			langs = append(langs, lang)
		}

		series := make([]*margaid.Series, len(langs))

		sb.WriteString(" &nbsp; ")
		langRuntimes := make([]time.Duration, len(langs))
		for i, lang := range langs {
			sb.WriteString(" | ")
			sb.WriteString(lang)
			totalRuntime := time.Duration(0)
			for _, runtime := range benchmarks[lang][year] {
				totalRuntime += runtime
			}
			langRuntimes[i] = totalRuntime
			series[i] = margaid.NewSeries(margaid.Titled(lang))
		}
		sb.WriteString("\n ---: ")
		for range langs {
			sb.WriteString(" | ---: ")
		}
		sb.WriteByte('\n')
		for di, day := range []string{
			"01", "02", "03", "04", "05", "06",
			"07", "08", "09", "10", "11", "12",
			"13", "14", "15", "16", "17", "18",
			"19", "20", "21", "22", "23", "24",
			"25"} {
			sb.WriteString("Day ")
			sb.WriteString(day)
			for i, lang := range langs {
				sb.WriteString(" | ")
				runtime, ok := benchmarks[lang][year][day]
				series[i].Add(margaid.MakeValue(float64(di+1), float64(runtime)))
				propTotal := float64(runtime) / float64(langRuntimes[i])
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
		minY, maxY := float64(99999), float64(0.0)
		sb.WriteString("*Total*")
		for _, lang := range langs {
			totalRuntime := time.Duration(0)
			for _, runtime := range benchmarks[lang][year] {
				totalRuntime += runtime
				if float64(runtime) > maxY {
					maxY = float64(runtime)
				}
				if float64(runtime) < minY {
					minY = float64(runtime)
				}
			}
			sb.WriteString(" | *")
			sb.WriteString(formatDuration(totalRuntime))
			sb.WriteString("*")
		}
		sb.WriteByte('\n')
		sb.WriteByte('\n')

		maxY = math.Min(maxY, 2000000000)
		dayLabel := func(value float64) string {
			return strconv.FormatFloat(value, 'f', 0, 64)
		}

		gmin, gmax, ginc, gfrac := looseLabel(minY, maxY, 8)
		labelSeries := margaid.NewSeries(margaid.Titled("Labels"))
		for tick := gmin; tick <= gmax; tick += ginc {
			labelSeries.Add(margaid.MakeValue(float64(1.0), float64(tick)))
		}
		var labeler func(float64) string
		if gfrac > 0 {
			labeler = func(value float64) string {
				return strconv.FormatFloat(value, 'f', gfrac, 64)
			}
		} else {
			labeler = func(value float64) string {
				return formatDuration(time.Duration(int64(value)))
			}
		}

		diagram := margaid.New(800, 600,
			margaid.WithRange(margaid.XAxis, 1.0, 25),
			margaid.WithRange(margaid.YAxis, 0.0, maxY),
			margaid.WithPadding(10),
			margaid.WithInset(80),
		)
		diagram.Bar(series)
		diagram.Legend(margaid.RightBottom)
		diagram.Frame()
		diagram.Axis(series[0], margaid.XAxis, diagram.LabeledTicker(dayLabel), false, "Day")
		diagram.Axis(labelSeries, margaid.YAxis, diagram.LabeledTicker(labeler), false, "Runtime")
		svg, err := os.Create("y" + year + ".svg")
		if err != nil {
			panic(err)
		}
		diagram.Render(svg)
		sb.WriteString("![Graph for year ")
		sb.WriteString(year)
		sb.WriteString("](y")
		sb.WriteString(year)
		sb.WriteString(".svg)\n")
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
		"go":  "Golang",
		"cr":  "Crystal",
		"hs":  "Haskell",
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
			err := benchmarks.readResult(path, "Rust", m[1], m[2])
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
		// rust or haskell result
		s := strings.Split(result, ": ")
		i := 0
		if len(s) > 1 {
			i = 1
		}
		result = s[i][:len(s[i])-2]
	case len(result) > 4 && result[len(result)-3:] == "μs":
		result = result[:len(result)-3]
		multiplier = 1000
	case len(result) > 3 && result[len(result)-2:] == "ms":
		result = result[:len(result)-2]
		multiplier = 1000000
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
	bm[lang][year][day] = time.Duration(int64(math.Round(benchmark * multiplier)))
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

func looseLabel(min, max float64, ticks int) (float64, float64, float64, int) {
	grange := niceNum(max-min, 0)
	d := niceNum(grange/float64(ticks-1), 1)
	nfrac := int(math.Max(-math.Floor(math.Log10(d)), 0))
	return math.Floor(min/d) * d, math.Ceil((max / d) * d), d, nfrac
}

func niceNum(x float64, round int) float64 {
	expv := math.Floor(math.Log10(x))
	f := x / math.Pow(10.0, expv)
	var nf float64
	if round > 0 {
		switch {
		case f < 1.5:
			nf = 1.0
		case f < 3.0:
			nf = 2.0
		case f < 7.0:
			nf = 5.0
		default:
			nf = 10.0
		}
	} else {
		switch {
		case f < 1.0:
			nf = 1.0
		case f < 2.0:
			nf = 2.0
		case f < 5.0:
			nf = 5.0
		default:
			nf = 10.0
		}
	}
	return nf * math.Pow(10.0, expv)
}

type benchmarkData map[string]map[string]map[string]time.Duration
