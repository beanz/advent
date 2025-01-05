const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    var j: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            '(' => {
                i += 1;
                const n = try aoc.chompUint(usize, inp, &i);
                i += 1;
                const m = try aoc.chompUint(usize, inp, &i);
                i += n;
                p1 += n * m;
            },
            '\n' => {
                p2 += try count(inp[j..i]);
                j = i + 1;
            },
            else => {
                p1 += 1;
            },
        }
    }
    return [2]usize{ p1, p2 };
}

fn count(s: []const u8) anyerror!usize {
    var l: usize = 0;
    var i: usize = 0;
    while (i < s.len) {
        if (s[i] != '(') {
            l += 1;
            i += 1;
            continue;
        }
        i += 1;
        const n = try aoc.chompUint(usize, s, &i);
        i += 1;
        const m = try aoc.chompUint(usize, s, &i);
        i += 1;
        l += m * try count(s[i .. i + n]);
        i += n;
    }
    return l;
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
