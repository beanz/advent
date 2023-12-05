package main

import (
	_ "embed"
	"fmt"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func Parts(in []byte) (int, int) {
	seeds := []int{}
	i := 0
	VisitUints[int](in, '\n', &i, func(n int) {
		seeds = append(seeds, n)
	})
	i += 2
	for in[i] != '\n' {
		i++
	}
	seedToSoil := [][3]int{}
	for i++; i <= len(in); i++ {
		s := [3]int{}
		j := 0
		VisitUints[int](in, '\n', &i, func(n int) {
			s[j] = n
			j++
		})
		seedToSoil = append(seedToSoil, s)
		if i+1 >= len(in) || in[i+1] == '\n' {
			break
		}
	}

	for i += 2; in[i] != '\n'; {
		i++
	}
	soilToFert := [][3]int{}
	for i++; i <= len(in); i++ {
		s := [3]int{}
		j := 0
		VisitUints[int](in, '\n', &i, func(n int) {
			s[j] = n
			j++
		})
		soilToFert = append(soilToFert, s)
		if i+1 >= len(in) || in[i+1] == '\n' {
			break
		}
	}

	for i += 2; in[i] != '\n'; {
		i++
	}
	fertToWater := [][3]int{}
	for i++; i <= len(in); i++ {
		s := [3]int{}
		j := 0
		VisitUints[int](in, '\n', &i, func(n int) {
			s[j] = n
			j++
		})
		fertToWater = append(fertToWater, s)
		if i+1 >= len(in) || in[i+1] == '\n' {
			break
		}
	}

	for i += 2; in[i] != '\n'; {
		i++
	}
	waterToLight := [][3]int{}
	for i++; i <= len(in); i++ {
		s := [3]int{}
		j := 0
		VisitUints[int](in, '\n', &i, func(n int) {
			s[j] = n
			j++
		})
		waterToLight = append(waterToLight, s)
		if i+1 >= len(in) || in[i+1] == '\n' {
			break
		}
	}

	for i += 2; in[i] != '\n'; {
		i++
	}
	lightToTemp := [][3]int{}
	for i++; i <= len(in); i++ {
		s := [3]int{}
		j := 0
		VisitUints[int](in, '\n', &i, func(n int) {
			s[j] = n
			j++
		})
		lightToTemp = append(lightToTemp, s)
		if i+1 >= len(in) || in[i+1] == '\n' {
			break
		}
	}

	for i += 2; in[i] != '\n'; {
		i++
	}
	tempToHumidity := [][3]int{}
	for i++; i <= len(in); i++ {
		s := [3]int{}
		j := 0
		VisitUints[int](in, '\n', &i, func(n int) {
			s[j] = n
			j++
		})
		tempToHumidity = append(tempToHumidity, s)
		if i+1 >= len(in) || in[i+1] == '\n' {
			break
		}
	}

	for i += 2; in[i] != '\n'; {
		i++
	}
	humidityToLocation := [][3]int{}
	for i++; i <= len(in); i++ {
		s := [3]int{}
		j := 0
		VisitUints[int](in, '\n', &i, func(n int) {
			s[j] = n
			j++
		})
		humidityToLocation = append(humidityToLocation, s)
		if i+1 >= len(in) || in[i+1] == '\n' {
			break
		}
	}

	p1 := 99999999999
	for _, s := range seeds {
		for _, m := range [][][3]int{seedToSoil, soilToFert, fertToWater, waterToLight, lightToTemp, tempToHumidity, humidityToLocation} {
			for _, r := range m {
				if r[1] <= s && s < r[1]+r[2] {
					s = r[0] + (s - r[1])
					break
				}
			}
		}
		if s < p1 {
			p1 = s
		}
	}
	p2 := 0
	for ; ; p2++ {
		s := p2
		for _, m := range [][][3]int{humidityToLocation, tempToHumidity, lightToTemp, waterToLight, fertToWater, soilToFert, seedToSoil} {
			for _, r := range m {
				if r[0] <= s && s < r[0]+r[2] {
					s = r[1] + (s - r[0])
					break
				}
			}
		}
		for k := 0; k < len(seeds); k += 2 {
			if seeds[k] <= s && s < seeds[k]+seeds[k+1] {
				return p1, p2
			}
		}
	}
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
