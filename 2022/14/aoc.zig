const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Grid = struct {
    minX: usize,
    maxX: usize,
    maxY: usize,
    m: [76800]bool,

    fn init(inp: []const u8) !Grid {
        var g = Grid{
            .minX = std.math.maxInt(usize),
            .maxX = std.math.minInt(usize),
            .maxY = std.math.minInt(usize),
            .m = .{false} ** 76800,
        };
        var i: usize = 0;
        while (i < inp.len) {
            var x = (try aoc.chompUint(usize, inp, &i)) - 300;
            i += 1;
            var y = try aoc.chompUint(usize, inp, &i);
            g.add(x, y);
            while (inp[i] != '\n') {
                i += 4;
                const nx = (try aoc.chompUint(usize, inp, &i)) - 300;
                i += 1;
                const ny = try aoc.chompUint(usize, inp, &i);
                const ix: usize = switch (std.math.order(nx, x)) {
                    .lt => 0,
                    .gt => 2,
                    .eq => 1,
                };
                const iy: usize = switch (std.math.order(ny, y)) {
                    .lt => 0,
                    .gt => 2,
                    .eq => 1,
                };
                while (x != nx or y != ny) {
                    x = x + ix - 1;
                    y = y + iy - 1;
                    g.set(x, y);
                }
                g.add(nx, ny);
            }
            i += 1;
        }
        return g;
    }
    inline fn occupied(self: *Grid, x: usize, y: usize) bool {
        return self.m[x * 192 + y];
    }
    inline fn set(self: *Grid, x: usize, y: usize) void {
        self.m[x * 192 + y] = true;
    }
    inline fn add(self: *Grid, x: usize, y: usize) void {
        self.m[x * 192 + y] = true;
        if (self.minX > x) {
            self.minX = x;
        }
        if (self.maxX < x) {
            self.maxX = x;
        }
        if (self.maxY < y) {
            self.maxY = y;
        }
    }
    fn dump(self: *Grid) void {
        for (0..self.maxY + 1) |y| {
            for (self.minX..self.maxX + 1) |x| {
                const ch: u8 = if (self.occupied(x, y)) '#' else '.';
                aoc.print("{c}", .{ch});
            }
            aoc.print("\n", .{});
        }
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var g = try Grid.init(inp);
    //g.dump();
    var p1: usize = 0;
    var p2: usize = 0;
    var sx: usize = 200;
    var sy: usize = 0;
    while (true) {
        if (p1 == 0 and (sx > g.maxX or sx < g.minX)) {
            p1 = p2;
        }
        if (sy < g.maxY + 1) {
            if (!g.occupied(sx, sy + 1)) {
                sy += 1;
                continue;
            }
            if (!g.occupied(sx - 1, sy + 1)) {
                sx -= 1;
                sy += 1;
                continue;
            }
            if (!g.occupied(sx + 1, sy + 1)) {
                sx += 1;
                sy += 1;
                continue;
            }
        }
        g.set(sx, sy);
        p2 += 1;
        if (sx == 200 and sy == 0) {
            break;
        }
        sx = 200;
        sy = 0;
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
