const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    return [2]usize{ part(inp, 4), part(inp, 14) };
}

fn part(inp: []const u8, l: usize) usize {
    var i: usize = 0;
    var n: u32 = 0;
    while (i < l) : (i += 1) {
        n ^= @as(u32, 1) << @as(u5, @intCast(inp[i] & 0x1f));
    }
    while (i < inp.len) : (i += 1) {
        n ^= @as(u32, 1) << @as(u5, @intCast(inp[i] & 0x1f));
        n ^= @as(u32, 1) << @as(u5, @intCast(inp[i - l] & 0x1f));
        if (@popCount(n) == l) {
            return i + 1;
        }
    }
    return 1;
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
