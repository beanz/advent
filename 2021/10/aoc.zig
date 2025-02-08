const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: [128]usize = undefined;
    var p2l: usize = 0;
    var stack: [128]u8 = undefined;
    var sp: usize = 0;
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        const ch = inp[i];
        switch (ch) {
            '(' => {
                stack[sp] = ')';
                sp += 1;
            },
            '[', '{', '<' => {
                stack[sp] = ch + 2;
                sp += 1;
            },
            '\n' => {
                var s: usize = 0;
                while (sp > 0) {
                    sp -= 1;
                    s = s * 5 + score2(stack[sp]);
                }
                p2[p2l] = s;
                p2l += 1;
            },
            else => {
                sp -= 1;
                const exp = stack[sp];
                if (exp != ch) {
                    p1 += score1(ch);
                    while (inp[i] != '\n') : (i += 1) {}
                    sp = 0;
                }
            },
        }
    }
    const scores = p2[0..p2l];
    std.mem.sort(usize, scores, {}, std.sort.asc(usize));
    return [2]usize{ p1, scores[scores.len / 2] };
}

fn score1(ch: u8) usize {
    return switch (ch) {
        ')' => 3,
        ']' => 57,
        '}' => 1197,
        '>' => 25137,
        else => unreachable,
    };
}

fn score2(ch: u8) usize {
    return switch (ch) {
        ')' => 1,
        ']' => 2,
        '}' => 3,
        '>' => 4,
        else => unreachable,
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
