DIRS=$(sort $(wildcard ????/??/))

PERL_SRC=$(sort $(wildcard ????/??/aoc.pl))
PERL_CHK=$(subst /aoc.pl,/aoc.pl.chk,${PERL_SRC})
PERL_LOG=$(subst /aoc.pl,/aoc.pl.log,${PERL_SRC})
PERL_ERR=$(subst /aoc.pl,/aoc.pl.err,${PERL_SRC})

GO_SRC=$(sort $(wildcard ????/??/main.go))
GO_TEST=$(sort $(wildcard ????/??/main_test.go))
GO_BIN=$(subst /main.go,/aoc-go,${GO_SRC})
GO_LOG=$(subst /main.go,/aoc-go.log,${GO_SRC})
GO_ERR=$(subst /main.go,/aoc-go.err,${GO_SRC})

ZIG_SRC=$(sort $(wildcard ????/??/aoc.zig))
ZIG_BIN=$(subst /aoc.zig,/aoc-zig,${ZIG_SRC})
ZIG_LOG=$(subst /aoc.zig,/aoc-zig.log,${ZIG_SRC})
ZIG_ERR=$(subst /aoc.zig,/aoc-zig.err,${ZIG_SRC})

NIM_SRC=$(sort $(wildcard ????/??/aoc.nim))
NIM_BIN=$(subst /aoc.nim,/aoc-nim,${NIM_SRC})
NIM_LOG=$(subst /aoc.nim,/aoc-nim.log,${NIM_SRC})
NIM_ERR=$(subst /aoc.nim,/aoc-nim.err,${NIM_SRC})

CR_SRC=$(sort $(wildcard ????/??/aoc.cr))
CR_BIN=$(subst /aoc.cr,/aoc-cr,${CR_SRC})
CR_LOG=$(subst /aoc.cr,/aoc-cr.log,${CR_SRC})
CR_ERR=$(subst /aoc.cr,/aoc-cr.err,${CR_SRC})

CPP_SRC=$(sort $(wildcard ????/??/cpp/aoc.cpp))
CPP_BIN=$(subst /cpp/aoc.cpp,/aoc-cpp,${CPP_SRC})
CPP_LOG=$(subst /cpp/aoc.cpp,/aoc-cpp.log,${CPP_SRC})
CPP_ERR=$(subst /cpp/aoc.cpp,/aoc-cpp.err,${CPP_SRC})

#CC=clang++-6.0
CC=g++-7
CR_DIR=$(HOME)/Tmp/crystal-0.35.1-1
CR_LIB=$(CR_DIR)/share/crystal/src:lib-cr
CR=$(CR_DIR)/bin/crystal
NIM=$(HOME)/Tmp/nim-1.0.4/bin/nim

TIME=../../bin/time

.DELETE_ON_ERROR: /bin/true

all: ${GO_BIN} ${CPP_BIN} ${NIM_BIN} ${ZIG_BIN} ${CR_BIN} ${PERL_CHK}
run: ${GO_LOG} ${CPP_LOG} ${NIM_LOG} ${ZIG_LOG} ${CR_LOG} ${PERL_LOG}

build: cpp-build cr-build go-build nim-build perl-build zig--build

cpp-build: ${CPP_BIN}
cpp: ${CPP_LOG} ${CPP_BIN}

cr-build: ${CR_BIN}
cr: ${CR_LOG} ${CR_BIN}

go-build: ${GO_BIN}
go: ${GO_LOG} ${GO_BIN}

nim-build: ${NIM_BIN}
nim: ${NIM_LOG} ${NIM_BIN}

perl: ${PERL_LOG}
perl-build: ${PERL_CHK}

zig-build: ${ZIG_BIN}
zig: ${ZIG_LOG} ${ZIG_BIN}

%/aoc.pl.chk: %/aoc.pl
	(cd $(dir $@) && perl -c aoc.pl && touch $(notdir $@)) || exit 1

%/aoc-go: %/main.go
	cd $(dir $@) && go build -o aoc-go main.go

