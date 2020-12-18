CC=clang++-6.0
ALL=aoc-go aoc-zig
EXTRA=aoc-gccgo aoc-zig-rel gocpu.out

all: input.txt ${ALL}

clean:
	-rm -f ${ALL} $(notdir $(CURDIR)).test ${EXTRA}
	-rm -rf zig-cache nytprof nytprof.out _Inline
	-find . -name '*~' -print0 |xargs -0 rm -f

times: ${ALL} input.txt
	@echo aoc-go
	@time ./aoc-go input.txt
	@echo
	@echo aoc-zig
	@time ./aoc-zig
	@echo
	@echo aoc.pl
	@time perl aoc.pl input.txt
	@echo
	@if [ -f aoc.jq ]; then \
	  echo aoc.jq ; \
	  time ./aoc.jq < input.txt ; \
	  echo ; \
	fi

input.txt:
	aoc-dump

aoc-zig: aoc.zig
	zig build-exe --name $@ $<

aoc-zig-rel: aoc.zig
	zig build-exe -O ReleaseSmall --name $@ $<

aoc-go: main.go
	go build $<
	mv main $@

aoc-gccgo: main.go
	 go build -a -compiler gccgo -gccgoflags=all='-flto -Os -fdata-sections -ffunction-sections -Wl,--gc-sections,-s' $<
	mv main $@

gocpu.out: main.go
	go test -cpuprofile=$@

go-prof: gocpu.out
	go tool pprof -http=":9999" $<

test: ${ALL}
	zig test aoc.zig
	go test -v
	AoC_TEST=2 perl aoc.pl input.txt

test-zig: aoc-zig
	zig test aoc.zig

test-go:
	go test -v

test-pl:
	AoC_TEST=2 perl aoc.pl input.txt

perl-prof:
	perl -d:NYTProf aoc.pl input.txt
	nytprofhtml --open
