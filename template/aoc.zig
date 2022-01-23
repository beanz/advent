const std = @import("std");
const aoc = @import("aoc-lib.zig");
pub fn parts(_: std.mem.Allocator, _: []const u8) ![2]usize {
    return [2]usize{ 1, 2 };
}

test "parts" {
    var t1 = try parts(aoc.talloc, aoc.test1file);
    try aoc.assertEq(@as(usize, 40), t1[0]);
    var r = try parts(aoc.talloc, aoc.inputfile);
    try aoc.assertEq(@as(usize, 595), r[0]);
    try aoc.assertEq(@as(usize, 315), t1[1]);
    try aoc.assertEq(@as(usize, 2914), r[1]);
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(aoc.halloc, inp);
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