%/aoc-cpp: %/cpp/aoc.cpp
	$(CC) -I$(dir $@)../lib -o $@ $<

%/aoc-nim: %/aoc.nim
	$(NIM) c --opt:speed -d:release -p:$(dir $@)../lib $<
	mv $(dir $@)/aoc $@

%/aoc-cr: %/aoc.cr
	CRYSTAL_PATH=$(CR_LIB) $(CR) build --release -o $@ $<

%/aoc-zig: %/aoc.zig
	cd $(dir $@) && zig build-exe -O ReleaseFast \
		--name $(notdir $@) $(notdir $<)

%/aoc-cpp.log: %/aoc-cpp
	cd $(dir $@) && \
	  ( ( ${TIME} ./$(notdir $<) <input.txt | \
	     tee $(notdir $<).log ) 2>&1 1>&3 | \
	     tee $(notdir $<).err ) 3>&1 1>&2

%/aoc-nim.log: %/aoc-nim
	cd $(dir $@) && \
	  ( ( ${TIME} ./$(notdir $<) <input.txt | \
	     tee $(notdir $<).log ) 2>&1 1>&3 | \
	     tee $(notdir $<).err ) 3>&1 1>&2

%.log: %
	cd $(dir $@) && \
	  ( ( ${TIME} ./$(notdir $<) input.txt | \
	     tee $(notdir $<).log ) 2>&1 1>&3 | \
	     tee $(notdir $<).err ) 3>&1 1>&2

%/aoc.pl.log: %/aoc.pl
	cd $(dir $@) && \
	  ( ( ${TIME} perl aoc.pl input.txt | tee aoc.pl.log ) 2>&1 1>&3 | \
	     tee aoc.pl.err ) 3>&1 1>&2

clean: clean-perl clean-go clean-zig clean-nim clean-cr clean-cpp clean-misc

clean-perl:
	rm -f ${PERL_LOG} ${PERL_ERR} ${PERL_CHK}
	find . -type d -name '_Inline' -print0| xargs -r -0 rm -rf

clean-go:
	rm -f ${GO_LOG} ${GO_ERR} ${GO_BIN}

clean-cpp:
	rm -f ${CPP_LOG} ${CPP_ERR} ${CPP_BIN}

clean-cr:
	rm -f ${CR_LOG} ${CR_ERR} ${CR_BIN}

clean-nim:
	rm -f ${NIM_LOG} ${NIM_ERR} ${NIM_BIN}

clean-zig:
	rm -f ${ZIG_LOG} ${ZIG_ERR} ${ZIG_BIN}
	find . -type d -name 'zig-cache' -print0| xargs -r -0 rm -rf

clean-misc:
	find . -name '*~' -print0|xargs -r -0 rm -f

build2015: go2015-build zig2015-build nim2015-build cr2015-build cpp2015-build perl2015-build
build2016: go2016-build zig2016-build nim2016-build cr2016-build cpp2016-build perl2016-build
build2017: go2017-build zig2017-build nim2017-build cr2017-build cpp2017-build perl2017-build
build2018: go2018-build zig2018-build nim2018-build cr2018-build cpp2018-build perl2018-build
build2019: go2019-build zig2019-build nim2019-build cr2019-build cpp2019-build perl2019-build
build2020: go2020-build zig2020-build nim2020-build cr2020-build cpp2020-build perl2020-build

cpp2015-build: $(filter 2015/%,${CPP_BIN})
cpp2015: $(filter 2015/%,${CPP_LOG})
cpp2016-build: $(filter 2016/%,${CPP_BIN})
cpp2016: $(filter 2016/%,${CPP_LOG})
cpp2017-build: $(filter 2017/%,${CPP_BIN})
cpp2017: $(filter 2017/%,${CPP_LOG})
cpp2018-build: $(filter 2018/%,${CPP_BIN})
cpp2018: $(filter 2018/%,${CPP_LOG})
cpp2019-build: $(filter 2019/%,${CPP_BIN})
cpp2019: $(filter 2019/%,${CPP_LOG})
cpp2020-build: $(filter 2020/%,${CPP_BIN})
cpp2020: $(filter 2020/%,${CPP_LOG})

