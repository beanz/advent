const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var p1: usize = 0;
    var p2: usize = 0;
    var i: usize = 0;
    var cache = std.AutoHashMap(usize, usize).init(aoc.halloc);
    while (i < inp.len) : (i += 2) {
        const j = i;
        const n = try aoc.chompUint(usize, inp, &i);
        const l = move_len(inp[j .. i + 1], 2, &cache);
        // aoc.print("{} += {s} {} * {}\n", .{ p1, inp[j .. i + 1], n, l });
        p1 += n * l;
        const l2 = move_len(inp[j .. i + 1], 25, &cache);
        p2 += n * l2;
    }
    return [2]usize{ p1, p2 };
}

inline fn cache_key(path: []const u8, depth: usize) usize {
    var k: usize = 0;
    for (path) |ch| {
        k = (k << 8) + @as(usize, ch);
    }
    k = (k << 8) + depth;
    return k;
}

fn move_len(path: []const u8, depth: u8, cache: *std.AutoHashMap(usize, usize)) usize {
    var l: usize = 0;
    const k = cache_key(path, depth);
    if (cache.get(k)) |res| {
        return res;
    }
    var cur: u8 = 'A';
    for (path) |key| {
        const paths = pad_paths(cur, key);
        if (depth == 0) {
            l += paths[0].len;
        } else {
            var min: ?usize = null;
            for (paths) |npath| {
                const sl = move_len(npath, depth - 1, cache);
                if (min == null or min.? > sl) {
                    min = sl;
                }
            }
            l += min.?;
        }
        cur = key;
    }
    cache.put(k, l) catch unreachable;
    return l;
}

