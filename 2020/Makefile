DIRS=$(sort $(wildcard ??/))
ZIG=$(subst /,/aoc-zig,${DIRS})
GO=$(subst /,/aoc-go,${DIRS})
PERL=$(subst /,/aoc.pl,${DIRS})

all: ${ZIG} ${GO}

clean:
	-rm -f ${ZIG} ${GO}
	-rm -rf */zig-cache zig-cache */nytprof* _Inline */_Inline */gocpu.out

%/aoc-zig: %/aoc.zig
	cd $(dir $@) && \
	  zig build-exe -O ReleaseFast --name $(notdir $@) $(notdir $<)

%/aoc-go:
	@cd $(dir $@) && make aoc-go

zig-time: ${ZIG}
	@echo -n "$@ "; /usr/bin/time sh -c "for f in ${ZIG} ; do \$$f ;done" \
	     2>&1 |grep -Po ':\K.*?(?=elapsed)'

zig-times: ${ZIG}
	@for f in ${ZIG} ; do \
	  echo "$@,$${f%/*},$$(/usr/bin/time $$f 2>&1 | \
	                         grep -Po ':\K.*?(?=elapsed)' )" ; \
	  done

go-time: ${GO}
	@echo -n "$@ "; /usr/bin/time \
	   sh -c "for f in ${GO} ; do \$$f \$${f%/aoc-go}/input.txt ;done" \
	     2>&1 |grep -Po ':\K.*?(?=elapsed)'

go-times: ${GO}
	@for f in ${GO} ; do \
	  echo "$@,$${f%/*},$$(/usr/bin/time \
                 $$f $${f%/aoc-go}/input.txt 2>&1 | \
	           grep -Po ':\K.*?(?=elapsed)' )" ; \
	  done

perl-time: ${PERL}
	@echo -n "$@ "; /usr/bin/time \
	  sh -c "\
	    for f in ${PERL} ; do \
	      perl -Ilib \$$f \$${f%/aoc.pl}/input.txt ; \
	    done" \
	    2>&1 |grep -Po ':\K.*?elapsed'

perl-times: ${PERL}
	@for f in ${PERL} ; do \
	  echo "$@,$${f%/*},$$(/usr/bin/time \
                 perl -Ilib $$f $${f%/aoc.pl}/input.txt 2>&1 | \
	           grep -Po ':\K.*?(?=elapsed)' )" ; \
	  done

test:
	@for f in ${DIRS} ; do make -C $$f $@ ;done

test-zig:
	@for f in ${DIRS} ; do make -C $$f $@ ;done

test-go:
	@for f in ${DIRS} ; do make -C $$f $@ ;done

test-pl:
	@for f in ${DIRS} ; do make -C $$f $@ ;done
