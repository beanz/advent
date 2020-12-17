CC=clang++-6.0
ALL=aoc-go aoc-zig
EXTRA=aoc-gccgo aoc-zig-rel gocpu.out

all: input.txt ${ALL}

clean:
	-rm -f ${ALL} $(notdir $(CURDIR)).test ${EXTRA}
	-rm -rf zig-cache
	-find . -name '*~' -print0 |xargs -0 rm -f

times: ${ALL} input.txt
	@for f in ${ALL} ; do \
	  echo $$f ; \
	  time ./$$f <input.txt input.txt ; \
	  echo ; \
	done
	@echo aoc.pl
	@AoC_TEST=1 time perl aoc.pl input.txt
	@echo
	@echo aoc.jq
	time ./aoc.jq < input.txt
	@echo

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
