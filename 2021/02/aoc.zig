const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn parts(inp: []const u8) [2]u64 {
    var x1: u64 = 0;
    var y1: u64 = 0;
    var x2: u64 = 0;
    var y2: u64 = 0;
    var a: u64 = 0;
    var i: usize = 0;
    while (i < inp.len) {
        switch (inp[i]) {
            'f' => {
                var u = inp[i + 8] - '0';
                x1 += u;
                x2 += u;
                y2 += a * u;
                i += 10;
            },
            'd' => {
                var u = inp[i + 5] - '0';
                y1 += u;
                a += u;
                i += 7;
            },
            'u' => {
                var u = inp[i + 3] - '0';
                y1 -= u;
                a -= u;
                i += 5;
            },
            else => {
                unreachable;
            },
        }
    }
    return [2]u64{ x1 * y1, x2 * y2 };
}

test "examples" {
    var t = parts(aoc.test1file);
    try aoc.assertEq(@as(u64, 150), t[0]);
    try aoc.assertEq(@as(u64, 900), t[1]);

    var ti = parts(aoc.inputfile);
    try aoc.assertEq(@as(u64, 1714950), ti[0]);
    try aoc.assertEq(@as(u64, 1281977850), ti[1]);
}

fn day02(inp: []const u8, bench: bool) anyerror!void {
    var p = parts(inp);
    if (!bench) {
        try aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day02);
}
