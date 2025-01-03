const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var b = try std.BoundedArray([2][]const u8, 64).init(0);
    var start: []const u8 = undefined;
    {
        var i: usize = 0;
        while (i < inp.len) : (i += 1) {
            if (inp[i] == '\n') {
                break;
            }
            var j: usize = i;
            while (inp[i] != ' ') : (i += 1) {}
            const from = inp[j..i];
            i += 4;
            j = i;
            while (inp[i] != '\n') : (i += 1) {}
            const to = inp[j..i];
            try b.append([2][]const u8{ from, to });
        }
        start = inp[i + 1 .. inp.len - 1];
    }
    const reps = b.slice();
    var new = std.StringHashMap(bool).init(aoc.halloc);
    defer new.deinit();
    for (reps) |sr| {
        for (0..start.len - sr[0].len + 1) |i| {
            var match = true;
            for (sr[0], 0..) |ch, j| {
                if (start[i + j] != ch) {
                    match = false;
                    break;
                }
            }
            if (!match) {
                continue;
            }
            var word: []u8 = try aoc.halloc.alloc(u8, start.len + sr[1].len - sr[0].len);
            for (0..i) |j| {
                word[j] = start[j];
            }
            for (sr[1], 0..) |ch, j| {
                word[i + j] = ch;
            }
            for (i + sr[0].len..start.len) |j| {
                word[j + sr[1].len - sr[0].len] = start[j];
            }
            const res: []const u8 = word[0..];
            try new.put(res, true);
        }
    }
    const p1 = new.count();
    {
        var it = new.keyIterator();
        while (it.next()) |k| {
            aoc.halloc.free(k.*);
        }
    }
    var upper: usize = 0;
    var y: usize = 0;
    var rn: usize = 0;
    var ar: usize = 0;
    for (0..start.len) |i| {
        if (start[i] < 'a') {
            upper += 1;
        }
        if (start[i] == 'Y') {
            y += 1;
        }
        if (i + 1 == start.len) {
            continue;
        }
        if (start[i] == 'R' and start[i + 1] == 'n') {
            rn += 1;
        } else if (start[i] == 'A' and start[i + 1] == 'r') {
            ar += 1;
        }
    }
    return [2]usize{ p1, upper - rn - ar - 2 * y - 1 };
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
