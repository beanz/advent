const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "examples" {
    try aoc.assertEq(@as(usize, 2), part1(aoc.test1file));
    try aoc.assertEq(@as(usize, 1), part2(aoc.test1file));
    try aoc.assertEq(@as(usize, 454), part1(aoc.inputfile));
    try aoc.assertEq(@as(usize, 649), part2(aoc.inputfile));
}

fn part1(inp: anytype) usize {
    var lit = std.mem.split(u8, inp, "\n");
    var c: usize = 0;
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var fit = std.mem.tokenize(u8, line, "- :");
        const n1 = std.fmt.parseInt(i64, fit.next().?, 10) catch unreachable;
        const n2 = std.fmt.parseInt(i64, fit.next().?, 10) catch unreachable;
        const ch = (fit.next().?)[0];
        const str = fit.next().?;
        var cc: i64 = 0;
        for (str) |tch| {
            if (tch == ch) {
                cc += 1;
            }
        }
        if (cc >= n1 and cc <= n2) {
            c += 1;
        }
    }
    return c;
}

fn part2(inp: anytype) usize {
    var lit = std.mem.split(u8, inp, "\n");
    var c: usize = 0;
    while (lit.next()) |line| {
        if (line.len == 0) {
            break;
        }
        var fit = std.mem.tokenize(u8, line, "- :");
        const n1 = std.fmt.parseUnsigned(usize, fit.next().?, 10) catch unreachable;
        const n2 = std.fmt.parseUnsigned(usize, fit.next().?, 10) catch unreachable;
        const ch = (fit.next().?)[0];
        const str = fit.next().?;
        var cc: i64 = 0;
        for (str) |tch| {
            if (tch == ch) {
                cc += 1;
            }
        }
        const first = str[n1 - 1] == ch;
        const second = str[n2 - 1] == ch;
        if ((first or second) and !(first and second)) {
            c += 1;
        }
    }
    return c;
}

fn day02(inp: []const u8, bench: bool) anyerror!void {
    var p1 = part1(inp);
    var p2 = part2(inp);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p1, p2 });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day02);
}
