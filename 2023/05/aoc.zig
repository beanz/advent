const std = @import("std");
const aoc = @import("aoc-lib.zig");
const isDigit = std.ascii.isDigit;

test "examples" {
    var t1 = try parts(aoc.test1file);
    try aoc.assertEq(@as(i32, 35), t1[0]);
    try aoc.assertEq(@as(i32, 46), t1[1]);
    var p = try parts(aoc.inputfile);
    try aoc.assertEq(@as(i32, 535088217), p[0]);
    try aoc.assertEq(@as(i32, 51399228), p[1]);
}

fn parts(inp: []const u8) ![2]usize {
    const Seed = struct {
        seed: usize,
        end: usize,
    };
    var seed_b = try std.BoundedArray(Seed, 21).init(0);
    var i: usize = 7;
    while (i < inp.len) : (i += 1) {
        var n = try aoc.chompUint(usize, inp, &i);
        try seed_b.append(Seed{ .seed = n, .end = n });
        if (inp[i] == '\n') {
            break;
        }
    }
    var seeds = seed_b.slice();
    var seed_ranges = try std.BoundedArray(Seed, 128).init(0);
    for (0..seeds.len / 2) |j| {
        var start = seeds[j * 2].seed;
        var end = start + seeds[j * 2 + 1].seed;
        try seed_ranges.append(Seed{ .seed = start, .end = end });
    }
    i += 2;
    while (i < inp.len) : (i += 1) {
        while (inp[i] != '\n') : (i += 1) {}
        i += 1;
        var map = try std.BoundedArray(usize, 1024).init(0);
        while (i < inp.len) : (i += 1) {
            var n = try aoc.chompUint(usize, inp, &i);
            try map.append(n);
            if (inp[i] == '\n' and i + 1 < inp.len and inp[i + 1] == '\n') {
                break;
            }
        }
        i += 1;
        for (0..seeds.len) |l| {
            for (0..map.len / 3) |k| {
                var dst = map.get(k * 3);
                var src = map.get(k * 3 + 1);
                var len = map.get(k * 3 + 2);
                if (src <= seeds[l].end and seeds[l].end < src + len) {
                    seeds[l].end = dst + seeds[l].end - src;
                    break;
                }
            }
        }
        var mapped = try std.BoundedArray(Seed, 128).init(0);
        outer: while (seed_ranges.len > 0) {
            var p = seed_ranges.pop();
            var start = p.seed;
            var end = p.end;
            for (0..map.len / 3) |k| {
                var dst = map.get(k * 3);
                var src = map.get(k * 3 + 1);
                var src_end = src + map.get(k * 3 + 2);
                var before_start = start;
                var before_end = aoc.min(usize, end, src);
                var overlap_start = aoc.max(usize, start, src);
                var overlap_end = aoc.min(usize, src_end, end);
                var after_start = aoc.max(usize, src_end, start);
                var after_end = end;
                if (overlap_end > overlap_start) {
                    try mapped.append(Seed{ .seed = overlap_start + dst - src, .end = overlap_end + dst - src });
                } else {
                    continue;
                }
                if (before_end > before_start) {
                    try seed_ranges.append(Seed{ .seed = before_start, .end = before_end });
                }
                if (after_end > after_start) {
                    try seed_ranges.append(Seed{ .seed = after_start, .end = after_end });
                }
                continue :outer;
            }
            try mapped.append(Seed{ .seed = start, .end = end });
        }
        std.mem.swap(std.BoundedArray(Seed, 128), &seed_ranges, &mapped);
    }
    var p1 = seeds[0].end;
    for (1..seeds.len) |k| {
        var v = seeds[k];
        if (p1 > v.end) {
            p1 = v.end;
        }
    }
    var p2 = seed_ranges.get(0).seed;
    for (1..seed_ranges.len) |k| {
        var v = seed_ranges.get(k);
        if (p2 > v.seed) {
            p2 = v.seed;
        }
    }
    return [2]usize{ p1, p2 };
}

fn day(inp: []const u8, bench: bool) anyerror!void {
    var p = try parts(inp);
    if (!bench) {
        aoc.print("Part1: {}\nPart2: {}\n", .{ p[0], p[1] });
    }
}

pub fn main() anyerror!void {
    try aoc.benchme(aoc.input(), day);
}