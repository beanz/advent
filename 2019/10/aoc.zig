const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;

const PointAngle = struct {
    x: Int,
    y: Int,
    a: f64,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray([2]Int, 512).init(0);
    var map: [40]u64 = .{0} ** 40;
    {
        var x: Int = 0;
        var y: Int = 0;
        for (inp) |ch| {
            switch (ch) {
                '\n' => {
                    y += 1;
                    x = 0;
                },
                '#' => {
                    try s.append([2]Int{ x, y });
                    map[@as(usize, @intCast(y))] |= @as(usize, 1) << @as(u6, @intCast(x));
                    x += 1;
                },
                '.' => {
                    x += 1;
                },
                else => unreachable,
            }
        }
    }
    const points = s.slice();
    var max_i: usize = 0;
    var max: usize = 0;
    {
        var vc: [512]usize = .{0} ** 512;
        for (0..points.len) |i| {
            for (i + 1..points.len) |j| {
                if (visible(&map, points[i], points[j])) {
                    vc[i] += 1;
                    if (vc[i] > max) {
                        max = vc[i];
                        max_i = i;
                    }
                    vc[j] += 1;
                    if (vc[j] > max) {
                        max = vc[j];
                        max_i = j;
                    }
                }
            }
        }
    }
    var angles = try std.BoundedArray(PointAngle, 512).init(0);
    {
        const best = points[max_i];
        for (points, 0..) |p, i| {
            if (i == max_i) {
                continue;
            }
            var a = angle(best, p);
            a += @as(f64, @floatFromInt(numBlockers(&map, best, p))) * std.math.tau;
            try angles.append(PointAngle{ .x = p[0], .y = p[1], .a = a });
        }
    }
    var a = angles.slice();
    std.mem.sort(PointAngle, a[0..], {}, angle_cmp);
    const p2: usize = @intCast(a[199].x * 100 + a[199].y);
    return [2]usize{ max, p2 };
}

fn angle_cmp(_: void, a: PointAngle, b: PointAngle) bool {
    return a.a < b.a;
}

inline fn angle(p1: [2]Int, p2: [2]Int) f64 {
    const x1: f64 = @floatFromInt(p1[0]);
    const y1: f64 = @floatFromInt(p1[1]);
    const x2: f64 = @floatFromInt(p2[0]);
    const y2: f64 = @floatFromInt(p2[1]);
    var a = std.math.atan2(x2 - x1, y1 - y2);
    if (a < 0) {
        a += std.math.tau;
    }
    return a;
}

inline fn numBlockers(map: []u64, p1: [2]Int, p2: [2]Int) Int {
    var dx = p2[0] - p1[0];
    var dy = p2[1] - p1[1];
    if (dx != 0 or dy != 0) {
        const d = std.math.gcd(@abs(dx), @abs(dy));
        dx = @divTrunc(dx, @as(Int, @intCast(d)));
        dy = @divTrunc(dy, @as(Int, @intCast(d)));
    }
    var x = p1[0] + dx;
    var y = p1[1] + dy;
    var res: Int = 0;
    while (x != p2[0] or y != p2[1]) {
        if (map[@as(usize, @intCast(y))] & @as(usize, 1) << @as(u6, @intCast(x)) != 0) {
            res += 1;
        }
        x += dx;
        y += dy;
    }
    return res;
}

inline fn visible(map: []u64, p1: [2]Int, p2: [2]Int) bool {
    var dx = p2[0] - p1[0];
    var dy = p2[1] - p1[1];
    if (dx != 0 or dy != 0) {
        const d = std.math.gcd(@abs(dx), @abs(dy));
        dx = @divTrunc(dx, @as(Int, @intCast(d)));
        dy = @divTrunc(dy, @as(Int, @intCast(d)));
    }
    var x = p1[0] + dx;
    var y = p1[1] + dy;
    while (x != p2[0] or y != p2[1]) {
        if (map[@as(usize, @intCast(y))] & @as(usize, 1) << @as(u6, @intCast(x)) != 0) {
            return false;
        }
        x += dx;
        y += dy;
    }
    return true;
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
