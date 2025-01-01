const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "testcases" {
    try aoc.TestCases(isize, parts);
}

const Rec = struct {
    ch: u8,
    p1: isize,
    p2: isize,
    has_red: bool,
};

fn parts(inp: []const u8) anyerror![2]isize {
    var num = false;
    var neg = false;
    var n: isize = 0;
    var stack: [512]Rec = .{Rec{ .ch = '_', .has_red = false, .p1 = 0, .p2 = 0 }} ** 512;
    var j: usize = 0;
    for (inp, 0..) |ch, i| {
        switch (ch) {
            '[' => {
                j += 1;
                stack[j].ch = ']';
                stack[j].has_red = false;
                stack[j].p1 = 0;
                stack[j].p2 = 0;
            },
            '{' => {
                j += 1;
                stack[j].ch = '}';
                stack[j].has_red = false;
                stack[j].p1 = 0;
                stack[j].p2 = 0;
            },
            '}' => {
                if (num) {
                    num = false;
                    if (neg) {
                        stack[j].p1 -= n;
                        stack[j].p2 -= n;
                    } else {
                        stack[j].p1 += n;
                        stack[j].p2 += n;
                    }
                    n = 0;
                }
                neg = false;
                stack[j - 1].p1 += stack[j].p1;
                if (!stack[j].has_red) {
                    stack[j - 1].p2 += stack[j].p2;
                }
                j -= 1;
            },
            ']' => {
                if (num) {
                    num = false;
                    if (neg) {
                        stack[j].p1 -= n;
                        stack[j].p2 -= n;
                    } else {
                        stack[j].p1 += n;
                        stack[j].p2 += n;
                    }
                    n = 0;
                }
                neg = false;
                stack[j - 1].p1 += stack[j].p1;
                stack[j - 1].p2 += stack[j].p2;
                j -= 1;
            },
            ':' => {
                if (inp[i + 1] == '"' and
                    inp[i + 2] == 'r' and
                    inp[i + 3] == 'e' and
                    inp[i + 4] == 'd' and
                    inp[i + 5] == '"')
                {
                    stack[j].has_red = true;
                }
            },
            '-' => {
                neg = true;
            },
            '0'...'9' => {
                num = true;
                n = n * 10 + @as(isize, ch - '0');
            },
            else => {
                if (num) {
                    num = false;
                    if (neg) {
                        stack[j].p1 -= n;
                        stack[j].p2 -= n;
                    } else {
                        stack[j].p1 += n;
                        stack[j].p2 += n;
                    }
                    n = 0;
                }
                neg = false;
            },
        }
    }
    if (j != 0) {
        unreachable;
    }
    return [2]isize{ stack[0].p1, stack[0].p2 };
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
