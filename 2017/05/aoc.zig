const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var ints: [1600]i32 = .{0} ** 1600;
    var l: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        ints[l] = try aoc.chompInt(i32, inp, &i);
        l += 1;
    }
    var ints2: [1600]i32 = .{0} ** 1600;
    std.mem.copyForwards(i32, ints2[0..l], ints[0..l]);
    var p1: usize = 0;
    {
        var j: isize = 0;
        while (0 <= j and j < l) {
            const k = @as(usize, @intCast(j));
            const v = ints[k];
            ints[k] += 1;
            j += v;
            p1 += 1;
        }
    }
    var p2: usize = 0;
    {
        var j: isize = 0;
        while (0 <= j and j < l) {
            const k = @as(usize, @intCast(j));
            const v = ints2[k];
            ints2[k] += if (v < 3) 1 else -1;
            j += v;
            p2 += 1;
        }
    }
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
