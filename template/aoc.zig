const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    var t1 = try parts(aoc.test1file);
    try aoc.assertEq([2]usize{ 10, 20 }, t1);
    var p = try parts(aoc.inputfile);
    try aoc.assertEq([2]usize{ 100, 200 }, p);
}

fn parts(inp: []const u8) ![2]usize {
    var p1 = inp.len;
    var p2 = 2;
    TODO;
    return [2]usize{ p1, p2 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
