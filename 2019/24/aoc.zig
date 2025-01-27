const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn bit(n: usize) u32 {
    return @as(u32, 1) << @as(u5, @intCast(24 - n));
}

const NEIGHBORS = nb: {
    var res: [25]u32 = undefined;
    for (0..5) |y| {
        for (0..5) |x| {
            const i = x + y * 5;
            res[i] = if (x > 0) bit(x - 1 + y * 5) else 0;
            res[i] |= if (x < 4) bit(x + 1 + y * 5) else 0;
            res[i] |= if (y > 0) bit(x + (y - 1) * 5) else 0;
            res[i] |= if (y < 4) bit(x + (y + 1) * 5) else 0;
        }
    }
    break :nb res;
};

const OUTER = out: {
    var res: [25]u32 = .{0} ** 25;
    for (0..5) |y| {
        {
            const i = y * 5;
            res[i] |= bit(11);
        }
        {
            const i = 4 + y * 5;
            res[i] |= bit(13);
        }
    }
    for (0..5) |x| {
        {
            res[x] |= bit(7);
        }
        {
            const i = x + 4 * 5;
            res[i] |= bit(17);
        }
    }
    break :out res;
};

const INNER = in: {
    var res: [25]u32 = .{0} ** 25;
    for (0..5) |n| {
        res[7] |= bit(n);
        res[11] |= bit(n * 5);
        res[13] |= bit(4 + n * 5);
        res[17] |= bit(n + 4 * 5);
    }
    break :in res;
};

fn parts(inp: []const u8) anyerror![2]usize {
    const initial = read: {
        var state: u32 = 0;
        var b: u32 = 1;
        for (inp) |ch| {
            switch (ch) {
                '\n' => {},
                '.' => {
                    b <<= 1;
                },
                '#' => {
                    state |= b;
                    b <<= 1;
                },
                else => unreachable,
            }
        }
        break :read state;
    };
    //aoc.print("{b:0>25}\n", .{initial});
    var p1 = initial;
    {
        var seen = std.AutoHashMap(u32, void).init(aoc.halloc);
        while (!(try seen.getOrPut(p1)).found_existing) {
            var next: u32 = 0;
            for (0..25) |i| {
                const b = bit(i);
                const live = p1 & b != 0;
                const n = @popCount(NEIGHBORS[i] & p1);
                if (n == 1 or (!live and n == 2)) {
                    next |= b;
                }
            }
            p1 = next;
        }
    }

    var levels: [403]u32 = .{0} ** 403;
    var next: [403]u32 = .{0} ** 403;
    levels[201] = initial;
    for (1..201) |depth| {
        for (201 - depth..202 + depth) |level| {
            next[level] = 0;
            for (0..25) |i| {
                if (i == 12) {
                    continue;
                }
                const b = bit(i);
                const live = levels[level] & b != 0;
                const n = @popCount(NEIGHBORS[i] & levels[level]) +
                    @popCount(OUTER[i] & levels[level - 1]) +
                    @popCount(INNER[i] & levels[level + 1]);
                if (n == 1 or (!live and n == 2)) {
                    next[level] |= b;
                }
            }
        }
        std.mem.swap([403]u32, &levels, &next);
    }

    var p2: usize = 0;
    for (levels) |level| {
        p2 += @popCount(level);
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
