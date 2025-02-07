const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCasesRes(Res, parts);
}

const ANS_LEN = 20;
const Res = struct {
    p1: [ANS_LEN]u8,
    p2: usize,
};

fn parts(inp: []const u8) anyerror!Res {
    var s: usize = 0;
    var n: usize = 0;
    for (inp) |ch| {
        switch (ch) {
            '\n' => {
                s += n;
                n = 0;
            },
            '2' => n = 5 * n + 2,
            '1' => n = 5 * n + 1,
            '0' => n *= 5,
            '-' => n = 5 * n - 1,
            '=' => n = 5 * n - 2,
            else => unreachable,
        }
    }
    var res = Res{ .p1 = .{32} ** ANS_LEN, .p2 = 0 };
    var l: usize = ANS_LEN - 1;
    while (true) {
        switch (s % 5) {
            0 => {
                res.p1[l] = '0';
                s /= 5;
            },
            1 => {
                res.p1[l] = '1';
                s /= 5;
            },
            2 => {
                res.p1[l] = '2';
                s /= 5;
            },
            3 => {
                res.p1[l] = '=';
                s = @divTrunc(s + 2, 5);
            },
            4 => {
                res.p1[l] = '-';
                s = @divTrunc(s + 1, 5);
            },
            else => unreachable,
        }
        if (s == 0) {
            break;
        }
        l -= 1;
    }
    return res;
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {}\n", .{ p.p1, p.p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
