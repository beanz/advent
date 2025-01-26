const std = @import("std");
const aoc = @import("aoc-lib.zig");

const rollWays = [_]usize{ 1, 3, 6, 7, 6, 3, 1 };

const Game = struct {
    start: [2]usize,
    d: usize,

    fn fromInput(alloc: std.mem.Allocator, inp: []const u8) !*Game {
        var g = try alloc.create(Game);
        var n: usize = 0;
        var p: usize = 0;
        for (inp) |ch| {
            switch (ch) {
                ':' => {
                    n = 0;
                },
                '0'...'9' => {
                    n = n * 10 + @as(usize, ch - '0');
                },
                '\n' => {
                    g.start[p] = n;
                    n = 0;
                    p += 1;
                },
                else => {},
            }
        }
        g.d = 0;
        return g;
    }
    fn roll(self: *Game) usize {
        const r = 1 + (self.d % 100);
        self.d += 1;
        return r;
    }
    pub fn part1(self: *Game) usize {
        var s = [_]usize{ 0, 0 };
        var p = [_]usize{ self.start[0] - 1, self.start[1] - 1 };
        while (true) {
            var r = self.roll() + self.roll() + self.roll();
            p[0] += r;
            p[0] %= 10;
            s[0] += p[0] + 1;
            if (s[0] >= 1000) {
                return s[1] * self.d;
            }
            r = self.roll() + self.roll() + self.roll();
            p[1] += r;
            p[1] %= 10;
            s[1] += p[1] + 1;
            if (s[1] >= 1000) {
                return s[0] * self.d;
            }
        }
        return 1;
    }
    pub fn part2(self: *Game) usize {
        var games: [21 * 21 * 11 * 11]usize = undefined;
        for (&games) |*v| {
            v.* = 0;
        }
        var wins: [21 * 21 * 11 * 11]usize = undefined;
        for (&wins) |*v| {
            v.* = 0;
        }
        var its: i8 = 40;
        while (its >= 0) : (its -= 1) {
            const ts = @as(usize, @intCast(its));
            var is1: isize = 20;
            while (is1 >= 0) : (is1 -= 1) {
                const s1 = @as(usize, @intCast(is1));
                if (s1 > ts) {
                    continue;
                }
                const s2 = ts - s1;
                if (s2 > 20) {
                    continue;
                }
                var p1: usize = 1;
                while (p1 <= 10) : (p1 += 1) {
                    var p2: usize = 1;
                    while (p2 <= 10) : (p2 += 1) {
                        const i = (((s1 * 21) + s2) * 11 + p1) * 11 + p2;
                        var r: usize = 3;
                        while (r <= 9) : (r += 1) {
                            const w = rollWays[r - 3];
                            var np1 = p1 + r;
                            if (np1 > 10) {
                                np1 -= 10;
                            }
                            const ns1 = s1 + np1;
                            if (ns1 >= 21) {
                                games[i] += w;
                                wins[i] += w;
                            } else {
                                const ii = ((((s2 * 21) + ns1) * 11 + p2) * 11) + np1;
                                games[i] += w * games[ii];
                                wins[i] += w * (games[ii] - wins[ii]);
                            }
                        }
                    }
                }
            }
        }
        const ri = self.start[0] * 11 + self.start[1];
        const w1 = wins[ri];
        const w2 = games[ri] - wins[ri];
        if (w1 > w2) {
            return w1;
        }
        return w2;
    }
};

test "examples" {
    const talloc = @import("std").testing.allocator;

    var t = Game.fromInput(aoc.test1file, talloc) catch unreachable;
    defer talloc.destroy(t);
    var ti = Game.fromInput(aoc.inputfile, talloc) catch unreachable;
    defer talloc.destroy(ti);
    try aoc.assertEq(@as(usize, 739785), t.part1());
    try aoc.assertEq(@as(usize, 428736), ti.part1());
    try aoc.assertEq(@as(usize, 444356092776315), t.part2());
    try aoc.assertEq(@as(usize, 57328067654557), ti.part2());
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var g = try Game.fromInput(aoc.halloc, inp);
    defer aoc.halloc.destroy(g);
    const p1 = g.part1();
    const p2 = g.part2();
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
