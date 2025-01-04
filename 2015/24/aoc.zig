const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var ws = try std.BoundedArray(usize, 32).init(0);
    var it = aoc.uintIter(usize, inp);
    var sum: usize = 0;
    while (it.next()) |n| {
        try ws.append(n);
        sum += n;
    }
    const third = sum / 3;
    const quarter = sum / 4;
    const w = ws.slice();
    return [2]usize{ solve(w, third), solve(w, quarter) };
}

fn solve(w: []const usize, target: usize) usize {
    const maskMax: usize = @as(usize, 1) << @as(u5, @intCast(w.len));
    var res: usize = std.math.maxInt(usize);
    for (1..w.len + 1) |size| {
        for (1..maskMax + 1) |m| {
            if (@popCount(m) != size) {
                continue;
            }
            var bit: usize = 1;
            var s: usize = 0;
            var p: usize = 1;
            for (w) |n| {
                if (m & bit != 0) {
                    s += n;
                    p *= n;
                }
                bit <<= 1;
            }
            if (s == target) {
                if (res > p) {
                    res = p;
                }
            }
        }
        if (res != std.math.maxInt(usize)) {
            break;
        }
    }
    return res;
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
