const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Int = u32;

const Brick = struct {
    xMin: Int,
    xMax: Int,
    yMin: Int,
    yMax: Int,
    zMin: Int,
    zMax: Int,
    pub fn format(b: @This(), comptime _: []const u8, _: std.fmt.FormatOptions, writer: anytype) !void {
        return writer.print("{}-{}, {}-{}, {}-{}", .{ b.xMin, b.xMax, b.yMin, b.yMax, b.zMin, b.zMax });
    }
};

const SIZE = 1210;

fn parts(inp: []const u8) anyerror![2]usize {
    const bricks: []Brick = parse: {
        var bricks: [SIZE]Brick = undefined;
        var l: usize = 0;
        var i: usize = 0;
        while (i < inp.len) {
            const xMin = try aoc.chompUint(Int, inp, &i);
            i += 1;
            const yMin = try aoc.chompUint(Int, inp, &i);
            i += 1;
            const zMin = try aoc.chompUint(Int, inp, &i);
            i += 1;
            const xMax = 1 + try aoc.chompUint(Int, inp, &i);
            i += 1;
            const yMax = 1 + try aoc.chompUint(Int, inp, &i);
            i += 1;
            const zMax = 1 + try aoc.chompUint(Int, inp, &i);
            i += 1;
            bricks[l] = Brick{
                .xMin = xMin,
                .xMax = xMax,
                .yMin = yMin,
                .yMax = yMax,
                .zMin = zMin,
                .zMax = zMax,
            };
            l += 1;
        }
        break :parse bricks[0..l];
    };
    std.mem.sort(Brick, bricks, {}, cmp);
    var height: [10][10]Int = .{.{0} ** 10} ** 10;
    var sc: [SIZE]usize = .{0} ** SIZE;
    var back: [SIZE * 10]usize = .{0} ** (SIZE * 10);
    var s = aoc.ListOfLists(usize).init(back[0..], SIZE);
    for (0..bricks.len) |i| {
        const z = 1 + stopZ(&bricks[i], &height);
        const drop = bricks[i].zMin - z;
        bricks[i].zMin = z;
        bricks[i].zMax -= drop;
        for (bricks[i].yMin..bricks[i].yMax) |y| {
            for (bricks[i].xMin..bricks[i].xMax) |x| {
                height[x][y] = bricks[i].zMax - 1;
            }
        }
        var c: usize = 0;
        const t = Brick{
            .xMin = bricks[i].xMin,
            .xMax = bricks[i].xMax,
            .yMin = bricks[i].yMin,
            .yMax = bricks[i].yMax,
            .zMin = bricks[i].zMin - 1,
            .zMax = bricks[i].zMax - 1,
        };
        for (0..bricks.len) |j| {
            if (i == j) {
                continue;
            }
            if (intersect(&bricks[j], &t)) {
                c += 1;
                try s.put(j, i);
            }
        }
        sc[i] = c;
    }
    var p1: usize = 0;
    var p2: usize = 0;
    for (0..bricks.len) |i| {
        var dis: usize = 0;
        var rem: [SIZE]usize = .{0} ** SIZE;
        var wback: [SIZE]usize = undefined;
        var work = aoc.Deque(usize).init(wback[0..]);
        for (s.items(i)) |j| {
            try work.push(j);
        }
        while (work.pop()) |cur| {
            rem[cur] += 1;
            if (sc[cur] == rem[cur]) {
                for (s.items(cur)) |k| {
                    try work.push(k);
                }
                dis += 1;
            }
        }
        if (dis == 0) {
            p1 += 1;
        }
        p2 += dis;
    }

    return [2]usize{ p1, p2 };
}

fn stopZ(a: *const Brick, height: *[10][10]Int) Int {
    var z: Int = 0;
    for (a.yMin..a.yMax) |y| {
        for (a.xMin..a.xMax) |x| {
            const h = height[x][y];
            if (h > z) {
                z = h;
            }
        }
    }
    return z;
}

fn intersect(a: *const Brick, b: *const Brick) bool {
    if (a.zMin >= b.zMax or b.zMin >= a.zMax) {
        return false;
    }
    if (a.yMin >= b.yMax or b.yMin >= a.yMax) {
        return false;
    }
    if (a.xMin >= b.xMax or b.xMin >= a.xMax) {
        return false;
    }
    return true;
}

fn cmp(_: void, a: Brick, b: Brick) bool {
    return a.zMin < b.zMin;
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
