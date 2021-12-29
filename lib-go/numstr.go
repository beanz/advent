package aoc

type NumStr struct {
	b  []byte
	l  int
	pl int
}

func NewNumStr(prefix string) *NumStr {
	pl := len(prefix)
	b := make([]byte, pl+10)
	copy(b, []byte(prefix))
	b[len(prefix)] = '0'
	return &NumStr{b: b, l: pl + 1, pl: pl}
}

func NewNumStrFromBytes(prefix []byte) *NumStr {
	pl := len(prefix)
	b := make([]byte, pl+10)
	copy(b, prefix)
	b[len(prefix)] = '0'
	return &NumStr{b: b, l: pl + 1, pl: pl}
}

func (n *NumStr) Bytes() []byte {
	return n.b[:n.l]
}

func (n *NumStr) String() string {
	return string(n.b[:n.l])
}

func (n *NumStr) Inc() {
	for i := n.l - 1; i >= n.pl; i-- {
		n.b[i]++
		if n.b[i] <= '9' {
			return
		}
		n.b[i] = '0'
	}
	n.b[n.pl] = '1'
	n.b[n.l] = '0'
	n.l++
}

type PerlyString struct {
	b []byte
	l int
}

func NewPerlyString(pw string) *PerlyString {
	b := make([]byte, len(pw)+10)
	copy(b, []byte(pw))
	return &PerlyString{b: b, l: len(pw)}
}

func (pw *PerlyString) Bytes() []byte {
	return pw.b[:pw.l]
}

func (pw *PerlyString) String() string {
	return string(pw.Bytes())
}

func (pw *PerlyString) Inc() {
	for i := pw.l - 1; i >= 0; i-- {
		pw.b[i]++
		if pw.b[i] <= 'z' {
			return
		}
		pw.b[i] = 'a'
	}
	pw.b[0] = 'a'
	pw.b[pw.l] = 'a'
	pw.l++
}
