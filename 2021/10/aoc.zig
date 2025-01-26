const std = @import("std");
const aoc = @import("aoc-lib.zig");

fn syntax(in: []const u8) ![2]usize {
    var r = [2]usize{ 0, 0 };
    var p2 = try std.BoundedArray(usize, 100).init(0);
    var stack = try std.BoundedArray(u8, 100).init(0);
    var i: usize = 0;
    while (i < in.len) : (i += 1) {
        const ch = in[i];
        switch (ch) {
            '(', '[', '{', '<' => {
                var rch = ch + 2;
                if (ch == '(') {
                    rch = ')';
                }
                try stack.append(rch);
            },
            '\n' => {
                var s: usize = 0;
                var e = stack.popOrNull();
                while (e != null) : (e = stack.popOrNull()) {
                    s = s * 5 + score2(e.?);
                }
                try p2.append(s);
            },
            else => {
                const exp = stack.pop();
                if (exp != ch) {
                    r[0] += score1(ch);
                    while (in[i] != '\n') : (i += 1) {}
                    try stack.resize(0);
                }
            },
        }
    }
    const scores = p2.slice();
    std.mem.sort(usize, scores, {}, std.sort.asc(usize));
    r[1] = scores[scores.len / 2];
    return r;
}

fn score1(ch: u8) usize {
    switch (ch) {
        ')' => return 3,
        ']' => return 57,
        '}' => return 1197,
        '>' => return 25137,
        else => unreachable,
    }
}

fn score2(ch: u8) usize {
    switch (ch) {
        ')' => return 1,
        ']' => return 2,
        '}' => return 3,
        '>' => return 4,
        else => unreachable,
    }
}

test "examples" {
    const test1 = try syntax(aoc.test1file);
    const real = try syntax(aoc.inputfile);
    try aoc.assertEq(@as(usize, 26397), test1[0]);
    try aoc.assertEq(@as(usize, 390993), real[0]);
    try aoc.assertEq(@as(usize, 288957), test1[1]);
    try aoc.assertEq(@as(usize, 2391385187), real[1]);
}

fn day10(inp: []const u8, bench: bool) anyerror!void {
    const p = try syntax(inp);
    if (!bench) {
        aoc.print("Part 1: {}\nPart 2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day10);
}
