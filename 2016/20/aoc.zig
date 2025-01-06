const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var b = try std.BoundedArray(usize, 2048).init(0);
    var it = aoc.uintIter(usize, inp);
    while (it.next()) |l| {
        const h = it.next().?;
        try b.append((l << 32) + h);
    }
    var f = b.slice();
    std.mem.sort(usize, f[0..], {}, comptime std.sort.asc(usize));
    var p1: ?usize = null;
    var p2: usize = 0;
    var pre: usize = 0;
    for (f) |r| {
        const l = r >> 32;
        const h = r & 0xffffffff;
        if (pre < l) {
            if (p1 == null) {
                p1 = pre;
            }
            p2 += l - pre;
        }
        if (pre <= h) {
            pre = h + 1;
        }
    }

    return [2]usize{ p1.?, p2 };
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
