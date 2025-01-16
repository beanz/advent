const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const w = std.mem.indexOfScalar(u8, inp, '\n') orelse unreachable;
    const h = inp.len / (w + 1);
    var woods: [2560]u8 = undefined;
    std.mem.copyForwards(u8, &woods, inp);
    var next: [2560]u8 = undefined;
    for (0..10) |_| {
        iter(&woods, &next, w, h);
        std.mem.swap([2560]u8, &woods, &next);
    }
    const p1 = counts(&woods, w, h);
    for (10..300) |_| {
        iter(&woods, &next, w, h);
        std.mem.swap([2560]u8, &woods, &next);
    }
    var i: usize = 300;
    const it: usize = 1000000000;
    var trees: usize = 0;
    var yards: usize = 0;
    var seen = std.AutoHashMap([2]usize, usize).init(aoc.halloc);
    while (i < it) {
        iter(&woods, &next, w, h);
        std.mem.swap([2560]u8, &woods, &next);
        i += 1;
        const c = counts(&woods, w, h);
        trees = c[0];
        yards = c[1];
        if (seen.get(c)) |prevI| {
            const cycle = i - prevI;
            const rem = it - i;
            const inc = cycle * @divTrunc(rem, cycle);
            i += inc;
            seen.clearRetainingCapacity();
        } else {
            try seen.put(c, i);
        }
    }

    return [2]usize{ p1[0] * p1[1], trees * yards };
}

fn counts(woods: []u8, w: usize, h: usize) [2]usize {
    var res: [2]usize = [2]usize{ 0, 0 };
    for (0..h) |y| {
        for (0..w) |x| {
            switch (woods[x + y * (w + 1)]) {
                '|' => res[0] += 1,
                '#' => res[1] += 1,
                else => {},
            }
        }
    }
    return res;
}

fn iter(woods: []u8, next: []u8, w: usize, h: usize) void {
    for (0..h) |y| {
        for (0..w) |x| {
            const c: [2]usize = neighbour_counts(woods, x, y, w, h);
            const trees = c[0];
            const lumber = c[1];
            const i = x + y * (w + 1);
            next[i] = switch (woods[i]) {
                '.' => if (trees >= 3) '|' else '.',
                '|' => if (lumber >= 3) '#' else '|',
                else => if (trees >= 1 and lumber >= 1) '#' else '.',
            };
        }
    }
}

inline fn neighbour_counts(woods: []u8, x: usize, y: usize, w: usize, h: usize) [2]usize {
    var res: [2]usize = [2]usize{ 0, 0 };
    const ix: i32 = @intCast(x);
    const iy: i32 = @intCast(y);
    const iw: i32 = @intCast(w);
    const ih: i32 = @intCast(h);
    var ox: i32 = -1;
    while (ox <= 1) : (ox += 1) {
        const nx = ix + ox;
        if (nx < 0 or nx >= iw) {
            continue;
        }
        var oy: i32 = -1;
        while (oy <= 1) : (oy += 1) {
            if (ox == 0 and oy == 0) {
                continue;
            }
            const ny = iy + oy;
            if (ny < 0 or ny >= ih) {
                continue;
            }
            switch (woods[@as(usize, @intCast(nx)) + @as(usize, @intCast(ny)) * (w + 1)]) {
                '|' => res[0] += 1,
                '#' => res[1] += 1,
                else => {},
            }
        }
    }
    return res;
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
