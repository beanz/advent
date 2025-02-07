const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const Map = struct {
    m: [1000][3800]bool,
    w: usize,
    h: usize,
    fn init(m: *Map, inp: []const u8) !void {
        const h = m.h;
        const w = m.w;
        for (0..1000) |t| {
            for (0..h) |y| {
                m.m[t][y * w] = true;
                m.m[t][w - 1 + y * w] = true;
            }
            for (1..w - 1) |x| {
                m.m[t][x] = true;
                m.m[t][x + (h - 1) * w] = true;
            }
            m.m[t][1] = false;
            m.m[t][w - 2 + (h - 1) * w] = false;
        }
        for (1..h - 1) |y| {
            for (1..w - 1) |x| {
                const ch = inp[x + y * (w + 1)];
                switch (ch) {
                    '.' => continue,
                    '^' => {
                        var sy = y;
                        m.m[0][x + y * w] = true;
                        for (1..1000) |t| {
                            sy -= 1;
                            if (sy == 0) {
                                sy = h - 2;
                            }
                            m.m[t][x + sy * w] = true;
                        }
                    },
                    'v' => {
                        var sy = y;
                        m.m[0][x + y * w] = true;
                        for (1..1000) |t| {
                            sy += 1;
                            if (sy == h - 1) {
                                sy = 1;
                            }
                            m.m[t][x + sy * w] = true;
                        }
                    },
                    '<' => {
                        var sx = x;
                        m.m[0][x + y * w] = true;
                        for (1..1000) |t| {
                            sx -= 1;
                            if (sx == 0) {
                                sx = w - 2;
                            }
                            m.m[t][sx + y * w] = true;
                        }
                    },
                    '>' => {
                        var sx = x;
                        m.m[0][x + y * w] = true;
                        for (1..1000) |t| {
                            sx += 1;
                            if (sx == w - 1) {
                                sx = 1;
                            }
                            m.m[t][sx + y * w] = true;
                        }
                    },
                    else => unreachable,
                }
            }
        }
    }

    const Search = struct {
        x: usize,
        y: usize,
        t: usize,
        start: bool,
        end: bool,
    };
    fn parts(self: *const Map) ![2]usize {
        var seen = std.AutoHashMap(Search, void).init(aoc.halloc);
        defer seen.deinit();
        var back: [8192]Search = undefined;
        var work = aoc.Deque(Search).init(back[0..]);
        try work.push(Search{ .x = 1, .y = 0, .t = 0, .start = false, .end = false });
        var p1: usize = 0;
        while (work.pop()) |cur| {
            if ((try seen.getOrPut(cur)).found_existing) {
                continue;
            }
            var end = cur.end;
            var start = cur.start;
            if (cur.y == self.h - 1) {
                if (start and end) {
                    return [2]usize{ p1, cur.t - 1 };
                }
                if (p1 == 0) {
                    p1 = cur.t - 1;
                }
                end = true;
            } else if (end and cur.y == 0) {
                start = true;
            }
            if (!self.m[cur.t][cur.x - 1 + cur.y * self.w]) {
                try work.push(Search{
                    .x = cur.x - 1,
                    .y = cur.y,
                    .t = cur.t + 1,
                    .start = start,
                    .end = end,
                });
            }
            if (!self.m[cur.t][cur.x + 1 + cur.y * self.w]) {
                try work.push(Search{
                    .x = cur.x + 1,
                    .y = cur.y,
                    .t = cur.t + 1,
                    .start = start,
                    .end = end,
                });
            }
            if (cur.y > 0 and !self.m[cur.t][cur.x + (cur.y - 1) * self.w]) {
                try work.push(Search{
                    .x = cur.x,
                    .y = cur.y - 1,
                    .t = cur.t + 1,
                    .start = start,
                    .end = end,
                });
            }
            if (cur.y < self.h - 1 and !self.m[cur.t][cur.x + (cur.y + 1) * self.w]) {
                try work.push(Search{
                    .x = cur.x,
                    .y = cur.y + 1,
                    .t = cur.t + 1,
                    .start = start,
                    .end = end,
                });
            }
            if (!self.m[cur.t][cur.x + cur.y * self.w]) {
                try work.push(Search{
                    .x = cur.x,
                    .y = cur.y,
                    .t = cur.t + 1,
                    .start = start,
                    .end = end,
                });
            }
        }
        unreachable;
    }
};

fn parts(inp: []const u8) anyerror![2]usize {
    const w = std.mem.indexOfScalar(u8, inp, '\n').?;
    const h = inp.len / (w + 1);
    var m = Map{
        .m = .{.{false} ** 3800} ** 1000,
        .w = w,
        .h = h,
    };
    try m.init(inp);
    return try m.parts();
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
