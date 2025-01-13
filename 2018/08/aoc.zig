const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray(u8, 20000).init(0);
    var it = aoc.uintIter(u8, inp);
    while (it.next()) |n| {
        try s.append(n);
    }
    const tree = s.slice();
    var i: usize = 0;
    const p1 = sum(tree, &i);
    i = 0;
    const p2 = try sum2(tree, &i);
    return [2]usize{ p1, p2 };
}

fn sum(tree: []u8, i: *usize) usize {
    const child = @as(usize, tree[i.*]);
    const meta = @as(usize, tree[i.* + 1]);
    i.* += 2;
    var r: usize = 0;
    for (0..child) |_| {
        r += sum(tree, i);
    }
    for (0..meta) |_| {
        r += @as(usize, tree[i.*]);
        i.* += 1;
    }
    return r;
}

fn sum2(tree: []u8, i: *usize) anyerror!usize {
    const child = @as(usize, tree[i.*]);
    const meta = @as(usize, tree[i.* + 1]);
    i.* += 2;
    var r: usize = 0;
    if (child == 0) {
        for (0..meta) |_| {
            r += @as(usize, tree[i.*]);
            i.* += 1;
        }
        return r;
    }
    var c = try std.BoundedArray(usize, 64).init(0);
    for (0..child) |_| {
        try c.append(try sum2(tree, i));
    }
    const cs = c.slice();
    for (0..meta) |_| {
        const j = @as(usize, tree[i.*]);
        i.* += 1;
        if (j <= cs.len) {
            r += cs[j - 1];
        }
    }
    return r;
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
