const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn Shuffle(comptime m: i128) type {
    return struct {
        a: i128,
        c: i128,
        pub fn noop() Shuffle(m) {
            return .{
                .a = 1,
                .c = 0,
            };
        }
        pub fn add(self: *Shuffle(m), other: Shuffle(m)) void {
            self.a = @rem(self.a * other.a, m);
            self.c = @rem(self.c * other.a + other.c, m);
        }
        pub fn addCut(self: *Shuffle(m), n: i128) void {
            const a: i128 = 1;
            const c: i128 = @rem(m - @rem(n, m), m);
            self.add(Shuffle(m){ .a = a, .c = c });
        }
        pub fn addDealNew(self: *Shuffle(m)) void {
            const a: i128 = m - 1;
            const c: i128 = m - 1;
            self.add(Shuffle(m){ .a = a, .c = c });
        }
        pub fn addDealWith(self: *Shuffle(m), n: i128) void {
            const a: i128 = @rem(m + @rem(n, m), m);
            const c: i128 = 0;
            self.add(Shuffle(m){ .a = a, .c = c });
        }
        pub fn shuffle(self: Shuffle(m), n: i128) i128 {
            return @rem(self.a * n + self.c, m);
        }
        pub fn inverse(self: Shuffle(m)) Shuffle(m) {
            const a = aoc.mod_inv(i128, self.a, m).?;
            const c: i128 = m - @rem(a * self.c, m);
            return Shuffle(m){
                .a = a,
                .c = c,
            };
        }
        pub fn pow(self: Shuffle(m), e: i128) Shuffle(m) {
            const a = aoc.mod_exp(i128, self.a, e, m);
            const c = @rem(@rem((a - 1) * aoc.mod_inv(i128, self.a - 1, m).?, m) * self.c, m);
            return Shuffle(m){
                .a = a,
                .c = c,
            };
        }
    };
}

const PART1: i128 = 10007;
const PART2: i128 = 119315717514047;

fn parts(inp: []const u8) anyerror![2]usize {
    var s1 = Shuffle(PART1).noop();
    var s2 = Shuffle(PART2).noop();
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            if (inp[i] == 'c') {
                i += 4;
                const n = try aoc.chompInt(i128, inp, &i);
                s1.addCut(n);
                s2.addCut(n);
            } else {
                switch (inp[i + 5]) {
                    'i' => {
                        i += 19;
                        s1.addDealNew();
                        s2.addDealNew();
                    },
                    'w' => {
                        i += 20;
                        const n = try aoc.chompInt(i128, inp, &i);
                        s1.addDealWith(n);
                        s2.addDealWith(n);
                    },
                    else => unreachable,
                }
            }
        }
    }
    const p1: usize = @intCast(s1.shuffle(2019));
    const p2: usize = @intCast(s2.inverse().pow(101741582076661).shuffle(2020));
    return [2]usize{ p1, p2 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
