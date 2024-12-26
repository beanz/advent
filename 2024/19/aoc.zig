const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(usize, parts);
}

const WAYS_SIZE: usize = 64;

fn parts(inp: []const u8) anyerror![2]usize {
    var i: usize = 0;
    var pattern: usize = 0;
    var patterns = std.hash_map.AutoHashMap(usize, bool).init(aoc.halloc);
    PL: while (true) {
        switch (inp[i]) {
            ',' => {
                try patterns.put(pattern, true);
                pattern = 0;
                i += 2;
            },
            '\n' => {
                try patterns.put(pattern, true);
                i += 2;
                break :PL;
            },
            else => {
                pattern = (pattern << 3) + @as(usize, col(inp[i]));
                i += 1;
            },
        }
    }
    var p1: usize = 0;
    var p2: usize = 0;
    var j = i;
    while (i < inp.len) : (i += 1) {
        if (inp[i] != '\n') {
            continue;
        }
        const towel = inp[j..i];
        const tl = towel.len;
        j = i + 1;
        var ways: [WAYS_SIZE]usize = .{0} ** WAYS_SIZE;
        ways[0] = 1;
        for (0..tl) |ii| {
            if (ways[ii] == 0) {
                continue;
            }
            var t: usize = 0;
            for (0..8) |jj| {
                if (ii + jj >= tl) {
                    break;
                }
                t = (t << 3) + col(towel[ii + jj]);
                if (patterns.contains(t)) {
                    ways[ii + jj + 1] += ways[ii];
                }
            }
        }
        const matches = ways[tl];
        if (matches != 0) {
            p1 += 1;
            p2 += matches;
        }
    }
    return [2]usize{ p1, p2 };
}

inline fn col(ch: u8) u3 {
    return switch (ch) {
        'b' => 1,
        'g' => 2,
        'r' => 3,
        'u' => 4,
        else => 5,
    };
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
