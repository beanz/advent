const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases([16]u8, parts);
}

fn parts(inp: []const u8) anyerror![2][16]u8 {
    var line: [16]u8 = [16]u8{ 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p' };

    try once(inp, line[0..]);
    var p1: [16]u8 = undefined;
    std.mem.copyForwards(u8, &p1, &line);
    const end = 10000000;
    var seen = std.StringHashMap(usize).init(aoc.halloc);
    defer seen.deinit();
    var cycle = false;
    var c: usize = 1;
    while (c < end) : (c += 1) {
        try once(inp, line[0..]);
        if (!cycle) {
            if (seen.get(&line)) |seen_c| {
                const remaining = end - c;
                const len = c - seen_c;
                c += (remaining / len) * len;
                cycle = true;
            }
        }
        const key = try aoc.halloc.dupe(u8, &line);
        try seen.put(key, c);
    }
    return [2][16]u8{ p1, line };
}

fn once(inp: []const u8, line: *[16]u8) anyerror!void {
    var i: usize = 0;
    while (i < inp.len) : (i += 1) {
        switch (inp[i]) {
            's' => {
                i += 1;
                const n = try aoc.chompUint(usize, inp, &i);
                std.mem.rotate(u8, line, 16 - n);
            },
            'x' => {
                i += 1;
                const n = try aoc.chompUint(usize, inp, &i);
                i += 1;
                const m = try aoc.chompUint(usize, inp, &i);
                std.mem.swap(u8, &line[n], &line[m]);
            },
            'p' => {
                const j = std.mem.indexOfScalar(u8, line, inp[i + 1]).?;
                const k = std.mem.indexOfScalar(u8, line, inp[i + 3]).?;
                std.mem.swap(u8, &line[j], &line[k]);
                i += 4;
            },
            else => unreachable,
        }
    }
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    const p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {s}\nPart2: {s}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}
