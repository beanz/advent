const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(i32, parts);
}

fn parts(inp: []const u8) anyerror![2]i32 {
    var acc: [1024]i32 = .{0} ** 1024;
    var l: usize = 0;
    var it = aoc.intIter(i32, inp);
    var p1: i32 = 0;
    while (it.next()) |a| {
        p1 += a;
        acc[l] = p1;
        l += 1;
    }
    var ri: usize = 0;
    var rq: i32 = std.math.maxInt(i32);
    for (0..l) |i| {
        for (i + 1..l) |j| {
            const d = @as(i32, @intCast(@abs(acc[i] - acc[j])));
            if (@mod(d, p1) == 0) {
                const q = @divExact(d, p1);
                if (q < rq) {
                    ri = j;
                    rq = q;
                }
            }
        }
    }

    return [2]i32{ p1, acc[ri] };
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
