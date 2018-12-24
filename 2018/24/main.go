package main

import (
	"fmt"
	"io/ioutil"
	"log"
	//"math"
	"os"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

type Units int

func (u Units) String() string {
	if u == 1 {
		return fmt.Sprintf("%d unit", u)
	} else {
		return fmt.Sprintf("%d units", u)
	}
}

type Group struct {
	num          int
	side         string
	units        Units
	initialUnits Units
	hp           int
	initialHP    int
	attackType   string
	attackDamage int
	initiative   int
	weak         map[string]bool
	immune       map[string]bool
	boost        int
}

func (g *Group) String() string {
	return g.Name()
}

func (g *Group) EffectivePower() int {
	return int(g.units) * (g.attackDamage + g.boost)
}

func (g *Group) WeakTo(attackType string) bool {
	if v, ok := g.weak[attackType]; ok && v {
		return true
	}
	return false
}

func (g *Group) ImmuneTo(attackType string) bool {
	if v, ok := g.immune[attackType]; ok && v {
		return true
	}
	return false
}

func (g *Group) Name() string {
	return fmt.Sprintf("%s group %d", g.side, g.num)
}

func (g *Group) Alive() bool {
	return g.units > 0
}

func (g *Group) Enemy() string {
	if g.side == "Immune System" {
		return "Infection"
	}
	return "Immune System"
}

type Game struct {
	groups []*Group
	sides  []string
	boost  int
	debug  bool
}

type InitiativeOrder []*Group

func (p InitiativeOrder) Len() int {
	return len(p)
}

func (p InitiativeOrder) Swap(i, j int) {
	p[i], p[j] = p[j], p[i]
}

func (p InitiativeOrder) Less(i, j int) bool {
	return p[i].initiative > p[j].initiative
}

type TargetSelectionOrder []*Group

func (tsg TargetSelectionOrder) Len() int {
	return len(tsg)
}

func (tsg TargetSelectionOrder) Swap(i, j int) {
	tsg[i], tsg[j] = tsg[j], tsg[i]
}

func (tsg TargetSelectionOrder) Less(i, j int) bool {
	iEP := tsg[i].EffectivePower()
	jEP := tsg[j].EffectivePower()
	return iEP > jEP || (iEP == jEP && tsg[i].initiative > tsg[j].initiative)
}

func (g *Game) TargetSelectionGroups() []*Group {
	groups := []*Group{}
	for _, grp := range g.groups {
		if grp.Alive() {
			groups = append(groups, grp)
		}
	}
	sort.Sort(TargetSelectionOrder(groups))
	return groups
}

func (g *Game) EnemyGroups(attacker *Group) []*Group {
	groups := []*Group{}
	for _, grp := range g.groups {
		if grp.Alive() && grp.side != attacker.side {
			groups = append(groups, grp)
		}
	}
	sort.Sort(TargetSelectionOrder(groups))
	return groups
}

func (g *Game) SideGroups(side string) []*Group {
	groups := []*Group{}
	for _, grp := range g.groups {
		if grp.side == side {
			groups = append(groups, grp)
		}
	}
	return groups
}

func (g *Game) Attackers(targets map[*Group]*Group) []*Group {
	groups := []*Group{}
	for grp := range targets {
		groups = append(groups, grp)
	}
	sort.Sort(InitiativeOrder(groups))
	return groups
}

func (g *Game) String() string {
	s := ""
	for _, side := range []string{"Immune System", "Infection"} {
		s += side + ":\n"
		for _, grp := range g.SideGroups(side) {
			s += fmt.Sprintf("Group %d contains %s\n", grp.num, grp.units)
		}
	}
	return s
}

func readInput(file string) (*Game, error) {
	b, err := ioutil.ReadFile(file)
	if err != nil {
		return nil, err
	}
	return readGame(string(b)), nil
}

func parseGroup(line string, side string, num int) *Group {
	lineRe :=
		regexp.MustCompile(`(\d+) units each with (\d+) hit points (.*)with an attack that does (\d+) (\w+) damage at initiative (\d+)`)
	specialRe := regexp.MustCompile(`(weak|immune) to ([^;]+)`)
	m := lineRe.FindStringSubmatch(line)
	if m == nil {
		log.Fatalf("invalid line:\n%s\n", line)
	}
	units, err := strconv.Atoi(m[1])
	if err != nil {
		log.Fatalf("invalid units in line:\n%s\n", line)
	}
	hp, err := strconv.Atoi(m[2])
	if err != nil {
		log.Fatalf("invalid hp in line:\n%s\n", line)
	}
	damage, err := strconv.Atoi(m[4])
	if err != nil {
		log.Fatalf("invalid damage in line:\n%s\n", line)
	}
	damageType := m[5]
	initiative, err := strconv.Atoi(m[6])
	if err != nil {
		log.Fatalf("invalid initiative in line:\n%s\n", line)
	}
	weak := make(map[string]bool)
	immune := make(map[string]bool)
	if m[3] != "" {
		for _, special := range strings.Split(m[3][1:len(m[3])-2], "; ") {
			sm := specialRe.FindStringSubmatch(special)
			sType := sm[1]
			for _, attack := range strings.Split(sm[2], ", ") {
				if sType == "weak" {
					weak[attack] = true
				} else {
					immune[attack] = true
				}
			}
		}
	}
	return &Group{
		num, side, Units(units), Units(units), hp, hp,
		damageType, damage,
		initiative, weak, immune, 0,
	}
}

func readGame(input string) *Game {
	input = strings.Replace(input, "\n ", " ", -1)
	groupInputs := strings.Split(input[:len(input)-1], "\n\n")
	groups := []*Group{}
	sides := []string{}
	for _, g := range groupInputs {
		num := 1
		lines := strings.Split(g, "\n")
		side := lines[0]
		if side[len(side)-1] != ':' {
			log.Fatalf("invalid side name line:\n  %s\n", lines[0])
		}
		side = side[:len(side)-1]
		sides = append(sides, side)
		for _, line := range lines[1:] {
			groups = append(groups, parseGroup(line, side, num))
			num++
		}
	}
	//fmt.Printf("Parsed %d groups\n", len(groups))
	return &Game{groups, sides, 0, false}
}

func AttackDamage(attacker *Group, target *Group) int {
	multiplier := 1
	if target.WeakTo(attacker.attackType) {
		multiplier = 2
	} else if target.ImmuneTo(attacker.attackType) {
		multiplier = 0
	}
	return attacker.EffectivePower() * multiplier
}

func Selected(done map[*Group]bool, grp *Group) bool {
	if _, ok := done[grp]; ok {
		return true
	}
	return false
}

func SetSelected(done map[*Group]bool, grp *Group) {
	done[grp] = true
}

func (g *Game) TargetSelection() map[*Group]*Group {
	selected := make(map[*Group]bool)
	targets := make(map[*Group]*Group)
	for _, attacker := range g.TargetSelectionGroups() {
		var bestTarget *Group
		var bestDamage int
		for _, target := range g.EnemyGroups(attacker) {
			if Selected(selected, target) {
				continue
			}
			damage := AttackDamage(attacker, target)
			if g.debug {
				fmt.Printf("%s would deal defending group %d %d damage\n",
					attacker, target.num, damage)
			}
			if damage > bestDamage {
				bestDamage = damage
				bestTarget = target
			}
		}
		if bestTarget != nil {
			targets[attacker] = bestTarget
			SetSelected(selected, bestTarget)
		}
	}
	return targets
}

func (g *Game) UnitCounts() map[string]int {
	counts := make(map[string]int, 2)
	counts["Immune System"] = 0
	counts["Infection"] = 0
	counts["Total"] = 0
	for _, grp := range g.groups {
		counts[grp.side] += int(grp.units)
		counts["Total"] += int(grp.units)
	}
	return counts
}

func (g *Game) Attacks(targets map[*Group]*Group) bool {
	damageDone := false
	for _, attacker := range g.Attackers(targets) {
		if !attacker.Alive() {
			continue
		}
		target := targets[attacker]
		if !target.Alive() {
			continue
		}
		units := int(AttackDamage(attacker, target) / target.hp)
		if units > int(target.units) {
			units = int(target.units)
		}
		if Units(units) > 0 {
			damageDone = true
		}
		target.units -= Units(units)
	}
	return damageDone
}

func (g *Game) Play() map[string]int {
	counts := g.UnitCounts()
	progressing := true
	for counts["Infection"] != 0 && counts["Immune System"] != 0 && progressing {
		if g.debug {
			fmt.Println(g)
		}
		targets := g.TargetSelection()
		progressing = g.Attacks(targets)
		counts = g.UnitCounts()
	}
	if g.debug {
		fmt.Println()
	}
	return counts
}

func (g *Game) Part1() int {
	counts := g.Play()
	return counts["Total"]
}

func (g *Game) Reset() {
	for _, grp := range g.groups {
		grp.hp = grp.initialHP
		grp.units = grp.initialUnits
	}
}

func (g *Game) SetBoost(boost int) {
	for _, grp := range g.SideGroups("Immune System") {
		grp.boost = boost
	}
}

func (g *Game) Part2() int {
	upper := 16000
	lower := 0
	var counts map[string]int
	for {
		g.Reset()
		g.SetBoost(upper)
		counts = g.Play()
		if counts["Immune System"] != 0 {
			break
		}
		upper *= 2
	}

	for (upper - lower) > 10 {
		cur := (upper + lower) / 2
		g.Reset()
		g.SetBoost(cur)
		counts = g.Play()
		if counts["Immune System"] != 0 && counts["Infection"] != 0 {
			// no winner
			upper += 3
		} else if counts["Immune System"] == 0 {
			lower = cur
		} else {
			upper = cur
		}
	}
	for boost := lower; boost <= upper; boost++ {
		g.Reset()
		g.SetBoost(boost)
		counts = g.Play()
		if counts["Immune System"] != 0 && counts["Infection"] == 0 {
			break
		}
	}
	return counts["Immune System"]
}

func main() {
	if len(os.Args) < 2 {
		log.Fatalf("Usage: %s <input.txt>\n", os.Args[0])
	}
	input := os.Args[1]
	game, err := readInput(input)
	if err != nil {
		log.Fatalf("error reading input: %s\n", err)
	}

	res := game.Part1()
	fmt.Printf("Part 1: %d\n", res)

	res = game.Part2()
	fmt.Printf("Part 2: %d\n", res)
}
