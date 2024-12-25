const std = @import("std");
const aoc = @import("aoc-lib.zig");

const Vec5 = @Vector(5, u8);

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var keys = try std.BoundedArray(Vec5, 512).init(0);
    var locks = try std.BoundedArray(Vec5, 512).init(0);
    var i: usize = 0;
    while (i < inp.len) : (i += 43) {
        var c: Vec5 = @splat(0);
        for (0..5) |j| {
            for (1..6) |k| {
                c[j] += if (inp[i + j + k * 6] == '#') 1 else 0;
            }
        }
        if (inp[i] == '#') {
            try locks.append(c);
        } else {
            try keys.append(c);
        }
    }
    var p1: usize = 0;
    for (locks.slice()) |lock| {
        for (keys.slice()) |key| {
            p1 += if (@reduce(.Max, lock + key) < 6) 1 else 0;
        }
    }

    return [2]usize{ p1, 0 };
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
