const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;

const Point = struct {
    x: Int,
    y: Int,
};

fn parts(inp: []const u8) anyerror![2]usize {
    const points = parse: {
        var points = try std.BoundedArray(Point, 512).init(0);
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            const x = try aoc.chompUint(i32, inp, &i);
            i += 1;
            const y = try aoc.chompUint(i32, inp, &i);
            try points.append(Point{ .x = x, .y = y });
        }
        break :parse points.slice();
    };
    var p1: usize = 0;
    var p2: usize = 0;
    for (0..points.len) |i| {
        loop: for (i + 1..points.len) |j| {
            const dx: usize = @intCast(1 + @abs(points[i].x - points[j].x));
            const dy: usize = @intCast(1 + @abs(points[i].y - points[j].y));
            const a: usize = dx * dy;
            p1 = @max(p1, a);
            if (a < p2) {
                continue :loop;
            }
            const min_x = @min(points[i].x, points[j].x);
            const max_x = @max(points[i].x, points[j].x);
            const min_y = @min(points[i].y, points[j].y);
            const max_y = @max(points[i].y, points[j].y);
            for (0..points.len) |k| {
                if (k == i or k == j) {
                    continue;
                }
                const l = @mod(k + 1, points.len);
                if (l == i or l == j) {
                    continue;
                }
                const min_x_l = @min(points[k].x, points[l].x);
                const max_x_l = @max(points[k].x, points[l].x);
                const min_y_l = @min(points[k].y, points[l].y);
                const max_y_l = @max(points[k].y, points[l].y);
                if (!(max_x_l <= min_x or max_x <= min_x_l or
                    max_y_l <= min_y or max_y <= min_y_l))
                {
                    continue :loop;
                }
            }
            p2 = a;
        }
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