cr2015-build: $(filter 2015/%,${CR_BIN})
cr2015: $(filter 2015/%,${CR_LOG})
cr2016-build: $(filter 2016/%,${CR_BIN})
cr2016: $(filter 2016/%,${CR_LOG})
cr2017-build: $(filter 2017/%,${CR_BIN})
cr2017: $(filter 2017/%,${CR_LOG})
cr2018-build: $(filter 2018/%,${CR_BIN})
cr2018: $(filter 2018/%,${CR_LOG})
cr2019-build: $(filter 2019/%,${CR_BIN})
cr2019: $(filter 2019/%,${CR_LOG})
cr2020-build: $(filter 2020/%,${CR_BIN})
cr2020: $(filter 2020/%,${CR_LOG})

go2015-build: $(filter 2015/%,${GO_BIN})
go2015: $(filter 2015/%,${GO_LOG})
go2016-build: $(filter 2016/%,${GO_BIN})
go2016: $(filter 2016/%,${GO_LOG})
go2017-build: $(filter 2017/%,${GO_BIN})
go2017: $(filter 2017/%,${GO_LOG})
go2018-build: $(filter 2018/%,${GO_BIN})
go2018: $(filter 2018/%,${GO_LOG})
go2019-build: $(filter 2019/%,${GO_BIN})
go2019: $(filter 2019/%,${GO_LOG})
go2020-build: $(filter 2020/%,${GO_BIN})
go2020: $(filter 2020/%,${GO_LOG})

nim2015-build: $(filter 2015/%,${NIM_BIN})
nim2015: $(filter 2015/%,${NIM_LOG})
nim2016-build: $(filter 2016/%,${NIM_BIN})
nim2016: $(filter 2016/%,${NIM_LOG})
nim2017-build: $(filter 2017/%,${NIM_BIN})
nim2017: $(filter 2017/%,${NIM_LOG})
nim2018-build: $(filter 2018/%,${NIM_BIN})
nim2018: $(filter 2018/%,${NIM_LOG})
nim2019-build: $(filter 2019/%,${NIM_BIN})
nim2019: $(filter 2019/%,${NIM_LOG})
nim2020-build: $(filter 2020/%,${NIM_BIN})
nim2020: $(filter 2020/%,${NIM_LOG})

perl2015: $(filter 2015/%,${PERL_LOG})
perl2016: $(filter 2016/%,${PERL_LOG})
perl2017: $(filter 2017/%,${PERL_LOG})
perl2018: $(filter 2018/%,${PERL_LOG})
perl2019: $(filter 2019/%,${PERL_LOG})
perl2020: $(filter 2020/%,${PERL_LOG})
perl2015-build: $(filter 2015/%,${PERL_CHK})
perl2016-build: $(filter 2016/%,${PERL_CHK})
perl2017-build: $(filter 2017/%,${PERL_CHK})
perl2018-build: $(filter 2018/%,${PERL_CHK})
perl2019-build: $(filter 2019/%,${PERL_CHK})
perl2020-build: $(filter 2020/%,${PERL_CHK})

zig2015-build: $(filter 2015/%,${ZIG_BIN})
zig2015: $(filter 2015/%,${ZIG_LOG})
zig2016-build: $(filter 2016/%,${ZIG_BIN})
zig2016: $(filter 2016/%,${ZIG_LOG})
zig2017-build: $(filter 2017/%,${ZIG_BIN})
zig2017: $(filter 2017/%,${ZIG_LOG})
zig2018-build: $(filter 2018/%,${ZIG_BIN})
zig2018: $(filter 2018/%,${ZIG_LOG})
zig2019-build: $(filter 2019/%,${ZIG_BIN})
zig2019: $(filter 2019/%,${ZIG_LOG})
zig2020-build: $(filter 2020/%,${ZIG_BIN})
zig2020: $(filter 2020/%,${ZIG_LOG})