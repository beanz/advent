package main

import (
	_ "embed"
	"fmt"
	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

type IP struct {
	ip []byte
}

func NewIP(ip []byte) *IP {
	return &IP{ip}
}

func (ip *IP) String() string {
	return string(ip.ip)
}

func (ip *IP) IsTLS() bool {
	found := false
	outside := true
	for i := 0; i < len(ip.ip)-3; i++ {
		if ip.ip[i] == '[' || ip.ip[i] == ']' {
			outside = !outside
			continue
		}
		if ip.ip[i] != ip.ip[i+1] && ip.ip[i] == ip.ip[i+3] && ip.ip[i+1] == ip.ip[i+2] {
			if outside {
				found = true
			} else {
				return false
			}
		}
	}
	return found
}

func (ip *IP) IsSSL() bool {
	for i := 0; i < len(ip.ip)-2; i++ {
		if ip.ip[i] == '[' {
			for i++; i < len(ip.ip) && ip.ip[i] != ']'; i++ {
			}
			i--
			continue
		}
		if ip.ip[i] != ip.ip[i+1] && ip.ip[i] == ip.ip[i+2] {
			j := 0
			for ; j < len(ip.ip) && ip.ip[j] != '['; j++ {
			}
			for j++; j < len(ip.ip)-2; j++ {
				if ip.ip[j] == ']' {
					for j++; j < len(ip.ip) && ip.ip[j] != '['; j++ {
					}
					j--
					continue
				}
				if ip.ip[j] == ip.ip[i+1] && ip.ip[j+1] == ip.ip[i] && ip.ip[j+2] == ip.ip[i+1] {
					return true
				}
			}
		}
	}
	return false
}

type Net struct {
	ips []*IP
}

func NewNet(in []byte) *Net {
	n := &Net{make([]*IP, 0, 2048)}
	j := 0
	for i := 0; i < len(in); i++ {
		if in[i] == '\n' {
			n.ips = append(n.ips, NewIP(in[j:i]))
			j = i + 1
		}
	}
	return n
}

func (n *Net) Parts() (int, int) {
	p1, p2 := 0, 0
	for _, ip := range n.ips {
		if ip.IsTLS() {
			p1++
		}
		if ip.IsSSL() {
			p2++
		}
	}
	return p1, p2
}

func main() {
	g := NewNet(InputBytes(input))
	p1, p2 := g.Parts()
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
