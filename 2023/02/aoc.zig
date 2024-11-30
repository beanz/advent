const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn chompUint(comptime T: type, inp: anytype, i: *usize) anyerror!T {
    var n: T = 0;
    std.debug.assert(i.* < inp.len and '0' <= inp[i.*] and inp[i.*] <= '9');
    while (i.* < inp.len) : (i.* += 1) {
        if ('0' <= inp[i.*] and inp[i.*] <= '9') {
            n = n * 10 + @as(T, inp[i.*] - '0');
            continue;
        }
        break;
    }
    return n;
}

test "examples" {
    try aoc.TestCases(u32, parts);
}

fn parts(inp: []const u8) ![2]u32 {
    var p1: u32 = 0;
    var p2: u32 = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        var mr: u32 = 1;
        var mg: u32 = 1;
        var mb: u32 = 1;
        i += 5;
        const id = try chompUint(u32, inp, &i);
        while (inp[i] != '\n') {
            i += 2;
            const n = try chompUint(u32, inp, &i);
            i += 1;
            switch (inp[i]) {
                'r' => {
                    if (mr < n) {
                        mr = n;
                    }
                    i += 3;
                },
                'g' => {
                    if (mg < n) {
                        mg = n;
                    }
                    i += 5;
                },
                'b' => {
                    if (mb < n) {
                        mb = n;
                    }
                    i += 4;
                },
                else => unreachable,
            }
        }
        if (mr <= 12 and mg <= 13 and mb <= 14) {
            p1 += id;
        }
        p2 += mr * mg * mb;
    }
    return [2]u32{ p1, p2 };
}

fn day01(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day01);
}
