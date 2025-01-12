const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const Res = struct {
    p1: usize,
    p2: [25]u8,
};

fn parts(inp: []const u8) anyerror!Res {
    var cc: [26]u8 = .{0} ** 26;
    var two: usize = 0;
    var three: usize = 0;
    var l: usize = 0;
    var s = try std.BoundedArray(usize, 256).init(0);
    {
        var i: usize = 0;
        var j: usize = 0;
        while (i < inp.len) : (i += 1) {
            switch (inp[i]) {
                '\n' => {
                    var inc2: usize = 0;
                    var inc3: usize = 0;
                    for (&cc) |*c| {
                        switch (c.*) {
                            2 => inc2 = 1,
                            3 => inc3 = 1,
                            else => {},
                        }
                        c.* = 0;
                    }
                    two += inc2;
                    three += inc3;
                    try s.append(j);
                    l = i - j;
                    j = i + 1;
                },
                'a'...'z' => cc[@as(usize, @intCast(inp[i] - 'a'))] += 1,
                else => unreachable,
            }
        }
    }
    var p2: [25]u8 = .{32} ** 25;
    const lines = s.slice();
    LOOP: for (0..lines.len) |i| {
        for (i + 1..lines.len) |j| {
            var m: usize = 0;
            for (0..l) |k| {
                if (inp[lines[i] + k] == inp[lines[j] + k]) {
                    m += 1;
                }
            }
            if (m != l - 1) {
                continue;
            }
            m = 0;
            for (0..l) |k| {
                if (inp[lines[i] + k] == inp[lines[j] + k]) {
                    p2[m] = inp[lines[j] + k];
                    m += 1;
                }
            }
            break :LOOP;
        }
    }

    return Res{ .p1 = two * three, .p2 = p2 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {s}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
