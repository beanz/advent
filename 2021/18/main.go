package main

import (
	_ "embed"
	"fmt"
	"strconv"

	. "github.com/beanz/advent/lib-go"
)

//go:embed input.txt
var input []byte

func NumBytes(n int) []byte {
	// TODO speedup?
	return []byte(strconv.Itoa(n))
}

func Explode(sf []byte) ([]byte, bool) {
	bc := 0
	for i := 0; i < len(sf); i++ {
		if sf[i] == '[' {
			bc++
			if bc == 5 {
				lb := i
				for ; sf[i] != ']'; i++ {
					if sf[i] == '[' {
						lb = i
					}
				}
				rb := i + 1
				pre := sf[:lb]
				post := sf[rb:]
				a, j := ScanUint(sf[lb+1:], 0)
				//fmt.Printf("%s\n", sf[lb+j+2:])
				b, _ := ScanUint(sf[lb+2+j:], 0)
				//fmt.Printf("%s / %d , %d / %s\n", pre, a, b, post)
				n := 0
				m := 1
				je := 0
				for j = lb - 1; j >= 0; j-- {
					if '0' <= sf[j] && sf[j] <= '9' {
						je = j
						for ; j > 0 && '0' <= sf[j] && sf[j] <= '9'; j-- {
							n += m * int(sf[j]-'0')
							m *= 10
						}
						break
					}
				}
				if j >= 0 {
					//fmt.Printf("would replace %d at %d-%d with %d\n",
					//	n, j, je, n+a)
					post := make([]byte, 0, len(pre[je+1:lb]))
					post = append(post, pre[je+1:lb]...)
					sf = append(pre[:j+1], NumBytes(n+a)...)
					sf = append(sf, post...)
				} else {
					sf = pre
				}
				sf = append(sf, '0')
				//fmt.Printf("new pre %s\n", sf)
				for j = 0; j < len(post); j++ {
					if '0' <= post[j] && post[j] <= '9' {
						n, je = ScanUint(post, j)
						break
					}
				}
				if j < len(post) {
					//fmt.Printf("would replace %d at %d-%d with %d\n",
					//	n, j, je, n+b)
					sf = append(sf, post[:j]...)
					sf = append(sf, NumBytes(b+n)...)
					sf = append(sf, post[je:]...)
				} else {
					sf = append(sf, post...)
				}
				return sf, true
			}
		} else if sf[i] == ']' {
			bc--
		}
	}
	return sf, false
}

func Split(sf []byte) ([]byte, bool) {
	for i := 1; i < len(sf); i++ {
		if '0' <= sf[i-1] && sf[i-1] <= '9' && '0' <= sf[i] && sf[i] <= '9' {
			n, j := ScanUint(sf, i-1)
			post := make([]byte, 0, len(sf[j:]))
			post = append(post, sf[j:]...)
			sf = append(sf[:i-1], '[')
			sf = append(sf, NumBytes(n/2)...)
			sf = append(sf, ',')
			sf = append(sf, NumBytes((1+n)/2)...)
			sf = append(sf, ']')
			sf = append(sf, post...)
			return sf, true
		}
	}
	return sf, false
}

func Reduce(sf []byte) []byte {
	//fmt.Printf("before: %s\n", string(sf))
	var changed bool
	for {
		if sf, changed = Explode(sf); changed {
			//fmt.Printf("after explode: %s\n", string(sf))
			continue
		}
		if sf, changed = Split(sf); changed {
			//fmt.Printf("after split:   %s\n", string(sf))
			continue
		}
		return sf
	}
}

func Add(a, b []byte) []byte {
	r := make([]byte, 0, 3+len(a)+len(b))
	r = append(r, '[')
	r = append(r, a...)
	r = append(r, ',')
	r = append(r, b...)
	r = append(r, ']')
	return Reduce(r)
}

func Magnitude(sf []byte) int {
	if sf[0] != '[' {
		n, _ := ScanUint(sf, 0)
		return n
	}
	level := 0
	for i := 1; i < len(sf); i++ {
		if sf[i] == '[' {
			level++
		} else if sf[i] == ']' {
			level--
		} else if sf[i] == ',' && level == 0 {
			return 3*Magnitude(sf[1:i]) + 2*Magnitude(sf[i+1:len(sf)-1])
		}
	}
	panic("unreachable")
}

func SumSnailFish(in []byte) []byte {
	var i int
	for ; i < len(in); i++ {
		if in[i] == '\n' {
			break
		}
	}
	if i == len(in)-1 {
		return in[:i]
	}
	return Add(in[:i], SumSnailFish(in[i+1:]))
}

func Part2(in []byte) int {
	sfs := make([][]byte, 0, 1000)
	start := 0
	for i := 0; i < len(in); i++ {
		if in[i] == '\n' {
			sfs = append(sfs, in[start:i])
			start = i + 1
		}
	}
	max := 0
	for i := 0; i < len(sfs); i++ {
		for j := i + 1; j < len(sfs); j++ {
			mag := Magnitude(Add(sfs[i], sfs[j]))
			if max < mag {
				max = mag
			}
			mag = Magnitude(Add(sfs[j], sfs[i]))
			if max < mag {
				max = mag
			}
		}
	}
	return max
}

func main() {
	in := InputBytes(input)
	sfs := SumSnailFish(in)
	p1 := Magnitude(sfs)
	if !benchmark {
		fmt.Printf("Part 1: %d\n", p1)
	}
	p2 := Part2(in)
	if !benchmark {
		fmt.Printf("Part 2: %d\n", p2)
	}
}

var benchmark = false
