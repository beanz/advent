const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var rd = try std.BoundedArray([3]usize, 16).init(0);
    var it = aoc.uintIter(usize, inp);
    while (it.next()) |speed| {
        const flyTime = it.next().?;
        const restTime = it.next().?;
        try rd.append([3]usize{ speed, flyTime, restTime });
    }
    const deer = rd.slice();
    const maxTime: usize = if (deer.len <= 2) 1000 else 2503;
    var maxDist: usize = 0;
    for (deer) |d| {
        const dist = deerDist(d[0], d[1], d[2], maxTime);
        if (maxDist < dist) {
            maxDist = dist;
        }
    }
    var scores: [16]usize = .{0} ** 16;
    var dists: [16]usize = .{0} ** 16;
    for (1..maxTime + 1) |t| {
        var max: usize = 0;
        for (deer, 0..) |d, i| {
            dists[i] = deerDist(d[0], d[1], d[2], t);
            if (max < dists[i]) {
                max = dists[i];
            }
        }
        for (deer, 0..) |_, i| {
            if (dists[i] == max) {
                scores[i] += 1;
            }
        }
    }
    var p2: usize = 0;
    for (0..deer.len) |i| {
        if (p2 < scores[i]) {
            p2 = scores[i];
        }
    }
    return [2]usize{ maxDist, p2 };
}

inline fn deerDist(speed: usize, flyTime: usize, restTime: usize, t: usize) usize {
    const totalTime = flyTime + restTime;
    const n = t / totalTime;
    const r = t % totalTime;
    return n * speed * flyTime + (if (r >= flyTime) speed * flyTime else speed * r);
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
