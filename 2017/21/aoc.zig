const std = @import("std");
const aoc = @import("aoc-lib.zig");

test "testcases" {
    try aoc.TestCases(usize, parts);
}

fn parts(inp: []const u8) anyerror![2]usize {
    var r2: [16]P3 = .{0} ** 16;
    var r3: [512][4]P2 = .{[4]P2{ 0, 0, 0, 0 }} ** 512;
    var i: usize = 0;
    while (i < inp.len) {
        if (inp[i + 6] == '=') {
            var lhs = read2(inp[i..]);
            const rhs = read3(inp[i + 9 ..]);
            r2[@as(usize, @intCast(lhs))] = rhs;
            lhs = transpose2(lhs);
            r2[@as(usize, @intCast(lhs))] = rhs;
            lhs = flip2(lhs);
            r2[@as(usize, @intCast(lhs))] = rhs;
            lhs = transpose2(lhs);
            r2[@as(usize, @intCast(lhs))] = rhs;
            lhs = flip2(lhs);
            r2[@as(usize, @intCast(lhs))] = rhs;
            lhs = transpose2(lhs);
            r2[@as(usize, @intCast(lhs))] = rhs;
            lhs = flip2(lhs);
            r2[@as(usize, @intCast(lhs))] = rhs;
            lhs = transpose2(lhs);
            r2[@as(usize, @intCast(lhs))] = rhs;
            i += 21;
        } else {
            var lhs = read3(inp[i..]);
            const rhs = read2x2(inp[i + 15 ..]);
            r3[@as(usize, @intCast(lhs))] = rhs;
            lhs = transpose3(lhs);
            r3[@as(usize, @intCast(lhs))] = rhs;
            lhs = flip3(lhs);
            r3[@as(usize, @intCast(lhs))] = rhs;
            lhs = transpose3(lhs);
            r3[@as(usize, @intCast(lhs))] = rhs;
            lhs = flip3(lhs);
            r3[@as(usize, @intCast(lhs))] = rhs;
            lhs = transpose3(lhs);
            r3[@as(usize, @intCast(lhs))] = rhs;
            lhs = flip3(lhs);
            r3[@as(usize, @intCast(lhs))] = rhs;
            lhs = transpose3(lhs);
            r3[@as(usize, @intCast(lhs))] = rhs;
            i += 35;
        }
    }
    var cur: [512]usize = .{0} ** 512;
    var next: [512]usize = .{0} ** 512;
    const start = read3(".#./..#/###");
    cur[@as(usize, @intCast(start))] = 1;
    var p1: usize = 0;
    var p2: usize = 0;
    for (0..6) |n| {
        var tc0: usize = 0;
        var tc1: usize = 0;
        var tc2: usize = 0;
        for (0..512) |v3| {
            const c = cur[v3];
            if (c == 0) {
                continue;
            }
            const r = iter3(v3, r2, r3);
            tc0 += r[0] * c;
            tc1 += r[1] * c;
            tc2 += r[2] * c;
            for (r[3..]) |n3| {
                next[n3] += c;
            }
            cur[v3] = 0;
        }
        std.mem.swap([512]usize, &cur, &next);
        p2 = tc2;
        if (n == 1) {
            p1 = tc1;
        }
    }
    return [2]usize{ p1, p2 };
}

