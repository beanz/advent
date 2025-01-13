const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray([2]i32, 50).init(0);
    var b: [4]i32 = .{ std.math.maxInt(i32), std.math.minInt(i32), std.math.maxInt(i32), std.math.minInt(i32) };
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            const x = try aoc.chompUint(i32, inp, &i);
            i += 2;
            const y = try aoc.chompUint(i32, inp, &i);
            try s.append([2]i32{ x, y });
            if (x < b[0]) {
                b[0] = x;
            }
            if (x > b[1]) {
                b[1] = x;
            }
            if (y < b[2]) {
                b[2] = y;
            }
            if (y > b[3]) {
                b[3] = y;
            }
        }
    }
    const points = s.slice();
    var areas: [50]?usize = .{0} ** 50;
    {
        var y: i32 = b[2];
        while (y <= b[3]) : (y += 1) {
            var x: i32 = b[0];
            while (x <= b[1]) : (x += 1) {
                const mc = closest(points, x, y);
                if (mc) |ci| {
                    if (x == b[0] or x == b[1] or y == b[2] or y == b[3]) {
                        areas[ci] = null;
                        continue;
                    }
                    if (areas[ci]) |a| {
                        areas[ci] = a + 1;
                    }
                }
            }
        }
    }
    var p1: usize = 0;
    for (areas) |a| {
        if (a) |n| {
            if (n > p1) {
                p1 = n;
            }
        }
    }

    const d: u32 = if (points.len > 10) 10000 else 32;
    var p2: usize = 0;
    const mx = @divTrunc(b[1] - b[0], 2);
    const my = @divTrunc(b[3] - b[2], 2);
    var dim: i32 = 0;
    var finished = false;
    while (!finished) {
        finished = true;
        {
            var y = my - dim;
            while (y < my + dim + 1) : (y += 1) {
                for ([2]i32{ mx - dim, mx + dim }) |x| {
                    var mds: u32 = 0;
                    for (points) |p| {
                        mds += @abs(x - p[0]) + @abs(y - p[1]);
                    }
                    if (mds < d) {
                        p2 += 1;
                        finished = false;
                    }
                }
            }
        }
        {
            var x = mx - dim + 1;
            while (x < mx + dim) : (x += 1) {
                for ([2]i32{ my - dim, my + dim }) |y| {
                    var mds: u32 = 0;
                    for (points) |p| {
                        mds += @abs(x - p[0]) + @abs(y - p[1]);
                    }
                    if (mds < d) {
                        p2 += 1;
                        finished = false;
                    }
                }
            }
        }
        dim += 1;
    }

    return [2]usize{ p1, p2 - 1 };
}

fn closest(points: [][2]i32, x: i32, y: i32) ?usize {
    var min: u32 = std.math.maxInt(u32);
    var min_i: ?usize = null;
    for (points, 0..) |p, i| {
        const md = @abs(p[0] - x) + @abs(p[1] - y);
        if (md < min) {
            min = md;
            min_i = i;
        } else if (md == min) {
            min_i = null;
        }
    }
    return min_i;
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
