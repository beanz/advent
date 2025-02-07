const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = u32;

inline fn fuel1(a: u32, b: u32) usize {
    return @abs(@as(isize, @intCast(a)) - @as(isize, @intCast(b)));
}

inline fn fuelsum1(p: Int, inp: []const Int) usize {
    var c: usize = 0;
    for (inp) |v| {
        c += fuel1(p, v);
    }
    return c;
}

inline fn fuel2(a: Int, b: Int) usize {
    const f = fuel1(a, b);
    return f * (f + 1) / 2;
}

inline fn fuelsum2(p: Int, inp: []const Int) usize {
    var c: usize = 0;
    for (inp) |v| {
        c += fuel2(p, v);
    }
    return c;
}

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray(Int, 1000).init(0);
    {
        var it = aoc.uintIter(Int, inp);
        while (it.next()) |n| {
            try s.append(n);
        }
    }
    const ints = s.slice();
    std.mem.sort(Int, ints, {}, std.sort.asc(Int));
    const p1 = fuelsum1(ints[ints.len / 2], ints);
    const mean = init: {
        var mean = ints[0];
        var i: usize = 1;
        while (i < ints.len) : (i += 1) {
            mean += ints[i];
        }
        mean /= @intCast(ints.len);
        break :init mean;
    };
    var p2 = fuelsum2(mean, ints);
    const c = fuelsum2(mean + 1, ints);
    if (p2 > c) {
        p2 = c;
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
