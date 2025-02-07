const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Rock = struct {
    rows: []const u8,
    w: usize,
};

const ROCKS: [5]Rock = .{
    Rock{ .rows = &[_]u8{0b1111000}, .w = 4 },
    Rock{ .rows = &[_]u8{ 0b0100000, 0b1110000, 0b0100000 }, .w = 3 },
    Rock{ .rows = &[_]u8{ 0b1110000, 0b0010000, 0b0010000 }, .w = 3 },
    Rock{ .rows = &[_]u8{ 0b1000000, 0b1000000, 0b1000000, 0b1000000 }, .w = 1 },
    Rock{ .rows = &[_]u8{ 0b1100000, 0b1100000 }, .w = 2 },
};

const CHAMBER: usize = 6400;

const Chamber = struct {
    m: [CHAMBER]u8,
    top: usize,
    jets: []const u8,
    jet_i: usize,
    rock_i: usize,

    fn init(inp: []const u8) Chamber {
        var c = Chamber{
            .m = .{0} ** CHAMBER,
            .top = 1,
            .jets = inp[0 .. inp.len - 1],
            .jet_i = 0,
            .rock_i = 0,
        };
        c.m[0] = 0b1111111;
        return c;
    }

    fn jet(self: *Chamber) u8 {
        const r = self.jets[self.jet_i];
        self.jet_i += 1;
        if (self.jet_i == self.jets.len) {
            self.jet_i = 0;
        }
        return r;
    }
    fn rock(self: *Chamber) usize {
        const r = self.rock_i;
        self.rock_i += 1;
        if (self.rock_i == ROCKS.len) {
            self.rock_i = 0;
        }
        return r;
    }
    fn hit(self: *Chamber, rows: []const u8, x: u3, y: usize) bool {
        for (rows, 0..) |row, i| {
            if (self.m[y + i] & (row >> x) != 0) {
                return true;
            }
        }
        return false;
    }
    fn fall(self: *Chamber) void {
        const r = ROCKS[self.rock()];
        const w = r.w;
        var x: u3 = 2;
        var y: usize = self.top + 3;
        while (true) : (y -= 1) {
            const j = self.jet();
            if (j == '<') {
                if (x > 0 and !self.hit(r.rows, x - 1, y)) {
                    x -= 1;
                }
            } else if (x + w < 7 and !self.hit(r.rows, x + 1, y)) {
                x += 1;
            }
            if (self.hit(r.rows, x, y - 1)) {
                break;
            }
        }
        for (0..r.rows.len) |i| {
            self.m[y + i] |= r.rows[i] >> x;
        }
        if (self.top < y + r.rows.len) {
            self.top = y + r.rows.len;
        }
    }
    fn key(self: *Chamber) usize {
        const y = self.top;
        var k: usize = @intCast(self.m[y - 4]);
        k <<= 7;
        k += @intCast(self.m[y - 3]);
        k <<= 7;
        k += @intCast(self.m[y - 2]);
        k <<= 7;
        k += @intCast(self.m[y - 1]);
        k <<= 14;
        k += (@as(usize, @intCast(self.jet_i)) << 3);
        k += @as(usize, @intCast(self.rock_i));
        return k;
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    var ch = Chamber.init(inp);
    var round: usize = 1;
    const last: usize = 1000000000000;
    var cycleTop: ?usize = null;
    var p1: usize = 0;
    var seen = std.AutoHashMap(usize, [2]usize).init(aoc.halloc);
    defer seen.deinit();
    try seen.ensureTotalCapacity(3000);
    while (round <= 5) : (round += 1) {
        ch.fall();
    }
    while (round <= last) : (round += 1) {
        ch.fall();
        if (round == 2022) {
            p1 = ch.top - 1;
        }
        if (cycleTop == null) {
            const k = ch.key();
            if (round >= 2022) {
                if (seen.get(k)) |old| {
                    const oldRound = old[0];
                    const oldTop = old[1];
                    const diffTop = ch.top - oldTop;
                    const diffRound = round - oldRound;
                    const n = (last - round) / diffRound;
                    round += n * diffRound;
                    cycleTop = n * diffTop;
                }
            }
            seen.putAssumeCapacity(k, [2]usize{ round, ch.top });
        }
    }
    return [2]usize{ p1, cycleTop.? + ch.top - 1 };
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
