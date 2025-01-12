const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Rect = struct {
    x1: u32,
    y1: u32,
    x2: u32,
    y2: u32,

    fn intersect(self: Rect, other: Rect) ?Rect {
        if (self.x1 < other.x2 and self.x2 > other.x1 and self.y1 < other.y2 and self.y2 > other.y1) {
            return Rect{
                .x1 = @max(self.x1, other.x1),
                .y1 = @max(self.y1, other.y1),
                .x2 = @min(self.x2, other.x2),
                .y2 = @min(self.y2, other.y2),
            };
        }
        return null;
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var s = try std.BoundedArray(Rect, 1500).init(0);
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            while (inp[i] != '@') : (i += 1) {}
            i += 2;
            const x = try aoc.chompUint(u32, inp, &i);
            i += 1;
            const y = try aoc.chompUint(u32, inp, &i);
            i += 2;
            const w = try aoc.chompUint(u32, inp, &i);
            i += 1;
            const h = try aoc.chompUint(u32, inp, &i);
            try s.append(Rect{ .x1 = x, .y1 = y, .x2 = x + w, .y2 = y + h });
        }
    }
    var p2: usize = 0;
    var area: [1024 * 1024]bool = .{false} ** (1024 * 1024);
    const rects = s.slice();
    for (rects, 0..) |r, i| {
        var overlap = false;
        for (rects, 0..) |o, j| {
            if (i == j) {
                continue;
            }
            if (r.intersect(o)) |ri| {
                if (i < j) {
                    var y = ri.y1;
                    while (y < ri.y2) : (y += 1) {
                        var x = ri.x1;
                        while (x < ri.x2) : (x += 1) {
                            const k = x + y * 1024;
                            area[k] = true;
                        }
                    }
                }
                overlap = true;
            }
        }
        if (!overlap) {
            p2 = i + 1;
        }
    }
    var p1: usize = 0;
    for (area) |e| {
        p1 += @intFromBool(e);
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
