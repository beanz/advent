const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "digit" {
    const t: []const u8 = "12\n";
    try aoc.assertEq(@as(u32, 1), digit(t, 0).?);
    try aoc.assertEq(@as(u32, 2), digit(t, 1).?);
    try aoc.assertEq(@as(u32, 99), digit(t, 2) orelse 99);
    try aoc.assertEq(@as(u32, 0), digit(t, 4).?);
}

fn digit(inp: []const u8, i: usize) ?u32 {
    if (i >= inp.len) {
        return 0;
    }
    switch (inp[i]) {
        '\n' => return null,
        '1', '2', '3', '4', '5', '6', '7', '8', '9' => return @as(u32, inp[i] - '0'),
        else => return 0,
    }
}

test "word" {
    try aoc.assertEq(@as(u32, 1), word("one", 0));
    try aoc.assertEq(@as(u32, 2), word("two", 0));
    try aoc.assertEq(@as(u32, 3), word("three", 0));
    try aoc.assertEq(@as(u32, 4), word("four", 0));
    try aoc.assertEq(@as(u32, 5), word("five", 0));
    try aoc.assertEq(@as(u32, 6), word("six", 0));
    try aoc.assertEq(@as(u32, 7), word("seven", 0));
    try aoc.assertEq(@as(u32, 8), word("eight", 0));
    try aoc.assertEq(@as(u32, 9), word("nine", 0));
    try aoc.assertEq(@as(u32, 0), word("foo", 0));
}

fn word(inp: []const u8, i: usize) u32 {
    switch (inp[i]) {
        'o' => if ((inp.len > i + 2) and (inp[i + 1] == 'n') and (inp[i + 2] == 'e')) {
            return 1;
        },
        't' => if ((inp.len > i + 2) and (inp[i + 1] == 'w') and (inp[i + 2] == 'o')) {
            return 2;
        } else if ((inp.len > i + 4) and (inp[i + 1] == 'h') and (inp[i + 2] == 'r') and (inp[i + 3] == 'e') and (inp[i + 4] == 'e')) {
            return 3;
        },
        'f' => if ((inp.len > i + 3) and (inp[i + 1] == 'o') and (inp[i + 2] == 'u') and (inp[i + 3] == 'r')) {
            return 4;
        } else if ((inp.len > i + 3) and (inp[i + 1] == 'i') and (inp[i + 2] == 'v') and (inp[i + 3] == 'e')) {
            return 5;
        },
        's' => if ((inp.len > i + 2) and (inp[i + 1] == 'i') and (inp[i + 2] == 'x')) {
            return 6;
        } else if ((inp.len > i + 4) and (inp[i + 1] == 'e') and (inp[i + 2] == 'v') and (inp[i + 3] == 'e') and (inp[i + 4] == 'n')) {
            return 7;
        },
        'e' => if ((inp.len > i + 4) and (inp[i + 1] == 'i') and (inp[i + 2] == 'g') and (inp[i + 3] == 'h') and (inp[i + 4] == 't')) {
            return 8;
        },
        'n' => if ((inp.len > i + 3) and (inp[i + 1] == 'i') and (inp[i + 2] == 'n') and (inp[i + 3] == 'e')) {
            return 9;
        },
        else => return 0,
    }
    return 0;
}

test "examples" {
    const overlap0 = try parts("twone\n");
    try aoc.assertEq(@as(u32, 0), overlap0[0]);
    try aoc.assertEq(@as(u32, 21), overlap0[1]);
    const overlap1 = try parts("eightwo\n");
    try aoc.assertEq(@as(u32, 0), overlap1[0]);
    try aoc.assertEq(@as(u32, 82), overlap1[1]);
    try aoc.TestCases(u32, parts);
}

fn parts(inp: []const u8) ![2]u32 {
    var p1: u32 = 0;
    var p2: u32 = 0;
    var f1: u32 = 0;
    var l1: u32 = 0;
    var f2: u32 = 0;
    var l2: u32 = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        var d = digit(inp, i) orelse {
            p1 += f1 * 10 + l1;
            f1 = 0;
            l1 = 0;
            p2 += f2 * 10 + l2;
            f2 = 0;
            l2 = 0;
            continue;
        };
        if (d != 0) {
            if (f1 == 0) {
                f1 = d;
            }
            if (f2 == 0) {
                f2 = d;
            }
            l1 = d;
            l2 = d;
            continue;
        }
        d = word(inp, i);
        if (d != 0) {
            if (f2 == 0) {
                f2 = d;
            }
            l2 = d;
        }
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
