const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var b = try std.BoundedArray(usize, 32).init(0);
    try aoc.chompUints(usize, inp, &b);
    const containers = b.slice();
    const target: usize = if (b.len < 10) 25 else 150;
    var ways: [151]usize = .{0} ** 151;
    ways[0] = 1;
    for (containers) |c| {
        var i = target;
        while (i >= c) : (i -= 1) {
            ways[i] += ways[i - c];
        }
    }
    const maskMax: usize = @as(usize, 1) << @as(u5, @intCast(containers.len));
    var p2: ?usize = null;
    for (1..containers.len + 1) |size| {
        for (1..maskMax + 1) |m| {
            var s: usize = 0;
            if (@popCount(m) != size) {
                continue;
            }
            var bit: usize = 1;
            for (containers) |c| {
                if (m & bit != 0) {
                    s += c;
                }
                bit <<= 1;
            }
            if (s == target) {
                if (p2 != null) {
                    p2.? += 1;
                } else {
                    p2 = 1;
                }
            }
        }
        if (p2 != null) {
            break;
        }
    }
    return [2]usize{ ways[target], p2.? };
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