fn pad_paths(from: u8, to: u8) []const []const u8 {
    return switch (from) {
        '0' => switch (to) {
            '0' => &.{"A"},
            '1' => &.{"^<A"},
            '2' => &.{"^A"},
            '3' => &.{ "^>A", ">^A" },
            '4' => &.{"^^<A"},
            '5' => &.{"^^A"},
            '6' => &.{ "^^>A", ">^^A" },
            '7' => &.{"^^^<A"},
            '8' => &.{"^^^A"},
            '9' => &.{ "^^^>A", ">^^^A" },
            'A' => &.{">A"},
            else => unreachable,
        },
        '1' => switch (to) {
            '0' => &.{">vA"},
            '1' => &.{"A"},
            '2' => &.{">A"},
            '3' => &.{">>A"},
            '4' => &.{"^A"},
            '5' => &.{ "^>A", ">^A" },
            '6' => &.{ "^>>A", ">>^A" },
            '7' => &.{"^^A"},
            '8' => &.{ "^^>A", ">^^A" },
            '9' => &.{ "^^>>A", ">>^^A" },
            'A' => &.{">>vA"},
            else => unreachable,
        },
        '2' => switch (to) {
            '0' => &.{"vA"},
            '1' => &.{"<A"},
            '2' => &.{"A"},
            '3' => &.{">A"},
            '4' => &.{ "^<A", "<^A" },
            '5' => &.{"^A"},
            '6' => &.{ "^>A", ">^A" },
            '7' => &.{ "^^<A", "<^^A" },
            '8' => &.{"^^A"},
            '9' => &.{ "^^>A", ">^^A" },
            'A' => &.{ "v>A", ">vA" },
            else => unreachable,
        },
        '3' => switch (to) {
            '0' => &.{ "v<A", "<vA" },
            '1' => &.{"<<A"},
            '2' => &.{"<A"},
            '3' => &.{"A"},
            '4' => &.{ "^<<A", "<<^A" },
            '5' => &.{ "^<A", "<^A" },
            '6' => &.{"^A"},
            '7' => &.{ "^^<<A", "<<^^A" },
            '8' => &.{ "^^<A", "<^^A" },
            '9' => &.{"^^A"},
            'A' => &.{"vA"},
            else => unreachable,
        },
        '4' => switch (to) {
            '0' => &.{">vvA"},
            '1' => &.{"vA"},
            '2' => &.{ "v>A", ">vA" },
            '3' => &.{ "v>>A", ">>vA" },
            '4' => &.{"A"},
            '5' => &.{">A"},
            '6' => &.{">>A"},
            '7' => &.{"^A"},
            '8' => &.{ "^>A", ">^A" },
            '9' => &.{ "^>>A", ">>^A" },
            'A' => &.{">>vvA"},
            else => unreachable,
        },
        '5' => switch (to) {
            '0' => &.{"vvA"},
            '1' => &.{ "v<A", "<vA" },
            '2' => &.{"vA"},
            '3' => &.{ "v>A", ">vA" },
            '4' => &.{"<A"},
            '5' => &.{"A"},
            '6' => &.{">A"},
            '7' => &.{ "^<A", "<^A" },
            '8' => &.{"^A"},
            '9' => &.{ "^>A", ">^A" },
            'A' => &.{ "vv>A", ">vvA" },
            else => unreachable,
        },
        '6' => switch (to) {
            '0' => &.{ "vv<A", "<vvA" },
            '1' => &.{ "v<<A", "<<vA" },
            '2' => &.{ "v<A", "<vA" },
            '3' => &.{"vA"},
            '4' => &.{"<<A"},
            '5' => &.{"<A"},
            '6' => &.{"A"},
            '7' => &.{ "^<<A", "<<^A" },
            '8' => &.{ "^<A", "<^A" },
            '9' => &.{"^A"},
            'A' => &.{"vvA"},
            else => unreachable,
        },
        '7' => switch (to) {
            '0' => &.{">vvvA"},
            '1' => &.{"vvA"},
            '2' => &.{ "vv>A", ">vvA" },
            '3' => &.{ "vv>>A", ">>vvA" },
            '4' => &.{"vA"},
            '5' => &.{ "v>A", ">vA" },
            '6' => &.{ "v>>A", ">>vA" },
            '7' => &.{"A"},
            '8' => &.{">A"},
            '9' => &.{">>A"},
            'A' => &.{">>vvA"},
            else => unreachable,
        },
        '8' => switch (to) {
            '0' => &.{"vvvA"},
            '1' => &.{ "vv<A", "<vvA" },
            '2' => &.{"vvA"},
            '3' => &.{ "vv>A", ">vvA" },
            '4' => &.{ "v<A", "<vA" },
            '5' => &.{"vA"},
            '6' => &.{ "v>A", ">vA" },
            '7' => &.{"<A"},
            '8' => &.{"A"},
            '9' => &.{">A"},
            'A' => &.{ ">vvvA", "vvv>A" },
            else => unreachable,
        },
        '9' => switch (to) {
            '0' => &.{ "vvv<A", "<vvvA" },
            '1' => &.{ "vv<<A", "<<vvA" },
            '2' => &.{ "vv<A", "<vvA" },
            '3' => &.{"vvA"},
            '4' => &.{ "v<<A", "<<vA" },
            '5' => &.{ "v<A", "<vA" },
            '6' => &.{"vA"},
            '7' => &.{"<<A"},
            '8' => &.{"<A"},
            '9' => &.{"A"},
            'A' => &.{"vvvA"},
            else => unreachable,
        },
        'A' => switch (to) {
            '0' => &.{"<A"},
            '1' => &.{"^<<A"},
            '2' => &.{ "^<A", "<^A" },
            '3' => &.{"^A"},
            '4' => &.{"^^<<A"},
            '5' => &.{ "^^<A", "<^^A" },
            '6' => &.{"^^A"},
            '7' => &.{"^^^<<A"},
            '8' => &.{ "^^^<A", "<^^^A" },
            '9' => &.{"^^^A"},
            'A' => &.{"A"},
            '^' => &.{"<A"},
            '>' => &.{"vA"},
            'v' => &.{ "<vA", "v<A" },
            '<' => &.{"v<<A"},
            else => unreachable,
        },
        '^' => switch (to) {
            'A' => &.{">A"},
            '^' => &.{"A"},
            '>' => &.{ "v>A", ">vA" },
            'v' => &.{"vA"},
            '<' => &.{"v<A"},
            else => unreachable,
        },
        '>' => switch (to) {
            'A' => &.{"^A"},
            '^' => &.{ "^<A", "<^A" },
            '>' => &.{"A"},
            'v' => &.{"<A"},
            '<' => &.{"<<A"},
            else => unreachable,
        },
        'v' => switch (to) {
            'A' => &.{ "^>A", ">^A" },
            '^' => &.{"^A"},
            '>' => &.{">A"},
            'v' => &.{"A"},
            '<' => &.{"<A"},
            else => unreachable,
        },
        '<' => switch (to) {
            'A' => &.{">>^A"},
            '^' => &.{">^A"},
            '>' => &.{">>A"},
            'v' => &.{">A"},
            '<' => &.{"A"},
            else => unreachable,
        },
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
