const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Sq = enum {
    Sand,
    Clay,
    Settled,
    Water,
};

pub fn BoundingBox(comptime T: type) type {
    return struct {
        minX: T,
        maxX: T,
        minY: T,
        maxY: T,

        const Self = @This();

        pub fn init() Self {
            return Self{
                .minX = std.math.maxInt(T),
                .maxX = std.math.minInt(T),
                .minY = std.math.maxInt(T),
                .maxY = std.math.minInt(T),
            };
        }
        pub fn addX(self: *Self, x: T) void {
            if (self.minX > x) {
                self.minX = x;
            }
            if (self.maxX < x) {
                self.maxX = x;
            }
        }
        pub fn addY(self: *Self, y: T) void {
            if (self.minY > y) {
                self.minY = y;
            }
            if (self.maxY < y) {
                self.maxY = y;
            }
        }
        pub fn addXY(self: *Self, x: T, y: T) void {
            if (self.minX > x) {
                self.minX = x;
            }
            if (self.maxX < x) {
                self.maxX = x;
            }
            if (self.minY > y) {
                self.minY = y;
            }
            if (self.maxY < y) {
                self.maxY = y;
            }
        }
    };
}

const Int = i32;

fn parts(inp: []const u8) anyerror![2]usize {
    var m: [1000000]Sq = .{Sq.Sand} ** 1000000;
    var bb = BoundingBox(Int).init();
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            const axis = inp[i];
            i += 2;
            const a = try aoc.chompUint(Int, inp, &i);
            i += 4;
            const b = try aoc.chompUint(Int, inp, &i);
            i += 2;
            const c = try aoc.chompUint(Int, inp, &i);
            switch (axis) {
                'x' => {
                    const x = a;
                    bb.addX(x);
                    var y: Int = b;
                    while (y <= c) : (y += 1) {
                        bb.addY(y);
                        m[index(x, y)] = Sq.Clay;
                    }
                },
                'y' => {
                    const y = a;
                    bb.addY(y);
                    var x: Int = b;
                    while (x <= c) : (x += 1) {
                        bb.addX(x);
                        m[index(x, y)] = Sq.Clay;
                    }
                },
                else => unreachable,
            }
        }
    }
    // make space for water at the edges
    bb.addX(bb.minX - 1);
    bb.addX(bb.maxX + 1);
    //pretty(m[0..], &bb);
    {
        var back: [512][2]Int = undefined;
        var water = aoc.Deque([2]Int).init(back[0..]);
        try water.push([2]Int{ 500, 0 });
        var visited: [1000000]bool = .{false} ** 1000000;
        while (water.pop()) |cur| {
            var y: Int = cur[1] + 1;
            while (y <= bb.maxY) : (y += 1) {
                const i = index(cur[0], y);
                const sq = m[i];
                if (sq != Sq.Clay and sq != Sq.Settled) {
                    m[i] = Sq.Water;
                    continue;
                }
                y -= 1;
                var maxX = cur[0];
                var fill = Sq.Settled;
                var x = cur[0] + 1;
                while (x <= bb.maxX) : (x += 1) {
                    const ni = index(x, y);
                    const below = m[index(x, y + 1)];
                    if (below == Sq.Sand or below == Sq.Water) {
                        if (!visited[ni]) {
                            visited[ni] = true;
                            try water.push([2]Int{ x, y });
                        }
                        maxX = x;
                        fill = Sq.Water;
                        break;
                    }
                    if (m[ni] == Sq.Clay) {
                        maxX = x - 1;
                        break;
                    }
                }
                var minX = cur[0];
                x = cur[0] - 1;
                while (x >= bb.minX) : (x -= 1) {
                    const ni = index(x, y);
                    const below = m[index(x, y + 1)];
                    if (below == Sq.Sand or below == Sq.Water) {
                        if (!visited[ni]) {
                            visited[ni] = true;
                            try water.push([2]Int{ x, y });
                        }
                        minX = x;
                        fill = Sq.Water;
                        break;
                    }
                    if (m[ni] == Sq.Clay) {
                        minX = x + 1;
                        break;
                    }
                }
                x = minX;
                while (x <= maxX) : (x += 1) {
                    m[index(x, y)] = fill;
                }
                y -= 1;
                if (fill == Sq.Water) {
                    break;
                }
            }
        }
    }
    //pretty(m[0..], &bb);
    var water: usize = 0;
    var settled: usize = 0;
    for (index(bb.minX, bb.minY)..m.len) |i| {
        switch (m[i]) {
            Sq.Settled => settled += 1,
            Sq.Water => water += 1,
            else => {},
        }
    }
    return [2]usize{ settled + water, settled };
}

fn pretty(m: []Sq, bb: *BoundingBox(Int)) void {
    var y: Int = bb.minY;
    while (y <= bb.maxY) : (y += 1) {
        var x: Int = bb.minX;
        while (x <= bb.maxX) : (x += 1) {
            const ch: u8 = switch (m[index(x, y)]) {
                Sq.Clay => '#',
                Sq.Water => '|',
                Sq.Settled => '~',
                Sq.Sand => '.',
            };
            aoc.print("{c}", .{ch});
        }
        aoc.print("\n", .{});
    }
}

inline fn index(x: Int, y: Int) usize {
    return @as(usize, @intCast(y)) * 500 + @as(usize, @intCast(x - 250));
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