fn iter3(v3: usize, r2: [16]P3, r3: [512][4]P2) [12]usize {
    // current 3x3 becomes 4x4 made up of 4 2x2
    const n4x4 = r3[v3];
    var res: [12]usize = .{0} ** 12;
    inline for (0..4) |n| {
        res[0] += @popCount(n4x4[n]);
    }

    // each 2x2 becomes a new 3x3
    const a3x3 = r2[n4x4[0]];
    const b3x3 = r2[n4x4[1]];
    const c3x3 = r2[n4x4[2]];
    const d3x3 = r2[n4x4[3]];
    res[1] = @popCount(a3x3);
    res[1] += @popCount(b3x3);
    res[1] += @popCount(c3x3);
    res[1] += @popCount(d3x3);

    // 4 combined 3x3 become 9 (3x3) of 2x2
    // these are really P2 but since they are built from bits of P3
    // and we only need to cast them to usize anyway keep them as P3
    const n2x2: [9]P3 = [9]P3{
        (((a3x3 & 0b110000000) >> 5) + ((a3x3 & 0b000110000) >> 4)),
        (((a3x3 & 0b001000000) >> 3) + ((a3x3 & 0b000001000) >> 2) + ((b3x3 & 0b100000000) >> 6) + ((b3x3 & 0b000100000) >> 5)),
        (((b3x3 & 0b011000000) >> 4) + ((b3x3 & 0b000011000) >> 3)),
        (((a3x3 & 0b000000110) << 1) + ((c3x3 & 0b110000000) >> 7)),
        (((a3x3 & 0b000000001) << 3) + (b3x3 & 0b000000100) + ((c3x3 & 0b001000000) >> 5) + ((d3x3 & 0b100000000) >> 8)),
        (((b3x3 & 0b000000011) << 2) + ((d3x3 & 0b011000000) >> 6)),
        (((c3x3 & 0b000110000) >> 2) + ((c3x3 & 0b000000110) >> 1)),
        ((c3x3 & 0b000001000) + ((d3x3 & 0b000100000) >> 3) + ((c3x3 & 0b000000001) << 1) + ((d3x3 & 0b000000100) >> 2)),
        (((d3x3 & 0b000011000) >> 1) + (d3x3 & 0b000000011)),
    };
    for (0..9) |n3| {
        const n3x3 = r2[n2x2[n3]];
        res[3 + n3] = n3x3;
        res[2] += @as(usize, @intCast(@popCount(n3x3)));
    }
    return res;
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

const P2 = u4;

fn pretty2(a: P2) [6]u8 {
    return [6]u8{ if (a & 0b1000 != 0) '#' else '.', if (a & 0b0100 != 0) '#' else '.', 10, if (a & 0b0010 != 0) '#' else '.', if (a & 0b0001 != 0) '#' else '.', 10 };
}

inline fn flip2(a: P2) P2 {
    return ((a & 0b1100) >> 2) | ((a << 2) & 0b1100);
}

inline fn transpose2(a: P2) P2 {
    return (a & 0b1001) | ((a & 0b0100) >> 1) | ((a & 0b0010) << 1);
}

fn read2(inp: []const u8) P2 {
    return (@as(P2, @intFromBool(inp[0] == '#')) << 3) |
        (@as(P2, @intFromBool(inp[1] == '#')) << 2) |
        // skip slash
        (@as(P2, @intFromBool(inp[3] == '#')) << 1) |
        (@as(P2, @intFromBool(inp[4] == '#')) << 0);
}

const P3 = u9;

fn pretty3(a: P3) [12]u8 {
    return [12]u8{
        if (a & 0b100000000 != 0) '#' else '.',
        if (a & 0b010000000 != 0) '#' else '.',
        if (a & 0b001000000 != 0) '#' else '.',
        10,
        if (a & 0b000100000 != 0) '#' else '.',
        if (a & 0b000010000 != 0) '#' else '.',
        if (a & 0b000001000 != 0) '#' else '.',
        10,
        if (a & 0b000000100 != 0) '#' else '.',
        if (a & 0b000000010 != 0) '#' else '.',
        if (a & 0b000000001 != 0) '#' else '.',
        10,
    };
}

inline fn flip3(a: P3) P3 {
    return ((a & 0b111000000) >> 6) | (a & 0b111000) | ((a & 0b111) << 6);
}

inline fn transpose3(a: P3) P3 {
    return (a & 0b100010001) |
        ((a & 0b010000000) >> 2) |
        ((a & 0b001000000) >> 4) |
        ((a & 0b000100000) << 2) |
        ((a & 0b000001000) >> 2) |
        ((a & 0b000000100) << 4) |
        ((a & 0b000000010) << 2);
}

fn read3(inp: []const u8) P3 {
    return (@as(P3, @intFromBool(inp[0] == '#')) << 8) |
        (@as(P3, @intFromBool(inp[1] == '#')) << 7) |
        (@as(P3, @intFromBool(inp[2] == '#')) << 6) |
        // skip slash
        (@as(P3, @intFromBool(inp[4] == '#')) << 5) |
        (@as(P3, @intFromBool(inp[5] == '#')) << 4) |
        (@as(P3, @intFromBool(inp[6] == '#')) << 3) |
        // skip slash
        (@as(P3, @intFromBool(inp[8] == '#')) << 2) |
        (@as(P3, @intFromBool(inp[9] == '#')) << 1) |
        (@as(P3, @intFromBool(inp[10] == '#')) << 0);
}

fn read22(inp: []const u8) [2]P2 {
    return [2]P2{ (@as(P2, @intFromBool(inp[0] == '#')) << 3) |
        (@as(P2, @intFromBool(inp[1] == '#')) << 2) |
        (@as(P2, @intFromBool(inp[5] == '#')) << 1) |
        (@as(P2, @intFromBool(inp[6] == '#')) << 0), (@as(P2, @intFromBool(inp[2] == '#')) << 3) |
        (@as(P2, @intFromBool(inp[3] == '#')) << 2) |
        (@as(P2, @intFromBool(inp[7] == '#')) << 1) |
        (@as(P2, @intFromBool(inp[8] == '#')) << 0) };
}

fn read2x2(inp: []const u8) [4]P2 {
    const a = read22(inp);
    const b = read22(inp[10..]);
    return [4]P2{ a[0], a[1], b[0], b[1] };
}
