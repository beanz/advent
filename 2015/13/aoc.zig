const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var ppl = try std.BoundedArray(u8, 32).init(0);
    var points: [256]isize = .{0} ** 256;
    {
        var seen: [32]bool = .{false} ** 32;
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            const a = inp[i] - 'A';
            i += 1;
            while (inp[i] != ' ') : (i += 1) {}
            i += 7;
            const neg = inp[i] == 'l';
            i += 5;
            var p = try aoc.chompUint(isize, inp, &i);
            if (neg) {
                p *= -1;
            }
            i += 36;
            const b = inp[i] - 'A';
            i += 1;
            while (inp[i] != '\n') : (i += 1) {}
            points[a * 16 + b] += p;
            points[b * 16 + a] += p;
            if (!seen[a]) {
                try ppl.append(a);
                seen[a] = true;
            }
            if (!seen[b]) {
                try ppl.append(b);
                seen[b] = true;
            }
        }
    }
    var p1: isize = 0;
    {
        var people = ppl.slice();
        var iter = aoc.permute(u8, people[0..]);
        while (iter.next()) |p| {
            var s: isize = 0;
            for (0..p.len - 1) |i| {
                s += points[p[i] * 16 + p[i + 1]];
            }
            s += points[p[0] * 16 + p[p.len - 1]];
            if (s > p1) {
                p1 = s;
            }
        }
    }
    var p2: isize = 0;
    {
        try ppl.append(13);
        var people = ppl.slice();
        var iter = aoc.permute(u8, people[0..]);
        while (iter.next()) |p| {
            var s: isize = 0;
            for (0..p.len - 1) |i| {
                s += points[p[i] * 16 + p[i + 1]];
            }
            s += points[p[0] * 16 + p[p.len - 1]];
            if (s > p2) {
                p2 = s;
            }
        }
    }
    return [2]usize{ @as(usize, @intCast(p1)), @as(usize, @intCast(p2)) };
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
