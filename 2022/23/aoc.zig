const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn Bound(comptime T: type) type {
    return struct {
        min: T,
        max: T,
        fn init() Bound(T) {
            return .{
                .min = std.math.maxInt(T),
                .max = std.math.minInt(T),
            };
        }
        fn reset(self: *Bound(T)) void {
            self.min = std.math.maxInt(T);
            self.max = std.math.minInt(T);
        }
        fn add(self: *Bound(T), n: T) void {
            if (self.min > n) {
                self.min = n;
            }
            if (self.max < n) {
                self.max = n;
            }
        }
    };
}

const Map = struct {
    m: [44100]bool,
    e: [][2]usize,
    xB: Bound(usize),
    yB: Bound(usize),
    dirI: u2,
    const SIZE: usize = 210;
    const SIZE2: usize = SIZE * SIZE;
    const BITS = [4]usize{ 1 + 2 + 4, 32 + 64 + 128, 1 + 8 + 32, 4 + 16 + 128 };
    const INC = [4][2]usize{ .{ 1, 0 }, .{ 1, 2 }, .{ 0, 1 }, .{ 2, 1 } };
    fn init(inp: []const u8, e: [][2]usize) !Map {
        var m: [SIZE2]bool = .{false} ** SIZE2;
        var xB = Bound(usize).init();
        var yB = Bound(usize).init();
        var l: usize = 0;
        var u: usize = 0;
        var x: usize = 70;
        var y: usize = 70;
        for (inp) |ch| {
            switch (ch) {
                '.' => {
                    x += 1;
                },
                '#' => {
                    xB.add(x);
                    yB.add(y);
                    m[y * SIZE + x] = true;
                    e[l] = [2]usize{ x, y };
                    l += 1;
                    x += 1;
                },
                '\n' => {
                    u = x;
                    y += 1;
                    x = 70;
                },
                else => unreachable,
            }
        }
        return Map{
            .m = m,
            .e = e[0..l],
            .dirI = 0,
            .xB = xB,
            .yB = yB,
        };
    }
    fn count(self: Map) usize {
        return (1 + self.xB.max - self.xB.min) * (1 + self.yB.max - self.yB.min) - self.e.len;
    }
    inline fn getBit(self: *Map, x: usize, y: usize) usize {
        return @as(usize, @intFromBool(self.m[x + y * SIZE]));
    }
    inline fn neighbits(self: *Map, x: usize, y: usize) usize {
        var b: usize = 0;
        b |= self.getBit(x - 1, y - 1);
        b |= self.getBit(x, y - 1) << 1;
        b |= self.getBit(x + 1, y - 1) << 2;
        b |= self.getBit(x - 1, y) << 3;
        b |= self.getBit(x + 1, y) << 4;
        b |= self.getBit(x - 1, y + 1) << 5;
        b |= self.getBit(x, y + 1) << 6;
        b |= self.getBit(x + 1, y + 1) << 7;
        return b;
    }
    fn iter(self: *Map) usize {
        var prop: [SIZE2]?[2]usize = .{null} ** SIZE2;
        var c: [SIZE2]usize = .{0} ** SIZE2;
        for (self.e) |e| {
            const nb = self.neighbits(e[0], e[1]);
            if (nb == 0) {
                continue;
            }
            for (0..4) |i| {
                const j = @rem(@as(usize, @intCast(self.dirI)) + i, 4);
                if (nb & BITS[j] == 0) {
                    const inc = INC[j];
                    const nx = e[0] + inc[0] - 1;
                    const ny = e[1] + inc[1] - 1;
                    prop[e[0] + e[1] * SIZE] = [2]usize{ nx, ny };
                    c[nx + ny * SIZE] += 1;
                    break;
                }
            }
        }
        self.xB.reset();
        self.yB.reset();
        var moved: usize = 0;
        for (0..self.e.len) |j| {
            const p = self.e[j];
            const oi = p[0] + p[1] * SIZE;
            if (prop[oi]) |np| {
                const ni = np[0] + np[1] * SIZE;
                if (c[np[0] + np[1] * SIZE] == 1) {
                    self.m[oi] = false;
                    self.m[ni] = true;
                    self.e[j] = np;
                    moved += 1;
                }
            }
            self.xB.add(self.e[j][0]);
            self.yB.add(self.e[j][1]);
        }
        self.dirI +%= 1;
        return moved;
    }
    fn dump(self: *Map) void {
        for (self.yB.min..self.yB.max + 1) |y| {
            for (self.xB.min..self.xB.max + 1) |x| {
                aoc.print("{c}", .{@as(u8, if (self.m[x + y * SIZE]) '#' else '.')});
            }
            aoc.print("\n", .{});
        }
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var e: [3000][2]usize = undefined;
    var m = try Map.init(inp, &e);
    for (1..10 + 1) |_| {
        _ = m.iter();
    }
    const p1 = m.count();
    var p2: usize = 11;
    while (true) : (p2 += 1) {
        if (m.iter() == 0) {
            break;
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
