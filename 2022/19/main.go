package main

import (
	_ "embed"
	"fmt"
	"sort"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type Blueprint struct {
	ore_ore, clay_ore, obs_ore, obs_clay, geode_ore, geode_obs int
}

func Read(in []byte) []Blueprint {
	res := make([]Blueprint, 0, 30)
	for i := 0; i < len(in); i++ {
		bp := Blueprint{}
		j, _ := ChompUInt[int](in, i+10)
		j, bp.ore_ore = ChompUInt[int](in, j+23)
		j, bp.clay_ore = ChompUInt[int](in, j+28)
		j, bp.obs_ore = ChompUInt[int](in, j+32)
		j, bp.obs_clay = ChompUInt[int](in, j+9)
		j, bp.geode_ore = ChompUInt[int](in, j+30)
		j, bp.geode_obs = ChompUInt[int](in, j+9)
		res = append(res, bp)
		i = j + 10
	}
	return res
}

const (
	ORE = iota
	CLAY
	OBSIDIAN
	GEODE
)

type Search struct {
	t      int
	score  int
	inv    [4]int
	robots [4]int
}

func Solve(bp Blueprint, maxTime int) int {
	todo := []Search{{maxTime, 0, [4]int{0, 0, 0, 0}, [4]int{1, 0, 0, 0}}}
	max := 0
	pruneLen := 20000
	if maxTime == 24 {
		pruneLen = 2000
	}
	pruneTime := maxTime - 1
	for len(todo) != 0 {
		if todo[0].t == pruneTime {
			pruneTime--
			if len(todo) > pruneLen {
				sort.Slice(todo, func(i, j int) bool {
					return todo[i].score > todo[j].score
				})
				todo = todo[:pruneLen]
			}
		}
		cur := todo[0]
		todo = todo[1:]
		// fmt.Printf("%d rbt=%v inv=%v\n", cur.t, cur.robots, cur.inv)
		if cur.inv[GEODE] > max {
			//fmt.Printf("Found new max %d > %d\n", cur.inv[GEODE], max)
			max = cur.inv[GEODE]
		}
		if cur.t == 0 {
			continue
		}
		no, nc, nob, ng := cur.inv[ORE]+cur.robots[ORE], cur.inv[CLAY]+cur.robots[CLAY], cur.inv[OBSIDIAN]+cur.robots[OBSIDIAN], cur.inv[GEODE]+cur.robots[GEODE]
		nscore := ((((ng*100+cur.robots[GEODE])*100+nob)*100+cur.robots[OBSIDIAN])*100+nc)*100 + no
		todo = append(todo, Search{
			t:     cur.t - 1,
			score: nscore,
			inv:   [4]int{no, nc, nob, ng},
			robots: [4]int{
				cur.robots[ORE],
				cur.robots[CLAY],
				cur.robots[OBSIDIAN],
				cur.robots[GEODE],
			},
		})
		if cur.inv[ORE] >= bp.geode_ore && cur.inv[OBSIDIAN] >= bp.geode_obs {
			todo = append(todo, Search{
				t:     cur.t - 1,
				score: nscore,
				inv:   [4]int{no - bp.geode_ore, nc, nob - bp.geode_obs, ng},
				robots: [4]int{
					cur.robots[ORE],
					cur.robots[CLAY],
					cur.robots[OBSIDIAN],
					cur.robots[GEODE] + 1,
				},
			})
		}
		if cur.inv[ORE] >= bp.obs_ore && cur.inv[CLAY] >= bp.obs_clay {
			todo = append(todo, Search{
				t:     cur.t - 1,
				score: nscore,
				inv:   [4]int{no - bp.obs_ore, nc - bp.obs_clay, nob, ng},
				robots: [4]int{
					cur.robots[ORE],
					cur.robots[CLAY],
					cur.robots[OBSIDIAN] + 1,
					cur.robots[GEODE],
				},
			})
		}
		if cur.inv[ORE] >= bp.clay_ore {
			todo = append(todo, Search{
				t:     cur.t - 1,
				score: nscore,
				inv:   [4]int{no - bp.clay_ore, nc, nob, ng},
				robots: [4]int{
					cur.robots[ORE],
					cur.robots[CLAY] + 1,
					cur.robots[OBSIDIAN],
					cur.robots[GEODE],
				},
			})
		}
		if cur.inv[ORE] >= bp.ore_ore {
			todo = append(todo, Search{
				t:     cur.t - 1,
				score: nscore,
				inv:   [4]int{no - bp.ore_ore, nc, nob, ng},
				robots: [4]int{
					cur.robots[ORE] + 1,
					cur.robots[CLAY],
					cur.robots[OBSIDIAN],
					cur.robots[GEODE],
				},
			})
		}
	}
	return max
}

func Parts(in []byte) (int, int) {
	bp := Read(in)
	p1 := 0
	for i, bp := range bp {
		p1 += (i + 1) * Solve(bp, 24)
	}
	p2 := 1
	p2 *= Solve(bp[0], 32)
	p2 *= Solve(bp[1], 32)
	if len(bp) > 2 {
		p2 *= Solve(bp[2], 32)
	}
	return p1, p2
}

func main() {
	p1, p2 := Parts(InputBytes(input))
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
