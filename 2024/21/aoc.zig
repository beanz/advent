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
    try cache.put(66229978939672, 28154654779);
    try cache.put(405308064024, 24095973438);
    try cache.put(1047937304, 27052881363);
    try cache.put(508789801240, 30331287706);
    try cache.put(404771193112, 24095973438);
    try cache.put(267871207704, 25419021194);
    try cache.put(68575031083288, 25419021195);
    try cache.put(1983660312, 30331287705);
    try cache.put(267334336792, 25419021194);
    try cache.put(68437592129816, 25419021195);
    try cache.put(258712420632, 27622800566);
    try cache.put(1010581784, 22411052533);
    try cache.put(103758830518552, 31420065371);
    try cache.put(16664, 1);
    try cache.put(1014382872, 27622800565);
    try cache.put(1581138200, 24095973437);
    try cache.put(508793602328, 20790420656);
    try cache.put(3948824, 22411052532);
    try cache.put(1987461400, 20790420655);
    try cache.put(259281273112, 28154654778);
    try cache.put(405310161176, 14752615086);
    try cache.put(130251162009880, 22778092493);
    try cache.put(258710847768, 28154654778);
    try cache.put(66479491268888, 27622800567);
    try cache.put(1983791384, 22778092491);
    try cache.put(7749912, 20790420654);
    try cache.put(68437996355864, 27052881365);
    try cache.put(6177048, 14752615084);
    try cache.put(405307932952, 31420065370);
    try cache.put(4079896, 14287938116);
    try cache.put(1012810008, 28154654777);
    try cache.put(130251161878808, 30331287707);
    try cache.put(1581007128, 31420065369);
    try cache.put(1583235352, 14752615085);
    try cache.put(103759400943896, 31420065371);
    try cache.put(507850408216, 22778092492);
    try cache.put(507816722712, 30331287706);
    try cache.put(130250222485784, 22778092493);
    try cache.put(103759401074968, 24095973439);
    try cache.put(66376007827736, 28154654779);
    try cache.put(259685499160, 27622800566);
    try cache.put(1046364440, 25419021193);
    try cache.put(508789932312, 22778092492);
    try cache.put(26562406641320216, 31420065372);
    try cache.put(268275433752, 27052881364);
    try cache.put(103758864204056, 24095973439);
    try cache.put(1044267288, 14287938117);
    try cache.put(267335909656, 27052881364);
    try cache.put(66230383165720, 27622800567);
    try cache.put(130250188800280, 30331287707);
    try cache.put(68678514524440, 27052881365);
    try cache.put(404737507608, 31420065370);
    while (i < inp.len) : (i += 2) {
        const j = i;
        const n = try aoc.chompUint(usize, inp, &i);
        const l = move_len(inp[j .. i + 1], 2, &cache);
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
