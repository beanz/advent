package aoc

func Permutations(min, max int) [][]int {
	orig := []int{}
	for i := min; i <= max; i++ {
		orig = append(orig, i)
	}
	var helper func([]int, int)
	res := [][]int{}

	helper = func(orig []int, n int) {
		if n == 1 {
			tmp := make([]int, len(orig))
			copy(tmp, orig)
			res = append(res, tmp)
		} else {
			for i := 0; i < n; i++ {
				helper(orig, n-1)
				if n%2 == 1 {
					tmp := orig[i]
					orig[i] = orig[n-1]
					orig[n-1] = tmp
				} else {
					tmp := orig[0]
					orig[0] = orig[n-1]
					orig[n-1] = tmp
				}
			}
		}
	}
	helper(orig, len(orig))
	return res
}
