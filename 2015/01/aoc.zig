const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(isize, parts);
}

fn parts(inp: []const u8) anyerror![2]isize {
    var p1: isize = 0;
    var p2: isize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            '(' => p1 += 1,
            ')' => p1 -= 1,
            '\n' => {},
            else => unreachable,
        }
        if (p1 < 0) {
            i += 1;
            p2 = @intCast(i);
            break;
        }
    }
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            '(' => p1 += 1,
            ')' => p1 -= 1,
            '\n' => {},
            else => unreachable,
        }
    }
    return [2]isize{ p1, p2 };
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
