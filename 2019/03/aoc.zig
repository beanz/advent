const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = i32;

const Orient = enum {
    Horizontal,
    Vertical,
};

const Line = struct {
    x: Int,
    y: Int,
    len: Int,
    steps: usize,
};

fn parts(inp: []const u8) anyerror![2]usize {
    var h = try std.BoundedArray(Line, 320).init(0);
    var v = try std.BoundedArray(Line, 320).init(0);
    var i: usize = 0;
    var x: Int = 0;
    var y: Int = 0;
    var steps: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            'U' => {
                i += 1;
                const l = try aoc.chompUint(Int, inp, &i);
                try v.append(Line{ .x = x, .y = y, .len = -l, .steps = steps });
                y -= l;
                steps += @as(usize, @intCast(l));
            },
            'D' => {
                i += 1;
                const l = try aoc.chompUint(Int, inp, &i);
                try v.append(Line{ .x = x, .y = y, .len = l, .steps = steps });
                y += l;
                steps += @as(usize, @intCast(l));
            },
            'R' => {
                i += 1;
                const l = try aoc.chompUint(Int, inp, &i);
                try h.append(Line{ .x = x, .y = y, .len = l, .steps = steps });
                x += l;
                steps += @as(usize, @intCast(l));
            },
            'L' => {
                i += 1;
                const l = try aoc.chompUint(Int, inp, &i);
                try h.append(Line{ .x = x, .y = y, .len = -l, .steps = steps });
                x -= l;
                steps += @as(usize, @intCast(l));
            },
            else => unreachable,
        }
        if (inp[i] == '\n') {
            i += 1;
            break;
        }
    }

    const hori = h.slice();
    const vert = v.slice();
    var p1: usize = std.math.maxInt(usize);
    var p2: usize = std.math.maxInt(usize);
    steps = 0;
    x = 0;
    y = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            'U' => {
                i += 1;
                const l = try aoc.chompUint(Int, inp, &i);
                intersectionH(hori, x, y, -l, steps, &p1, &p2);
                y -= l;
                steps += @as(usize, @intCast(l));
            },
            'D' => {
                i += 1;
                const l = try aoc.chompUint(Int, inp, &i);
                intersectionH(hori, x, y, l, steps, &p1, &p2);
                y += l;
                steps += @as(usize, @intCast(l));
            },
            'R' => {
                i += 1;
                const l = try aoc.chompUint(Int, inp, &i);
                intersectionV(vert, x, y, l, steps, &p1, &p2);
                x += l;
                steps += @as(usize, @intCast(l));
            },
            'L' => {
                i += 1;
                const l = try aoc.chompUint(Int, inp, &i);
                intersectionV(vert, x, y, -l, steps, &p1, &p2);
                x -= l;
                steps += @as(usize, @intCast(l));
            },
            else => unreachable,
        }
        if (inp[i] == '\n') {
            i += 1;
            break;
        }
    }
    return [2]usize{ p1, p2 };
}

fn intersectionH(hori: []const Line, x: Int, y: Int, l: Int, steps: usize, p1: *usize, p2: *usize) void {
    for (hori) |h| {
        const xb = if (h.len > 0) [2]Int{ h.x, h.x + h.len } else [2]Int{ h.x + h.len, h.x };
        const yb = if (l > 0) [2]Int{ y, y + l } else [2]Int{ y + l, y };
        if (xb[0] < x and x < xb[1] and yb[0] < h.y and h.y < yb[1]) {
            const md = @abs(x) + @abs(h.y);
            const st = steps + @abs(y - h.y) + h.steps + @abs(x - h.x);
            if (p1.* > md) {
                p1.* = md;
            }
            if (p2.* > st) {
                p2.* = st;
            }
        }
    }
}

fn intersectionV(vert: []const Line, x: Int, y: Int, l: Int, steps: usize, p1: *usize, p2: *usize) void {
    for (vert) |v| {
        const xb = if (l > 0) [2]Int{ x, x + l } else [2]Int{ x + l, x };
        const yb = if (v.len > 0) [2]Int{ v.y, v.y + v.len } else [2]Int{ v.y + v.len, v.y };
        if (xb[0] < v.x and v.x < xb[1] and yb[0] < y and y < yb[1]) {
            const md = @abs(v.x) + @abs(y);
            const st = steps + @abs(y - v.y) + v.steps + @abs(x - v.x);
            if (p1.* > md) {
                p1.* = md;
            }
            if (p2.* > st) {
                p2.* = st;
            }
        }
    }
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
