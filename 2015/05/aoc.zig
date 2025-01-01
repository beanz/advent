const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var vowels: usize = 0;
    var has_repeat = false;
    var has_repeat2 = false;
    var has_pair_repeat = false;
    var has_bad = false;
    var prev: u8 = '{';
    var prevprev: u8 = '}';
    var seen: [1024]usize = .{0} ** 1024;
    var j: usize = 1;
    for (inp, 1..) |ch, i| {
        has_repeat = has_repeat or ch == prev;
        has_bad = has_bad or (prev == 'a' and ch == 'b') or (prev == 'c' and ch == 'd') or (prev == 'p' and ch == 'q') or (prev == 'x' and ch == 'y');
        has_repeat2 = has_repeat2 or ch == prevprev;
        if (ch != '\n') {
            const k: usize = (@as(usize, prev & 0x1f) << 5) + @as(usize, ch & 0x1f);
            if (seen[k] >= j) {
                if (seen[k] + 1 < i) {
                    has_pair_repeat = true;
                }
            } else {
                seen[k] = i;
            }
        }
        switch (ch) {
            'a', 'e', 'i', 'o', 'u' => {
                vowels += 1;
            },
            '\n' => {
                if (has_repeat and !has_bad and vowels >= 3) {
                    p1 += 1;
                }
                if (has_repeat2 and has_pair_repeat) {
                    p2 += 1;
                }
                j = i;
                has_repeat = false;
                has_bad = false;
                has_repeat2 = false;
                has_pair_repeat = false;
                vowels = 0;
                prev = '{';
                prevprev = '}';
                continue;
            },
            else => {},
        }
        prevprev = prev;
        prev = ch;
    }

    return [2]usize{ p1, p2 };
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
