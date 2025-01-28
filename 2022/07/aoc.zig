const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    const used = total: {
        var t: usize = 0;
        var n: usize = 0;
        for (inp) |ch| {
            switch (ch) {
                '0'...'9' => n = 10 * n + @as(usize, @intCast(ch & 0xf)),
                else => {
                    t += n;
                    n = 0;
                },
            }
        }
        break :total t;
    };
    var p1: usize = 0;
    var min: usize = 70000000;
    const need = 30000000 - (min - used);
    var i: usize = 7;
    var c: usize = 0;
    var stack: [80]usize = undefined;
    var sp: usize = 0;
    while (i < inp.len) : (i += 1) {
        if ('0' <= inp[i] and inp[i] <= '9') {
            const n = try aoc.chompUint(usize, inp, &i);
            i += 1;
            c += n;
        } else if (inp[i + 5] == '.') {
            if (c < 100000) {
                p1 += c;
            } else if (c < min and c > need) {
                min = c;
            }
            sp -= 1;
            c += stack[sp];
        } else if (inp[i + 2] == 'c') {
            i += 6;
            stack[sp] = c;
            sp += 1;
            c = 0;
        }
        while (inp[i] != '\n') : (i += 1) {}
    }
    if (c < 100000) {
        p1 += c;
    } else if (c < min and c > need) {
        min = c;
    }
    return [2]usize{ p1, min };
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
